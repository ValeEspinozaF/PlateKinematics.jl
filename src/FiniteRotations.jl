using PlateKinematics: Covariance
using DocStringExtensions

"""
$(TYPEDEF)

Finite rotation in Spherical coordinates, expressed in degrees.

Fields
------
* `Lon::Float64`: Longitude of the rotation axis in degrees-East
* `Lat::Float64`: Latitude of the rotation axis in degrees-North
* `Angle::Float64`: Angle of rotation in degrees
* `Time::Union{Float64, Nothing}`: Age of rotation in million years
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²

Examples:
------
```julia-repl
julia> PlateKinematics.FiniteRotSph(30, 20, 10)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [30, 20, 10];
julia> PlateKinematics.FiniteRotSph(array)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> PlateKinematics.FiniteRotSph(30, 20, 10, 2)
PlateKinematics.FiniteRotSph(30, 20, 10, 2, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotSph(30, 20, 10, array)
PlateKinematics.FiniteRotSph(30, 20, 10, nothing, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotSph(30, 20, 10, 2, array)
PlateKinematics.FiniteRotSph(30, 20, 10, 2, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))
```
"""
struct FiniteRotSph
    "Longitude of the rotation axis in degrees-East."
        Lon::Float64
    "Latitude of the rotation axis in degrees-North."
        Lat::Float64
    "Angle of rotation in degrees."
        Angle::Float64
    "Age of rotation in million years."
        Time::Union{Float64, Nothing}
    "[`Covariance`](@ref) in radians²."
        Covariance::Covariance
end



"""
$(TYPEDEF)

Finite rotation in Cartesian coordinates, expressed in degrees.

Fields
------
* `X::Float64`: X-coordinate in degrees
* `Y::Float64`: Y-coordinate in degrees
* `Z::Float64`: Z-coordinate in degrees
* `TimeRange::Union{Float64, Nothing}`: Age of rotation in million years
* `Covariance::Covariance`: [`Covariance`](@ref) in radians²

Examples:
------
```julia-repl
julia> PlateKinematics.FiniteRotCart(1, 2, 3)
PlateKinematics.FiniteRotCart(1, 2, 3, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [30, 20, 10];
julia> PlateKinematics.FiniteRotCart(array)
PlateKinematics.FiniteRotCart(30, 20, 10, nothing, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> PlateKinematics.FiniteRotCart(1, 2, 3, 1.5)
PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, PlateKinematics.Covariance(0, 0, 0, 0, 0, 0))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotCart(30, 20, 10, array)
PlateKinematics.FiniteRotCart(30, 20, 10, nothing, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, array)
PlateKinematics.FiniteRotCart(1, 2, 3, 1.5, PlateKinematics.Covariance(1, 2, 3, 4, 5, 6))
```
"""
struct FiniteRotCart
    "X-coordinate in degrees."
        X::Float64
    "Y-coordinate in degrees."
        Y::Float64
    "Z-coordinate in degrees."
        Z::Float64
    "Age of rotation in million years."
        Time::Union{Float64, Nothing}
    "[`Covariance`](@ref) in radians²."
        Covariance::Covariance
end

"""
$(TYPEDEF)

Euler angles that describe the rotation around the three main axes on Earth.

Fields
------
* `X::Float64`: Angle of rotation around the X-axis (0N, 0E)
* `Y::Float64`: Angle of rotation around the Y-axis (0N, 90E)
* `Z::Float64`: Angle of rotation around the Z-axis (90N, 0E)

Examples: 
------
```julia-repl
julia> PlateKinematics.EulerAngles(4, 5, 6)
PlateKinematics.EulerAngles(4, 5, 6)

julia> array = [4, 5, 6];
julia> PlateKinematics.EulerAngles(array)
PlateKinematics.EulerAngles(4, 5, 6)
```
"""
struct EulerAngles
    "Angle of rotation around the X-axis (0N, 0E)."
        X::Float64
    "Angle of rotation around the Y-axis (0N, 90E)."
        Y::Float64
    "Angle of rotation around the Z-axis (90N, 0E)."
        Z::Float64
end


# --- Aditional outer structure methods ---

# Spherical finite rotations 
FiniteRotSph(lon, lat, angle) = FiniteRotSph(lon, lat, angle, nothing, Covariance())
FiniteRotSph(lon, lat, angle, time) = FiniteRotSph(lon, lat, angle, time, Covariance())
FiniteRotSph(lon, lat, angle, covariance::Covariance) = FiniteRotSph(lon, lat, angle, nothing, covariance)
FiniteRotSph(lon, lat, angle, array::Array) = FiniteRotSph(lon, lat, angle, nothing, Covariance(array))
FiniteRotSph(lon, lat, angle, time, array::Array) = FiniteRotSph(lon, lat, angle, time, Covariance(array))
FiniteRotSph(array::Array) = FiniteRotSph(array[1], array[2], array[3], nothing, Covariance())
FiniteRotSph(array::Array, time) = FiniteRotSph(array[1], array[2], array[3], time, Covariance())
FiniteRotSph(array::Array, time, covariance::Covariance) = FiniteRotSph(array[1], array[2], array[3], time, covariance)
Base.getindex(x::FiniteRotSph, i::Int) = getfield(x, i)


# Cartesian finite rotations 
FiniteRotCart(x, y, z) = FiniteRotCart(x, y, z, nothing, Covariance())
FiniteRotCart(x, y, z, time) = FiniteRotCart(x, y, z, time, Covariance())
FiniteRotCart(x, y, z, covariance::Covariance) = FiniteRotCart(x, y, z, nothing, covariance)
FiniteRotCart(x, y, z, array::Array) = FiniteRotCart(x, y, z, nothing, Covariance(array))
FiniteRotCart(x, y, z, time, array::Array) = FiniteRotCart(x, y, z, time, Covariance(array))
FiniteRotCart(array::Array) = FiniteRotCart(array[1], array[2], array[3], nothing, Covariance())
FiniteRotCart(array::Array, time) = FiniteRotCart(array[1], array[2], array[3], time, Covariance())
Base.getindex(x::FiniteRotCart, i::Int) = getfield(x, i)


# Euler angles
EulerAngles(array::Array) = EulerAngles(array[1], array[2], array[3])
Base.getindex(x::EulerAngles, i::Int) = getfield(x, i)


"""
    ToArray(myStruct::Union{FiniteRotSph, FiniteRotCart})

Convert a Finite Rotations structure into a Vector.
"""
function ToArray(myStruct::Union{FiniteRotSph, FiniteRotCart})
    field_names = fieldnames(typeof(myStruct))
    cov_names = fieldnames(Covariance)

    values = zeros(Float64, 10)

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

function IsEqual(FRs1::FiniteRotSph, FRs2::FiniteRotSph, tolerance=1.0e-10::Float64, testCov=true::Bool)
    sameLon = abs( FRs1.Lon - FRs2.Lon ) <= tolerance
    sameLat = abs( FRs1.Lat - FRs2.Lat ) <= tolerance
    sameAngle = abs( FRs1.Angle - FRs2.Angle ) <= tolerance

    if isnothing(FRs1.Time) && isnothing(FRs2.Time)
        sameTime = true
    else
        sameTime = abs( FRs1.Time - FRs2.Time ) <= tolerance
    end

    sameCov = false
    if testCov == true
        cov1 = FRs1.Covariance
        cov2 = FRs2.Covariance

        if CovIsZero(cov1) && CovIsZero(cov2)
            sameCov = true

        else
            sameC11 = abs( cov1.C11 - cov2.C11 ) <= tolerance
            sameC12 = abs( cov1.C12 - cov2.C12 ) <= tolerance
            sameC13 = abs( cov1.C13 - cov2.C13 ) <= tolerance
            sameC22 = abs( cov1.C22 - cov2.C22 ) <= tolerance
            sameC23 = abs( cov1.C23 - cov2.C23 ) <= tolerance
            sameC33 = abs( cov1.C33 - cov2.C33 ) <= tolerance
            sameCov = all([sameC11, sameC12, sameC13, sameC22, sameC23, sameC33])
        end

        return all([sameLon, sameLat, sameAngle, sameTime, sameCov])
    else
        return all([sameLon, sameLat, sameAngle, sameTime])
    end
end

"""
    CovToMatrix(FR::Union{FiniteRotSph, FiniteRotCart})
    
Converts a Finite Rotations Covariance structure [radians^2] to a 3x3 symmetric Matrix [radians^2]. 
"""
function CovToMatrix(FR::Union{FiniteRotSph, FiniteRotCart})
        
    cov = FR.Covariance
    covMatrix = Array{Float64}(undef, 3, 3)
    
    covMatrix[1, :] .= cov.C11, cov.C12, cov.C13
    covMatrix[2, :] .= cov.C12, cov.C22, cov.C23
    covMatrix[3, :] .= cov.C13, cov.C23, cov.C33
    
    return covMatrix
end