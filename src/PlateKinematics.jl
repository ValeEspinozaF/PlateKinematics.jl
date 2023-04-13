"""
Main module for `PlateKinematics.jl` -- a compilation of tools for easy handling of Plate Kinematics functions with Julia 🌏 📐.

This package provides types, functions and documentation for working with Finite Rotations, Euler Vectors and Surface Velocities. \\
The knowledge builds from the framework layed down by Allan Cox in his book Plate Tectonics: How It Works.
"""
module PlateKinematics

using LinearAlgebra, Statistics
using DelimitedFiles, Serialization, Printf, DataFrames

# Structures
include("types/Covariance_types.jl")
include("types/FiniteRotation_types.jl")
include("types/EulerVector_types.jl")
include("types/SurfaceVelocity_types.jl")

# Methods
include("methods/Covariance_methods.jl")
include("methods/FiniteRotations_methods.jl")
include("methods/EulerVector_methods.jl")
include("methods/SurfaceVelocity_methods.jl")

# Transformations
include("CoordinateSystemTransformations.jl")
include("FiniteRotationTransformations.jl")
include("EulerVectorTransformations.jl")

# Subsidiary functions
include("LoadData.jl")
include("SaveData.jl")
include("BuildEnsemble.jl")
include("AverageEnsemble.jl")
include("Add_FiniteRotations.jl")
include("Invert_RotationMatrix.jl")
include("Multiply_RotationMatrices.jl")

# Main Functions
include("Interpolate_FiniteRotations.jl")
include("Concatenate_FiniteRotations.jl")
include("Convert_toStageEulerVector.jl")
include("Convert_toFiniteRotation.jl")
include("Calculate_SurfaceVelocity.jl")



end
 