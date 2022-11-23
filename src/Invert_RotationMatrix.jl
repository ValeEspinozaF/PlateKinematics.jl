using PlateKinematics: FiniteRotMatrix
using PlateKinematics.FiniteRotationsTransformations: Finrot2Array3D

function Invert_RotationMatrix(FRmArray::Matrix{FiniteRotMatrix})
    iMTX3D = Invert_RotationMatrix(Finrot2Array3D(FRmArray))

    return [FiniteRotMatrix(MTX) for MTX in eachslice(iMTX3D, dims=3)]
end


function Invert_RotationMatrix(MTX3D::Array{Float64, 3})

    if size(MTX3D)[1:2] != (3,3)
        throw("Error. Input 3D array must be of size (3, 3, n).")
    end

    iMTX = Array{Float64}(undef, 3, 3, size(MTX3D)[3])

    iMTX[1,1,:] .= (MTX3D[2,2,:] .* MTX3D[3,3,:] - MTX3D[2,3,:] .* MTX3D[3,2,:])
    iMTX[2,1,:] .= (MTX3D[2,1,:] .* MTX3D[3,3,:] - MTX3D[2,3,:] .* MTX3D[3,1,:]) * -1
    iMTX[3,1,:] .= (MTX3D[2,1,:] .* MTX3D[3,2,:] - MTX3D[2,2,:] .* MTX3D[3,1,:])
    iMTX[1,2,:] .= (MTX3D[1,2,:] .* MTX3D[3,3,:] - MTX3D[1,3,:] .* MTX3D[3,2,:]) * -1
    iMTX[2,2,:] .= (MTX3D[1,1,:] .* MTX3D[3,3,:] - MTX3D[1,3,:] .* MTX3D[3,1,:])
    iMTX[3,2,:] .= (MTX3D[1,1,:] .* MTX3D[3,2,:] - MTX3D[1,2,:] .* MTX3D[3,1,:]) * -1
    iMTX[1,3,:] .= (MTX3D[1,2,:] .* MTX3D[2,3,:] - MTX3D[1,3,:] .* MTX3D[2,2,:])
    iMTX[2,3,:] .= (MTX3D[1,1,:] .* MTX3D[2,3,:] - MTX3D[1,3,:] .* MTX3D[2,1,:]) * -1
    iMTX[3,3,:] .= (MTX3D[1,1,:] .* MTX3D[2,2,:] - MTX3D[1,2,:] .* MTX3D[2,1,:])

    detMTX = MTX3D[1,1,:] .* iMTX[1,1,:] + MTX3D[1,2,:] .* iMTX[2,1,:] + MTX3D[1,3,:] .* iMTX[3,1,:]
    iMTX = reshape(repeat(1 ./detMTX', inner=(3, 3)), 3, 3, length(detMTX)) .* iMTX

    return iMTX
end



#= FRm = FiniteRotMatrix([1.0 4 5; 6 7 3; 9 7 2])
FRmArray = [FRm FRm]
iFRmArray = Invert_RotationMatrix(FRmArray)

using Random
Random.seed!(1)
MTX3D = rand(3,3,2)
Invert_RotationMatrix(MTX3D) =#