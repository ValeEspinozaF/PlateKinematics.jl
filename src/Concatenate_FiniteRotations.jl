using PlateKinematics: FiniteRotSph
using PlateKinematics: ChangeTime


"""
    Concatenate_FiniteRotations(FRsArray::Array{T}, Nsize = 1e5::Number) where {T<:FiniteRotSph}

Concatenate all the Finite Rotations in the given array `FRsArray`. Ensure the list is given !!!

"""
function Concatenate_FiniteRotations(FRsArray::Array{T}, Nsize = 1e5::Number) where {T<:FiniteRotSph}

    # Ensure array is stored as vector
    FRsArray = vec(FRsArray)

    # Check if all finite rotations share same :Time parameter value.
    FRtimes = [FRs.Time for FRs in FRsArray]
    if !all(time == FRtimes[1] for time in FRtimes)
        error(
            "Ages in given array are not the same for every finite rotation ($FRtimes). " *
            "Consider using the Add_FiniteRotations function for simple summation of two Finite Rotations."
            )
    end
 
    # Concatenate finite rotations (in inverse order)
    i = lastindex(FRsArray)
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


"""
    Concatenate_FiniteRotations(
        FRs1List::Array{T}, FRs2List::Array{T}, 
        Nsize = 1e5::Number, times = []::Array) where {T<:FiniteRotSph}

Given two lists of Finite Rotations (`FRs1List` and `FRs2List`), concatenate the poles for 
available common ages. Specific ages may be passed through the argument `times`.
"""
function Concatenate_FiniteRotations(
    FRs1List::Array{T}, FRs2List::Array{T}, 
    Nsize = 1e5::Number, times = []::Array) where {T<:FiniteRotSph}

    # Ensure arrays are stored as vectors
    FRs1List = vec(FRs1List)
    FRs2List = vec(FRs2List)

    # Available times for interpolation
    commonAges = Find_commonAges(FRs1List, FRs2List, times)

    # Output array
    FRs_out = Array{T}(undef, length(commonAges))

    for (i, time) in enumerate(commonAges)

        # Find relevant Finite rotations (with same age)
        findFR_byTime(FRs) = FRs.Time == time
        FRs1 = FRs1List[findfirst(findFR_byTime, FRs1List)]
        FRs2 = FRs2List[findfirst(findFR_byTime, FRs2List)]

        FRs_out[i] = ChangeTime(Add_FiniteRotations(FRs1, FRs2, Nsize), time)
    end
     
    return FRs_out
end


function Find_commonAges(FRs1Array::Array{T}, FRs2Array::Array{T}, times=[]::Array) where {T<:FiniteRotSph}

    # Available times for interpolation
    FR1times = [FRs.Time for FRs in FRs1Array]
    FR2times = [FRs.Time for FRs in FRs2Array]
    commonAges = sort(intersect(FR1times, FR2times))

    # If specific time are given, filter common times through given ones
    if !isempty(times) 
        commonAges = sort(intersect(commonAges, times))
        diff = setdiff(times, commonAges)

        if !isempty(diff)
            error("Some ages have not been found on both finite rotation arrays ($diff).")
        end
    end

    return commonAges
end