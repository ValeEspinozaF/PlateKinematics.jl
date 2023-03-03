module EulerVectorTransformations

using PlateKinematics: EulerVectorSph, EulerVectorCart
using PlateKinematics: ToRadians, ToDegrees, sph2cart, cart2sph


function ChangeLon(EVs::EulerVectorSph, newLon)
    return EulerVectorSph(newLon, EVs.Lat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeLat(EVs::EulerVectorSph, newLat)
    return EulerVectorSph(EVs.Lon, newLat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeAngVel(EVs::EulerVectorSph, newAngVelocity)
    return EulerVectorSph(EVs.Lon, EVs.Lat, newAngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeTimeRange(EVs::EulerVectorSph, newTimeRange)
    return EulerVectorSph(EVs.Lon, EVs.Lat, EVs.AngVelocity, newTimeRange, EVs.Covariance); end

function GetAntipole(EVs::EulerVectorSph)
    if EVs.AngVelocity <= 0
        return ChangeAngVel(EVs, -EVs.AngVelocity)
    else
        if EVs.Lon <= 0
            return EulerVectorSph(EVs.Lon + 180, -EVs.Lat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance)
        else
            return EulerVectorSph(EVs.Lon - 180, -EVs.Lat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance)
        end
    end
end


function EuVector2Sph(MTX::Array{Float64, 3})

    if size(MTX)[1:2] != (3,3)
        throw("Error. Input 3D array must be of size (3, 3, n).")
    end

    x = MTX[3,2,:] - MTX[2,3,:]
    y = MTX[1,3,:] - MTX[3,1,:]
    z = MTX[2,1,:] - MTX[1,2,:]

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees]
    t = MTX[1,1,:] + MTX[2,2,:] + MTX[3,3,:]
    mag = ToDegrees( atan.(mag, t .- 1) )

    return mapslices(v -> EulerVectorSph(v), [lon lat mag], dims=(2))
end


function EuVector2Sph(X::Array{Float64}, Y::Array{Float64}, Z::Array{Float64})

    if length(X) != length(Y) || length(Z) != length(Y) || length(X) != length(Z)
        throw("Error. Input arrays must have the same length.")
    end

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(X, Y, Z)

    return mapslices(v -> EulerVectorSph(v), [lon lat mag], dims=(2))
end


function EuVector2Cart(EVs::EulerVectorSph)

    # Turn to spherical coordinates, pole in [deg]
    x, y, z = sph2cart(EVs.Lon, EVs.Lat, EVs.AngVelocity)

    return EulerVectorCart(x, y, z, EVs.TimeRange, EVs.Covariance)
end


function EuVector2Cart(EVs_array::Array{T}) where {T<:EulerVectorSph}

    return map(EVs -> EulerVectorCart(sph2cart(EVs.Lon, EVs.Lat, EVs.AngVelocity)), EVs_array)
end

#= function EuVector2Array3D(EVs::EulerVectorSph)

    x, y, z = sph2cart(EVs.Lon, EVs.Lat, 1)
    
    a = ToRadians(EVs.AngVelocity)
    b = 1 - cos(a)
    c = sin(a)

    MTX = Array{Float64}(undef, 3, 3, 1)

    # Rotation matrix in [radians]
    MTX[1,1,1] = cos(a) + x^2 * b
    MTX[1,2,1] = x * y * b - z * c
    MTX[1,3,1] = x * z * b + y * c
    MTX[2,1,1] = y * x * b + z * c
    MTX[2,2,1] = cos(a) + y^2 * b
    MTX[2,3,1] = y * z * b - x * c
    MTX[3,1,1] = z * x * b - y * c
    MTX[3,2,1] = z * y * b + x * c
    MTX[3,3,1] = cos(a) + z^2 * b
    
    return MTX; end
 =#
end
