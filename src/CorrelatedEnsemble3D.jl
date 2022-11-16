function CorrelatedEnsemble3D(correlationMatrix, N)

"""
This function generates a series of N samples [x y z]
whose covariance matrix is CORRELATION_MATRIX.


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


N = floor(Int, N)

M1 = correlationMatrix
eig_va, eig_ve = eigen(M1)

x1 = eig_va[1]^0.5 * randn(N)
y1 = eig_va[2]^0.5 * randn(N)
z1 = eig_va[3]^0.5 * randn(N)

Rot = eig_ve
data = [x1 y1 z1]'

ndata = Array{Float64}(undef, 3, N)

for i=1:length(data[1,:])

   ndata[:,i] = Rot*data[:,i]

end

x = ndata[1,:]
y = ndata[2,:]
z = ndata[3,:]

return [x,y,z]

end
