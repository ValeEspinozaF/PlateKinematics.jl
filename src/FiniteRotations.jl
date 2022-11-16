using PlateKinematics: Covariance

struct FiniteRotSph
    Lon::Number
    Lat::Number
    Angle::Number
    Covariance::Covariance
    FiniteRotSph(Lon, Lat, Angle) = new(Lon, Lat, Angle, Covariance())
    FiniteRotSph(Lon, Lat, Angle, covariance) = new(Lon, Lat, Angle, covariance)
    FiniteRotSph(Lon, Lat, Angle, array::Matrix) = new(Lon, Lat, Angle, Covariance(array))
end

struct FiniteRotCart
    X::Number
    Y::Number
    Z::Number
    Covariance::Covariance
    FiniteRotCart(x, y, z) = new(x, y, z, Covariance())
    FiniteRotCart(ar::Union{Matrix, Vector}) = new(ar[1], ar[2], ar[3], Covariance())
    FiniteRotCart(x, y, z, Covariance) = new(x, y, z, Covariance)
    FiniteRotCart(x, y, z, array::Union{Matrix, Vector}) = new(x, y, z, Covariance(array))
end

struct FiniteRotMatrix
    Values::Matrix
    FiniteRotMatrix(m::Matrix) = new(m)
    FiniteRotMatrix(v1::Vector, v2::Vector, v3::Vector) = new(vcat([v1, v2, v3]'...))
end
