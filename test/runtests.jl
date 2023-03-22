using Test
using PlateKinematics

@testset "PlateKinematics.jl" begin

    #doctest(PlateKinematics, manual=false)

    include("CoordinateSystemTransformations.jl")
    include("Add_FiniteRotations.jl")
    include("Interpolate_FiniteRotation.jl")

end
