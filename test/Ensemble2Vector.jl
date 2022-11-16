@testset "Ensemble to Vector" begin

    using PlateKinematics: Ensemble2Vector, CovToArray

    Ens_FRc = [FiniteRotCart(1,2,3) FiniteRotCart(2,2,3) FiniteRotCart(1,1,3) FiniteRotCart(1,2,2) FiniteRotCart(2,2,2)]
    Vec_FRc = Ensemble2Vector(Ens_FRc)
    CovArray = CovToArray(Vec_FRc.Covariance)
    Array = [0.16  -0.08  -0.16  0.04  0.08  0.16]

    @test Vec_FRc.X == 1.4 && Vec_FRc.Y == 1.8 && Vec_FRc.Z == 2.6 
    @test all([isapprox(CovArray[i], Array[i]) for i in collect(1:6)])
end