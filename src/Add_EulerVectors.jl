function Add_EulerVectors(
    EVs1::EulerVectorSph, EVs2::EulerVectorSph, 
    Nsize=100000::Int64)

    if CovIsZero(EVs1.Covariance) || CovIsZero(EVs2.Covariance)
        error("Provided Euler Vector must include a valid covariance.")
    end

    covMatrix1 = CovToMatrix(EVs1)
    covMatrix2 = CovToMatrix(EVs2)

    if !CheckCovariance(covMatrix1)
        covMatrix1 = ReplaceCovariaceEigs(covMatrix1)
    end

    if !CheckCovariance(covMatrix2)
        covMatrix2 = ReplaceCovariaceEigs(covMatrix2)
    end

    xc1, yc1, zc1 = CorrelatedEnsemble3D(covMatrix1, Nsize)
    xc2, yc2, zc2 = CorrelatedEnsemble3D(covMatrix2, Nsize)

    # Get Euler vector in cartesian coordinates
    x1, y1, z1 = sph2cart(EVs1.Lon, EVs1.Lat, EVs1.AngVelocity)
    x2, y2, z2 = sph2cart(EVs2.Lon, EVs2.Lat, EVs2.AngVelocity)

    # Build ensemble
    EVx = x1 .+ xc1
    EVy = y1 .+ yc1
    EVz = z1 .+ zc1
    EVx .+= x2 .+ xc2
    EVy .+= y2 .+ yc2
    EVz .+= z2 .+ zc2

    return ToEVs(EVx, EVy, EVz, EVs1.TimeRange)
end
