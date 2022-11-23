@testset "Interpolate Finite Rotations" begin

    using PlateKinematics: Interpolate_FiniteRotation

    FRs1 = FiniteRotSph(87.21, -62.00, 19.63, 0.78)
    FRs2 = FiniteRotSph(86.73, -60.01, -16.86, 6.57)

    @test Interpolate_FiniteRotation(FRs1, FRs2, FRs1.Time) == FRs1
    @test Interpolate_FiniteRotation(FRs1, FRs2, FRs2.Time) == FRs2


    # Taken from Cox - Plate Tectonics, pp. 246 
    FRs1 = FiniteRotSph(129.9, 68.0, -7.8, 37)
    FRs2 = FiniteRotSph(142.8, 50.8, -9.8, 48)   
    FRs_out = FiniteRotSph(-44.391241415230084, -62.660029601043, 8.253188013001928, 40)

    @test Interpolate_FiniteRotation(FRs1, FRs2, 40) == FRs_out
    @test Interpolate_FiniteRotation([FRs1, FRs2], [40, 40]) == [FRs_out, FRs_out] 
end