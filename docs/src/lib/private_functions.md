```@meta
CurrentModule = PlateKinematics
```

# Private Functions

## Contents

```@contents
Pages = ["private_functions.md"]
Depth = 3
```

## Index

```@index
Pages = ["private_functions.md"]
```

## Private Functions

### Covariance-related functions
```@docs
CorrelatedEnsemble3D
CovIsZero
CheckCovariance
CovToMatrix
ReplaceCovariaceEigs
ToArray
```

### Mutate Structs
```@docs
ChangeLon
ChangeLat
ChangeAngle
ChangeTime
ChangeCovariance
```

### Others
```@docs
CartesianVelocity_toEN
GeographicalCoords_toCartesian
```