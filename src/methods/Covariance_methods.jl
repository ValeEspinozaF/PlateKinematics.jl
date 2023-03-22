# --- Outer structure methods ---

Covariance() = Covariance(0,0,0,0,0,0)
Covariance(a::Array) = Covariance(a[1], a[2], a[3], a[4], a[5], a[6])


"""
    ToArray(cov::Covariance)

Convert a Covariance structure to a 1x6 Matrix. 
"""
function ToArray(cov::Covariance)
    return [cov.C11 cov.C12 cov.C13 cov.C22 cov.C23 cov.C33]
end


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


"""
    CovToMatrix(EVs::Union{EulerVectorSph, EulerVectorCart})

Convert an Euler Vector Covariance structure [radians²/Myr²] to a 3x3 symmetric Matrix [degrees²/Myr²]. 
"""
function CovToMatrix(EVs::Union{EulerVectorSph, EulerVectorCart})
    
    cov = EVs.Covariance
    covMatrix = Array{Float64}(undef, 3, 3)
    
    covMatrix[1, :] .= [cov.C11, cov.C12, cov.C13] * (180/pi)^2
    covMatrix[2, :] .= [cov.C12, cov.C22, cov.C23] * (180/pi)^2
    covMatrix[3, :] .= [cov.C13, cov.C23, cov.C33] * (180/pi)^2
    
    return covMatrix
end