import PlateKinematics
using PlateKinematics: FileToFiniteRotation

filePath = joinpath(pwd(), raw"test\FR_exampleFile.txt")


FRarray = FileToFiniteRotation(filePath)
