"""
    ToFiniteRotation(EVs::EulerVectorSph, reverseRot=false::Bool, Nsize=1e5::Number)
    ToFiniteRotation(EVsArray::Array{EulerVectorSph}, reverseRot=false::Bool)

Return a total Finite Rotation from a total Euler Vector `EVs`. The output time-orientation 
may the inverted by setting the `reverseRot` parameter to `true`.
"""
function ToFiniteRotation(EVs::EulerVectorSph, reverseRot=false::Bool, Nsize=1e5::Number)

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        rEVs = ChangeAngVel(EVs, EVs.AngVelocity * -1)
    else
        rEVs = EVs
    end

    # Get sense of rotation 
    t1 = EVs.TimeRange[1]
    t2 = EVs.TimeRange[2]

    if t1 == 0 && t2 != 0
        FRt = t2
        EVs = GetAntipole(EVs)

    elseif t1 != 0 && t2 == 0
        FRt = t1

    else
        error("Funtion only supports total Euler Vector transformation (TimeRange[1] == 0 or TimeRange[2] == 0).")

    end

    # Build ensemble if covariances are given
    if !CovIsZero(EVs.Covariance)
        EVs_array = BuildEnsemble3D(rEVs, Nsize)
        nFRs = map(ev -> FiniteRotSph(ev.Lon, ev.Lat, ev.AngVelocity * FRt), EVs_array)
        return ChangeTime(AverageEnsemble(nFRs), FRt)

    else
        return FiniteRotSph(rEVs.Lon, rEVs.Lat, rEVs.AngVelocity * FRt, FRt)

    end 
end 


function ToFiniteRotation(EVsArray::Array{EulerVectorSph}, reverseRot=false::Bool)

    # Reverses sense of rotation (usually when using reconstruction finite rotations)
    if reverseRot == true
        rEVs = map(EVs -> ChangeAngVel(EVs, EVs.AngVelocity * -1), EVsArray)
    else
        rEVs = EVs
    end

    # Get sense of rotation  
    t1 = EVsArray[1].TimeRange[1]
    t2 = EVsArray[1].TimeRange[2]

    if t1 == 0 && t2 != 0
        time = t2
        EVsArray = map(EVs -> GetAntipole(EVs), EVsArray)

    elseif t1 != 0 && t2 == 0
        time = t1

    else
        error("Funtion only supports total Euler Vector transformation (TimeRange[1] == 0 or TimeRange[2] == 0).")
    end

    return map(EVs -> FiniteRotSph(EVs.Lon, EVs.Lat, EVs.AngVelocity * time, time), EVsArray)
end