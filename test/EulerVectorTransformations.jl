@testset "Euler Vector Transformations" begin

    using PlateKinematics: ToEVs, ToEVc, IsEqual

    # From Cox(2008) Table 4-4
    EVs_PA = PlateKinematics.EulerVectorSph(97.2, -61.7, 0.967)
    EVc_PA = PlateKinematics.EulerVectorCart(-0.0575, 0.4548, -0.8514)

    @test IsEqual(ToEVc(EVs_PA), EVc_PA, 3)
    @test IsEqual(ToEVs(EVc_PA), EVs_PA, 3)

end