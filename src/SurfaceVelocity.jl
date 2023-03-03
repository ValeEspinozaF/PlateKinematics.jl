using Statistics, LinearAlgebra
using PlateKinematics: EulerVectorSph, EulerVectorCart, Covariance, SurfaceVelocityVector, Stat
using PlateKinematics: CovIsZero, BuildEnsemble3D, ToRadians, ToDegrees


"""
Calculate the surface velocity components for a given point on Earth. """
function Calculate_SurfaceVelocity(EVs::EulerVectorSph, pntLon::Number, pntLat::Number, Nsize = 1e5::Number)

    OUT_UNIT = 1e-6     # unit of measurement to mm/yr
    Re = 6371e6         # Earth's radius

    
    # Build ensemble if covariances are given
    if CovIsZero(EVs.Covariance)
        EVs_array = [EVs]
    else
        EVs_array = BuildEnsemble3D(EVs, Nsize)
    end 

    
    # Euler pole coorinates in radians
    lon_rad = ToRadians(getindex.(EVs_array, 1))
    lat_rad = ToRadians(getindex.(EVs_array, 2))
    mag_rad = ToRadians(getindex.(EVs_array, 3))


    # Location point in radians 
    pntLon_rad = ToRadians(pntLon)
    pntLat_rad = ToRadians(pntLat)


    # Calculate the surface velocity
    v_mag = Re * OUT_UNIT * mag_rad

    eastVel = v_mag .* (cos.(pntLat_rad) * sin.(lat_rad) .- sin.(pntLat_rad) .* cos.(lat_rad) .* cos.(pntLon_rad .- lon_rad))
    northVel = v_mag .* cos.(lat_rad) .* sin.(pntLon_rad .- lon_rad)
    totalVel = map((ev, nv) -> norm([ev, nv]), eastVel, northVel)
    azimuth = 90 .- ToDegrees(atan.(northVel, eastVel))


    # Surface velocity statistics
    meanEast = mean(eastVel)
    meanNorth = mean(northVel)
    meanTotal = mean(totalVel)
    meanAzim = mean(azimuth)

    stdEast = std(eastVel)
    stdNorth = std(northVel)
    stdTotal = std(totalVel)
    stdAzimuth = std(azimuth)


    # Return SurfaceVelocityVector
    if size(EVs_array)[1] !== 1
        return SurfaceVelocityVector(
            pntLon, pntLat, 
            Stat(meanEast, stdEast), 
            Stat(meanNorth, stdNorth), 
            Stat(meanTotal, stdTotal), 
            Stat(meanAzim, stdAzimuth)
            )
    else
        return SurfaceVelocityVector(pntLon, pntLat, mean(eastVel), mean(northVel))
    end
end