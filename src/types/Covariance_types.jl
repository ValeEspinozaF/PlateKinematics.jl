using DocStringExtensions

"""
$(TYPEDEF)

Covariance upper triangle elements. Expressed in radians² for Finite Rotations and in radians²/Myr² for Euler Vectors.

# Examples:

```julia-repl
julia> PlateKinematics.Covariance()
PlateKinematics.Covariance(0, 0, 0, 0, 0, 0)

julia> PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)
PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.Covariance(array)
PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)
```
"""
struct Covariance
    C11::Float64
    C12::Float64
    C13::Float64
    C22::Float64
    C23::Float64
    C33::Float64
end