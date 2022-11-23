using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix, Add_FiniteRotations
using PlateKinematics: ChangeAngle, ChangeTime
using PlateKinematics.FiniteRotationsTransformations: Finrot2Array3D

function Interpolate_FiniteRotation(FRm1Array::Matrix{FiniteRotMatrix}, FRm2Array::Matrix{FiniteRotSph}, t1::Number, t2::Number, time::Number)
    
    iMTX1 = Invert_RotationMatrix(Finrot2Array3D(FRm1Array))
    MTX2 = Finrot2Array3D(FRm2Array)
    mMTX = Multiply_RotationMatrices(MTX2, iMTX1)

    cf = (time-t1) / (t2-t1)

    mFRs = Finrot2Sph(mMTX)

    #iFRm1Array = Invert_RotationMatrix(FRm1Array)

    FRmp = [ FiniteRotMatrix(FRm2Array[i].Values * iFRm1Array[i].Values) for i in eachindex(iFRm1Array) ]

end

function Interpolate_FiniteRotation(FRs1::FiniteRotSph, FRs2::FiniteRotSph, time::Number, Nsize = 1e5)
    
    t1 = FRs1.Time
    t2 = FRs2.Time

    if time > t2
        return nothing #or an error?

    elseif time == t1
        return FRs1
    
    elseif time == t2
        return FRs2
    
    elseif time < t1
        delta = (t1 - time) / t1
        FRs_ = Add_FiniteRotations(FRs1, ChangeAngle(FRs1, FRs1.Angle * (-delta)), Nsize)

        FRs = ChangeTime(FRs_, time)
        return FRs

    elseif time < t2 && t1 < time 
        delta = (t2-time)/(t2-t1)

        # If a covariance is found, build ensemble
        if !CovIsZero(FRs1.Covariance) || !CovIsZero(FRs2.Covariance)
            FRs1_ = BuildEnsemble3D(FRs1, Nsize)
            FRs2_ = BuildEnsemble3D(FRs2, Nsize)
            
        else
            FRs1_ = [FRs1]
            FRs2_ = [FRs2]
        end 


        FRm1 = Finrot2Matrix(FRs1_)
        FRm2 = Finrot2Matrix(FRs2_)

        Interpolate_FiniteRotation(FRm1, FRm2, t1, t2, time)

        # Calculate stage pole t2 ROT t1
        SPs = Add_FiniteRotations(ChangeAngle(FRs2, -FRs2.Angle), FRs1, Nsize)
        FRs_ = Add_FiniteRotations(FRs2, ChangeAngle(SPs, SPs.Angle * delta))

        FRs = ChangeTime(FRs_, time)
        return FRs
    end
end


function Interpolate_FiniteRotation(FRc1::FiniteRotCart, FRc2::FiniteRotCart, time::Number, Nsize = 1e5)

    FRs1 = Finrot2Sph(FRc1)
    FRs2 = Finrot2Sph(FRc2)

    FRc = Interpolate_FiniteRotation(FRs1, FRs2, time, Nsize)

    return FiniteRotCart(FRc)
end


function Interpolate_FiniteRotation(FRsArray, times::Union{Matrix, Vector}, Nsize = 1e5) #::Array{FiniteRotSph}

    if typeof(FRsArray) == Matrix{FiniteRotSph}
        FRsArray = vec(FRsArray)
    end

    # Available times for interpolation
    FRtimes = [FRs.Time for FRs in FRsArray]

    FRs_out = []

    for time in times
        
        idx = findfirst(x -> x >= time, FRtimes) 
        index = idx === nothing ? continue : idx

        # t <= t1
        if index == 1
            FRs = Interpolate_FiniteRotation(FRsArray[index], FRsArray[index], time, Nsize)

        # t <= tn
        else
            FRs = Interpolate_FiniteRotation(FRsArray[index-1], FRsArray[index], time, Nsize)
        end

        FRs_out = vcat(FRs_out, FRs)
    end

    return FRs_out
end