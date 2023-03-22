"""
    Interpolate_FiniteRotation(FRs1::FiniteRotSph, time::Float64, Nsize=100000::Int64)
    Interpolate_FiniteRotation(FRs1::Array{T}, time::Float64) where {T<:FiniteRotSph}

Interpolate a Finite Fotation for a given `time` between a Finite Rotation `FRs` and present-day.
"""
function Interpolate_FiniteRotation(FRs::FiniteRotSph, time::Float64, Nsize=100000::Int64)
    
    if time > FRs.Time
        error("Time of interpolation ($time) is expected to be younger or equal to that of FRs ($(FRs.Time)).")

    elseif time == FRs.Time
        return FRs
    
    else
        # Build ensemble if covariances are given
        if !CovIsZero(FRs.Covariance)
            MTX = BuildEnsemble3D(FRs, Nsize)
        else
            MTX = ToRotationMatrix(FRs)
        end 

        inFR = Interpolate_FiniteRotation(MTX, FRs.Time, time)

        if size(inFR)[1] !== 1
            return AverageEnsemble(inFR)
        else
            return inFR[1]
        end
    end
end


function Interpolate_FiniteRotation(FRs::Array{T}, time::Float64) where {T<:FiniteRotSph}
    
    if time > FRs[1].Time
        error("Time of interpolation ($time) is expected to be younger or equal to that of FRs ($(FRs1Array[1].Time)).")

    elseif time == FRs[1].Time
        return FRs
    
    else
        MTX = ToRotationMatrix(FRs1)

        inFR = Interpolate_FiniteRotation(MTX, FRs[1].Time, time)

        if size(inFR)[1] !== 1
            return AverageEnsemble(inFR)
        else
            return inFR[1]
        end
    end
end


"""
    Interpolate_FiniteRotation(
        FRs1::FiniteRotSph, FRs2::FiniteRotSph, time::Float64, Nsize=100000::Int64)

    Interpolate_FiniteRotation(
        FRs1::Array{T}, FRs2::Array{T}, time::Float64) where {T<:FiniteRotSph}

Interpolate a Finite Rotation for a given `time` between two total Finite Rotations, 
a younger `FRs1` and an older one `FRs2`.
"""
function Interpolate_FiniteRotation(
    FRs1::FiniteRotSph, FRs2::FiniteRotSph, time::Float64, Nsize=100000::Int64) 
    
    t1 = FRs1.Time
    t2 = FRs2.Time

    if t2 <= t1
        error("The age of FRs2 ($t2) is expected to be older than the age of FRs1 ($t1).")

    elseif time > t2
        error("Given interpolation time ($time) is older than the age of FRs2 ($t2).")

    elseif time == t1
        return FRs1
    
    elseif time == t2
        return FRs2
    
    else
        # Build ensemble if covariances are given
        if !CovIsZero(FRs1.Covariance) && !CovIsZero(FRs2.Covariance)
            MTX1 = BuildEnsemble3D(FRs1, Nsize)
            MTX2 = BuildEnsemble3D(FRs2, Nsize)
        else
            MTX1 = ToRotationMatrix(FRs1)
            MTX2 = ToRotationMatrix(FRs2)
        end 

        if time < t1
            inFR = Interpolate_FiniteRotation(MTX1, t1, time)

        elseif time < t2 && t1 < time 
            inFR = Interpolate_FiniteRotation(MTX1, MTX2, t1, t2, time)
            
        end

        if size(inFR)[1] !== 1
            return AverageEnsemble(inFR)
        else
            return inFR[1]
        end
    end
end


function Interpolate_FiniteRotation(
    FRs1Array::Array{T}, FRs2Array::Array{T}, time::Float64) where {T<:FiniteRotSph}
    
    t1 = FRs1Array[1].Time
    t2 = FRs2Array[1].Time

    if t2 <= t1
        error("The age of FRs2Array ($t2) is expected to be older than the age of FRs1Array ($t1).")

    elseif time > t2
        error("Given interpolation time ($time) is older than the age of FRs2Array ($t2).")

    elseif time == t1
        return FRs1Array
    
    elseif time == t2
        return FRs2Array
    
    else
        MTX1 = ToRotationMatrix(FRs1Array)
        MTX2 = ToRotationMatrix(FRs2Array) 

        if time < t1
            println("Warning! Given interpolation time ($time) is between FRs1Array ($t1) and present-day.")
            inFR = Interpolate_FiniteRotation(MTX1, t1, time)

        elseif time < t2 && t1 < time 
            inFR = Interpolate_FiniteRotation(MTX1, MTX2, t1, t2, time)
            
        end

        return inFR
    end
end


"""
    Interpolate_FiniteRotation(
        FRsList::Array{T}, times::Array{N}, Nsize=100000::Int64) where {T<:FiniteRotSph, N<:Float64}

Interpolate a list `times` from a list of total Finite Rotations `FRsList`.
"""
function Interpolate_FiniteRotation(
    FRsList::Array{T}, times::Array{N}, Nsize=100000::Int64) where {T<:FiniteRotSph, N<:Float64}

    # Ensure array is stored as vector
    FRsList = vec(FRsList)

    # Available times for interpolation
    FRtimes = [FRs.Time for FRs in FRsList]

    FRs_out = []

    for time in times
        
        # Find index of inmmediatly oldest rotation
        idx = findfirst(x -> x >= time, FRtimes) 

        # If index is not found (time is older than oldest rotation), continue
        index = idx === nothing ? continue : idx

        # t <= t1  --- time is between youngest rotation and present-day
        if index == 1
            FRs = Interpolate_FiniteRotation(FRsList[index], time, Nsize)

        # t <= tn  --- time is between oldest rotation and present-day
        else
            FRs = Interpolate_FiniteRotation(FRsList[index-1], FRsList[index], time, Nsize)
        end

        FRs_out = vcat(FRs_out, FRs)
    end

    return FRs_out
end


"""
    Interpolate_FiniteRotation(MTX::Array{N, 3}, t1::N, time::N) where {N<:Float64}

Interpolate a Finite Fotation for a given `time` between a Rotation Matrix `MTX`
and present-day. `t1` is the age of the Rotation Matrix. `MTX` may be a sampled 
ensemble from [`BuildEnsemble3D`](@ref).
"""
function Interpolate_FiniteRotation(MTX::Array{N, 3}, t1::N, time::N) where {N<:Float64}

    if  time > t1 
        error("Interpolation time is not between given t1 and t2.")

    elseif time == t1
        return ToFRs(MTX, t1)

    else
        delta = time / t1

        mFRs = ToFRs(MTX, time)
        return map(FRs -> ChangeAngle(FRs, FRs.Angle * delta), mFRs)
        
    end
end


"""
Interpolate_FiniteRotation(
    MTX1::Array{N, 3}, MTX2::Array{N, 3}, t1::N, t2::N, time::N) where {N<:Float64}

Interpolate a Finite Rotation for a given `time` between two total Rotation Matrices,
a younger `MTX1` and an older one `MTX2`. Rotation Matrices ages are `t1` and `t2`, 
respectively. `MTX1` and `MTX2` may be sampled ensembles from [`BuildEnsemble3D`](@ref).
"""
function Interpolate_FiniteRotation(
    MTX1::Array{N, 3}, MTX2::Array{N, 3}, t1::N, t2::N, time::N) where {N<:Float64}
    
    if  time > t2 || t1 > time 
        error("Interpolation time is not between given t1 and t2.")

    elseif time == t1
        return ToFRs(MTX1, t1)

    elseif time == t2
        return ToFRs(MTX2, t2)
    
    else
        # Calculate stage pole t2 ROT t1
        delta = (time-t1) / (t2-t1)

        iMTX1 = Invert_RotationMatrix(MTX1)
        mMTX = Multiply_RotationMatrices(MTX2, iMTX1)
        mFRs = ToFRs(mMTX)
        xFRs = map(FRs -> ChangeAngle(FRs, FRs.Angle * delta), mFRs)

        # Calculate finite rotation 0 ROT time, return MTX array
        intMTX = Multiply_RotationMatrices(ToRotationMatrix(xFRs), MTX1)
        return ToFRs(intMTX, time)
        
    end
end