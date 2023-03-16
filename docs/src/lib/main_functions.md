```@meta
CurrentModule = PlateKinematics
```

# Main Functions

**PlateKinematics.jl** includes functions to aid in the step between [Finite Rotations](@ref) to [Euler Vectors](@ref) to [Surface Velocity](@ref). These steps usually involve interpolation and concatenation of Finite Rotations. All functions allow the user to work with (i) sampled ensembles of a Finite Rotations, (ii) an average Finite Rotation from which an ensemble is drawn, or (iii) a single Finite Rotation to which no [Covariance](@ref) has been given. The same principle applies to functions involving Euler Vectors. In many functions you will notice the optional parameter `Nsize`, which aims at providing control to the user on the size of the sampled ensemble of Finite Rotations/Euler Vector, shall a [Covariance](@ref) be provided.

## Contents

```@contents
Pages = ["main_functions.md"]
Depth = 3
```

## Index

```@index
Pages = ["main_functions.md"]
```

## Main Functions

### Build Sampled Ensembles
```@docs
BuildEnsemble3D
```

### Un-build Sampled Ensembles (Average)
```@docs
AverageEnsemble
```

### Interpolate Finite Rotations
```@docs
Interpolate_FiniteRotation
```

### Concatenate Finite Rotations
Concatenate two or more finite rotations into a plate circuit that links two plates. 
```@docs
Concatenate_FiniteRotations
```
Note that concatenation is nothing more than a summation of every two Finite Rotations
in a particular order. Knowing this, one may also use the [`Add_FiniteRotations`](@ref)
function.

### Finite Rotations to Euler Vector
```@docs
ToEulerVector
ToEulerVectorList
```

### Euler Vector de Finite Rotation
```@docs
ToFiniteRotation
```

### Calculate Surface Velocity
```@docs
Calculate_SurfaceVelocity
```