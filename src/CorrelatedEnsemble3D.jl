"""
Generates a series of N samples [x y z] whose covariance matrix 
is correlationMatrix.


Parameters
----------
correlationMatrix : array [3x3]
    Symmetric covariance matrix in [Any^2] units of measurement.
N : float or integer
    Size of the output ensemble.

Returns
-------
x,y,z : array [1xn]
    Series of xyz samples (in [Any] units of measurement) 
    whose covariance matrix is CORRELATION_MATRIX.
"""
function CorrelatedEnsemble3D(correlationMatrix, N)

    M1 = correlationMatrix
    eig_va, eig_ve = eigen(M1)
    
    data = eig_va .^ 0.5 .* randn(3, floor(Int, N))
    ndata = [eig_ve * row for row in eachslice(data, dims=2)]

    return [getindex.(ndata,1), getindex.(ndata,2), getindex.(ndata,3)]
    
end