using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix
using PlateKinematics: ChangeAngle, ChangeTime
using PlateKinematics: Add_FiniteRotations, Invert_RotationMatrix, Multiply_RotationMatrices
using PlateKinematics.FiniteRotationsTransformations: Finrot2Sph, Finrot2Array3D

"""
Interpolates a finite rotation matrix between a matrix for a given
time and present day time. """
function Interpolate_FiniteRotation(MTX::Array{Float64, 3}, t1::Number, time::Number)

    if  time >= t1 
        throw("Interpolation time is not between given t1 and t2.")
    end

    delta = time / t1

    mFRs = Finrot2Sph(MTX)
    xFRs = map(FRs -> ChangeAngle(FRs, FRs.Angle * delta), mFRs)
    return map(FRs -> ChangeTime(FRs, time), xFRs)
end

"""
Interpolates two finite rotations matrices at an intermediate time. """
function Interpolate_FiniteRotation(MTX1::Array{Float64, 3}, MTX2::Array{Float64, 3}, t1::Number, t2::Number, time::Number)
    
    if  time >= t2 || t1 >= time 
        throw("Interpolation time is not between given t1 and t2.")
    end

    # Calculate stage pole t2 ROT t1
    delta = (time-t1) / (t2-t1)

    iMTX1 = Invert_RotationMatrix(MTX1)
    mMTX = Multiply_RotationMatrices(MTX2, iMTX1)
    mFRs = Finrot2Sph(mMTX)
    xFRs = map(FRs -> ChangeAngle(FRs, FRs.Angle * delta), mFRs)

    # Calculate finite rotation 0 ROT time, return MTX array
    intMTX = Multiply_RotationMatrices(Finrot2Array3D(xFRs), MTX1)
    return map(FRs -> ChangeTime(FRs, time), Finrot2Sph(intMTX))
end

"""
Interpolates a finite rotation between two finite rotations in spherical format. """
function Interpolate_FiniteRotation(FRs1::FiniteRotSph, FRs2::FiniteRotSph, time::Number, Nsize = 1e5)
    
    if FRs2.Time < FRs1.Time
        throw("Error. Age for rotation FRs2 is expected to be older or equal than FRs1.")
    end

    t1 = FRs1.Time
    t2 = FRs2.Time

    if time > t2
        println("Given interpolation time ($time) is older than time oldest rotation supplied (FRs2 time = $(FRs2.Time)).")
        return nothing

    elseif time == t1
        return FRs1
    
    elseif time == t2
        return FRs2
    
    else
        # Build ensemble if covariances are given
        if !CovIsZero(FRs1.Covariance) && !CovIsZero(FRs2.Covariance)
            MTX1 = BuildEnsemble3D(FRs1, Nsize)
            MTX2 = BuildEnsemble3D(FRs2, Nsize)
            
        else
            MTX1 = Finrot2Matrix(FRs1).Values
            MTX2 = Finrot2Matrix(FRs2).Values

        end 

        if time < t1
            return Interpolate_FiniteRotation(MTX1, t1, time)

        elseif time < t2 && t1 < time 
            return Interpolate_FiniteRotation(MTX1, MTX2, t1, t2, time)
            
        end
    end
end

"""
Interpolates a list finite rotations from an array of finite rotations in spherical format. """
function Interpolate_FiniteRotation(FRsArray, times::Union{Matrix, Vector}, Nsize = 1e5) #::Array{FiniteRotSph}

    if typeof(FRsArray) == Matrix{FiniteRotSph}
        FRsArray = vec(FRsArray)
    end

    # Available times for interpolation
    FRtimes = [FRs.Time for FRs in FRsArray]

    FRs_out = []

    for time in times
        
        # Find index of inmmediatly oldest rotation
        idx = findfirst(x -> x >= time, FRtimes) 

        # If index is not found (time is older than oldest rotation), continue
        index = idx === nothing ? continue : idx

        # t <= t1  --- time is between youngest rotation and present time
        if index == 1
            FRs = Interpolate_FiniteRotation(FRsArray[index], FRsArray[index], time, Nsize)

        # t <= tn  --- time is between oldest rotation and present time
        else
            FRs = Interpolate_FiniteRotation(FRsArray[index-1], FRsArray[index], time, Nsize)
        end

        FRs_out = vcat(FRs_out, FRs)
    end

    return FRs_out
end