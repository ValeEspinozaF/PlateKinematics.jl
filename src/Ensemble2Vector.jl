using PlateKinematics: Covariance, FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph
using PlateKinematics.FiniteRotationsTransformations: Finrot2EuAngle, EuAngle2Sph, ChangeCovariance, ChangeTime


function Ensemble2Vector(ENSs::Matrix{T})  where {T<:FiniteRotSph}

    N = length(ENSs);

    # Ensemble array components [ensMag]
    EA_XYZ = map(FRs -> Finrot2EuAngle(FRs), ENSs)

    # Calculate mean vector and its covariance
    x = getindex.(EA_XYZ, 1)
    y = getindex.(EA_XYZ, 2)
    z = getindex.(EA_XYZ, 3)
    x_mean = mean(x)
    y_mean = mean(y)
    z_mean = mean(z)
    
    # If time/timerange has been assigned, use it
    time = nothing
    if ENSs[1][4] !== nothing
        time = ENSs[1][4]
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
    FRs_mean = EuAngle2Sph(EulerAngles(x_mean, y_mean, z_mean))
    FRs_mean = ChangeCovariance(FRs_mean, Covariance(cov))
    FRs_mean = ChangeTime(FRs_mean, time)

    return FRs_mean
end


function Ensemble2Vector(ENSc::Matrix{FiniteRotCart})

    # Calculate mean vector and its covariance
    return Finrot2Cart(Ensemble2Vector(Finrot2Sph(ENSc)))
    
end


function Ensemble2Vector(ENSs::Matrix{EulerVectorSph}) 

    # Ensemble array components [ensMag]
    XYZ = map(v -> sph2cart(v[1], v[2], v[3]), ENSs)

    # Calculate mean vector and its covariance
    x_mean, y_mean, z_mean, cov = Ensemble2Vector(getindex.(XYZ, 1), getindex.(XYZ, 2), getindex.(XYZ,3))
    
    # If time/timerange has been assigned, use it
    time = nothing
    if ENSs[1][4] !== nothing
        time = ENSs[1][4]
    end
    
    # Mean pole in degrees, magnitude in [ensMag], covariace in [ensMag ^2]
    return T(cart2sph(x_mean, y_mean, z_mean), time, Covariance(cov))
end


function Ensemble2Vector(ENSc::Matrix{EulerVectorCart})

    # Calculate mean vector and its covariance
    x_mean, y_mean, z_mean, cov = Ensemble2Vector(getindex.(ENSc, 1), getindex.(ENSc, 2), getindex.(ENSc, 3))
    
    # If time range has been assigned, use it
    time = nothing
    if ENSc[1][4] !== nothing
        time = ENSc[1][4]
    end
    
    # Mean vector in [ensMag], covariace in [ensMag ^2]
    return EulerVectorCart(x_mean, y_mean, z_mean, time, cov)
    
end


function Ensemble2Vector(x::Union{Matrix, Vector}, y::Union{Matrix, Vector}, z::Union{Matrix, Vector})

    # Ensemble length
    Nsize = length(x)
    
    # Mean xyz values
    x_mean = mean(x)
    y_mean = mean(y)
    z_mean = mean(z)
    
    # Set empty covariance ensemble
    covEnsemble = Array{Float64}(undef, Nsize, 6)
    
    # Calculate covariance elements [ensMag ^2]
    for i=1:Nsize
        covEnsemble[i,1] = (x[i]-x_mean) * (x[i]-x_mean)
        covEnsemble[i,2] = (x[i]-x_mean) * (y[i]-y_mean)
        covEnsemble[i,3] = (x[i]-x_mean) * (z[i]-z_mean)
        covEnsemble[i,4] = (y[i]-y_mean) * (y[i]-y_mean)
        covEnsemble[i,5] = (y[i]-y_mean) * (z[i]-z_mean)
        covEnsemble[i,6] = (z[i]-z_mean) * (z[i]-z_mean)
    end
    
    # Build Covariance 
    covariance = map(ii -> mean(covEnsemble[:,ii]), collect(1:6))
    
    # Mean vector in [ensMag], covariace in [ensMag ^2]
    return [x_mean, y_mean, z_mean, covariance]
     
end