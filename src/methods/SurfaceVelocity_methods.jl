# --- Outer structure methods ---

# Stat
Stat(a::Array{Float64}) = Stat(a[1], a[2])


# Spherical Euler vector
SurfaceVelocityVector(lon, lat, tv) = SurfaceVelocityVector(lon, lat, nothing, nothing, tv, nothing)
SurfaceVelocityVector(lon, lat, tv::Array) = SurfaceVelocityVector(lon, lat, nothing, nothing, Stat(tv), nothing)
SurfaceVelocityVector(lon, lat, ev, nv) = SurfaceVelocityVector(lon, lat, ev, nv, nothing, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), nothing, nothing)
SurfaceVelocityVector(lon, lat, ev, nv, tv) = SurfaceVelocityVector(lon, lat, ev, nv, tv, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array, tv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), Stat(tv), nothing)