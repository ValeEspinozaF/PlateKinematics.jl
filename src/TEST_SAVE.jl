using PlateKinematics
using PlateKinematics: BuildEnsemble3D, LoadTXT_asStruct, ToEVc, SaveStruct_asTXT, EulerVectorSph
using DelimitedFiles

projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
fileDir = joinpath(projectDir, raw"2_Pipeline\1_EulerVector_to_PlateCircuit\store")
fileName = "NZ_EV_SA_qui22_fRot_ve"
filePath = joinpath(fileDir, fileName * ".txt")


EVs_list = LoadTXT_asStruct(filePath, EulerVectorSph, header=true)
SaveStruct_asTXT(EVs_list[1], joinpath(fileDir, fileName * "_test.txt"), delimiter=" ", fields=["Lon", "Lat"], header=false)

