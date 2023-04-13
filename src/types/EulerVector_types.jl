"""
$(TYPEDEF)

Euler vector in spherical coordinates with the following parameters:

Fields
------
* `Lon::Float64`: Longitude of the Euler pole in degrees-East
* `Lat::Float64`: Latitude of the Euler pole in degrees-North
* `AngVelocity::Float64`: Angular velocity in degrees/Myr
* `TimeRange::Union{Matrix, Nothing}`: Initial to final age of rotation
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²/Myr²

Examples:
------
```julia-repl
julia> PlateKinematics.EulerVectorSph(1, 2, 3)
PlateKinematics.EulerVectorSph:
        Lon         : 1.0
        Lat         : 2.0
        AngVelocity : 3.0
        TimeRange   : nothing
        Covariance  : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

julia> array = [30, 20, 10];
julia> PlateKinematics.EulerVectorSph(array)
PlateKinematics.EulerVectorSph:
        Lon         : 30.0
        Lat         : 20.0
        AngVelocity : 10.0
        TimeRange   : nothing
        Covariance  : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

julia> array = [1.5 2.5];
julia> length(array) == 2
true
julia> PlateKinematics.EulerVectorSph(30, 20, 10, array)
PlateKinematics.EulerVectorSph:
        Lon         : 30.0
        Lat         : 20.0
        AngVelocity : 10.0
        TimeRange   : [1.5 2.5]
        Covariance  : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

julia> array = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
julia> length(array) != 2
true
julia> PlateKinematics.EulerVectorSph(30, 20, 10, array)
PlateKinematics.EulerVectorSph:
        Lon         : 30.0
        Lat         : 20.0
        AngVelocity : 10.0
        TimeRange   : nothing
        Covariance  : PlateKinematics.Covariance(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
```
"""
struct EulerVectorSph
    "Longitude of the Euler pole in degrees-East."
        Lon::Float64
    "Latitude of the Euler pole in degrees-North."
        Lat::Float64
    "Angular velocity in degrees/Myr."
        AngVelocity::Float64
    "Initial to final age of rotation."
        TimeRange::Union{Matrix, Nothing}
    "[`Covariance`](@ref) in radians²/Myr²."
        Covariance::Covariance
    
end

"""
$(TYPEDEF)

Euler vector in Cartesian coordinates, expressed in degrees/Myr.

Fields
------
* `X::Float64`: X-coordinate in degrees/Myr
* `Y::Float64`: Y-coordinate in degrees/Myr
* `Z::Float64`: Z-coordinate in degrees/Myr
* `TimeRange::Union{Matrix, Nothing}`: Initial to final age of rotation
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²/Myr²

Examples:
------
Same outer Constructor Methods as [`EulerVectorSph`](@ref).
"""
struct EulerVectorCart
    "X-coordinate in degrees/Myr."
        X::Float64
    "Y-coordinate in degrees/Myr."
        Y::Float64
    "Z-coordinate in degrees/Myr."
        Z::Float64
    "Initial to final age of rotation."
        TimeRange::Union{Matrix, Nothing}
    "[`Covariance`](@ref) in radians²/Myr²."
        Covariance::Covariance
end