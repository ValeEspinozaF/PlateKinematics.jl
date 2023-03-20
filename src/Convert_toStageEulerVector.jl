"""
    ToEulerVector(FRs::FiniteRotSph, reverseRot=false::Bool, Nsize=100000::Int64)
    ToEulerVector(FRsArray::Array{FiniteRotSph}, reverseRot=false::Bool)

Return a stage Euler Vector describing the motion between a total Finite Rotation `FRs`
and present-day. The output time-orientation may the inverted by setting the `reverseRot` 
parameter to `true`.
"""
function ToEulerVector(FRs::FiniteRotSph, reverseRot=false::Bool, Nsize=100000::Int64)

    timeRange = [0.0 FRs.Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        timeRange = reverse(timeRange)
        rFRs = ChangeAngle(FRs, FRs.Angle * -1)
    else
        rFRs = FRs
    end

    # Build ensemble if covariances are given
    if !CovIsZero(rFRs.Covariance)
        MTX = BuildEnsemble3D(rFRs, Nsize)
    else
        MTX = ToRotationMatrix(rFRs)
    end 

    EVs = ToEulerVector(MTX, timeRange)

    if size(EVs)[1] !== 1  
        return AverageEnsemble(EVs)
    else
        return EVs[1]
    end
end

function ToEulerVector(FRsArray::Array{T}, reverseRot=false::Bool) where {T<:FiniteRotSph}

    if FRsArray[1].Time != FRsArray[2].Time
        error("This function is meant to handle the sample array of a single Finite Rotation. " *
            "To sample and convert a list of individual Finite Rotations, use ToEulerVectorList function.")
    end

    timeRange = [0.0 FRsArray[1].Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        timeRange = reverse(timeRange)
        rFRs = map(FRs -> ChangeAngle(FRs, FRs.Angle * -1), FRsArray)
    else
        rFRs = FRs
    end

    MTX = ToRotationMatrix(rFRs)
    return ToEulerVector(MTX, timeRange)
end


"""
    ToEulerVector(
        FRs1::FiniteRotSph, FRs2::FiniteRotSph, 
        reverseRot=false::Bool, Nsize=100000::Int64)
    ToEulerVector(
        FRs1Array::Array{T}, FRs2Array::Array{T}, 
        reverseRot=false::Bool) where {T<:FiniteRotSph}

Return a stage Euler Vector describing the motion between two total Finite Rotations
(`FRs1` and `FRs2`). The output time-orientation may the inverted by setting the 
`reverseRot` parameter to `true`.
"""
function ToEulerVector(
    FRs1::FiniteRotSph, FRs2::FiniteRotSph, reverseRot=false::Bool, Nsize=100000::Int64)

    timeRange = [FRs1.Time FRs2.Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        timeRange = reverse(timeRange)
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
        MTX1 = ToRotationMatrix(rFRs1)
        MTX2 = ToRotationMatrix(rFRs2)
    end 

    EVs = ToEulerVector(MTX1, MTX2, timeRange)

    if size(EVs)[1] !== 1  
        return AverageEnsemble(EVs)
    else
        return EVs[1]
    end
end

function ToEulerVector(
    FRs1Array::Array{T}, FRs2Array::Array{T}, reverseRot=false::Bool) where {T<:FiniteRotSph}

    timeRange = [FRs1Array[1].Time FRs2Array[2].Time] 

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        timeRange = reverse(timeRange)
        rFRs1 = map(FRs1 -> ChangeAngle(FRs1, FRs1.Angle * -1), FRs1Array)
        rFRs2 = map(FRs2 -> ChangeAngle(FRs2, FRs2.Angle * -1), FRs2Array)

    else
        rFRs1 = FRs1Array
        rFRs2 = FRs2Array
    end

    MTX1 = ToRotationMatrix(rFRs1)
    MTX2 = ToRotationMatrix(rFRs2)
    return ToEulerVector(MTX1, MTX2, timeRange)
end

function ToEulerVector2(
    FRs1Array::Array{T}, FRs2Array::Array{T}, reverseRot=false::Bool) where {T<:FiniteRotSph}

    timeRange = [FRs1Array[1].Time FRs2Array[2].Time] 

    MTX1 = ToRotationMatrix(FRs1Array)
    MTX2 = ToRotationMatrix(FRs2Array)

    # Reverses sense of rotation (when using reconstruction finite rotations)
    if reverseRot == true
        timeRange = reverse(timeRange)
        rMTX1 = ToRotationMatrix(FRs1Array)
        rMTX2 = ToRotationMatrix(FRs2Array)

        return ToEulerVector(rMTX1, rMTX2, timeRange)

    else
        #rFRs1 = FRs1Array
        #rFRs2 = FRs2Array
        return ToEulerVector(MTX1, MTX2, timeRange)

    end
end


function ToEulerVector(
    MTX1::Array{N, 3}, MTX2::Array{N, 3}, timeRange::Array{N}) where {N<:Float64}

    if size(MTX1)[1:2] != (3,3) || size(MTX2)[1:2] != (3,3)
        error("Input 3D array must be of size (3, 3, n).")
    end

    if size(MTX1) != size(MTX2) 
        error("Input arrays dont have the same length (MTX1: $(size(MTX1)), MTX2: $(size(MTX2))).")
    end

    iMTX1 = Invert_RotationMatrix(MTX1)
    MTX = Multiply_RotationMatrices(iMTX1, MTX2)

    return ToEulerVector(MTX, timeRange)
end


function ToEulerVector(MTX::Array{N, 3}, timeRange::Array{N}) where {N<:Float64}
    
    if size(MTX)[1:2] != (3,3)
        error("Input 3D array must be of size (3, 3, n).")
    end

    # Time spanned
    dTime = abs(timeRange[2] - timeRange[1])

    # Turn to spherical coordinates, pole in [deg]
    x = MTX[3,2,:] - MTX[2,3,:]
    y = MTX[1,3,:] - MTX[3,1,:]
    z = MTX[2,1,:] - MTX[1,2,:]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees/Myr]
    t = MTX[1,1,:] + MTX[2,2,:] + MTX[3,3,:]
    vel = ToDegrees( atan.(mag, t .- 1) ) ./ dTime

    return mapslices(v -> EulerVectorSph(v, timeRange), [lon lat vel], dims=(2))
end


"""
    ToEulerVectorList(
        FRsArray::Array{T}, reverseRot=false::Bool, Nsize=100000::Int64) where {T<:FiniteRotSph}

Return a list of Euler Vectors describing the motion for a list of total Finite Rotations `FRsArray`.
The output time-orientation may the inverted by setting the `reverseRot` parameter to `true`.
"""
function ToEulerVectorList(
    FRsArray::Array{T}, reverseRot=false::Bool, Nsize=100000::Int64) where {T<:FiniteRotSph}

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