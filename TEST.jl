import PlateKinematics
using PlateKinematics: FileToFiniteRotation, Interpolate_FiniteRotation

# Upload textfile with spherical finite rotations
filePath = joinpath(pwd(), raw"test\FR_exampleFile.txt")
FRsArray = FileToFiniteRotation(filePath)

# Interpolate
timesInterp = [0.78, 8.86, 12.99, 17.28, 24.73, 28.28, 33.54, 40.1, 47.91]
#Interpolate_FiniteRotation(FRsArray, timesInterp, 1e3)
intFRs = Interpolate_FiniteRotation(FRsArray[2], FRsArray[3], 5.0, 1e6)