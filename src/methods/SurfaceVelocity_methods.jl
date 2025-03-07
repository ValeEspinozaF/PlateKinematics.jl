# --- Outer structure methods ---

# Stat
Stat(a::Array{Float64}) = Stat(a[1], a[2])


# Suface velocity vector
SurfaceVelocityVector(lon, lat, tv) = SurfaceVelocityVector(lon, lat, nothing, nothing, tv, nothing)
SurfaceVelocityVector(lon, lat, tv::Array) = SurfaceVelocityVector(lon, lat, nothing, nothing, Stat(tv), nothing)
SurfaceVelocityVector(lon, lat, ev, nv) = SurfaceVelocityVector(lon, lat, ev, nv, nothing, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), nothing, nothing)
SurfaceVelocityVector(lon, lat, ev, nv, tv) = SurfaceVelocityVector(lon, lat, ev, nv, tv, nothing)
SurfaceVelocityVector(lon, lat, ev::Array, nv::Array, tv::Array) = SurfaceVelocityVector(lon, lat, Stat(ev), Stat(nv), Stat(tv), nothing)


# --- Base overload methods ---

function Base.show(io::IO, m::Stat)
    print(io, "Stat(", m.Mean, ", ", m.StDev, ")")
end

function Base.show(io::IO, ::MIME"text/plain", x::Stat)
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(Stat)]))
    print(io, "Stat:\n")
    for field_name in fieldnames(Stat)
        field_value = getfield(x, field_name)
        field_name_padded = rpad(field_name, max_field_name_length)
        try
            print(io, "\t$field_name_padded : $(round(field_value, digits=2))\n")
        catch
            print(io, "\t$field_name_padded : $field_value\n")
        end
    end
end

function Base.show(io::IO, m::SurfaceVelocityVector)
    try
        print(io, "SurfaceVelocityVector(", m.Lon, ", ", m.Lat, ", ", m.EastVel.Mean, ", ", m.NorthVel.Mean, ")")
    catch
        print(io, "SurfaceVelocityVector(", m.Lon, ", ", m.Lat, ", ", m.EastVel, ", ", m.NorthVel, ")")
    end
end

function Base.show(io::IO, ::MIME"text/plain", x::SurfaceVelocityVector)
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(SurfaceVelocityVector)]))
    print(io, "SurfaceVelocityVector:\n")
    for field_name in fieldnames(SurfaceVelocityVector)
        field_value = getfield(x, field_name)
        field_name_padded = rpad(field_name, max_field_name_length)

        if isnothing(field_value)
            println(io, "\t$field_name_padded : $field_value")
        elseif typeof(field_value) == Stat
            println(io, "\t$field_name_padded : $(round(field_value.Mean, digits=2)) ± $(round(field_value.StDev, digits=2))")
        else
            println(io, "\t$field_name_padded : $(round(field_value, digits=2))")
        end
    end
end