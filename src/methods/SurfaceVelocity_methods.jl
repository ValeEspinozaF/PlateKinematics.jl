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

function Base.show(io::IO, x::Stat)
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(Stat)]))
    println(string(Stat) * ":")
    for field_name in fieldnames(Stat)
        field_value = getfield(x, field_name)
        field_name_padded = rpad(field_name, max_field_name_length)
        try
            println(io, "\t$field_name_padded : $(round(field_value, digits=2))")
        catch
            println(io, "\t$field_name_padded : $field_value")
        end
    end
end


function Base.show(io::IO, x::SurfaceVelocityVector)
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(SurfaceVelocityVector)]))
    println(string(SurfaceVelocityVector) * ":")
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

        if isnothing(field_value)
            println(io, "\t$field_name_padded : $field_value")
        elseif typeof(field_value) == Stat
            println(io, "\t$field_name_padded : $(round(field_value.Mean, digits=2)) ± $(round(field_value.StDev, digits=2))")
        else
            println(io, "\t$field_name_padded : $(round(field_value, digits=2))")
        end
    end
end