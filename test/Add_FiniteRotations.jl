@testset "Add Finite Rotations" begin

    using PlateKinematics: FiniteRotSph, Add_FiniteRotations, IsEqual

    FRs1 = FiniteRotSph(150.1, 70.5, 20.3)
    FRs2 = FiniteRotSph(145.0, 40.0, -11.4)
    FRs_add = Add_FiniteRotations(FRs1, FRs2)
    FRs_out = FiniteRotSph(-75.94, 78.09, 11.97)

    @test IsEqual(FRs_add, FRs_out, 1e-1)
end