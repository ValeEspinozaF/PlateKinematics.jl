@testset "Covariance" begin

    array1 = [0 0 0 0 0 0]
    cov1 = Covariance()
    cov2 = Covariance(0,0,0,0,0,0)
    cov3 = Covariance(array1)
    cov4 = Covariance([1,2,3,4,5,6])


    @test cov1 == cov2
    @test cov2 == cov3
    @test PlateKinematics.CovToArray(cov2) == array1
    @test PlateKinematics.CovToMatrix(cov4) == [1 2 3; 2 4 5; 3 5 6] 
    @test PlateKinematics.CovIsZero(cov2)
    @test !PlateKinematics.CovIsZero(cov4)

end