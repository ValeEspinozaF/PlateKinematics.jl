import PlateKinematics
using PlateKinematics: FileToFiniteRotation

# Upload textfile with spherical finite rotations
filePath = joinpath(pwd(), raw"test\FR_exampleFile.txt")
FRarray = FileToFiniteRotation(filePath)

# Interpolate
timesInterp = [0.5, 0.78, 8.86, 12.99, 17.28, 24.73, 28.28, 33.54, 40.1, 47.91]
Interpolate_FiniteRotation(FRsArray::Matrix{FiniteRotSph}, timesInterp, Nsize = 1e3)