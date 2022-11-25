using PlateKinematics: CorrelatedEnsemble3D
using PlateKinematics: Covariance, CovToMatrix, FiniteRotSph
using PlateKinematics.FiniteRotationsTransformations: Finrot2EuAngle, EuAngle2Array3D

function BuildEnsemble3D(FRs::FiniteRotSph, Nsize = 1e6)

    N = floor(Int, Nsize)

    covMatrix = CovToMatrix(FRs.Covariance)
    
    if !CheckCovariance(covMatrix)
        covMatrix = ReplaceCovariaceEigs(covMatrix)
    end

    xc, yc, zc = CorrelatedEnsemble3D(covMatrix, N)

    # Get Euler angles
    EuAngles = Finrot2EuAngle(FRs::FiniteRotSph)

    # Build ensemble
    EAx = EuAngles.X .+ xc
    EAy = EuAngles.Y .+ yc
    EAz = EuAngles.Z .+ zc

    return EuAngle2Array3D(EAx, EAy, EAz)
end


function CheckCovariance(covMatrix)

    switch = true

    eig_va, _ = eigen(covMatrix)

    # Check imaginary part is non-existent
    if sum(imag(eig_va)) == 0.0

        chk = sum(eig_va)/sum(abs.(eig_va))

        if chk < 1
            
            negIdx = findall(x -> x < 0, eig_va)

            if length(negIdx) == 3
                throw("Error in eigen values. No positive values found.")

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

function ReplaceCovariaceEigs(covMatrix)

    eig_va, _ = eigen(covMatrix)
    ave_va = mean(filter(x -> x > 0, eig_va))

    return [ave_va 0 0; 0 ave_va 0; 0 0 ave_va]
end

using Statistics, LinearAlgebra
FRs = FiniteRotSph(65.37, -68.68, 10.3, 12.29, Covariance(0.0001344, 5.678e-5, 5.151e-5, 0.0001857, 7.154e-5, 0.0003873))
BuildEnsemble3D(FRs, 1e2)
