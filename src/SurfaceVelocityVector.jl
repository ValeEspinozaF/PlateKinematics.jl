"""
$(TYPEDEF)

Mean and standard deviation of a parameter:

Fields
------
* `Mean::Number`: Mean (average)
* `StDev::Number`: Standard deviation

Examples:
------
```julia-repl
julia> PlateKinematics.Stat(10, 20)
PlateKinematics.Stat(10, 20)

julia> PlateKinematics.Stat([10 20])
PlateKinematics.Stat(10, 20)
```
"""
struct Stat
    "Mean (average)."
        Mean::Number
    "Standard deviation."
        StDev::Number
end

"""
$(TYPEDEF)

Surface velocity vector components, expressed in mm/yr.

Fields
------
* `Lon::Number`: Longitude of the surface point in degrees-East
* `Lat::Number`: Latitude of the surface point in degrees-North
* `EastVel::Union{Number, Stat, Nothing}`: East-component of the velocity in mm/yr
* `NorthVel::Union{Number, Stat, Nothing}`: North-component of the velocity in mm/yr
* `TotalVel::Union{Number, Stat, Nothing}`: Total velocity in mm/yr
* `Azimuth::Union{Number, Stat, Nothing}`: Azimuth of the velocity vector as measured clockwise from the North

Examples:
------
```julia-repl
julia> PlateKinematics.SurfaceVelocityVector(10, 20, 4)
PlateKinematics.SurfaceVelocityVector(10, 20, nothing, nothing, 4, nothing)

julia> totalVel = PlateKinematics.Stat(2.5, 2);
julia> PlateKinematics.SurfaceVelocityVector(10, 20, totalVel)
PlateKinematics.SurfaceVelocityVector(10, 20, nothing, nothing, PlateKinematics.Stat(2.5, 2.0), nothing)

julia> PlateKinematics.SurfaceVelocityVector(10, 20, [2.5, 2])
PlateKinematics.SurfaceVelocityVector(10, 20, nothing, nothing, PlateKinematics.Stat(2.5, 2.0), nothing)

julia> PlateKinematics.SurfaceVelocityVector(10, 20, 4, 3)
PlateKinematics.SurfaceVelocityVector(10, 20, 4, 3, nothing, nothing)

julia> PlateKinematics.SurfaceVelocityVector(10, 20, 4, 3, 2)
PlateKinematics.SurfaceVelocityVector(10, 20, 4, 3, 2, nothing)
```
"""
struct SurfaceVelocityVector
    "Longitude of the surface point in degrees-East."
        Lon::Number
    "Latitude of the surface point in degrees-North."
        Lat::Number
    "East-component of the velocity in mm/yr."
        EastVel::Union{Number, Stat, Nothing}
    "North-component of the velocity in mm/yr."
        NorthVel::Union{Number, Stat, Nothing}
    "Total velocity in mm/yr."
        TotalVel::Union{Number, Stat, Nothing}
    "Azimuth of the velocity vector as measured clockwise from the North."
        Azimuth::Union{Number, Stat, Nothing}    
end


# --- Aditional outer structure methods ---

# Stat
Stat(a::Array) = Stat(a[1], a[2])


# Spherical Euler vector
SurfaceVelocityVector(lon, lat, tv) = SurfaceVelocityVector(lon, lat, nothing, nothing, tv, nothing)
SurfaceVelocityVector(lon, lat, tv::Array) = SurfaceVelocityVector(lon, lat, nothing, nothing, Stat(tv), nothing)
SurfaceVelocityVector(lon, lat, ev, nv) = SurfaceVelocityVector(lon, lat, ev, nv, nothing, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), nothing, nothing)
SurfaceVelocityVector(lon, lat, ev, nv, tv) = SurfaceVelocityVector(lon, lat, ev, nv, tv, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array, tv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), Stat(tv), nothing)
#Base.getindex(x::SurfaceVelocityVector, i::Int) = getfield(x, i)