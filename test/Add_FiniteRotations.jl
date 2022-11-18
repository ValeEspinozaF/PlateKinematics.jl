@testset "Add Finite Rotations" begin

    using PlateKinematics: Add_FiniteRotations

    FRs1 = FiniteRotSph(150.1, 70.5, 20.3)
    FRs2 = FiniteRotSph(145.0, 40.0, -11.4)
    FRs_out = FiniteRotSph(-75.94058301542901, 78.09279618197233, 11.973721246059403)

    @test Add_FiniteRotations(FRs1, FRs2) == FRs_out
end