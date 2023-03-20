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


# Cartesian finite rotations 
FiniteRotCart(x, y, z) = FiniteRotCart(x, y, z, nothing, Covariance())
FiniteRotCart(x, y, z, time) = FiniteRotCart(x, y, z, time, Covariance())
FiniteRotCart(x, y, z, covariance::Covariance) = FiniteRotCart(x, y, z, nothing, covariance)
FiniteRotCart(x, y, z, array::Array) = FiniteRotCart(x, y, z, nothing, Covariance(array))
FiniteRotCart(x, y, z, time, array::Array) = FiniteRotCart(x, y, z, time, Covariance(array))
FiniteRotCart(array::Array) = FiniteRotCart(array[1], array[2], array[3], nothing, Covariance())
FiniteRotCart(array::Array, time) = FiniteRotCart(array[1], array[2], array[3], time, Covariance())

# Euler angles
EulerAngles(array::Array) = EulerAngles(array[1], array[2], array[3])



# --- Base overload methods ---

Base.getindex(x::FiniteRotSph, i::Int) = getfield(x, i)
Base.getindex(x::FiniteRotCart, i::Int) = getfield(x, i)
Base.getindex(x::EulerAngles, i::Int) = getfield(x, i)

function Base.show(io::IO, x::Union{FiniteRotSph, FiniteRotCart, EulerAngles})
    max_field_name_length = maximum(length.([string(field) for field in fieldnames(typeof(x))]))
    for field_name in fieldnames(typeof(x))
        field_value = getfield(x, field_name)
        field_name_padded = rpad(field_name, max_field_name_length)
        try
            println(io, "$field_name_padded : $(round(field_value, digits=2))")
        catch
            println(io, "$field_name_padded : $field_value")
        end
    end
end



"""
    ToArray(myStruct::Union{FiniteRotSph, FiniteRotCart})

Convert a Finite Rotations structure into a Vector.
"""
function ToArray(FR::Union{FiniteRotSph, FiniteRotCart})
    field_names = fieldnames(typeof(FR))
    cov_names = fieldnames(Covariance)

    values = zeros(Float64, 10)

    i, j = 1, 0
    for (i, field_name) in enumerate(field_names)
        if field_name == :Covariance
            for (j, cov_name) in enumerate(cov_names)
                values[j + i - 1] = getfield(FR.Covariance, cov_name)
            end
        else
            values[i + j] = getfield(FR, field_name)
        end
    end
    return values
end


#= function IsEqual(FRs1::FiniteRotSph, FRs2::FiniteRotSph, tolerance=1.0e-10::Float64, testCov=true::Bool)
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
end =#


function IsEqual(
    x::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
    y::Union{FiniteRotSph, FiniteRotCart, EulerAngles}, 
    sig=6::Int64)

    if typeof(x) != typeof(y)
        return false
    end

    for fieldname in fieldnames(typeof(x))

        if fieldname == :Time
            if isnothing(x.Time) && isnothing(y.Time)
                continue
            elseif isnothing(x.Time) && !isnothing(y.Time)
                return false
            elseif isnothing(x.Time) && !isnothing(y.Time)
                return false
            end
        end

        if fieldname == :Covariance
            for fieldname_cov in fieldnames(Covariance)
                field_x = getfield(x.Covariance, fieldname_cov)
                field_y = getfield(y.Covariance, fieldname_cov)

                if !(isapprox(field_x, field_y, atol=tol))
                    return false
                end
            end
        end


        field_x = getfield(x, fieldname)
        field_y = getfield(y, fieldname)
        tol = 10.0^(-sig) * max(abs(field_x), abs(field_y))

        if !(isapprox(field_x, field_y, atol=tol))
            return false
        end
    end
    return true
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