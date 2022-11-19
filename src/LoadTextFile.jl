using PlateKinematics: FiniteRotCart, FiniteRotSph


function FileToDictionary(filePath::String, delimiter=' '::Char, comment='#'::Char, header=false)

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

        stringArray = split(line, delimiter)

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

    else
        for (j, key) in pairs(dictKeys)
            dict[key] = valuesArray[j,:]
        end
    end

    return dict
end



function FileToFiniteRotation(filePath::String, delimiter=' '::Char, comment='#'::Char)

    dictRot = FileToDictionary(filePath, delimiter, comment, true)
    rows = length(collect(values(dictRot))[1])


    ageKeys = ["age" "ages" "Age" "Ages" "t" "T" "time" "Time"]
    cartKeys_x = ["x" "X"]
    cartKeys_y = ["y" "Y"]
    cartKeys_z = ["z" "Z"]
    sphKeys_lon = ["lon" "long" "longitude" "Lon" "Long" "Longitude"]
    sphKeys_lat = ["lat" "latitude" "Lat" "Latitude"]
    sphKeys_angle = ["angle" "w" "om" "omega" "Angle" "W" "Om" "Omega"]

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
    hasCovariance = any([haskey(dictRot, key) for key in covarianceKeys[:,1]])

    if hasCovariance
        keysCov = [covarianceKeys[:,i][[haskey(dictRot, key) for key in covarianceKeys[:,i]]][1] for i in 1:6]
        covArray = getindex.(Ref(dictRot), keysCov)

    else
        covArray = [vec(zeros(rows)) for i in 1:6]
    end


    # --- Age ---
    hasAge = any([haskey(dictRot, key) for key in ageKeys])

    if hasAge
        keyAge = ageKeys[[haskey(dictRot, key) for key in ageKeys]][1]
        ageArray = dictRot[keyAge]

    else
        ageArray = repeat(nothing, length(rows))

    end


    # --- Mean Vector ---
    isCart = any([haskey(dictRot, key) for key in cartKeys_x])
    isSph = any([haskey(dictRot, key) for key in sphKeys_lon])

    if isCart

        FRarray = Vector{FiniteRotCart}()

        keyX = cartKeys_x[[haskey(dictRot, key) for key in cartKeys_x]][1]
        keyY = cartKeys_y[[haskey(dictRot, key) for key in cartKeys_y]][1]
        keyZ = cartKeys_z[[haskey(dictRot, key) for key in cartKeys_z]][1]

        xArray = dictRot[keyX]
        yArray = dictRot[keyY]
        zArray = dictRot[keyZ]

        for i in eachindex(xArray)
            FRc = FiniteRotCart(xArray[i], yArray[i], zArray[i], ageArray[i], getindex.(covArray,i))
            FRarray = vcat(FRarray, FRc)
        end

    elseif isSph

        FRarray = Vector{FiniteRotSph}()

        keyLon = sphKeys_lon[[haskey(dictRot, key) for key in sphKeys_lon]][1]
        keyLat = sphKeys_lat[[haskey(dictRot, key) for key in sphKeys_lat]][1]
        keyAngle = sphKeys_angle[[haskey(dictRot, key) for key in sphKeys_angle]][1]

        lonArray = dictRot[keyLon]
        latArray = dictRot[keyLat]
        angleArray = dictRot[keyAngle]

        for i in eachindex(lonArray)
            FRc = FiniteRotSph(lonArray[i], latArray[i], angleArray[i], ageArray[i], getindex.(covArray,i))
            FRarray = vcat(FRarray, FRc)
        end
    end

    return FRarray
end