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

"""
    ToEVs(EVc::EulerVectorCart)
    ToEVs(EVcArray::Array{T}) where {T<:EulerVectorSph}
    ToEVs(MTX::Array{Number, 3}, timeRange=nothing::Union{Nothing, Matrix})
    ToEVs(X::Array{T, 1}, Y::Array{T, 1}, Z::Array{T, 1}, 
        timeRange=nothing::Union{Nothing, Matrix}) where {T<:Number}

Return an Euler Vector in Spherical coordinates (`::EulerVectorSph`), with 
magnitude expressed in degrees/Myr.
"""
function ToEVs(EVc::EulerVectorCart)
    lon_deg, lat_deg, mag = cart2sph(EVc.X, EVc.Y, EVc.Z)
    return EulerVectorSph(lon_deg, lat_deg, mag, EVc.TimeRange, EVc.Covariance)
end

function ToEVs(EVcArray::Array{T}) where {T<:EulerVectorCart}
    return map(EVc -> ToEVs(EVc), EVcArray)
end

function ToEVs(MTX::Array{T, 3}, timeRange=nothing::Union{Nothing, Matrix}) where {T<:Number}

    if size(MTX)[1:2] != (3,3)
        error("Input 3D array must be of size (3, 3, n).")
    end

    x = MTX[3,2,:] - MTX[2,3,:]
    y = MTX[1,3,:] - MTX[3,1,:]
    z = MTX[2,1,:] - MTX[1,2,:]

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees]
    t = MTX[1,1,:] + MTX[2,2,:] + MTX[3,3,:]
    mag = ToDegrees( atan.(mag, t .- 1) )

    return mapslices(v -> EulerVectorSph(v, timeRange), [lon lat mag], dims=(2))
end

function ToEVs(X::Array{T, 1}, Y::Array{T, 1}, Z::Array{T, 1}, timeRange=nothing::Union{Nothing, Matrix}) where {T<:Number}

    if length(X) == length(Y) == length(Z)

        # Turn to spherical coordinates, pole in [deg]
        lon, lat, mag = cart2sph(X, Y, Z)

        return mapslices(v -> EulerVectorSph(v, timeRange), [lon lat mag], dims=(2))
    
    else
        error("Input arrays must have the same length.")

    end
end


"""
    ToEVc(EVs::EulerVectorSph)
    ToEVc(EVsArray::Array{T}) where {T<:EulerVectorSph}

Return an Euler Vector in Cartesian coordinates (`::EulerVectorCart`), expressed in degrees/Myr.
"""
function ToEVc(EVs::EulerVectorSph)
    x, y, z = sph2cart(EVs.Lon, EVs.Lat, EVs.AngVelocity)
    return EulerVectorCart(x, y, z, EVs.TimeRange, EVs.Covariance)
end

function ToEVc(EVsArray::Array{T}) where {T<:EulerVectorSph}
    return map(EVs -> ToEVc(EVs), EVsArray)
end