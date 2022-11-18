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



# --- Aditional outer structure methods ---

# Spherical finite rotations 
FiniteRotSph(lon, lat, angle) = FiniteRotSph(lon, lat, angle, nothing, Covariance())
FiniteRotSph(lon, lat, angle, time) = FiniteRotSph(lon, lat, angle, time, Covariance())
FiniteRotSph(lon, lat, angle, covariance::Covariance) = FiniteRotSph(lon, lat, angle, nothing, covariance)
FiniteRotSph(lon, lat, angle, array::Union{Matrix, Vector}) = FiniteRotSph(lon, lat, angle, nothing, Covariance(array))
FiniteRotSph(lon, lat, angle, time, array::Union{Matrix, Vector}) = FiniteRotSph(lon, lat, angle, time, Covariance(array))

# Cartesian finite rotations 
FiniteRotCart(x, y, z) = FiniteRotCart(x, y, z, nothing, Covariance())
FiniteRotCart(x, y, z, time) = FiniteRotCart(x, y, z, time, Covariance())
FiniteRotCart(x, y, z, covariance::Covariance) = FiniteRotCart(x, y, z, nothing, covariance)
FiniteRotCart(x, y, z, array::Union{Matrix, Vector}) = FiniteRotCart(x, y, z, nothing, Covariance(array))
FiniteRotCart(x, y, z, time, array::Union{Matrix, Vector}) = FiniteRotCart(x, y, z, time, Covariance(array))
FiniteRotCart(array::Union{Matrix, Vector}) = FiniteRotCart(array[1], array[2], array[3], nothing, Covariance())
FiniteRotCart(array::Union{Matrix, Vector}, time) = FiniteRotCart(array[1], array[2], array[3], time, Covariance())

# Rotation Matrix
FiniteRotMatrix(v1::Vector, v2::Vector, v3::Vector) = FiniteRotMatrix(vcat([v1, v2, v3]'...))



function ChangeLon(FRs::FiniteRotSph, newLon)
    return FiniteRotSph(newLon, FRs.Lat, FRs.Angle, FRs.Time, FRs.Covariance)
end

function ChangeLat(FRs::FiniteRotSph, newLat)
    return FiniteRotSph(FRs.Lon, newLat, FRs.Angle, FRs.Time, FRs.Covariance)
end

function ChangeAngle(FRs::FiniteRotSph, newAngle)
    return FiniteRotSph(FRs.Lon, FRs.Lat, newAngle, FRs.Time, FRs.Covariance)
end

function ChangeTime(FRs::FiniteRotSph, newTime)
    return FiniteRotSph(FRs.Lon, FRs.Lat, FRs.Angle, newTime, FRs.Covariance)
end
