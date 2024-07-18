push!(LOAD_PATH, "C:/Users/nbt571/.julia/dev/PlateKinematics")
using Statistics, LinearAlgebra
using PlateKinematics
using PlateKinematics: LoadTXT_asStruct, ToTXT
using PlateKinematics: Interpolate_FiniteRotation, BuildEnsemble3D, ToFRs, AverageEnsemble, ToEulerVector
using DelimitedFiles, Serialization, Printf, DataFrames

projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
Nsize = 1000000

# Finite rotations
fileDir_ref = joinpath(projectDir, raw"1_Scripts\0_FinRot_to_EulerVector\REDBACK_Analysis\REDBACK-1.0.5\FINROT")
fileName_ref = "NB_SA/NB_SA_DM_2019_FINROT"
filePath_ref = joinpath(fileDir_ref, fileName_ref * ".txt")
FRs_list_ref = LoadTXT_asStruct(filePath_ref, FiniteRotSph, names=["Age", "Lon", "Lat", "Angle", "C11", "C12", "C13", "C22", "C23", "C33"])

interp_times = [FRs.Time for FRs in FRs_list_ref]


# Finite rotations
fileDir_test = joinpath(projectDir, raw"1_Scripts\0_FinRot_to_EulerVector\REDBACK_Analysis\REDBACK-1.0.5\FINROT")
fileName_test = "NB_SA/NB_SA_OUTPUT_FINITE_ROTATIONS" #"NZ_PA/NZ_PA_Wilder2003_Tb1_GTS20" #"AN_NB/AN_NB_OUTPUT_FINITE_ROTATIONS" #"PA_AN/PA_AN_OUTPUT_FINITE_ROTATIONS" #
filePath_test = joinpath(fileDir_test, fileName_test * ".txt")
FRs_list_test = LoadTXT_asStruct(filePath_test, FiniteRotSph, names=["Age", "Lon", "Lat", "Angle", "C11", "C12", "C13", "C22", "C23", "C33"])
#FRs_list_test = LoadTXT_asStruct(filePath_test, FiniteRotSph, header=true)

FRs_list_test_interp = Interpolate_FiniteRotation(FRs_list_test, interp_times, Nsize)
ToTXT(FRs_list_test_interp, joinpath(fileDir_test, fileName_test * "_interp.txt"), delimiter=" ")


