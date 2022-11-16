using PlateKinematics: FiniteRotCart, EulerVectorCart

function Ensemble2Vector(ensembleXYZ::Matrix{FiniteRotCart})

    # Ensemble length
    Nsize = size(ensembleXYZ)[1]
    
    # Ensemble components [ensMag]
    x = [v.X for v in ensembleXYZ]
    y = [v.Y for v in ensembleXYZ]
    z = [v.Z for v in ensembleXYZ]
    
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
    covariance = Array{Float64}(undef, 6)
    for ii=1:6
        covariance[ii] = mean(covEnsemble[:,ii]) 
    end
    
    # Mean vector in [ensMag], covariace in [ensMag ^2]
    return FiniteRotCart(x_mean, y_mean, z_mean, covariance)
    
end