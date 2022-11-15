module PlateKinematics

# 3D coordinate system transformations
export cart2sph, sph2cart

# Core kinematic structures
export Covariance, FiniteRotSph, FiniteRotCart

# Finite rotation units and system transformations
export Finrot2Rad, Finrot2Deg
export Finrot2Cart, Finrot2Sph, Finrot2Matrix


include("CoordinateSystemTransformations.jl")
include("Covariances.jl")
include("FiniteRotations.jl")
include("FiniteRotationTransformations.jl")

end
