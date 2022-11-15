@testset "Coordinate System Transformations" begin

    @testset "Numbers" begin
        cart1 = sph2cart(60, 30)
        x2, y2, z2 = sph2cart(60, 30, 1)
        
        sph2 = cart2sph(x2, y2, z2)
        cart3 = sph2cart(sph2[1], sph2[2], sph2[3])
        
        @test cart1 == (x2, y2, z2)
        @test all([isapprox(cart1[i], cart3[i]) for i in [1 2 3]])

        @test sph2cart(60, 30) == (0.43301270189221946, 0.75, 0.49999999999999994)
        @test cart2sph(1,2,3) == (63.43494882292201, 53.30077479951012, 3.7416573867739413)
    end

    @testset "Matrices" begin
    end

    @testset "Vectors" begin
    end

end