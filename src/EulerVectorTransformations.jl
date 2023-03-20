function ChangeLon(EVs::EulerVectorSph, newLon::Float64)
    return EulerVectorSph(newLon, EVs.Lat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeLat(EVs::EulerVectorSph, newLat::Float64)
    return EulerVectorSph(EVs.Lon, newLat, EVs.AngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeAngVel(EVs::EulerVectorSph, newAngVelocity::Float64)
    return EulerVectorSph(EVs.Lon, EVs.Lat, newAngVelocity, EVs.TimeRange, EVs.Covariance); end

function ChangeTimeRange(EVs::EulerVectorSph, newTimeRange::Union{Nothing, Matrix{N}}) where {N<:Float64}
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
    ToEVs(
        X::Array{N, 1}, Y::Array{N, 1}, Z::Array{N, 1}, 
        timeRange=nothing::Union{Nothing, Matrix{N}}) where {N<:Float64}

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


function ToEVs(
    X::Array{N, 1}, Y::Array{N, 1}, Z::Array{N, 1}, 
    timeRange=nothing::Union{Nothing, Matrix{N}}) where {N<:Float64}

    if length(X) == length(Y) == length(Z)

        # Turn to spherical coordinates, pole in [deg]
        lon, lat, mag = cart2sph(X, Y, Z)

        return mapslices(v -> EulerVectorSph(v, timeRange), [lon lat mag], dims=(2))
    
    else
        error("Input arrays do not have the same length (X: $(length(X)), Y: $(length(Y)), Z: $(length(Z))).")

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