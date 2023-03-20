"""
$(TYPEDEF)

Mean and standard deviation of a parameter:

Fields
------
* `Mean::Float64`: Mean (average)
* `StDev::Float64`: Standard deviation

Examples:
------
```julia-repl
julia> PlateKinematics.Stat(10.0, 20.0)
PlateKinematics.Stat(10.0, 20.0)

julia> PlateKinematics.Stat([10.0 20.0])
PlateKinematics.Stat(10.0, 20.0)
```
"""
struct Stat
    "Mean (average)."
        Mean::Float64
    "Standard deviation."
        StDev::Float64
end

"""
$(TYPEDEF)

Surface velocity vector components, expressed in mm/yr.

Fields
------
* `Lon::Float64`: Longitude of the surface point in degrees-East
* `Lat::Float64`: Latitude of the surface point in degrees-North
* `EastVel::Union{Float64, Stat, Nothing}`: East-component of the velocity in mm/yr
* `NorthVel::Union{Float64, Stat, Nothing}`: North-component of the velocity in mm/yr
* `TotalVel::Union{Float64, Stat, Nothing}`: Total velocity in mm/yr
* `Azimuth::Union{Float64, Stat, Nothing}`: Azimuth of the velocity vector as measured clockwise from the North

Examples:
------
```julia-repl
julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0)
PlateKinematics.SurfaceVelocityVector(10.0, 20.0, nothing, nothing, 4.0, nothing)

julia> totalVel = PlateKinematics.Stat(2.5, 2.0);
julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, totalVel)
PlateKinematics.SurfaceVelocityVector(10.0, 20.0, nothing, nothing, PlateKinematics.Stat(2.5, 2.0), nothing)

julia> PlateKinematics.SurfaceVelocityVector(10, 20, [2.5, 2])
PlateKinematics.SurfaceVelocityVector(10.0, 20.0, nothing, nothing, PlateKinematics.Stat(2.5, 2.0), nothing)

julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0)
PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0, nothing, nothing)

julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0, 2.0)
PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0, 2.0, nothing)
```
"""
struct SurfaceVelocityVector
    "Longitude of the surface point in degrees-East."
        Lon::Float64
    "Latitude of the surface point in degrees-North."
        Lat::Float64
    "East-component of the velocity in mm/yr."
        EastVel::Union{Float64, Stat, Nothing}
    "North-component of the velocity in mm/yr."
        NorthVel::Union{Float64, Stat, Nothing}
    "Total velocity in mm/yr."
        TotalVel::Union{Float64, Stat, Nothing}
    "Azimuth of the velocity vector as measured clockwise from the North."
        Azimuth::Union{Float64, Stat, Nothing}    
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