# --- Outer structure methods ---

# Spherical Euler vector
EulerVectorSph(lon, lat, angVelocity) = EulerVectorSph(lon, lat, angVelocity, nothing, Covariance())
EulerVectorSph(lon, lat, angVelocity, timeRange) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance())
EulerVectorSph(lon, lat, angVelocity, covariance::Covariance) = EulerVectorSph(lon, lat, angVelocity, nothing, covariance)
EulerVectorSph(lon, lat, angVelocity, timeRange, array::Array) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance(array))
EulerVectorSph(array::Array) = EulerVectorSph(array[1], array[2], array[3], nothing, Covariance())
EulerVectorSph(array::Array, timeRange) = EulerVectorSph(array[1], array[2], array[3], timeRange, Covariance())
EulerVectorSph(array::Array, timeRange, covariance::Covariance) = EulerVectorSph(array[1], array[2], array[3], timeRange, covariance)
EulerVectorSph(array::Array, timeRange, covariance::Array) = EulerVectorSph(array[1], array[2], array[3], timeRange, Covariance(covariance))

function EulerVectorSph(lon::N, lat::N, angVelocity::N, array::Array{N}) where {N<:Float64}
    if length(array) == 2
        return EulerVectorSph(lon, lat, angVelocity, array, Covariance())
    else
        return EulerVectorSph(lon, lat, angVelocity, nothing, Covariance(array))
    end
end


# Cartesian Euler vector
EulerVectorCart(x, y, z) = EulerVectorCart(x, y, z, nothing, Covariance())
EulerVectorCart(x, y, z, timeRange) = EulerVectorCart(x, y, z, timeRange, Covariance())
EulerVectorCart(x, y, z, covariance::Covariance) = EulerVectorCart(x, y, z, nothing, covariance)
EulerVectorCart(x, y, z, array::Array) = EulerVectorCart(x, y, z, nothing, Covariance(array))
EulerVectorCart(x, y, z, timeRange, array::Array) = EulerVectorCart(x, y, z, timeRange, Covariance(array))
EulerVectorCart(array::Array) = EulerVectorCart(array[1], array[2], array[3], nothing, Covariance())
EulerVectorCart(array::Array, timeRange) = EulerVectorCart(array[1], array[2], array[3], timeRange, Covariance())
EulerVectorCart(array::Array, timeRange, covariance::Covariance) = EulerVectorCart(array[1], array[2], array[3], timeRange, covariance)
EulerVectorCart(array::Array, timeRange, covariance::Array) = EulerVectorCart(array[1], array[2], array[3], timeRange, Covariance(covariance))

function EulerVectorCart(x::N, y::N, z::N, array::Array{N}) where {N<:Float64}
    if length(array) == 2
        return EulerVectorCart(x, y, z, array, Covariance())
    else
        return EulerVectorCart(x, y, z, nothing, Covariance(array))
    end
end



# --- Base overload methods ---

Base.getindex(x::EulerVectorSph, i::Int) = getfield(x, i)
Base.getindex(x::EulerVectorCart, i::Int) = getfield(x, i)

function Base.show(io::IO, x::Union{EulerVectorSph, EulerVectorCart})
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
    x::Union{EulerVectorSph, EulerVectorCart}, 
    y::Union{EulerVectorSph, EulerVectorCart}, 
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

        elseif fieldname == :TimeRange
            if isnothing(x.TimeRange) && isnothing(y.TimeRange)
                continue
            elseif isnothing(x.TimeRange) && !isnothing(y.TimeRange)
                return false
            elseif isnothing(x.TimeRange) && !isnothing(y.TimeRange)
                return false
            else
                for j in 1:2
                    field_x = x.TimeRange[j]
                    field_y = y.TimeRange[j]
                    rounded_x = round(field_x, sigdigits=sig)
                    rounded_y = round(field_y, sigdigits=sig)

                    if rounded_x != rounded_y
                        return false
                    end
                end
            end

        else
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