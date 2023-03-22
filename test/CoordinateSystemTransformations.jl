@testset "Coordinate System Transformations" begin

    using PlateKinematics: sph2cart, cart2sph

    @testset "Numbers" begin
        cart1 = sph2cart(60.0, 30.0)
        cart2 = sph2cart(60.0, 30.0, 1.0)
        
        sph2 = cart2sph(cart2[1], cart2[2], cart2[3])
        cart3 = sph2cart(sph2[1], sph2[2], sph2[3])
        
        @test all([isapprox(cart1[i], cart2[i]) for i in [1 2 3]])
        @test all([isapprox(cart1[i], cart3[i]) for i in [1 2 3]])

        #@test sph2cart(60, 30) == (0.43301270189221946, 0.75, 0.49999999999999994)
        #@test cart2sph(1,2,3) == (63.43494882292201, 53.30077479951012, 3.7416573867739413)
    end

    @testset "Matrices" begin
    end

    @testset "Vectors" begin
    end

end