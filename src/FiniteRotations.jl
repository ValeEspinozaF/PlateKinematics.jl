using PlateKinematics: Covariance

struct FiniteRotSph
    Lon::Number
    Lat::Number
    Angle::Number
    Time::Union{Number, Nothing}
    Covariance::Covariance
end

struct FiniteRotCart
    X::Number
    Y::Number
    Z::Number
    Time::Union{Number, Nothing}
    Covariance::Covariance
end

struct FiniteRotMatrix
    Values::Matrix
end

struct EulerAngles
    X::Number
    Y::Number
    Z::Number
end


# --- Aditional outer structure methods ---

# Spherical finite rotations 
FiniteRotSph(lon, lat, angle) = FiniteRotSph(lon, lat, angle, nothing, Covariance())
FiniteRotSph(lon, lat, angle, time) = FiniteRotSph(lon, lat, angle, time, Covariance())
FiniteRotSph(lon, lat, angle, covariance::Covariance) = FiniteRotSph(lon, lat, angle, nothing, covariance)
FiniteRotSph(lon, lat, angle, array::Union{Matrix, Vector}) = FiniteRotSph(lon, lat, angle, nothing, Covariance(array))
FiniteRotSph(lon, lat, angle, time, array::Union{Matrix, Vector}) = FiniteRotSph(lon, lat, angle, time, Covariance(array))
FiniteRotSph(array::Union{Matrix, Vector, Tuple}) = FiniteRotSph(array[1], array[2], array[3], nothing, Covariance())
FiniteRotSph(array::Union{Matrix, Vector, Tuple}, time) = FiniteRotSph(array[1], array[2], array[3], time, Covariance())
FiniteRotSph(array::Union{Matrix, Vector, Tuple}, time, covariance::Covariance) = FiniteRotSph(array[1], array[2], array[3], time, covariance)
Base.getindex(x::FiniteRotSph, i::Int) = getfield(x, i)


# Cartesian finite rotations 
FiniteRotCart(x, y, z) = FiniteRotCart(x, y, z, nothing, Covariance())
FiniteRotCart(x, y, z, time) = FiniteRotCart(x, y, z, time, Covariance())
FiniteRotCart(x, y, z, covariance::Covariance) = FiniteRotCart(x, y, z, nothing, covariance)
FiniteRotCart(x, y, z, array::Union{Matrix, Vector}) = FiniteRotCart(x, y, z, nothing, Covariance(array))
FiniteRotCart(x, y, z, time, array::Union{Matrix, Vector}) = FiniteRotCart(x, y, z, time, Covariance(array))
FiniteRotCart(array::Union{Matrix, Vector}) = FiniteRotCart(array[1], array[2], array[3], nothing, Covariance())
FiniteRotCart(array::Union{Matrix, Vector}, time) = FiniteRotCart(array[1], array[2], array[3], time, Covariance())
Base.getindex(x::FiniteRotCart, i::Int) = getfield(x, i)


# Rotation Matrix
FiniteRotMatrix(v1::Vector, v2::Vector, v3::Vector) = FiniteRotMatrix(vcat([v1, v2, v3]'...))


# Euler angles
Base.getindex(x::EulerAngles, i::Int) = getfield(x, i)


function ToArray(myStruct::Union{FiniteRotSph, FiniteRotCart})
    field_names = fieldnames(typeof(myStruct))
    cov_names = fieldnames(Covariance)

    values = zeros(Number, 10)

    i, j = 1, 0
    for (i, field_name) in enumerate(field_names)
        if field_name == :Covariance
            for (j, cov_name) in enumerate(cov_names)
                values[j + i - 1] = getfield(myStruct.Covariance, cov_name)
            end
        else
            values[i + j] = getfield(myStruct, field_name)
        end
    end
    return values
end