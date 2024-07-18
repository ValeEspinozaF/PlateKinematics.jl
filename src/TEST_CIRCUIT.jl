push!(LOAD_PATH, "C:/Users/nbt571/.julia/dev/PlateKinematics")
using Statistics, LinearAlgebra
using PlateKinematics
using PlateKinematics: LoadTXT_asDict, Dict_toStruct, ToTXT
using PlateKinematics: Add_FiniteRotations, BuildEnsemble3D, ToFRs, AverageEnsemble, ToEulerVector
using DelimitedFiles, Serialization, Printf, DataFrames

projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
Nsize = 1000000

# Finite rotations
#fileDir = joinpath(projectDir, raw"0_Data\ProcessedData\FiniteRotations")
#fileNames = ["NZ_ROT_PA_qui22_gts20", "PA_ROT_AN_qui22_gts20", "AN_ROT_NB_qui22_gts20", "NB_SA_OUTPUT_FINITE_ROTATIONS"]
#reverseRot_list = [true, true, true, false]

fileDir = joinpath(projectDir, raw"1_Scripts\0_FinRot_to_EulerVector\REDBACK_Analysis\REDBACK-1.0.5\FINROT")
fileNames = ["NZ_PA/NZ_PA_Wilder2003_Tb1_GTS20_interp", "PA_AN/PA_AN_OUTPUT_FINITE_ROTATIONS_interp", "AN_NB/AN_NB_OUTPUT_FINITE_ROTATIONS_interp", "NB_SA/NB_SA_OUTPUT_FINITE_ROTATIONS_interp"]
reverseRot_list = [true, false, false, false]

# To calculate SA/NZ
invertOrder = true
if invertOrder == true
    fileNames = reverse(fileNames)
    reverseRot_list = [!bool for bool in reverse(reverseRot_list)]
end


filePath0 = joinpath(fileDir, fileNames[1] * ".txt")
FRs_list0 = LoadTXT_asStruct(filePath0, FiniteRotSph, header=true)
MTX_list_ens0 = [BuildEnsemble3D(FRs_0, Nsize, reverseRot_list[1]) for FRs_0 in FRs_list0]
times = [FRs.Time for FRs in FRs_list0]


for (index, fileName) in enumerate(fileNames[2:end])
    
    filePath_i = joinpath(fileDir, fileName * ".txt")
    FRs_list_i = LoadTXT_asStruct(filePath_i, FiniteRotSph, header=true)
    
    for (index_j, MTX_list_ens0_j) in enumerate(MTX_list_ens0)
        MTX_ens_i = BuildEnsemble3D(FRs_list_i[index_j], Nsize, reverseRot_list[index+1])
        MTX_list_ens0[index_j] = Add_FiniteRotations(MTX_list_ens0_j, MTX_ens_i)
    end
end


#FRs_circuit_list_ens = [ToFRs(MTX_ens) for MTX_ens in MTX_list_ens0]
#FRs_circuit = [AverageEnsemble(FRs_circuit_ens, times[index]) for (index, FRs_circuit_ens) in enumerate(FRs_circuit_list_ens)];


global EVs_list = []

for j in 1:length(times) - 1

    timeRange = [times[j+1] times[j]]   # because all finite rotations are already in forward motion (not reconstruction)

    # Transform to Euler Vector
    EVs_array = ToEulerVector(MTX_list_ens0[j+1], MTX_list_ens0[j], timeRange)

    # Average Euler Vector
    EVs_mean = AverageEnsemble(EVs_array)
    global EVs_list = vcat(EVs_list, EVs_mean)


    #= EVc_list_local = []
    for i in 1:length(EVc_array)
        EVc_list_local = push!(EVc_list_local, [EVc_array[i].X, EVc_array[i].Y, EVc_array[i].Z])
    end

    local outName = "NZ_EV_SA_qui22_$(timeRange[1])_$(timeRange[2])"
    outav_filePathTXT = joinpath(outfileDir, outName * "_ev.txt") 
    writedlm(outav_filePathTXT, EVc_list_local, ',') =#
end

# Outputs
if invertOrder
    ToTXT(EVs_list, raw"C:\Users\nbt571\Documents\PhD\Project_Folder\2_Pipeline\1_EulerVector_to_PlateCircuit\store\SA_EV_NZ_qui22_fRot_ve.txt", delimiter=" ")
else
    ToTXT(EVs_list, raw"C:\Users\nbt571\Documents\PhD\Project_Folder\2_Pipeline\1_EulerVector_to_PlateCircuit\store\NZ_EV_SA_qui22_fRot_ve.txt", delimiter=" ")
end
