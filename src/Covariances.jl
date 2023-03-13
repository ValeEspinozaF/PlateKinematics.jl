using DocStringExtensions

"""
$(TYPEDEF)

Covariance upper triangle elements. Expressed in radians² for Finite Rotations and in radians²/Myr² for Euler Vectors.

# Examples:

```julia-repl
julia> PlateKinematics.Covariance()
PlateKinematics.Covariance(0, 0, 0, 0, 0, 0)

julia> PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)
PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)

julia> array = [1, 2, 3, 4, 5, 6];
julia> PlateKinematics.Covariance(array)
PlateKinematics.Covariance(1, 2, 3, 4, 5, 6)
```
"""
struct Covariance
    C11::Number
    C12::Number
    C13::Number
    C22::Number
    C23::Number
    C33::Number
end

Covariance() = Covariance(0,0,0,0,0,0)
Covariance(a::Array) = Covariance(a[1], a[2], a[3], a[4], a[5], a[6])


"""
    ToArray(cov::Covariance)

Convert a Covariance structure to a 1x6 Matrix. 
"""
function ToArray(cov::Covariance)
    return [cov.C11 cov.C12 cov.C13 cov.C22 cov.C23 cov.C33]; end


"""
    CovIsZero(cov::Covariance)

Check whether all Covariance elements are zero. 
"""
function CovIsZero(cov::Covariance)
    if any(x -> x != 0, ToArray(cov))
        return false
    end
    return true
end