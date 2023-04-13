function Invert_RotationMatrix(MTX::Array{N, 3}) where {N<:Float64}

    if size(MTX)[1:2] != (3,3)
        error("Input 3D array must be of size (3, 3, n).")
    end

    iMTX = Array{Float64}(undef, 3, 3, size(MTX)[3])

    iMTX[1,1,:] .= (MTX[2,2,:] .* MTX[3,3,:] - MTX[2,3,:] .* MTX[3,2,:])
    iMTX[2,1,:] .= (MTX[2,1,:] .* MTX[3,3,:] - MTX[2,3,:] .* MTX[3,1,:]) * -1
    iMTX[3,1,:] .= (MTX[2,1,:] .* MTX[3,2,:] - MTX[2,2,:] .* MTX[3,1,:])
    iMTX[1,2,:] .= (MTX[1,2,:] .* MTX[3,3,:] - MTX[1,3,:] .* MTX[3,2,:]) * -1
    iMTX[2,2,:] .= (MTX[1,1,:] .* MTX[3,3,:] - MTX[1,3,:] .* MTX[3,1,:])
    iMTX[3,2,:] .= (MTX[1,1,:] .* MTX[3,2,:] - MTX[1,2,:] .* MTX[3,1,:]) * -1
    iMTX[1,3,:] .= (MTX[1,2,:] .* MTX[2,3,:] - MTX[1,3,:] .* MTX[2,2,:])
    iMTX[2,3,:] .= (MTX[1,1,:] .* MTX[2,3,:] - MTX[1,3,:] .* MTX[2,1,:]) * -1
    iMTX[3,3,:] .= (MTX[1,1,:] .* MTX[2,2,:] - MTX[1,2,:] .* MTX[2,1,:])

    detMTX = MTX[1,1,:] .* iMTX[1,1,:] + MTX[1,2,:] .* iMTX[2,1,:] + MTX[1,3,:] .* iMTX[3,1,:]
    iMTX = reshape(repeat(1 ./detMTX', inner=(3, 3)), 3, 3, length(detMTX)) .* iMTX

    return iMTX
end