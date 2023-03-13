"""
    Add_FiniteRotations(FRs1::FiniteRotSph, FRs2::FiniteRotSph, Nsize=1e5::Number)
    Add_FiniteRotations(FRs1::Array{T}, FRs2::Array{T}) where {T<:FiniteRotSph}

Return the sumation of two Finite Rotations in Spherical coordinates. 
"""
function Add_FiniteRotations(FRs1::FiniteRotSph, FRs2::FiniteRotSph, Nsize=1e5::Number)
    
    # Build ensemble if covariances are given
    if !CovIsZero(FRs1.Covariance) || !CovIsZero(FRs2.Covariance)
        MTX1 = BuildEnsemble3D(FRs1, Nsize)
        MTX2 = BuildEnsemble3D(FRs2, Nsize)

    else
        MTX1 = ToRotationMatrix(FRs1)
        MTX2 = ToRotationMatrix(FRs2)

    end 

    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    addFRs = ToFRs(mMTX)

    if size(addFRs)[1] !== 1
        return AverageEnsemble(addFRs)
    else
        return addFRs[1]
    end
end


function Add_FiniteRotations(FRs1::Array{T}, FRs2::Array{T}) where {T<:FiniteRotSph}
    
    MTX1 = ToRotationMatrix(FRs1)
    MTX2 = ToRotationMatrix(FRs2)

    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    return ToFRs(mMTX)

end