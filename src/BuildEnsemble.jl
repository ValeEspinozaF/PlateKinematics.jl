using PlateKinematics: CorrelatedEnsemble3D
using PlateKinematics: Covariance, CovToMatrix, FiniteRotCart
using PlateKinematics.FiniteRotationsTransformations: Finrot2EuAngle, EuAngle2Sph

function BuildEnsemble3D(FRs::FiniteRotSph, Nsize = 1e6)

    N = floor(Int, Nsize)

    covMatrix = CovToMatrix(FRs.Covariance)
    xc, yc, zc = CorrelatedEnsemble3D(covMatrix, N)
    
    # Get Euler angles
    EuAngles = Finrot2EuAngle(FRs::FiniteRotSph)

    # Build ensemble
    EAx = EuAngles.X .+ xc
    EAy = EuAngles.Y .+ yc
    EAz = EuAngles.Z .+ zc

    return EuAngle2Sph(EAx, EAy, EAz)

    #return mapslices(v -> FiniteRotCart(v), [xa ya za], dims=(2))
end