using PlateKinematics: FiniteRotSph
using PlateKinematics: EulerVectorSph
using PlateKinematics.EulerVectorTransformations: EuVector2Sph, ChangeAngVel, ChangeTimeRange, GetAntipole
using PlateKinematics.FiniteRotationsTransformations: Finrot2Sph, Finrot2Array3D

function ToFiniteRotation(EVs::EulerVectorSph, reverseRot=true, Nsize=1e5::Number)

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        rEVs = ChangeAngVel(EVs, EVs.AngVelocity * -1)
    else
        rEVs = EVs
    end

    # Get sense of rotation 
    if EVs.TimeRange[1] == 0 && EVs.TimeRange[2] != 0
        FRt = EVs.TimeRange[2]
        EVs = GetAntipole(EVs)
    elseif EVs.TimeRange[1] != 0 && EVs.TimeRange[2] == 0
        FRt = EVs.TimeRange[1]
    else
        throw("Error. Funtion ToFiniteRotation only supports total Euler Vector transformation (EVs.TimeRange[1] == 0 || EVs.TimeRange[2] == 0).")
    end

    # Build ensemble if covariances are given
    if !CovIsZero(EVs.Covariance)
        MTX = BuildEnsemble3D(rEVs, Nsize)
        nFRs = map(FRs -> ChangeTime(ChangeAngle(FRs, FRs.Angle * FRt), FRt), Finrot2Sph(MTX))

        #
        #return Ensemble2Vector
    else
        return FiniteRotSph(rEVs.Lon, rEVs.Lat, rEVs.AngVelocity * FRt, FRt)
    end 
end 


function ToFiniteRotation(EVsArray::Matrix{EulerVectorSph}, reverseRot=true, Nsize=1e5::Number)

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        rEVs = map(EVs -> ChangeAngVel(EVs, EVs.AngVelocity * -1), EVsArray)
    else
        rEVs = [EVs]
    end

    # Get sense of rotation 
    if EVsArray[1].TimeRange[1] == 0 && EVsArray[1].TimeRange[2] != 0
        FRt = EVsArray[1].TimeRange[2]
        EVs = map(EVs -> GetAntipole(EVs), EVsArray)

    elseif EVsArray[1].TimeRange[1] != 0 && EVsArray[1].TimeRange[2] == 0
        FRt = EVsArray[1].TimeRange[1]

    else
        throw("Error. Funtion ToFiniteRotation only supports total Euler Vector transformation (EVs.TimeRange[1] == 0 || EVs.TimeRange[2] == 0).")
    end

    return map(ev -> FiniteRotSph(ev.Lon, ev.Lat, ev.AngVelocity * FRt, FRt, ev.Covariance), EVs)
end 