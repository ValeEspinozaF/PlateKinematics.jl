using PlateKinematics: Covariance
using DocStringExtensions

"""
$(TYPEDEF)

Euler vector in spherical coordinates with the following parameters:

Fields
------
* `Lon::Number`: Longitude of the Euler pole in degrees-East
* `Lat::Number`: Latitude of the Euler pole in degrees-North
* `AngVelocity::Number`: Angular velocity in degrees/Myr
* `TimeRange::Union{Matrix, Nothing}`: Initial to final age of rotation
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²/Myr²

Examples:
------
```julia-repl
julia> PlateKinematics.EulerVectorSph(1, 2, 3)
PlateKinematics.EulerVectorSph(1, 2, 3, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [30, 20, 10];
julia> PlateKinematics.EulerVectorSph(array)
PlateKinematics.EulerVectorSph(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1.5 2.5];
julia> length(array) == 2
true
julia> PlateKinematics.EulerVectorSph(30, 20, 10, array)
PlateKinematics.EulerVectorSph(30, 20, 10, [1.5 2.5], PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1, 2, 3, 4, 5, 6];
julia> length(array) != 2
true
julia> PlateKinematics.EulerVectorSph(30, 20, 10, array)
PlateKinematics.EulerVectorSph(30, 20, 10, nothing, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.EulerVectorSph(1, 2, 3, [1.5 2.5], array)
PlateKinematics.EulerVectorSph(1, 2, 3, [1.5 2.5], PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))
```
"""
struct EulerVectorSph
    "Longitude of the Euler pole in degrees-East."
        Lon::Number
    "Latitude of the Euler pole in degrees-North."
        Lat::Number
    "Angular velocity in degrees/Myr."
        AngVelocity::Number
    "Initial to final age of rotation."
        TimeRange::Union{Matrix, Nothing}
    "[`Covariance`](@ref) in radians²/Myr²."
        Covariance::Covariance
    
end

"""
$(TYPEDEF)

Euler vector in Cartesian coordinates, expressed in degrees/Myr.

Fields
------
* `X::Number`: X-coordinate in degrees/Myr
* `Y::Number`: Y-coordinate in degrees/Myr
* `Z::Number`: Z-coordinate in degrees/Myr
* `TimeRange::Union{Matrix, Nothing}`: Initial to final age of rotation
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²/Myr²

Examples:
------
Same outer Constructor Methods as [`EulerVectorSph`](@ref).
"""
struct EulerVectorCart
    "X-coordinate in degrees/Myr."
        X::Number
    "Y-coordinate in degrees/Myr."
        Y::Number
    "Z-coordinate in degrees/Myr."
        Z::Number
    "Initial to final age of rotation."
        TimeRange::Union{Matrix, Nothing}
    "[`Covariance`](@ref) in radians²/Myr²."
        Covariance::Covariance
end


# --- Aditional outer structure methods ---

# Spherical Euler vector
EulerVectorSph(lon, lat, angVelocity) = EulerVectorSph(lon, lat, angVelocity, nothing, Covariance())
EulerVectorSph(lon, lat, angVelocity, timeRange) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance())
EulerVectorSph(lon, lat, angVelocity, covariance::Covariance) = EulerVectorSph(lon, lat, angVelocity, nothing, covariance)
EulerVectorSph(lon, lat, angVelocity, timeRange, array::Array) = EulerVectorSph(lon, lat, angVelocity, timeRange, Covariance(array))
EulerVectorSph(array::Array) = EulerVectorSph(array[1], array[2], array[3], nothing, Covariance())
EulerVectorSph(array::Array, timeRange) = EulerVectorSph(array[1], array[2], array[3], timeRange, Covariance())
EulerVectorSph(array::Array, timeRange, covariance::Covariance) = EulerVectorSph(array[1], array[2], array[3], timeRange, covariance)
EulerVectorSph(array::Array, timeRange, covariance::Array) = EulerVectorSph(array[1], array[2], array[3], timeRange, Covariance(covariance))
Base.getindex(x::EulerVectorSph, i::Int) = getfield(x, i)

function EulerVectorSph(lon::Number, lat::Number, angVelocity::Number, array::Array)
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
Base.getindex(x::EulerVectorCart, i::Int) = getfield(x, i)

function EulerVectorCart(x::Number, y::Number, z::Number, array::Array)
    if length(array) == 2
        return EulerVectorCart(x, y, z, array, Covariance())
    else
        return EulerVectorCart(x, y, z, nothing, Covariance(array))
    end
end

"""
    CovToMatrix(EVs::Union{EulerVectorSph, EulerVectorCart})

Convert an Euler Vector Covariance structure [radians²/Myr²] to a 3x3 symmetric Matrix [degrees²/Myr²]. 
"""
function CovToMatrix(EVs::Union{EulerVectorSph, EulerVectorCart})
    
    cov = EVs.Covariance
    covMatrix = Array{Number}(undef, 3, 3)
    
    covMatrix[1, :] .= [cov.C11, cov.C12, cov.C13] * (180/pi)^2
    covMatrix[2, :] .= [cov.C12, cov.C22, cov.C23] * (180/pi)^2
    covMatrix[3, :] .= [cov.C13, cov.C23, cov.C33] * (180/pi)^2
    
    return covMatrix
end