@testset "Finite Rotations" begin

    using PlateKinematics.FiniteRotationsTransformations: Finrot2Rad, Finrot2Deg, Finrot2Cart, Finrot2Sph, Finrot2Matrix

    @testset "Numbers" begin
        cov1 = Covariance(1,1,2,2,3,3)
        FRc1 = FiniteRotCart(9/pi,18/pi,9/pi)
        FRs1 = FiniteRotSph(60, 30, 9/pi)

        FRc2 = Finrot2Rad(FRc1)
        FRs2 = Finrot2Rad(FRs1)
        FRc3 = Finrot2Deg(FRc2)
        FRs3 = Finrot2Deg(FRs2)

        FRc4 = Finrot2Cart(FRs1)
        FRs4 = Finrot2Sph(FRc4)
        
        @test FRc2 == FiniteRotCart(0.05, 0.1, 0.05)
        @test FRs2 == FiniteRotSph(60, 30, 0.05)
        @test isapprox(FRc1.X, FRc3.X) && isapprox(FRc1.Y, FRc3.Y) && isapprox(FRc1.Z, FRc3.Z) 
        @test isapprox(FRs1.Lon, FRs3.Lon) && isapprox(FRs1.Lat, FRs3.Lat) && isapprox(FRs1.Angle, FRs3.Angle) 
        @test [FRc4.X, FRc4.Y, FRc4.Z] == [1.2404900146990323, 2.1485917317405874, 1.4323944878270578]
        @test isapprox(FRs1.Lon, FRs4.Lon) && isapprox(FRs1.Lat, FRs4.Lat) && isapprox(FRs1.Angle, FRs4.Angle) 


        FRs12 = Finrot2Sph(Finrot2Matrix(FRs1))
        FRc12 = Finrot2Cart(Finrot2Matrix(FRc1))

        @test isapprox(FRs1.Lon, FRs12.Lon) && isapprox(FRs1.Lat, FRs12.Lat) && isapprox(FRs1.Angle, FRs12.Angle) 
        @test isapprox(FRc1.X, FRc12.X) && isapprox(FRc1.Y, FRc12.Y) && isapprox(FRc1.Z, FRc12.Z) 
    end

    @testset "Matrices" begin
    end
end