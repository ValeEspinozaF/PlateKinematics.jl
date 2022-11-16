using PlateKinematics: CorrelatedEnsemble3D
using PlateKinematics: Covariance, CovToMatrix, FiniteRotCart, EulerVectorCart

function BuildEnsemble3D(FRc::Union{FiniteRotCart, EulerVectorCart}, Nsize = 1e6)

    N = floor(Int, Nsize)

    covMatrix = CovToMatrix(FRc.Covariance)
    xc, yc, zc = CorrelatedEnsemble3D(covMatrix, N)
    
    xa = FRc.X .+ xc
    ya = FRc.Y .+ yc
    za = FRc.Z .+ zc

    return mapslices(v -> FiniteRotCart(v), [xa ya za], dims=(2))
end