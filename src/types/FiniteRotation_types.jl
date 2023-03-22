using DocStringExtensions

"""
$(TYPEDEF)

Finite rotation in Spherical coordinates, expressed in degrees.

Fields
------
* `Lon::Float64`: Longitude of the rotation axis in degrees-East
* `Lat::Float64`: Latitude of the rotation axis in degrees-North
* `Angle::Float64`: Angle of rotation in degrees
* `Time::Union{Float64, Nothing}`: Age of rotation in million years
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²

Examples:
------
```julia-repl
julia> PlateKinematics.FiniteRotSph(30, 20, 10)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [30, 20, 10];
julia> PlateKinematics.FiniteRotSph(array)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> PlateKinematics.FiniteRotSph(30, 20, 10, 2)
PlateKinematics.FiniteRotSph(30, 20, 10, 2, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotSph(30, 20, 10, array)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotSph(30, 20, 10, 2, array)
PlateKinematics.FiniteRotSph(30, 20, 10, 2, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))
```
"""
struct FiniteRotSph
    "Longitude of the rotation axis in degrees-East."
        Lon::Float64
    "Latitude of the rotation axis in degrees-North."
        Lat::Float64
    "Angle of rotation in degrees."
        Angle::Float64
    "Age of rotation in million years."
        Time::Union{Float64, Nothing}
    "[`Covariance`](@ref) in radians²."
        Covariance::Covariance
end



"""
$(TYPEDEF)

Finite rotation in Cartesian coordinates, expressed in degrees.

Fields
------
* `X::Float64`: X-coordinate in degrees
* `Y::Float64`: Y-coordinate in degrees
* `Z::Float64`: Z-coordinate in degrees
* `TimeRange::Union{Float64, Nothing}`: Age of rotation in million years
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²

Examples:
------
```julia-repl
julia> PlateKinematics.FiniteRotCart(1, 2, 3)
PlateKinematics.FiniteRotCart(1, 2, 3, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [30, 20, 10];
julia> PlateKinematics.FiniteRotCart(array)
PlateKinematics.FiniteRotCart(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> PlateKinematics.FiniteRotCart(1, 2, 3, 1.5)
PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotCart(30, 20, 10, array)
PlateKinematics.FiniteRotCart(30, 20, 10, nothing, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, array)
PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))
```
"""
struct FiniteRotCart
    "X-coordinate in degrees."
        X::Float64
    "Y-coordinate in degrees."
        Y::Float64
    "Z-coordinate in degrees."
        Z::Float64
    "Age of rotation in million years."
        Time::Union{Float64, Nothing}
    "[`Covariance`](@ref) in radians²."
        Covariance::Covariance
end

"""
$(TYPEDEF)

Euler angles that describe the rotation around the three main axes on Earth.

Fields
------
* `X::Float64`: Angle of rotation around the X-axis (0N, 0E)
* `Y::Float64`: Angle of rotation around the Y-axis (0N, 90E)
* `Z::Float64`: Angle of rotation around the Z-axis (90N, 0E)

Examples: 
------
```julia-repl
julia> PlateKinematics.EulerAngles(4, 5, 6)
PlateKinematics.EulerAngles(4, 5, 6)

julia> array = [4, 5, 6];
julia> PlateKinematics.EulerAngles(array)
PlateKinematics.EulerAngles(4, 5, 6)
```
"""
struct EulerAngles
    "Angle of rotation around the X-axis (0N, 0E)."
        X::Float64
    "Angle of rotation around the Y-axis (0N, 90E)."
        Y::Float64
    "Angle of rotation around the Z-axis (90N, 0E)."
        Z::Float64
end