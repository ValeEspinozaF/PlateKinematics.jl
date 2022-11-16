@testset "Add Finite Rotations" begin

    using PlateKinematics: Add_FiniteRotations

    FRs1 = FiniteRotSph(87.21, -62.00, 19.63)
    FRs2 = FiniteRotSph(86.73, -60.01, -16.86)
    FRs_out = FiniteRotSph(85.02148146350461, -73.90357631188796, 2.8415079851017944)

    @test Add_FiniteRotations(FRs1, FRs2) == FRs_out
end