using PlateKinematics: FiniteRotSph
using PlateKinematics.FiniteRotationsTransformations: ChangeTime

"""
Concatenate two arrays of finite rotations for available common ages. """
function Concatenate_FiniteRotations(
    FRs1Array::Array{T}, FRs2Array::Array{T}, Nsize = 1e5::Number) where {T<:FiniteRotSph}

    # Ensure arrays are stored as vectors
    FRs1Array = vec(FRs1Array)
    FRs2Array = vec(FRs2Array)

    # Available times for interpolation
    commonAges = Find_commonAges(FRs1Array, FRs2Array)

    # Output array
    FRs_out = Array{FiniteRotSph}(undef, length(commonAges))

    for (i, time) in enumerate(commonAges)

        # Find relevant Finite rotations (with same age)
        findFR_byTime(FRs) = FRs.Time == time
        FRs1 = FRs1Array[findfirst(findFR_byTime, FRs1Array)]
        FRs2 = FRs2Array[findfirst(findFR_byTime, FRs2Array)]

        FRs_out[i] = ChangeTime(Add_FiniteRotations(FRs1, FRs2, Nsize), time)
    end
     
    return FRs_out
end

"""
Concatenate two arrays of finite rotations for given ages. """
function Concatenate_FiniteRotations(
    FRs1Array::Array{T}, FRs2Array::Array{T}, 
    times::Union{Matrix, Vector}, Nsize = 1e5::Number) where {T<:FiniteRotSph}

    # Ensure arrays are stored as vectors
    FRs1Array = vec(FRs1Array)
    FRs2Array = vec(FRs2Array)

    # Available times for interpolation
    commonAges = Find_commonAges(FRs1Array, FRs2Array, times)

    # Output array
    FRs_out = Array{FiniteRotSph}(undef, len(commonAges))

    for (i, time) in enumerate(commonAges)

        # Find relevant Finite rotations (with same age)
        findFR_byTime(FRs) = FRs.Time == time
        FRs1 = FRs1Array[findfirst(findFR_byTime, FRs1Array)]
        FRs2 = FRs2Array[findfirst(findFR_byTime, FRs2Array)]

        FRs_out[i] = Add_FiniteRotations(FRs1, FRs2, Nsize)
    end
     
    return FRs_out
end


"""
Concatenate all finite rotations in the given array. """
function Concatenate_FiniteRotations(FRsArray::Array{FiniteRotSph}, Nsize = 1e5::Number)

    # Ensure array is stored as vector
    FRsArray = vec(FRsArray)

    # Check if all finite rotations share same .Time parameter value.
    FRtimes = [FRs.Time for FRs in FRsArray]
    if !all(time == FRtimes[1] for time in FRtimes)
        throw("Ages in given array are not the same for every finite rotation ($FRtimes).")
    end
 
    # Concatenate finite rotations (in inverse order)
    last_index = lastindex(FRsArray)
    i = last_index
    FRs2 = FRsArray[i]

    while i >= 2
        println(a[i])
        FRs1 = FRsArray[i - 1]
        FRs2 = Add_FiniteRotations(FRs1, FRs2, Nsize)
        i -= 1
    end
     
    FRs_out = FRs2

    return FRs_out
end


function Find_commonAges(FRs1Array::Array{T}, FRs2Array::Array{T}, times=[]::Union{Matrix, Vector}) where {T<:FiniteRotSph}

    # Available times for interpolation
    FR1times = [FRs.Time for FRs in FRs1Array]
    FR2times = [FRs.Time for FRs in FRs2Array]
    commonAges = sort(intersect(FR1times, FR2times))

    # If specific time are given, filter common times through given ones
    if !isempty(times) 
        commonAges = sort(intersect(commonAges, times))
        diff = setdiff(times, commonAges)

        if !isempty(diff)
            throw("Some ages have not been found on both finite rotation arrays ($diff).")
        end
    end

    return commonAges
end