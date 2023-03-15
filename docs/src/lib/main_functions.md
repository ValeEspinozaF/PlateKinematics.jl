```@meta
CurrentModule = PlateKinematics
```

# Main Functions

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