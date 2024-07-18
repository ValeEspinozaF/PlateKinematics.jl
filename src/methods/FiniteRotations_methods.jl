# --- Outer structure methods ---

# Spherical finite rotations 
FiniteRotSph(lon, lat, angle) = FiniteRotSph(lon, lat, angle, nothing, Covariance())
FiniteRotSph(lon, lat, angle, time) = FiniteRotSph(lon, lat, angle, time, Covariance())
FiniteRotSph(lon, lat, angle, covariance::Covariance) = FiniteRotSph(lon, lat, angle, nothing, covariance)
FiniteRotSph(lon, lat, angle, array::Array) = FiniteRotSph(lon, lat, angle, nothing, Covariance(array))
FiniteRotSph(lon, lat, angle, time, array::Array) = FiniteRotSph(lon, lat, angle, time, Covariance(array))
FiniteRotSph(array::Array) = FiniteRotSph(array[1], array[2], array[3], nothing, Covariance())
FiniteRotSph(array::Array, time) = FiniteRotSph(array[1], array[2], array[3], time, Covariance())
FiniteRotSph(array::Array, time, covariance::Covariance) = FiniteRotSph(array[1], array[2], array[3], time, covariance)
FiniteRotSph(array::Array, time, covariance::Array) = FiniteRotSph(array[1], array[2], array[3], time, Covariance(covariance))


# Cartesian finite rotations 
FiniteRotCart(x, y, z) = FiniteRotCart(x, y, z, nothing, Covariance())
FiniteRotCart(x, y, z, time) = FiniteRotCart(x, y, z, time, Covariance())
FiniteRotCart(x, y, z, covariance::Covariance) = FiniteRotCart(x, y, z, nothing, covariance)
FiniteRotCart(x, y, z, array::Array) = FiniteRotCart(x, y, z, nothing, Covariance(array))
FiniteRotCart(x, y, z, time, array::Array) = FiniteRotCart(x, y, z, time, Covariance(array))
FiniteRotCart(array::Array) = FiniteRotCart(array[1], array[2], array[3], nothing, Covariance())
FiniteRotCart(array::Array, time) = FiniteRotCart(array[1], array[2], array[3], time, Covariance())
FiniteRotCart(array::Array, time, covariance::Array) = FiniteRotCart(array[1], array[2], array[3], time, Covariance(covariance))

# Euler angles
EulerAngles(array::Array) = EulerAngles(array[1], array[2], array[3])



# --- Base overload methods ---

Base.getindex(x::FiniteRotSph, i::Int) = getfield(x, i)
Base.getindex(x::FiniteRotCart, i::Int) = getfield(x, i)
Base.getindex(x::EulerAngles, i::Int) = getfield(x, i)

function Base.show(io::IO, x::Union{FiniteRotSph, FiniteRotCart, EulerAngles})
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(typeof(x))]))
    println(string(typeof(x)) * ":")
    for field_name in fieldnames(typeof(x))
        field_value = getfield(x, field_name)
        field_name_padded = rpad(field_name, max_field_name_length)
        try
            println(io, "\t$field_name_padded : $(round(field_value, digits=2))")
        catch
            println(io, "\t$field_name_padded : $field_value")
        end
    end
end



# --- Other type-specific functions ---

"""
    IsEqual(
        x::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
        y::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
        sig=6::Int64)

Compares two variables to determine if they are equal 
given an amount of significant digits `sig`. 
"""
function IsEqual(
    x::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
    y::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
    sig=6::Int64)

    if typeof(x) != typeof(y)
        return false
    end

    for fieldname in fieldnames(typeof(x))

        if fieldname == :Covariance
            for fieldname_cov in fieldnames(Covariance)
                field_x = getfield(x.Covariance, fieldname_cov)
                field_y = getfield(y.Covariance, fieldname_cov)
                rounded_x = round(field_x, sigdigits=sig)
                rounded_y = round(field_y, sigdigits=sig)

                if rounded_x != rounded_y
                    return false
                end
            end

        else

            if fieldname == :Time
                if isnothing(x.Time) && isnothing(y.Time)
                    continue
                elseif isnothing(x.Time) && !isnothing(y.Time)
                    return false
                elseif !isnothing(x.Time) && isnothing(y.Time)
                    return false
                end
            end

            field_x = getfield(x, fieldname)
            field_y = getfield(y, fieldname)
            rounded_x = round(field_x, sigdigits=sig)
            rounded_y = round(field_y, sigdigits=sig)

            if rounded_x != rounded_y
                return false
            end
        end
    end
    return true
end