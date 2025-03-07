using Statistics, LinearAlgebra
using PlateKinematics
using PlateKinematics: EulerVectorSph, CovIsZero, BuildEnsemble, SurfaceVelocityVector, sph2cart, ToDegrees, ToRadians

#= """ Simplified, faster version. - Does not use the ellipsoid and gives an azimuth between -90 and 270. 

Calculate the surface velocity components for a given point on Earth. """
function Calculate_SurfaceVelocity(EVs::EulerVectorSph, pntLon::Float64, pntLat::Float64, Nsize=100000::Int64)

    OUT_UNIT = 1e-7     # unit of measurement to cm/yr
    Re = 6371e6         # Earth's radius

    
    # Build ensemble if covariances are given
    if CovIsZero(EVs.Covariance)
        EVsArray = [EVs]
    else
        EVsArray = BuildEnsemble(EVs, Nsize)
    end 

    
    # Euler pole coorinates in radians
    lon_rad = ToRadians(getindex.(EVsArray, 1))
    lat_rad = ToRadians(getindex.(EVsArray, 2))
    mag_rad = ToRadians(getindex.(EVsArray, 3))


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
    if size(EVsArray, 1) !== 1
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
end =#


"""
    Calculate_SurfaceVelocity(
        EVs::EulerVectorSph, pntLon::Float64, pntLat::Float64, Nsize=100000::Int64)

    Calculate_SurfaceVelocity(
        EVsArray::Array{T}, pntLon::Float64, pntLat::Float64) where {T<:EulerVectorSph}

    Calculate_SurfaceVelocity(
        EVs::EulerVectorSph, arrayLon::Array{N}, arrayLat::Array{N}, 
        Nsize=100000::Int64) where {N<:Float64}

Calculate the Surface Velocity components for a given point on Earth, subject to the motion
described by an Euler Vector `EVs`. Location(s) are given through parameters `pntLon` 
and `pntLat`, which represent spherical coordinates in degrees-East and degrees-North, 
respectively. Outputs are given in cm/yr and degrees.	
"""
function Calculate_SurfaceVelocity(EVs::EulerVectorSph, pntLon::Float64, pntLat::Float64, Nsize=100000::Int64)
    
    # Build ensemble if covariances are given
    if CovIsZero(EVs.Covariance)
        EVsArray = [EVs]
    else
        EVsArray = BuildEnsemble(EVs, Nsize)
    end 


    # Calculate surface velocity components
    eastVel, northVel, totalVel, azimuth = Calculate_SurfaceVelocity(EVsArray, pntLon, pntLat)


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
    if size(EVsArray, 1) !== 1

        return SurfaceVelocityVector(
            pntLon, pntLat, 
            Stat(meanEast, stdEast), 
            Stat(meanNorth, stdNorth), 
            Stat(meanTotal, stdTotal), 
            Stat(meanAzim, stdAzimuth)
            )
    else
        return SurfaceVelocityVector(
            pntLon, pntLat, 
            meanEast, 
            meanNorth,
            meanTotal,
            meanAzim
            )
    end
end


function Calculate_SurfaceVelocity(
    EVs::EulerVectorSph, pntLon::Array{N}, pntLat::Array{N}, 
    Nsize=100000::Int64) where {N<:Float64}

    
    # Build ensemble if covariances are given
    if CovIsZero(EVs.Covariance)
        EVsArray = [EVs]
    else
        EVsArray = BuildEnsemble(EVs, Nsize)
    end 


    # Surface velocity
    SV_array = Array{SurfaceVelocityVector}(undef, length(pntLon))


    for (i, (pntLon, pntLat)) in enumerate(zip(pntLon, pntLat))

        # Calculate surface velocity components
        eastVel, northVel, totalVel, azimuth = Calculate_SurfaceVelocity(EVsArray, pntLon, pntLat)


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
        if size(EVsArray, 1) !== 1

            SV_array[i] = SurfaceVelocityVector(
                pntLon, pntLat, 
                Stat(meanEast, stdEast), 
                Stat(meanNorth, stdNorth), 
                Stat(meanTotal, stdTotal), 
                Stat(meanAzim, stdAzimuth)
                )

        else
            SV_array[i] = SurfaceVelocityVector(
                pntLon, pntLat, 
                meanEast, 
                meanNorth,
                meanTotal,
                meanAzim
                )
        end
    end

    return SV_array
end


function Calculate_SurfaceVelocity(EVsArray::Array{T}, pntLon::Float64, pntLat::Float64) where {T<:EulerVectorSph}

    Nsize = length(EVsArray)

    # Point coordinates to Cartesian (WGS-84 ellipsoid)
    x, y, z = GeographicalCoords_toCartesian(pntLon, pntLat)

    # Euler vector to Cartesian components
    wx, wy, wz = sph2cart(
        getindex.(EVsArray, 1),
        getindex.(EVsArray, 2),
        getindex.(EVsArray, 3),
        )

    wx = ToRadians(wx)
    wy = ToRadians(wy)
    wz = ToRadians(wz)

    # Surface velocity
    SVcArray = Array{Float64}(undef, Nsize, 3)

    SVcArray[:, 1] = (wy .* z) .- (wz .* y)
    SVcArray[:, 2] = (wz .* x) .- (wx .* z)
    SVcArray[:, 3] = (wx .* y) .- (wy .* x)


    # [m/Myr] to [cm/yr]
    SVcArray = SVcArray .* (1e2/1e6)


    # East/North components [cm/yr]
    eastVel, northVel = CartesianVelocity_toEN(pntLon, pntLat, SVcArray)


    # Total surface velocity in cm/yr
    totalVel = ( eastVel.^2 .+ northVel.^2 ) .^ 0.5


    # Velocity vector azimuth (clockwise from North)
    AT = ToDegrees(atan.(northVel ./ eastVel))
    azimuth = Array{Float64}(undef, Nsize)

    r = findall(eastVel .> 0)
    azimuth[r] .= 90 .- sign.(northVel[r]) .* abs.(AT[r])

    r = findall(eastVel .<= 0)
    azimuth[r] .= -90 .+ sign.(northVel[r]) .* abs.(AT[r])
    
    # Return surface velocity components
    return [eastVel, northVel, totalVel, azimuth]
end

function Calculate_MeanSurfaceVelocity(EVsArray::Array{T}, pntLon::Float64, pntLat::Float64) where {T<:EulerVectorSph}
    
    eastVel, northVel, totalVel, azimuth = Calculate_SurfaceVelocity(EVsArray, pntLon, pntLat)
    
    # Surface velocity statistics
    meanEast = mean(eastVel)
    meanNorth = mean(northVel)
    meanTotal = mean(totalVel)
    meanAzim = mean(azimuth)

    stdEast = std(eastVel)
    stdNorth = std(northVel)
    stdTotal = std(totalVel)
    stdAzimuth = std(azimuth)

    # Return SurfaceVelocityVector instance
    return SurfaceVelocityVector(
            pntLon, pntLat, 
            Stat(meanEast, stdEast), 
            Stat(meanNorth, stdNorth), 
            Stat(meanTotal, stdTotal), 
            Stat(meanAzim, stdAzimuth)
            )
end


"""
    GeographicalCoords_toCartesian(pntLon::Float64, pntLat::Float64, Ht=0.0::Float64)

Converts local geographical coordinates (ellipsoidal) into Cartesian. """
function GeographicalCoords_toCartesian(pntLon::Float64, pntLat::Float64, Ht=0.0::Float64)

    # pntLon and pntLat are geographical coordinates in degrees.
    # Ht is the height abode the ellipsoid in meters.
    # Output x, y, z are in meters.

    # Semimajor axis axis and flattening for WGS-84
    a = 6378137.0000
    f = 1.0 / 298.257223563

    # Semiminor axis (should be 6356752.3142)
    b = a * (1-f)
    
    # Eccentricity
    ecc = 2*f - f^2

    # Degrees to radians
    lon_rad = ToRadians(pntLon)
    lat_rad = ToRadians(pntLat)

    # Radius of curvature in prime vertical
    N = a ./ sqrt( 1 .- ( sin.(lat_rad) ).^2 .* ecc )

    # Cartesian coordinates
    x = cos.(lat_rad) .* cos.(lon_rad) .* (N .+ Ht)
    y = cos.(lat_rad) .* sin.(lon_rad) .* (N .+ Ht)
    z = sin.(lat_rad) .* ( N .* (b^2 / a^2) .+ Ht )

    return [x, y, z]
end


"""
    CartesianVelocity_toEN(pntLon::N, pntLat::N, SVcArray::Array{N, 2}) where {N<:Float64}

Converts a set of velocities from Cartesian to East/North (EN) components. """
function CartesianVelocity_toEN(pntLon::N, pntLat::N, SVcArray::Array{N, 2}) where {N<:Float64}

    lon_rad = ToRadians(pntLon)
    lat_rad = ToRadians(pntLat)

    vX = SVcArray[:, 1]
    vY = SVcArray[:, 2]
    vZ = SVcArray[:, 3]

    R11 = -sin(lat_rad) * cos(lon_rad)
    R12 = -sin(lat_rad) * sin(lon_rad)
    R13 =  cos(lat_rad)
    R21 = -sin(lon_rad)
    R22 =  cos(lon_rad)
    R23 =  0.0
    R31 =  cos(lat_rad) * cos(lon_rad)
    R32 =  cos(lat_rad) * sin(lon_rad)
    R33 =  sin(lat_rad)

    vN = (R11 .* vX) .+ (R12 .* vY) .+ (R13 .* vZ)
    vE = (R21 .* vX) .+ (R22 .* vY) .+ (R23 .* vZ)

    return vE, vN

end


EVs = EulerVectorSph(-122.5, -22.41, 0.1247, [1997 2000])

Calculate_SurfaceVelocity(EVs, -48.0, -5.0)