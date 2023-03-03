using PlateKinematics: FiniteRotSph
using PlateKinematics: EulerVectorSph
using PlateKinematics.EulerVectorTransformations: EuVector2Sph, ChangeAngVel, ChangeTimeRange
using PlateKinematics.FiniteRotationsTransformations: Finrot2Sph, Finrot2Array3D

function ToEulerVector(FRs::FiniteRotSph, reverseRot=true, Nsize=1e5::Number)

    EVts = [0.0 FRs.Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        EVts = reverse(EVts)
        rFRs = ChangeAngle(FRs, FRs.Angle * -1)
    else
        rFRs = FRs
    end

    # Build ensemble if covariances are given
    if !CovIsZero(rFRs.Covariance)
        MTX = BuildEnsemble3D(rFRs, Nsize)
    else
        MTX = Finrot2Array3D(rFRs)
    end 

    EVs = ToEulerVector(MTX, EVts)

    if size(EVs)[1] !== 1  
        return Ensemble2Vector(EVs)
    else
        return EVs[1]       # Check this!!!
    end
end


function ToEulerVector(FRs1::FiniteRotSph, FRs2::FiniteRotSph, reverseRot=true, Nsize=1e5::Number)

    EVts = [FRs1.Time FRs2.Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        EVts = reverse(EVts)
        rFRs1 = ChangeAngle(FRs1, FRs1.Angle * -1)
        rFRs2 = ChangeAngle(FRs2, FRs2.Angle * -1)
    else
        rFRs1 = FRs1
        rFRs2 = FRs2
    end

    # Build ensemble if covariances are given
    if !CovIsZero(rFRs1.Covariance) && !CovIsZero(rFRs2.Covariance)
        MTX1 = BuildEnsemble3D(rFRs1, Nsize)
        MTX2 = BuildEnsemble3D(rFRs2, Nsize)
    else
        MTX1 = Finrot2Array3D(rFRs1)
        MTX2 = Finrot2Array3D(rFRs2)
    end 

    EVs = ToEulerVector(MTX1, MTX2, EVts)

    if size(EVs)[1] !== 1  
        return Ensemble2Vector(EVs)
    else
        return EVs[1]       # Check this!!!
    end
end

function ToEulerVector(FRsArray::Array{T}, reverseRot=true, Nsize=1e5::Number) where {T<:FiniteRotSph}

    N_EV = length(FRsArray)

    # Output array
    EVs_out = Array{EulerVectorSph}(undef, N_EV)

    for i in 1:N_EV

        if i == 1
            FRs = FRsArray[i]
            EVs_out[i] = ToEulerVector(FRs, reverseRot, Nsize)
        else
            FRs1 = FRsArray[i - 1]
            FRs2 = FRsArray[i]
            EVs_out[i] = ToEulerVector(FRs1, FRs2, reverseRot, Nsize)
        end

    end

    return EVs_out
end

function ToEulerVector(MTX1::Array{Float64, 3}, MTX2::Array{Float64, 3}, EVts::Union{Matrix, Vector})
    
    EVdt = abs(EVts[2] - EVts[1])

    iMTX1 = Invert_RotationMatrix(MTX1)
    MTXs = Multiply_RotationMatrices(iMTX1, MTX2)
    return map(EVs -> ChangeTimeRange(ChangeAngVel(EVs, EVs.AngVelocity / EVdt), EVts), EuVector2Sph(MTXs))

end

function ToEulerVector(MTX::Array{Float64, 3}, EVts::Union{Matrix, Vector})
    
    EVdt = abs(EVts[2] - EVts[1])
    return map(EVs -> ChangeTimeRange(ChangeAngVel(EVs, EVs.AngVelocity / EVdt), EVts), EuVector2Sph(MTX))

end