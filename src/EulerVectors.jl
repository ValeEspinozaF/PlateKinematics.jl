using PlateKinematics: Covariance

struct EulerVectorSph
    Lon::Number
    Lat::Number
    AngVelocity::Number
    TimeRange::Union{Matrix, Nothing}
    Covariance::Covariance
    
end
    
struct EulerVectorCart
    X::Number
    Y::Number
    Z::Number
    TimeRange::Union{Matrix, Nothing}
    Covariance::Covariance
end


# --- Aditional outer structure methods ---

# Spherical Euler vector
EulerVectorSph(lon, lat, angVelocity) = EulerVectorSph(lon, lat, angVelocity, nothing, Covariance())
EulerVectorSph(lon, lat, angVelocity, timeRange) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance())
EulerVectorSph(lon, lat, angVelocity, covariance::Covariance) = EulerVectorSph(lon, lat, angVelocity, nothing, covariance)
EulerVectorSph(lon, lat, angVelocity, array::Union{Matrix, Vector}) = EulerVectorSph(lon, lat, angVelocity, nothing, Covariance(array))
EulerVectorSph(lon, lat, angVelocity, timeRange, array::Union{Matrix, Vector}) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance(array))
EulerVectorSph(array::Union{Matrix, Vector, Tuple}) = EulerVectorSph(array[1], array[2], array[3], nothing, Covariance())
EulerVectorSph(array::Union{Matrix, Vector, Tuple}, timeRange) = EulerVectorSph(array[1], array[2], array[3], timeRange, Covariance())
EulerVectorSph(array::Union{Matrix, Vector, Tuple}, timeRange, covariance::Covariance) = EulerVectorSph(array[1], array[2], array[3], timeRange, covariance)
Base.getindex(x::EulerVectorSph, i::Int) = getfield(x, i)

# Cartesian Euler vector
EulerVectorCart(x, y, z) = EulerVectorCart(x, y, z, nothing, Covariance())
EulerVectorCart(x, y, z, timeRange) = EulerVectorCart(x, y, z, timeRange, Covariance())
EulerVectorCart(x, y, z, covariance::Covariance) = EulerVectorCart(x, y, z, nothing, covariance)
EulerVectorCart(x, y, z, array::Union{Matrix, Vector}) = EulerVectorCart(x, y, z, nothing, Covariance(array))
EulerVectorCart(x, y, z, timeRange, array::Union{Matrix, Vector}) = EulerVectorCart(x, y, z, timeRange, Covariance(array))
EulerVectorCart(array::Union{Matrix, Vector}) = EulerVectorCart(array[1], array[2], array[3], nothing, Covariance())
EulerVectorCart(array::Union{Matrix, Vector}, timeRange) = EulerVectorCart(array[1], array[2], array[3], timeRange, Covariance())
EulerVectorCart(array::Union{Matrix, Vector}, timeRange, covariance::Covariance) = EulerVectorCart(array[1], array[2], array[3], timeRange, covariance)
Base.getindex(x::EulerVectorCart, i::Int) = getfield(x, i)