struct Covariance
    C11::Number
    C12::Number
    C13::Number
    C22::Number
    C23::Number
    C33::Number
end

Covariance() = Covariance(0,0,0,0,0,0)
Covariance(ar::Union{Matrix, Vector}) = Covariance(ar[1], ar[2], ar[3], ar[4], ar[5], ar[6])


"""
Converts a Covariance structure to a 3x3 symmetric Matrix. """
function CovToMatrix(cov::Covariance)
        
    covMatrix = Array{Number}(undef, 3, 3)
    
    covMatrix[1, :] .= cov.C11, cov.C12, cov.C13
    covMatrix[2, :] .= cov.C12, cov.C22, cov.C23
    covMatrix[3, :] .= cov.C13, cov.C23, cov.C33
    
    return covMatrix; end


"""
Converts a Covariance structure to a 1x6 Matrix. """
function CovToArray(cov::Covariance)
    return [cov.C11 cov.C12 cov.C13 cov.C22 cov.C23 cov.C33]; end

"""
Checks whether all Covariance elements are zero. """
function CovIsZero(cov::Covariance)

    if any(x -> x != 0, CovToArray(cov))
        return false
    end

    return true; end