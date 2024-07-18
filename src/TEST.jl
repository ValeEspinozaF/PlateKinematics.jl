push!(LOAD_PATH, "C:/Users/nbt571/.julia/dev/PlateKinematics")
using Statistics, LinearAlgebra
using PlateKinematics
using PlateKinematics: LoadTXT_asFR, ToTXT
using PlateKinematics: BuildEnsemble3D, ToEulerVector, AverageEnsemble, Calculate_MeanSurfaceVelocity
using DelimitedFiles, Serialization, Printf, DataFrames

# Inputs Files
projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
fileDir = joinpath(projectDir, raw"0_Data\ProcessedData\FiniteRotations")
fileNames = ["NZ_ROT_SA_som12", "NZ_ROT_SA_qui22"]
delimiter = ['\t', ' ']

# Input Params
pntLon = -70.0
pntLat = -22.0
Nsize = 10000
reverseRot = true

# Outputs
outfileDir = joinpath(projectDir, raw"2_Pipeline\0_FinRot_to_EulerVector\out")
outNames = ["NZ_EV_SA_som12", "NZ_EV_SA_qui22"]


# ============ T O   S T A G E   P O L E ==================

for (i, fileName) in enumerate(fileNames)

    # Upload finite rotations
    filePath = joinpath(fileDir, fileName * ".txt")
    FRsList = LoadTXT_asFR(filePath, delimiter[i])
    FRsArrays = [BuildEnsemble3D(FRs, Nsize, reverseRot) for FRs in FRsList]
    times = [FRs.Time for FRs in FRsList]

    EVsList = []
    SVList = []
    AV_array = Array{Any}(undef, length(times)*2, 4)

    # 1st Euler Vector
    EVsArray = ToEulerVector(FRsArrays[1], [0.0 times[1]] )
    EVs = AverageEnsemble(EVsArray)
    EVsList = vcat(EVsList, EVs)
    #SV = Calculate_MeanSurfaceVelocity(EVsArray, pntLon, pntLat)
    #SVList = vcat(SVList, SV)
    AV_array[1, 1] = 0.0
    AV_array[2, 1] = times[1]

    EVs_magArray = [ev.AngVelocity for ev in EVsArray]
    mean_av = round(mean(EVs_magArray), digits = 2)
    std_av = std(EVs_magArray)
    AV_array[1, 2] = mean_av
    AV_array[2, 2] = mean_av
    AV_array[1, 3] = round(mean_av-std_av, digits = 2)
    AV_array[2, 3] = round(mean_av-std_av, digits = 2)
    AV_array[1, 4] = round(mean_av+std_av, digits = 2)
    AV_array[2, 4] = round(mean_av+std_av, digits = 2)

    for j in 1:length(times) - 1

        if reverseRot == false
            timeRange = [times[j+1] times[j]] 
        else
            timeRange = [times[j] times[j+1]] 
        end

        AV_array[j*2+1, 1] = timeRange[1]
        AV_array[j*2+2, 1] = timeRange[2]

        # Transform to Euler Vector
        FRs1Array = FRsArrays[j]
        FRs2Array = FRsArrays[j+1]
        EVsArray = ToEulerVector(FRs2Array, FRs1Array, timeRange)

        EVs_magArray = [ev.AngVelocity for ev in EVsArray]
        mean_av = round(mean(EVs_magArray), digits = 2)
        std_av = std(EVs_magArray)
        AV_array[j*2+1, 2] = mean_av
        AV_array[j*2+2, 2] = mean_av
        AV_array[j*2+1, 3] = round(mean_av-std_av, digits = 2)
        AV_array[j*2+2, 3] = round(mean_av-std_av, digits = 2)
        AV_array[j*2+1, 4] = round(mean_av+std_av, digits = 2)
        AV_array[j*2+2, 4] = round(mean_av+std_av, digits = 2)

        # Average Euler Vector
        #EVs = AverageEnsemble(EVsArray)
        #EVsList = vcat(EVsList, EVs)

        # Average Velocity
        #SV = Calculate_MeanSurfaceVelocity(EVsArray, pntLon, pntLat)
        #SVList = vcat(SVList, SV)

    end

    # Save output in .txt files
    #outev_filePathTXT = joinpath(outfileDir, outNames[i] * "ev_.txt")   
    #outsv_filePathTXT = joinpath(outfileDir, outNames[i] * "sv_.txt") 
    outav_filePathTXT = joinpath(outfileDir, outNames[i] * "_av.txt") 
    #ToTXT(EVsList, outev_filePathTXT, delimiter='\t')
    #ToTXT(SVList, outsv_filePathTXT, delimiter='\t')
    writedlm(outav_filePathTXT, AV_array, ',')

end