using PlateKinematics: FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph
using DataFrames: DataFrame


function LoadTXT_asDict(filePath::String, delimiter=' '::Char, comment='#'::Char, header=false) 

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
        if header && i == lineCount
            global dictKeys = stringArray
            continue
        else
            floatArray = [parse(Float64, string) for string in stringArray]
        end

        # Add line floats to array
        if size(valuesArray) == (0,)
            valuesArray = floatArray
        else
            valuesArray = hcat(valuesArray, floatArray)
        end
    end

    close(f)

    # Array of vectors to dictionary
    if length(dictKeys) == 0
        global dictKeys = repeat(["empty"], size(valuesArray)[1])
    end
    
    for (j, key) in pairs(dictKeys)
        dict[key] = valuesArray[j,:]
    end

    return dict
end

function Dict_toStruct(dict)

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
    else
        covArray = [vec(zeros(rows)) for i in 1:6]
    end


    # Is Finite Rotation
    isFR_angle = any([haskey(dict, key) for key in sphKeys_angle])
    isFR_time = any([haskey(dict, key) for key in ageKeys])
    is_FR = isFR_angle && isFR_time

    # Is Euler Vector
    isEV_velocity = any([haskey(dict, key) for key in sphKeys_vel])
    isEV_time = any([haskey(dict, key) for key in ageKeys1])
    is_EV = isEV_velocity && isEV_time

    if !is_EV && !is_FR
        throw("Incompatible key names for neither Finite Rotation and Euler Vector.") 
    elseif is_EV && is_FR
        throw("Compatible key names for both Finite Rotation and Euler Vector.") 
    end


    # is Cartesian or Spherical
    isCart = any([haskey(dict, key) for key in cartKeys_x])
    isSph = any([haskey(dict, key) for key in sphKeys_lon])

    if !isCart && !isSph
        throw("Incompatible key names for neither spherical nor cartesian coordinates.") 
    elseif isCart && isSph
        throw("Compatible key names for both spherical nor cartesian coordinates. Supply only one.") 
    end


    if is_FR

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

    elseif is_EV

        # --- Age ---
        hasAge1 = any([haskey(dict, key) for key in ageKeys1])
        hasAge2 = any([haskey(dict, key) for key in ageKeys2])

        if hasAge1 && hasAge2
            keyAge1 = ageKeys1[[haskey(dict, key) for key in ageKeys1]][1]
            keyAge2 = ageKeys2[[haskey(dict, key) for key in ageKeys2]][1]
            ageArray1 = dict[keyAge1]
            ageArray2 = dict[keyAge2]
        else
            ageArray1 = repeat(nothing, length(rows))
            ageArray2 = repeat(nothing, length(rows))
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
                ageRange = [ageArray1[i] ageArray2[i]]
                EVc = EulerVectorCart(xArray[i], yArray[i], zArray[i], ageRange, getindex.(covArray,i))
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

    dictRot = LoadTXT_asDict(filePath, delimiter, comment, header)
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