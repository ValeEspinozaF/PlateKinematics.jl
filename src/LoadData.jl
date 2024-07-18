using PlateKinematics: Covariance, FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph
using DataFrames: DataFrame
using DelimitedFiles: readdlm


global X_keys = ["x" "X"]
global Y_keys = ["y" "Y"]
global Z_keys = ["z" "Z"]
global Lon_keys = ["lon" "long" "longitude" "Lon" "Long" "Longitude"]
global Lat_keys = ["lat" "latitude" "Lat" "Latitude"]
global Angle_keys = ["angle" "w" "Angle" "W"]
global Vel_keys = ["om" "omega" "Om" "Omega" "vel" "velocity" "angvel" "AngVelocity"]
global Age_keys = ["age" "Age" "t" "T" "time" "Time"]
global Age1_keys = ["age1" "Age1" "t1" "T1" "time1" "Time1"]
global Age2_keys = ["age2" "Age2" "t2" "T2" "time2" "Time2"]
global C11_keys = ["a", "A", "c11", "C11", "cxx", "CXX", "Cxx", "cXX"]
global C12_keys = ["b", "B", "c12", "C12", "cxy", "CXY", "Cxy", "cXY"]
global C13_keys = ["c", "C", "c13", "C13", "cxz", "CXZ", "Cxz", "cXZ"]
global C22_keys = ["d", "D", "c22", "C22", "cyy", "CYY", "Cyy", "cYY"]
global C23_keys = ["e", "E", "c23", "C23", "cyz", "CYZ", "Cyz", "cYZ"]
global C33_keys = ["f", "F", "c33", "C33", "czz", "CZZ", "Czz", "cZZ"]

"""
    LoadTXT_asStruct(filePath::String, structType::DataType; names=nothing, header=false, skipstart=0, skipblanks=true, comments=true, comment_char='#')

Load the content of a TXT file into a struct array. The structType must be one of FiniteRotCart, FiniteRotSph, EulerVectorCart or EulerVectorSph. The names of the columns must be provided in the names argument if header is false. If header is true, the names are extracted from the first row of the file. The skipstart argument is the number of lines to skip at the start of the file. If skipblanks is true, blank lines are skipped. If comments is true, lines starting with the comment_char are skipped.

### Arguments
- `filePath`: Path to the TXT file.
- `structType`: Type of the struct to be loaded.
- `names`: Names of the columns in the file, used as field names in struct constructor. (optional, default: nothing)
- `header`: If true, the first row of the file is considered the header. If `names` is not provided, the header is used as field names. (optional, default: false)
- `skipstart`: Number of lines to skip at the start of the file. (optional, default: 0)
- `skipblanks`: If true, blank lines are skipped. (optional, default: true)
- `comments`: If true, lines starting with the `comment_char` are skipped. (optional, default: true)
- `comment_char`: Character that indicates a comment line. (optional, default: '#')

### Returns
- Array of structs of type `structType`.
"""
function LoadTXT_asStruct(filePath::String, structType::DataType; 
    names=nothing::Union{Vector, Array, Nothing}, header=false::Bool, skipstart=0::Int, skipblanks=true::Bool, comments=true, comment_char='#')
    
    if isnothing(names) && header == false
        error("names or header must be provided.")
    end

    if header
        data, heading = readdlm(filePath, header=header, skipstart=skipstart, skipblanks=skipblanks, comments=comments, comment_char=comment_char)
        if isnothing(names)
            names = heading
        end
    else
        data = readdlm(filePath, header=header, skipstart=skipstart, skipblanks=skipblanks, comments=comments, comment_char=comment_char)
    end
    
    names = reduce(vcat, names)

    if structType == FiniteRotCart 
        ParseArray_asFiniteRotation(data, names, FiniteRotCart)

    elseif structType == FiniteRotSph
        ParseArray_asFiniteRotation(data, names, FiniteRotSph)

    elseif structType == EulerVectorCart
        return ParseArray_asEulerVector(data, names, EulerVectorCart)

    elseif structType == EulerVectorSph
        return ParseArray_asEulerVector(data, names, EulerVectorSph)
    
    else
        error("Invalid structType. Options are FiniteRotCart, FiniteRotSph, EulerVectorCart or EulerVectorSph.")
    end
end


"""
    ParseArray_asFiniteRotation(data::Matrix, names::Union{Vector, Matrix}, structType::DataType)

Parse a matrix of data into an array of FiniteRotCart or FiniteRotSph structs. The names of the columns must be provided in the names argument. The structType must be one of FiniteRotCart or FiniteRotSph.

### Arguments
- `data`: Matrix of data to be parsed.
- `names`: Names of the columns in the data, used as field names in struct constructor.
- `structType`: Type of the struct to be loaded. Options are FiniteRotCart or FiniteRotSph.

### Returns
- Array of structs of type `structType`.

"""
function ParseArray_asFiniteRotation(data::Matrix, names::Union{Vector, Matrix}, structType::DataType)

    n_data = size(data, 1)  
    names = reduce(vcat, names)  

    if structType == FiniteRotCart
        keys_list = [X_keys, Y_keys, Z_keys, Age_keys, C11_keys, C12_keys, C13_keys, C22_keys, C23_keys, C33_keys]

    elseif structType == FiniteRotSph
        keys_list = [Lon_keys, Lat_keys, Angle_keys, Age_keys, C11_keys, C12_keys, C13_keys, C22_keys, C23_keys, C33_keys]
    
    else
        error("Invalid structType. Options are FiniteRotCart or FiniteRotSph.")
    end

    idxs = Vector{Union{Int64, Nothing}}(undef, length(keys_list))
    fill!(idxs, nothing)

    for (i, keys) in enumerate(keys_list)
        global idx = [findfirst(name -> name == key, names) for key in keys if key in names]
        global idx = isempty(idx) ? nothing : idx[1]
        idxs[i] = idx
    end

    if isnothing(idxs[1]) || isnothing(idxs[2]) || isnothing(idxs[3])
        error("Invalid names. Must contain columns X, Y and Z, or Lon, Lat, Angle/AngVelocity.")
    end


    FR_array = Vector{structType}(undef, n_data)
    has_age = !isnothing(idxs[4])
    has_covariance = all([!isnothing(i) for i in idxs[5:10]])


    if has_age
        if has_covariance
            for i in 1:n_data
                FR_array[i] = structType(data[i, idxs[1:3]], data[i, idxs[4]], data[i, idxs[5:10]])
            end
        else
            for i in 1:n_data
                FR_array[i] = structType(data[i, idxs[1:3]], data[i, idxs[4]])
            end
        end

    else
        if has_covariance
            for i in 1:n_data
                FR_array[i] = structType(data[i, idxs[1:3]], nothing, data[i, idxs[5:10]])
            end
        else
            for i in 1:n_data
                FR_array[i] = structType(data[i, idxs[1:3]])
            end
        end
    end

    return FR_array
end


"""
    ParseArray_asEulerVector(data::Matrix, names::Union{Vector, Matrix}, structType::DataType)

Parse a matrix of data into an array of EulerVectorCart or EulerVectorSph structs. The names of the columns must be provided in the names argument. The structType must be one of EulerVectorCart or EulerVectorSph.

### Arguments
- `data`: Matrix of data to be parsed.
- `names`: Names of the columns in the data, used as field names in struct constructor.
- `structType`: Type of the struct to be loaded. Options are EulerVectorCart or EulerVectorSph.

### Returns
- Array of structs of type `structType`.

"""
function ParseArray_asEulerVector(data::Matrix, names::Union{Vector, Matrix}, structType::DataType)

    n_data = size(data, 1)  
    names = reduce(vcat, names)  

    if structType == EulerVectorCart
        keys_list = [X_keys, Y_keys, Z_keys, Age1_keys, Age2_keys, C11_keys, C12_keys, C13_keys, C22_keys, C23_keys, C33_keys]

    elseif structType == EulerVectorSph
        keys_list = [Lon_keys, Lat_keys, Vel_keys, Age1_keys, Age2_keys, C11_keys, C12_keys, C13_keys, C22_keys, C23_keys, C33_keys]
    
    else
        error("Invalid structType. Options are EulerVectorCart or EulerVectorSph.")
    end

    idxs = Vector{Union{Int64, Nothing}}(undef, length(keys_list))
    fill!(idxs, nothing)

    for (i, keys) in enumerate(keys_list)
        global idx = [findfirst(name -> name == key, names) for key in keys if key in names]
        global idx = isempty(idx) ? nothing : idx[1]
        idxs[i] = idx
    end

    if isnothing(idxs[1]) || isnothing(idxs[2]) || isnothing(idxs[3])
        error("Invalid names. Must contain columns X, Y and Z, or Lon, Lat, Angle/AngVelocity.")
    end


    EV_array = Vector{structType}(undef, n_data)
    has_age = all([!isnothing(i) for i in idxs[4:5]])
    has_covariance = all([!isnothing(i) for i in idxs[6:11]])


    if has_age
        if has_covariance
            for i in 1:n_data
                EV_array[i] = structType(data[i, idxs[1:3]], [data[i, idxs[4]] data[i, idxs[5]]], data[i, idxs[6:11]])
            end
        else
            for i in 1:n_data
                EV_array[i] = structType(data[i, idxs[1:3]], [data[i, Age1_idx], data[i, Age2_idx]])
            end
        end

    else
        if has_covariance
            for i in 1:n_data
                EV_array[i] = structType(data[i, idxs[1:3]], nothing, data[i, idxs[6:11]])
            end
        else
            for i in 1:n_data
                EV_array[i] = structType(data[i, idxs[1:3]])
            end
        end
    end

    return EV_array
end


function LoadTXT_asDict(filePath::String; delimiter=' '::Char, comment='#'::Char, header=false::Bool, names=nothing::Union{Nothing, Vector{String}}) 

    valuesArray = []
    dict = Dict()
    dictKeys = []

    f = open(filePath, "r")
    lineCount = 1
    for (i, line) in pairs(readlines(f))
        
        # Skip comment lines
        if line[1] == comment
            lineCount += 1
            continue
        end

        stringArray = split(line, delimiter, keepempty=false)

        # Parse header/floats
        if i == lineCount
            if names == nothing
                if header
                    global dictKeys = stringArray
                    continue
                else
                    global dictKeys = repeat( ["empty"], size(stringArray, 1) )
                end
            else 
                global dictKeys = names
            end
        end
        

        # Add line floats to array
        floatArray = [parse(Float64, string) for string in stringArray]
        if size(valuesArray) == (0,)
            valuesArray = floatArray
        else
            valuesArray = hcat(valuesArray, floatArray)
        end
    end

    close(f)

    # Array of vectors to dictionary
    if length(dictKeys) == 0
        global dictKeys = repeat( ["empty"], size(valuesArray, 1) )
    end
    
    for (j, key) in pairs(dictKeys)
        dict[key] = valuesArray[j,:]
    end

    return dict
end


function Dict_toStruct(dict, structType=nothing::Union{Nothing, DataType})

    rows = length(collect(values(dict))[1])

    ageKeys = ["age" "Age" "t" "T" "time" "Time"]
    ageKeys1 = ["age1" "Age1" "t1" "T1" "time1" "Time1"]
    ageKeys2 = ["age2" "Age2" "t2" "T2" "time2" "Time2"]
    cartKeys_x = ["x" "X"]
    cartKeys_y = ["y" "Y"]
    cartKeys_z = ["z" "Z"]
    sphKeys_lon = ["lon" "long" "longitude" "Lon" "Long" "Longitude"]
    sphKeys_lat = ["lat" "latitude" "Lat" "Latitude"]
    sphKeys_angle = ["angle" "w" "Angle" "W"]
    sphKeys_vel = ["om" "omega" "Om" "Omega" "vel" "velocity" "angvel" "AngVelocity"]

    covarianceKeys = [
        "a" "b" "c" "d" "e" "f";
        "A" "B" "C" "D" "E" "F";
        "c11" "c12" "c13" "c22" "c23" "c33";
        "C11" "C12" "C13" "C22" "C23" "C33";
        "cxx" "cxy" "cxz" "cyy" "cyz" "czz";
        "CXX" "CXY" "CXZ" "CYY" "CYZ" "CZZ";
        "Cxx" "Cxy" "Cxz" "Cyy" "Cyz" "Czz";
        "CXX" "cXY" "cXZ" "cYY" "cYZ" "cZZ";
    ]

    # --- Covariance ---
    hasCovariance = any([haskey(dict, key) for key in covarianceKeys[:,1]])

    if hasCovariance
        keysCov = [covarianceKeys[:,i][[haskey(dict, key) for key in covarianceKeys[:,i]]][1] for i in 1:6]
        covArray = getindex.(Ref(dict), keysCov)
    #else
    #    covArray = [vec(zeros(rows)) for i in 1:6]
    end


    if typeof(structType) == DataType
        if structType == FiniteRotCart 
            isFR = true
            isEV = false
            isCart = true
            isSph = false
        elseif structType == FiniteRotSph
            isFR = true
            isEV = false
            isSph = true
            isCart = false
        elseif structType == EulerVectorCart
            isEV = true
            isFR = false
            isCart = true
            isSph = false
        elseif structType == EulerVectorSph
            isEV = true
            isFR = false
            isSph = true
            isCart = false
        else
            error("Invalid structType.")
        end

    else
        # Is Finite Rotation
        isFR_angle = any([haskey(dict, key) for key in sphKeys_angle])
        isFR_time = any([haskey(dict, key) for key in ageKeys])
        isFR = isFR_angle && isFR_time

        # Is Euler Vector
        isEV_velocity = any([haskey(dict, key) for key in sphKeys_vel])
        isEV_time = any([haskey(dict, key) for key in ageKeys1])
        isEV = isEV_velocity && isEV_time

        if !isEV && !isFR
            error("Incompatible key names for neither Finite Rotation and Euler Vector.") 
        elseif isEV && isFR
            error("Compatible key names for both Finite Rotation and Euler Vector.") 
        end

        # is Cartesian or Spherical
        isCart = any([haskey(dict, key) for key in cartKeys_x])
        isSph = any([haskey(dict, key) for key in sphKeys_lon])

        if !isCart && !isSph
            error("Incompatible key names for neither spherical nor cartesian coordinates.") 
        elseif isCart && isSph
            error("Compatible key names for both spherical nor cartesian coordinates. Supply only one.") 
        end

    end



    if isFR

        # --- Age ---
        hasAge = any([haskey(dict, key) for key in ageKeys])

        if hasAge
            keyAge = ageKeys[[haskey(dict, key) for key in ageKeys]][1]
            ageArray = dict[keyAge]
        else
            ageArray = repeat(nothing, length(rows))
        end


        # --- Mean Vector ---
        if isCart

            FRarray = Vector{FiniteRotCart}()

            keyX = cartKeys_x[[haskey(dict, key) for key in cartKeys_x]][1]
            keyY = cartKeys_y[[haskey(dict, key) for key in cartKeys_y]][1]
            keyZ = cartKeys_z[[haskey(dict, key) for key in cartKeys_z]][1]

            xArray = dict[keyX]
            yArray = dict[keyY]
            zArray = dict[keyZ]

            for i in eachindex(xArray)
                FRc = FiniteRotCart(xArray[i], yArray[i], zArray[i], ageArray[i], getindex.(covArray,i))
                FRarray = vcat(FRarray, FRc)
            end

        elseif isSph

            FRarray = Vector{FiniteRotSph}()

            keyLon = sphKeys_lon[[haskey(dict, key) for key in sphKeys_lon]][1]
            keyLat = sphKeys_lat[[haskey(dict, key) for key in sphKeys_lat]][1]
            keyAngle = sphKeys_angle[[haskey(dict, key) for key in sphKeys_angle]][1]

            lonArray = dict[keyLon]
            latArray = dict[keyLat]
            angleArray = dict[keyAngle]

            for i in eachindex(lonArray)
                FRc = FiniteRotSph(lonArray[i], latArray[i], angleArray[i], ageArray[i], getindex.(covArray,i))
                FRarray = vcat(FRarray, FRc)
            end
        end
        return FRarray

    elseif isEV

        # --- Age ---
        hasAge1 = any([haskey(dict, key) for key in ageKeys1])
        hasAge2 = any([haskey(dict, key) for key in ageKeys2])

        if hasAge1 && hasAge2
            keyAge1 = ageKeys1[[haskey(dict, key) for key in ageKeys1]][1]
            keyAge2 = ageKeys2[[haskey(dict, key) for key in ageKeys2]][1]
            ageArray1 = dict[keyAge1]
            ageArray2 = dict[keyAge2]
        #else
        #    ageArray1 = repeat(nothing, length(rows))
        #    ageArray2 = repeat(nothing, length(rows))
        end

        # --- Mean Vector ---
        if isCart

            EVarray = Vector{EulerVectorCart}()

            keyX = cartKeys_x[[haskey(dict, key) for key in cartKeys_x]][1]
            keyY = cartKeys_y[[haskey(dict, key) for key in cartKeys_y]][1]
            keyZ = cartKeys_z[[haskey(dict, key) for key in cartKeys_z]][1]

            xArray = dict[keyX]
            yArray = dict[keyY]
            zArray = dict[keyZ]

            for i in eachindex(xArray)
                if hasAge1 && hasAge2
                    ageRange = [ageArray1[i] ageArray2[i]]
                    if hasCovariance
                        EVc = EulerVectorCart(xArray[i], yArray[i], zArray[i], ageRange, getindex.(covArray,i))
                    else
                        EVc = EulerVectorCart(xArray[i], yArray[i], zArray[i], ageRange)
                    end
                else
                    if hasCovariance
                        EVc = EulerVectorCart(xArray[i], yArray[i], zArray[i], getindex.(covArray,i))
                    else
                        EVc = EulerVectorCart(xArray[i], yArray[i], zArray[i])
                    end
                end

                EVarray = vcat(EVarray, EVc)
            end

        elseif isSph

            EVarray = Vector{EulerVectorSph}()

            keyLon = sphKeys_lon[[haskey(dict, key) for key in sphKeys_lon]][1]
            keyLat = sphKeys_lat[[haskey(dict, key) for key in sphKeys_lat]][1]
            keyVelocity = sphKeys_vel[[haskey(dict, key) for key in sphKeys_vel]][1]

            lonArray = dict[keyLon]
            latArray = dict[keyLat]
            velArray = dict[keyVelocity]

            for i in eachindex(lonArray)
                ageRange = [ageArray1[i] ageArray2[i]]
                EVc = EulerVectorSph(lonArray[i], latArray[i], velArray[i], ageRange, getindex.(covArray,i))
                EVarray = vcat(EVarray, EVc)
            end
        end
        return EVarray
    end
end

function LoadTXT_asFR(filePath::String, delimiter=' '::Char, comment='#'::Char, header=true::Bool) 

    dictRot = LoadTXT_asDict(filePath, delimiter=delimiter, comment=comment, header=header)
    return Dict_toStruct(dictRot)
end


function LoadJLS(filePath::String)

    # Open the file in binary mode
    file = open(filePath, "r")

    # Deserialize the array from the file
    data = deserialize(file)

    # Close the file
    close(file)

    return data

end

function LoadJLS(filePath::String, outType::DataType)

    # Open the file in binary mode
    file = open(filePath, "r")

    # Deserialize the array from the file
    data = deserialize(file)

    # Close the file
    close(file)

    return convert(outType, data)

end


function Load_DataFrame(df::DataFrame)
    dict = Dict(name => collect(values(df[!, name])) for name in names(df))
    return Dict_toStruct(dict)
end