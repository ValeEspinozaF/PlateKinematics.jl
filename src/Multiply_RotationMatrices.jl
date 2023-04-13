function Multiply_RotationMatrices(MTX1::Array{N, 3}, MTX2::Array{N, 3}) where {N<:Float64}

    if size(MTX1)[1:2] != (3,3) || size(MTX2)[1:2] != (3,3)
        error("Input 3D arrays must be of size (3, 3, n).")
    end

    if size(MTX1) != size(MTX2) 
        error("Input arrays dont have the same length.")
    end

    mMTX = Array{Float64}(undef, 3, 3, size(MTX1)[3])

    mMTX[1,1,:] .= MTX1[1,1,:] .* MTX2[1,1,:] + MTX1[1,2,:] .* MTX2[2,1,:] + MTX1[1,3,:] .* MTX2[3,1,:]
    mMTX[1,2,:] .= MTX1[1,1,:] .* MTX2[1,2,:] + MTX1[1,2,:] .* MTX2[2,2,:] + MTX1[1,3,:] .* MTX2[3,2,:]
    mMTX[1,3,:] .= MTX1[1,1,:] .* MTX2[1,3,:] + MTX1[1,2,:] .* MTX2[2,3,:] + MTX1[1,3,:] .* MTX2[3,3,:]

    mMTX[2,1,:] .= MTX1[2,1,:] .* MTX2[1,1,:] + MTX1[2,2,:] .* MTX2[2,1,:] + MTX1[2,3,:] .* MTX2[3,1,:]
    mMTX[2,2,:] .= MTX1[2,1,:] .* MTX2[1,2,:] + MTX1[2,2,:] .* MTX2[2,2,:] + MTX1[2,3,:] .* MTX2[3,2,:]
    mMTX[2,3,:] .= MTX1[2,1,:] .* MTX2[1,3,:] + MTX1[2,2,:] .* MTX2[2,3,:] + MTX1[2,3,:] .* MTX2[3,3,:]

    mMTX[3,1,:] .= MTX1[3,1,:] .* MTX2[1,1,:] + MTX1[3,2,:] .* MTX2[2,1,:] + MTX1[3,3,:] .* MTX2[3,1,:]
    mMTX[3,2,:] .= MTX1[3,1,:] .* MTX2[1,2,:] + MTX1[3,2,:] .* MTX2[2,2,:] + MTX1[3,3,:] .* MTX2[3,2,:]
    mMTX[3,3,:] .= MTX1[3,1,:] .* MTX2[1,3,:] + MTX1[3,2,:] .* MTX2[2,3,:] + MTX1[3,3,:] .* MTX2[3,3,:]

    return mMTX
end