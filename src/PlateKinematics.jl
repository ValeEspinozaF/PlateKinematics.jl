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
include("EulerVectors.jl")

# Transformations
include("CoordinateSystemTransformations.jl")
include("FiniteRotationTransformations.jl")
include("EulerVectorTransformations.jl")

# Subsidiary functions
include("LoadData.jl")
include("SaveData.jl")
include("CorrelatedEnsemble3D.jl")
include("Ensemble2Vector.jl")
include("BuildEnsemble.jl")
include("Add_FiniteRotations.jl")
include("Invert_RotationMatrix.jl")
include("Multiply_RotationMatrices.jl")

# Main Functions
include("Interpolate_FiniteRotations.jl")
include("Convert_toStageEulerVector.jl")
include("Convert_toFiniteRotation.jl")



end
 