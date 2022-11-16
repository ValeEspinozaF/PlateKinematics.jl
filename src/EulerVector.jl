using PlateKinematics: Covariance

struct EulerVectorSph
    Lon::Number
    Lat::Number
    AngVelocity::Number
    Covariance::Covariance
    EulerVectorSph(Lon, Lat, AngVelocity) = new(Lon, Lat, AngVelocity, Covariance())
    EulerVectorSph(Lon, Lat, AngVelocity, covariance) = new(Lon, Lat, AngVelocity, covariance)
    EulerVectorSph(Lon, Lat, AngVelocity, array::Matrix) = new(Lon, Lat, AngVelocity, Covariance(array))
end
    
struct EulerVectorCart
    X::Number
    Y::Number
    Z::Number
    Covariance::Covariance
    EulerVectorCart(x, y, z) = new(x, y, z, Covariance())
    EulerVectorCart(ar::Union{Matrix, Vector}) = new(ar[1], ar[2], ar[3], Covariance())
    EulerVectorCart(x, y, z, Covariance) = new(x, y, z, Covariance)
    EulerVectorCart(x, y, z, array::Union{Matrix, Vector}) = new(x, y, z, Covariance(array))
end