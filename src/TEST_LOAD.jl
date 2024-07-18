using PlateKinematics
using PlateKinematics: LoadTXT_asStruct


projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
Nsize = 10000

# Finite rotations
fileDir = joinpath(projectDir, raw"1_Scripts\0_FinRot_to_EulerVector\REDBACK_Analysis\REDBACK-1.0.5\FINROT\NZ_PA")
fileName = "NZ_PA_Wilder2003_Tb1_GTS20"


filePath = joinpath(fileDir, fileName * ".txt")
FRs_list = LoadTXT_asStruct(filePath, FiniteRotSph, header=true)