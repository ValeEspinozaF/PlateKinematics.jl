struct Stat
    Mean::Number
    StDev::Number
end

struct SurfaceVelocityVector
    # Surface velocity vector is mm/yr

    Lon::Number
    Lat::Number
    EastVel::Union{Number, Stat, Nothing}
    NorthVel::Union{Number, Stat, Nothing}
    TotalVel::Union{Number, Stat, Nothing}
    Azimuth::Union{Number, Stat, Nothing}    
end


# --- Aditional outer structure methods ---

# Spherical Euler vector
SurfaceVelocityVector(lon, lat, totalVel) = SurfaceVelocityVector(lon, lat, nothing, nothing, totalVel, nothing)
SurfaceVelocityVector(lon, lat, eastVel, northVel) = SurfaceVelocityVector(lon, lat, eastVel, northVel, nothing, nothing)
SurfaceVelocityVector(lon, lat, eastVel, northVel, totalVel) = SurfaceVelocityVector(lon, lat, eastVel, northVel, totalVel, nothing)
#Base.getindex(x::SurfaceVelocityVector, i::Int) = getfield(x, i)