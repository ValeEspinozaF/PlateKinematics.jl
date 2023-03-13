"""
    AverageEnsemble(FRsArray::Array{T}) where {T<:FiniteRotSph}
    AverageEnsemble(FRcArray::Array{T}) where {T<:FiniteRotCart}

Return the average Finite Rotation from a given ensemble.
"""
function AverageEnsemble(FRsArray::Array{T}) where {T<:FiniteRotSph}

    N = length(FRsArray);

    # Ensemble array components [ensMag]
    EA_XYZ = ToEulerAngles(FRsArray)

    # Calculate mean vector and its covariance
    x = getindex.(EA_XYZ, 1)
    y = getindex.(EA_XYZ, 2)
    z = getindex.(EA_XYZ, 3)
    x_mean = mean(x)
    y_mean = mean(y)
    z_mean = mean(z)
    
    # If time/timerange has been assigned, use it
    time = nothing
    if FRsArray[1][4] !== nothing
        time = FRsArray[1][4]
    end

    # Calculates the covariance matrix
    cov = Array{Float64}(undef, 6)

    cov[1] = sum(x .* x) / N - x_mean * x_mean 
    cov[2] = sum(x .* y) / N - x_mean * y_mean    
    cov[3] = sum(x .* z) / N - x_mean * z_mean   
    cov[4] = sum(y .* y) / N - y_mean * y_mean 
    cov[5] = sum(y .* z) / N - y_mean * z_mean 
    cov[6] = sum(z .* z) / N - z_mean * z_mean
    
    # Mean pole in degrees, magnitude in [ensMag], covariace in [ensMag ^2]
    FRs_mean = ToFRs(EulerAngles(x_mean, y_mean, z_mean))
    FRs_mean = ChangeCovariance(FRs_mean, Covariance(cov))
    FRs_mean = ChangeTime(FRs_mean, time)

    return FRs_mean
end


function AverageEnsemble(FRcArray::Array{T}) where {T<:FiniteRotCart}

    # Calculate mean vector and its covariance
    return ToFRc(AverageEnsemble(ToFRs(FRcArray)))
    
end


"""
    AverageEnsemble(EVsArray::Array{T}) where {T<:EulerVectorSph}
    AverageEnsemble(EVcArray::Array{T}) where {T<:EulerVectorCart}

Return the average Euler Vector from a given ensemble.
"""
function AverageEnsemble(EVsArray::Matrix{T}) where {T<:EulerVectorSph}

    # Ensemble array components [ensMag]
    XYZ = map(v -> sph2cart(v[1], v[2], v[3]), EVsArray)

    # Calculate mean vector and its covariance
    x_mean, y_mean, z_mean, cov = AverageVector(getindex.(XYZ, 1), getindex.(XYZ, 2), getindex.(XYZ,3))
    
    # If time/timerange has been assigned, use it
    time = nothing
    if EVsArray[1][4] !== nothing
        time = EVsArray[1][4]
    end
    
    # Mean pole in degrees, magnitude in [ensMag], covariace in [ensMag ^2]
    return T(cart2sph(x_mean, y_mean, z_mean), time, Covariance(cov))
end


function AverageEnsemble(EVcArray::Matrix{T}) where {T<:EulerVectorCart}

    # Calculate mean vector and its covariance
    x_mean, y_mean, z_mean, cov = AverageVector(getindex.(EVcArray, 1), getindex.(EVcArray, 2), getindex.(EVcArray, 3))
    
    # If time range has been assigned, use it
    time = nothing
    if EVcArray[1][4] !== nothing
        time = EVcArray[1][4]
    end
    
    # Mean vector in [ensMag], covariace in [ensMag ^2]
    return T(x_mean, y_mean, z_mean, time, cov)
    
end


function AverageVector(x::Array, y::Array, z::Array)

    # Ensemble length
    N = length(x)
    
    # Mean xyz values
    x_mean = mean(x)
    y_mean = mean(y)
    z_mean = mean(z)
    
    # Coordinates in radians
    x_rad = ToRadians(x)
    y_rad = ToRadians(y)
    z_rad = ToRadians(z)

    # Set empty covariance ensemble
    covArray = Array{Float64}(undef, 6)
    
    # Calculate covariance elements [rad^2]
    covArray[1] = sum(x_rad .* x_rad)/N - sum(x_rad)/N * sum(x_rad)/N
    covArray[2] = sum(x_rad .* y_rad)/N - sum(x_rad)/N * sum(y_rad)/N
    covArray[3] = sum(x_rad .* z_rad)/N - sum(x_rad)/N * sum(z_rad)/N
    covArray[4] = sum(y_rad .* y_rad)/N - sum(y_rad)/N * sum(y_rad)/N
    covArray[5] = sum(y_rad .* z_rad)/N - sum(y_rad)/N * sum(z_rad)/N
    covArray[6] = sum(z_rad .* z_rad)/N - sum(z_rad)/N * sum(z_rad)/N

    # Mean vector in [ensMag], covariace in [rad^2]
    return [x_mean, y_mean, z_mean, covArray]
     
end