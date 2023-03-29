```@meta
CurrentModule = PlateKinematics
```

# Concatenate Finite Rotations


Lest take for instance a direct example from Allan Cox' book for the motion of the Australian plate with respect to the Antartican plate. We are provided with total finite rotations (Table 7-3) for the ages 37 and 42 Ma (*mega-annun*, meaning million years before present):

| t(Ma) | Longitude(°E) | Latitude(°N) | Angle(°) |
|-------|:-------------:|:------------:|:--------:|
| 37.0  | 34.4          | 11.9         | -20.5    |
| 42.0  | 34.8          | 10.3         | -23.6    |

However, we wish the finite rotation for the age of 40 Ma, so we need to interpolate:

```julia
using PlateKinematics
using PlateKinematics: FiniteRotSph, Interpolate_FiniteRotation

FRs_37 = FiniteRotSph(34.4, 11.9, -20.5, 37.0);
FRs_42 = FiniteRotSph(34.8, 10.3, -23.6, 42.0);
Interpolate_FiniteRotation(FRs_37, FRs_42, 40.0)
```

The output finite rotation will be something in the lines of:

```REPL
FiniteRotSph:
        Lon     : -145.35
        Lat     : -10.89
        Angle   : 22.36
        Time    : 40.0
        Covariance : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```

Similarilly, one may interpolate between one finite rotation and present-day, shall we lack a younger constrain for the desired motion:

```julia
julia> Interpolate_FiniteRotation(FRs_42, 40.0)
```
```REPL
FiniteRotSph:
        Lon     : -145.2
        Lat     : -10.3
        Angle   : 22.48
        Time    : 40.0
        Covariance : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```



