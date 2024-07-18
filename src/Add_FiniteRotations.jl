"""
    Add_FiniteRotations(
        FRs1::FiniteRotSph, FRs2::FiniteRotSph, 
        Nsize=100000::Int64, time=nothing::Union{Nothing, Float64})

    Add_FiniteRotations(
        FRs1::Array{T}, FRs2::Array{T},
        time=nothing::Union{Nothing, Float64}) where {T<:FiniteRotSph}

Return the sumation of two Finite Rotations in Spherical coordinates. 
A specific output `:Time` field may be passed through the argument `time`.
"""
function Add_FiniteRotations(
    FRs1::FiniteRotSph, FRs2::FiniteRotSph, 
    Nsize=100000::Int64, time=nothing::Union{Nothing, Float64})
    
    # Check .Time field can be assigned
    if isnothing(time)
        if FRs1.Time == FRs2.Time
            time = FRs1.Time
        end
    end

    
    # Build ensemble if covariances are given
    if !CovIsZero(FRs1.Covariance) || !CovIsZero(FRs2.Covariance)
        MTX1 = BuildEnsemble3D(FRs1, Nsize)
        MTX2 = BuildEnsemble3D(FRs2, Nsize)

    else
        MTX1 = ToRotationMatrix(FRs1)
        MTX2 = ToRotationMatrix(FRs2)

    end 

    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    addFRs = ToFRs(mMTX, time)

    if size(addFRs, 1) !== 1
        return AverageEnsemble(addFRs, time)
    else
        return addFRs[1]
    end
end


function Add_FiniteRotations(
    FRs1::Array{T}, FRs2::Array{T}, 
    time=nothing::Union{Nothing, Float64}) where {T<:FiniteRotSph}
    
    # Check .Time field can be assigned
    if isnothing(time)
        if FRs1[1].Time == FRs2[1].Time
            time = FRs1[1].Time
        end
    end

    MTX1 = ToRotationMatrix(FRs1)
    MTX2 = ToRotationMatrix(FRs2)

    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    return ToFRs(mMTX, time)

end


function Add_FiniteRotations(
    MTX1::Array{N, 3}, MTX2::Array{N, 3}) where {N<:Float64}

    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    return mMTX

end