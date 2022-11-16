using Test
using PlateKinematics

@testset "PlateKinematics.jl" begin

    #doctest(PlateKinematics, manual=false)
    include("CoordinateSystemTransformations.jl")
    include("Covariances.jl")
    include("FiniteRotations.jl")
    include("Ensemble2Vector.jl")
    include("Add_FiniteRotations.jl")

end
