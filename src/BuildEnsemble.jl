"""
    BuildEnsemble3D(FRs::FiniteRotSph, Nsize=1e6::Number)
    
Draws `Nsize` Rotation Matrix samples from the covariance of a given Finite Rotation `FRs`.
"""
function BuildEnsemble3D(FRs::FiniteRotSph, Nsize=1e6::Number)

    if CovIsZero(FRs.Covariance)
        error("Provided Finite rotations must include a valid covariance.")
    end

    covMatrix = CovToMatrix(FRs)
    
    if !CheckCovariance(covMatrix)
        covMatrix = ReplaceCovariaceEigs(covMatrix)
    end

    xc, yc, zc = CorrelatedEnsemble3D(covMatrix, Nsize)

    # Get Euler angles
    EuAngles = ToEulerAngles(FRs)

    # Build ensemble
    EAx = EuAngles.X .+ xc
    EAy = EuAngles.Y .+ yc
    EAz = EuAngles.Z .+ zc

    return ToRotationMatrix(EAx, EAy, EAz)
end

"""
    BuildEnsemble3D(EVs::EulerVectorSph, Nsize=1e6::Number)

Draws `Nsize` Euler Vector samples from the covariance of a given Euler Vector `EVs`.
"""
function BuildEnsemble3D(EVs::EulerVectorSph, Nsize=1e6::Number)

    if CovIsZero(EVs.Covariance)
        error("Provided Euler Vector must include a valid covariance.")
    end

    covMatrix = CovToMatrix(EVs)
    
    if !CheckCovariance(covMatrix)
        covMatrix = ReplaceCovariaceEigs(covMatrix)
    end

    xc, yc, zc = CorrelatedEnsemble3D(covMatrix, Nsize)

    # Get Euler vector in cartesian coordinates
    x, y, z = sph2cart(EVs.Lon, EVs.Lat, EVs.AngVelocity)

    # Build ensemble
    EVx = x .+ xc
    EVy = y .+ yc
    EVz = z .+ zc

    return ToEVs(EVx, EVy, EVz)
end


"""
    CorrelatedEnsemble3D(matrix::Array{Number, 2}, Nsize::Number)

Generates a series of samples [x y z] based on a covariance matrix.
"""
function CorrelatedEnsemble3D(matrix::Array{Number, 2}, Nsize::Number)

    eig_va, eig_ve = eigen(matrix)
    
    data = eig_va .^ 0.5 .* randn(3, floor(Int, Nsize))
    ndata = [eig_ve * row for row in eachslice(data, dims=2)]

    return [getindex.(ndata,1), getindex.(ndata,2), getindex.(ndata,3)]
end


"""
    CheckCovariance(covMatrix::Array{Number, 2})

Check whether the covariance matrix yields any negative or imaginary eigenvalue.
"""
function CheckCovariance(covMatrix::Array{Number, 2})

    switch = true

    eig_va, _ = eigen(covMatrix)

    # Check imaginary part is non-existent
    if sum(imag(eig_va)) == 0.0

        chk = sum(eig_va)/sum(abs.(eig_va))

        if chk < 1
            
            negIdx = findall(x -> x < 0, eig_va)

            if length(negIdx) == 3
                error("No positive eigen values found.")

            else
                rel = abs.(eig_va[negIdx]) / maximum(eig_va)
                
                if length(findall(x -> x > 0.05, rel)) != 0
                    switch = false
                end

            end
        end
    else
        switch = false
    end

    return switch
end


"""
    ReplaceCovariaceEigs(covMatrix::Array{Number, 2})

Checks if a covariance-matrix has negative or imaginary eigenvalues, and replace 
the diagonal elements (variances) with an average of the positive eigenvalues,
while the other elements (covariances) are replaced by zeros.
"""
function ReplaceCovariaceEigs(covMatrix::Array{Number, 2})

    eig_va, _ = eigen(covMatrix)
    ave_va = mean(filter(x -> x > 0, eig_va))

    return [ave_va 0 0; 0 ave_va 0; 0 0 ave_va]
end