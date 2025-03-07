using PlateKinematics: FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph

Structs = Union{FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph, SurfaceVelocityVector}

Writables = Union{FiniteRotCart, FiniteRotSph, 
                  EulerVectorCart, EulerVectorSph,
                  SurfaceVelocityVector,
                  AbstractArray{FiniteRotCart}, 
                  AbstractArray{FiniteRotSph}, 
                  AbstractArray{EulerVectorCart},
                  AbstractArray{EulerVectorSph},
                  AbstractArray{SurfaceVelocityVector}}


"""
    SaveStruct_asTXT(array::Writables, filePath::String; delimiter=' '::Char, fields=nothing::Union{Vector, Array, Nothing}, header=true::Bool, format=nothing::Union{Vector, Array, Nothing})

Save a structure to a text file. The function will save the structure in a tabular format.

### Arguments
- `array:`: An array of structures to save to file. May also be a single structure. Options are `FiniteRotCart`, `FiniteRotSph`, `EulerVectorCart`, `EulerVectorSph`, `SurfaceVelocityVector`.
- `filePath`: The path to the file to save the structure to.
- `delimiter`: The delimiter to use in the text file. Warning, \\t may not work as expected. (optional, default=' ')
- `fields`: The fields to save to the file. If nothing, all fields will be saved. (optional, default=nothing)
- `header`: If true, a header will be added to the file, with the field names of the struct. (optional, default=true)
- `format`: The format to save the fields in. If nothing, the default is "%.5f" for all columns. (optional, default=nothing)

### Returns
- `Nothing`
"""
function SaveStruct_asTXT(array::Writables, filePath::String; 
    delimiter=' '::Char, fields=nothing::Union{Vector, Array, Nothing}, header=true::Bool, format=nothing::Union{Vector, Array, Nothing})


    if typeof(array) <: Writables
        if typeof(array) <: Structs
            array = [array]
        end
    else
        error("Input array is not a valid type for saving to file.")
    end 
  

    Nsize = size(array, 1)
    structType = typeof(array[1])
    structFields = fieldnames(structType)
    fieldNames = [string(field) for field in structFields]
    covFields = (:C11, :C12, :C13, :C22, :C23, :C33)
    velFields = (:EastVel, :NorthVel, :TotalVel, :Azimuth)


    if !isnothing(fields)
        if any([name ∉ fieldNames for name in fields])
            error("Names supplied are not valid field names for $(structType)")
        end
        fieldNames = fields
    end

    
    # Establish the heading fields
    heading = ""
    for field in fieldNames
        if field == "Covariance"
            for covField in covFields
                heading = heading * delimiter * string(covField)
            end
        elseif (field in velFields) && (typeof(getproperty(ENS[1], field)) != Float64)
            heading = heading * string(field) * "_mean" * delimiter * string(field) * "_std"
        elseif field == "TimeRange"
            heading = heading * delimiter * "Age1" * delimiter * "Age2"
        else
            heading = heading * delimiter * string(field)
        end
    end

    
    # Establish format
    cols = length(split(heading, delimiter, keepempty=false))

    if isnothing(format)
        format = fill("%.5f", cols)
    else
        if cols != length(format)
            error("Format supplied does not match the amount of field in $(typeof(array[1]))")
        end
    end
    

    # Create header
    if header
        Nlines = Nsize + 1
    else
        Nlines = Nsize
    end

    lines = Array{String}(undef, Nlines)

    idx = 1
    for i in 1:Nlines

        if header && i == 1
            lines[i] = heading[2:end]
            continue
        end

        line = ""
        for (index, field) in enumerate(fieldNames)

            fmt = format[index]

            if field == "Covariance"
                for covField in covFields
                    fieldValue = getproperty(array[idx].Covariance, covField)
                    line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
                end

            elseif (Symbol(field) in velFields) && (typeof(getproperty(array[1], Symbol(field))) == Stat)
                fieldValue = getproperty(array[idx], Symbol(field))
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue.Mean)
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue.StDev)

            elseif field == "TimeRange"
                fieldValue = getproperty(array[idx], Symbol(field))
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue[1])
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue[2])

            else
                fieldValue = getproperty(array[idx], Symbol(field))
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
            end
        end

        lines[i] = line[2:end]
        idx += 1
    end

    writedlm(filePath, lines)

end


function ToTXT(ENS::Union{Matrix, Vector}, filePath::String; delimiter=' '::Char, fields=nothing::Union{Vector, Array, Nothing})

    Nsize = size(ENS, 1)
    structFields = fieldnames(typeof(ENS[1]))
    covFields = (:C11, :C12, :C13, :C22, :C23, :C33)
    velFields = (:EastVel, :NorthVel, :TotalVel, :Azimuth)

    
    field_names = []
    for field in structFields
        if (field == :Covariance)
            covArray = [string(covField) for covField in covFields]
            field_names = vcat(field_names, covArray)

        elseif (field in velFields) && (typeof(getproperty(ENS[1], field)) == Stat)
            field_names = vcat(field_names, string(field) * "_mean", string(field) * "_std")

        elseif (field == :TimeRange)
            field_names = vcat(field_names, "Age1", "Age2")

        else
            field_names = vcat(field_names, string(field))
        end
    end

    if !isnothing(fields)
        if any([name in field_names for name in fields])
            error("Names supplied are not valid field names for $(typeof(ENS[1]))")
        end
        header = fields
        
    else
        header = field_names
    end

    cols = length(header)

    m_out = Array{Any}(undef, Nsize+1, cols)
    m_out[1, :] = header
    for i in 2:Nsize + 1

        index = 1
        for field in structFields

            if field == :Covariance
                for (cov_idx, covField) in enumerate(covFields)
                    fieldValue = getproperty(ENS[i-1].Covariance, covField)
                    m_out[i, index + cov_idx - 1] = fieldValue
                end

            elseif (field in velFields) && (typeof(getproperty(ENS[1], field)) == Stat)
                fieldValue = getproperty(ENS[i-1], field)
                m_out[i, index ] = fieldValue.Mean
                m_out[i, index + 1] = fieldValue.StDev
                index += 1

            elseif field == :TimeRange 
                fieldValue = getproperty(ENS[i-1], field)
                if fieldValue == nothing
                    m_out[i, index] = "nan"
                    m_out[i, index+1] = "nan"
                else
                    m_out[i, index] = fieldValue[1]
                    m_out[i, index+1] = fieldValue[2]
                end
                index += 1

            else
                fieldValue = getproperty(ENS[i-1], field)
                m_out[i, index] = fieldValue
            end

            index += 1
        end
    end

    writedlm(filePath, m_out, delimiter)

end

function SaveJLS(data, filePath::String)

    # Open the file in binary mode
    file = open(filePath, "w")

    # Serialize the array to the file
    serialize(file, data)

    # Close the file
    close(file)

end
