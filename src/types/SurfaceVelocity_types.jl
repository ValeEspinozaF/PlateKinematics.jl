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
PlateKinematics.Stat:
        Mean  : 10.0
        StDev : 20.0

julia> stat = [10.0 20.0]
julia> PlateKinematics.Stat(stat)
PlateKinematics.Stat:
        Mean  : 10.0
        StDev : 20.0
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
PlateKinematics.SurfaceVelocityVector:
        Lon      : 10.0
        Lat      : 20.0
        EastVel  : nothing
        NorthVel : nothing
        TotalVel : 4.0
        Azimuth  : nothing

julia> PlateKinematics.SurfaceVelocityVector(10, 20, [2.5, 2])
PlateKinematics.SurfaceVelocityVector:
        Lon      : 10.0
        Lat      : 20.0
        EastVel  : nothing
        NorthVel : nothing
        TotalVel : 2.5 ± 2.0
        Azimuth  : nothing

julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0)
PlateKinematics.SurfaceVelocityVector:
        Lon      : 10.0
        Lat      : 20.0
        EastVel  : 4.0
        NorthVel : 3.0
        TotalVel : nothing
        Azimuth  : nothing

julia> PlateKinematics.SurfaceVelocityVector(10.0, 20.0, 4.0, 3.0, 2.0)
PlateKinematics.SurfaceVelocityVector:
        Lon      : 10.0
        Lat      : 20.0
        EastVel  : 4.0
        NorthVel : 3.0
        TotalVel : 2.0
        Azimuth  : nothing
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