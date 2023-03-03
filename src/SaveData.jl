using PlateKinematics: FiniteRotCart, FiniteRotSph, EulerVectorCart, EulerVectorSph

function FRtoTXT(ENS::Union{Matrix, Vector}, filePath::String, format::Array{String}, delimiter=' '::Char)

    #, delimiter=' '::Char, commentChar='#'::Char, comment=""::String)

    Nsize = size(ENS)[1]
    structFields = fieldnames(typeof(ENS[1]))
    covFields = (:C11, :C12, :C13, :C22, :C23, :C33)
    lines = Array{String}(undef, Nsize + 1)

    header = ""

    for field in structFields

        if field == :Covariance
            for covField in covFields
                header = header * delimiter * string(covField)
            end
        else
            header = header * delimiter * string(field)
        end
    end

    lines[1] = header[2:end]
    cols = length(split(lines[1], ' '))

    if ismissing(format)
        format = fill("%.2f", cols)
    else
        if cols != length(format)
            throw("Format supplied does not match the amount of field in $(typeof(ENS[1]))")
        end
    end
    

    for i in 2:Nsize + 1

        line = ""

        for (index, field) in enumerate(structFields)

            if field == :Covariance
                for covField in covFields
                    fieldValue = getproperty(ENS[i-1].Covariance, covField)
                    fmt = format[index]
                    line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
                end
            else
                fieldValue = getproperty(ENS[i-1], field)
                fmt = format[index]
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
            end
        end

        lines[i] = line[2:end]
    end

    writedlm(filePath, lines)

end

function EVtoTXT(ENS::Union{Matrix, Vector}, filePath::String, format::Array{String}, delimiter=' '::Char)

    #, delimiter=' '::Char, commentChar='#'::Char, comment=""::String)

    Nsize = size(ENS)[1]
    structFields = fieldnames(typeof(ENS[1]))
    covFields = (:C11, :C12, :C13, :C22, :C23, :C33)
    lines = Array{String}(undef, Nsize + 1)

    header = ""

    for field in structFields

        if field == :Covariance
            for covField in covFields
                header = header * delimiter * string(covField)
            end
        elseif field == :TimeRange
            header = header * delimiter * "Age1" * delimiter * "Age2"
        else
            header = header * delimiter * string(field)
        end
    end

    lines[1] = header[2:end]
    cols = length(split(lines[1], ' '))

    if ismissing(format)
        format = fill("%.2f", cols)
    else
        if cols != length(format) + 1
            throw("Format supplied does not match the amount of field in $(typeof(ENS[1]))")
        end
    end
    

    for i in 2:Nsize + 1

        line = ""

        for (index, field) in enumerate(structFields)

            fmt = format[index]

            if field == :Covariance
                for covField in covFields
                    fieldValue = getproperty(ENS[i-1].Covariance, covField)
                    line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
                end

            elseif field == :TimeRange 
                fieldValue = getproperty(ENS[i-1], field)
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue[1])
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue[2])

            else
                fieldValue = getproperty(ENS[i-1], field)
                line = line * delimiter * Printf.format(Printf.Format(fmt), fieldValue)
            end
        end

        lines[i] = line[2:end]
    end

    writedlm(filePath, lines)

end

function SaveJLS(data, filePath::String)

    # Open the file in binary mode
    file = open(filePath, "w")

    # Serialize the array to the file
    serialize(file, data)

    # Close the file
    close(file)

end