using PlateKinematics: FiniteRotMatrix
using PlateKinematics.FiniteRotationsTransformations: Finrot2Array3D


function Invert_RotationMatrix(FRmArray1::Matrix{FiniteRotMatrix}, FRmArray2::Matrix{FiniteRotMatrix})
    mMTX3D = Multiply_RotationMatrices(Finrot2Array3D(FRmArray1), Finrot2Array3D(FRmArray2))
    
    return [FiniteRotMatrix(MTX) for MTX in eachslice(mMTX3D, dims=3)]
end


function Multiply_RotationMatrices(MTX1::Array{Float64, 3}, MTX2::Array{Float64, 3})

    if size(MTX1)[1:2] != (3,3) || size(MTX2)[1:2] != (3,3)
        throw("Error. Input 3D arrays must be of size (3, 3, n).")
    end

    if size(MTX1) != size(MTX2) 
        throw("Error. Input arrays dont have the same length.")
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