module PlateKinematics

using LinearAlgebra, Statistics

# 3D coordinate system transformations
export cart2sph, sph2cart

# Core kinematic structures
export Covariance, FiniteRotSph, FiniteRotCart

# Finite rotation units and system transformations
export Finrot2Rad, Finrot2Deg
export Finrot2Cart, Finrot2Sph, Finrot2Matrix


# Structures
include("Covariances.jl")
include("FiniteRotations.jl")
include("EulerVector.jl")

# Transformations
include("CoordinateSystemTransformations.jl")
include("FiniteRotationTransformations.jl")

# Functions
include("CorrelatedEnsemble3D.jl")
include("BuildEnsemble.jl")
include("Ensemble2Vector.jl")
include("Add_FiniteRotations.jl")


end
 