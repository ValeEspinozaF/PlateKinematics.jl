"""
    ChangeLon(FRs::FiniteRotSph, newLon)

Change the :Lon (longitude) value of `FRs` with `newLon`.
"""
function ChangeLon(FRs::FiniteRotSph, newLon::Number)
    return FiniteRotSph(newLon, FRs.Lat, FRs.Angle, FRs.Time, FRs.Covariance)
end

"""
Change the :Lat (latitude) value of `FRs` with `newLat`.
"""
function ChangeLat(FRs::FiniteRotSph, newLat::Number)
    return FiniteRotSph(FRs.Lon, newLat, FRs.Angle, FRs.Time, FRs.Covariance)
end

"""
    ChangeAngle(FRs::FiniteRotSph, newAngle::Number)

Change the :Angle (angle) value of `FRs` with `newAngle`.
"""
function ChangeAngle(FRs::FiniteRotSph, newAngle::Number)
    return FiniteRotSph(FRs.Lon, FRs.Lat, newAngle, FRs.Time, FRs.Covariance)
end

"""
    ChangeTime(FRs::FiniteRotSph, newTime::Number)

Change the :Time (rotation age) value of `FRs` with `newTime`.
"""
function ChangeTime(FRs::FiniteRotSph, newTime::Number)
    return FiniteRotSph(FRs.Lon, FRs.Lat, FRs.Angle, newTime, FRs.Covariance)
end

"""
    ChangeCovariance(FRs::FiniteRotSph, newCovariance::Union{Covariance, Array})

Change the ::Covariance (covariance elements) of `FRs` with `newCovariance`.
"""
function ChangeCovariance(FRs::FiniteRotSph, newCovariance::Union{Covariance, Array})
    return FiniteRotSph(FRs.Lon, FRs.Lat, FRs.Angle, FRs.Time, newCovariance)
end


"""
    ToFRs(FRc::FiniteRotCart)
    ToFRs(FRcArray::Array{FiniteRotCart})
    ToFRs(EA::EulerAngles)
    ToFRs(EA::Array{EulerAngles})

Return a Finite Rotation in Spherical coordinates (`::FiniteRotSph`), expressed in degrees.
"""
function ToFRs(FRc::FiniteRotCart)
    lon_deg, lat_deg, mag = cart2sph(FRc.X, FRc.Y, FRc.Z)
    return FiniteRotSph(lon_deg, lat_deg, mag, FRc.Time, FRc.Covariance)
end

function ToFRs(FRcArray::Array{FiniteRotCart})
    return map(FRc -> ToFRs(FRc), FRcArray)
end

function ToFRs(MTX::Array{T, 3}) where {T<:Number}

    if size(MTX)[1:2] != (3,3)
        error("Input 3D array must be of size (3, 3, n).")
    end

    x = MTX[3,2,:] - MTX[2,3,:]
    y = MTX[1,3,:] - MTX[3,1,:]
    z = MTX[2,1,:] - MTX[1,2,:]

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees]
    t = MTX[1,1,:] + MTX[2,2,:] + MTX[3,3,:]
    mag = ToDegrees( atan.(mag, t .- 1) )

    return mapslices(v -> FiniteRotSph(v), [lon lat mag], dims=(2))
end

function ToFRs(EA::EulerAngles)

    MTX = Array{Float64}(undef, 3, 3, 1)

    MTX[1,1,1] = cos(EA.Z) * cos(EA.Y)
    MTX[1,2,1] = cos(EA.Z) * sin(EA.Y) * sin(EA.X) - sin(EA.Z) * cos(EA.X)
    MTX[1,3,1] = cos(EA.Z) * sin(EA.Y) * cos(EA.X) + sin(EA.Z) * sin(EA.X)
    MTX[2,1,1] = sin(EA.Z) * cos(EA.Y) 
    MTX[2,2,1] = sin(EA.Z) * sin(EA.Y) * sin(EA.X) + cos(EA.Z) * cos(EA.X)
    MTX[2,3,1] = sin(EA.Z) * sin(EA.Y) * cos(EA.X) - cos(EA.Z) * sin(EA.X)
    MTX[3,1,1] = -1 * sin(EA.Y) 
    MTX[3,2,1] = cos(EA.Y) * sin(EA.X) 
    MTX[3,3,1] = cos(EA.Y) * cos(EA.X) 

    return ToFRs(MTX)[1]
end

function ToFRs(EA::Array{EulerAngles})

    MTX = Array{Float64}(undef, 3, 3, length(EA))
    EAx = getindex.(EA, 1)
    EAy = getindex.(EA, 2)
    EAz = getindex.(EA, 3)

    MTX[1,1,:] = cos.(EAz) .* cos.(EAy)
    MTX[1,2,:] = cos.(EAz) .* sin.(EAy) .* sin.(EAx) .- sin.(EAz) .* cos.(EAx)
    MTX[1,3,:] = cos.(EAz) .* sin.(EAy) .* cos.(EAx) .+ sin.(EAz) .* sin.(EAx)
    MTX[2,1,:] = sin.(EAz) .* cos.(EAy) 
    MTX[2,2,:] = sin.(EAz) .* sin.(EAy) .* sin.(EAx) .+ cos.(EAz) .* cos.(EAx)
    MTX[2,3,:] = sin.(EAz) .* sin.(EAy) .* cos.(EAx) .- cos.(EAz) .* sin.(EAx)
    MTX[3,1,:] = -1 * sin.(EAy) 
    MTX[3,2,:] = cos.(EAy) .* sin.(EAx) 
    MTX[3,3,:] = cos.(EAy) .* cos.(EAx) 

    return ToFRs(MTX)
end



"""
    ToFRc(FRs::FiniteRotSph)
    ToFRc(FRsArray::Array{FiniteRotSph})

Return a Finite Rotation in Cartesian coordinates (`::FiniteRotCart`), expressed in degrees.
"""
function ToFRc(FRs::FiniteRotSph)
    x, y, z = sph2cart(FRs.Lon, FRs.Lat, FRs.Angle)
    return FiniteRotCart(x, y, z , FRs.Time, FRs.Covariance)
end

function ToFRc(FRsArray::Array{FiniteRotSph})
    return map(FRs -> ToFRc(FRs), FRsArray)
end



"""
    ToRotationMatrix(FRs::FiniteRotSph)
    ToRotationMatrix(FRsArray::Array{FiniteRotSph})
    ToRotationMatrix(EA::Array{EulerAngles})
    ToRotationMatrix(EAx::Array{T, 1}, EAy::Array{T, 1}, EAz::Array{T, 1}) where {T<:Number}

Return a Rotation Matrix (3x3 Array) expressed in radians.
"""
function ToRotationMatrix(FRs::FiniteRotSph)

    x, y, z = sph2cart(FRs.Lon, FRs.Lat)
    
    a = ToRadians(FRs.Angle)
    b = 1 - cos(a)
    c = sin(a)

    MTX = Array{Float64}(undef, 3, 3, 1)

    # Rotation matrix in [radians]
    MTX[1,1,1] = cos(a) + x^2 * b
    MTX[1,2,1] = x * y * b - z * c
    MTX[1,3,1] = x * z * b + y * c
    MTX[2,1,1] = y * x * b + z * c
    MTX[2,2,1] = cos(a) + y^2 * b
    MTX[2,3,1] = y * z * b - x * c
    MTX[3,1,1] = z * x * b - y * c
    MTX[3,2,1] = z * y * b + x * c
    MTX[3,3,1] = cos(a) + z^2 * b
    
    return MTX
end

function ToRotationMatrix(FRsArray::Array{FiniteRotSph})

    FRsArray = vec(FRsArray)
    x, y, z = sph2cart( getindex.(FRsArray, 1), getindex.(FRsArray, 2) )
    
    a = ToRadians(getindex.(FRsArray, 3))
    b = 1 .- cos.(a)
    c = sin.(a)

    MTX = Array{Float64}(undef, 3, 3, length(FRsArray))

    # Rotation matrix in [radians]
    MTX[1,1,:] .= cos.(a) .+ x.^2 .* b
    MTX[1,2,:] .= x .* y .* b .- z .* c
    MTX[1,3,:] .= x .* z .* b .+ y .* c
    MTX[2,1,:] .= y .* x .* b .+ z .* c
    MTX[2,2,:] .= cos.(a) .+ y.^2 .* b
    MTX[2,3,:] .= y .* z .* b .- x .* c
    MTX[3,1,:] .= z .* x .* b .- y .* c
    MTX[3,2,:] .= z .* y .* b .+ x .* c
    MTX[3,3,:] .= cos.(a) .+ z.^2 .* b
 
    return MTX
end

function ToRotationMatrix(EA::Array{EulerAngles})
    return ToRotationMatrix( getindex.(EA, 1), getindex.(EA, 2), getindex.(EA, 3))
end

function ToRotationMatrix(EAx::Array{T, 1}, EAy::Array{T, 1}, EAz::Array{T, 1}) where {T<:Number}

    MTX = Array{Float64}(undef, 3, 3, length(EAx))

    cosX = cos.(EAx)
    sinX = sin.(EAx)
    cosY = cos.(EAy)
    sinY = sin.(EAy)
    cosZ = cos.(EAz)
    sinZ = sin.(EAz)

    MTX[1,1,:] .= cosZ .* cosY
    MTX[1,2,:] .= cosZ .* sinY .* sinX - sinZ .* cosX
    MTX[1,3,:] .= cosZ .* sinY .* cosX + sinZ .* sinX
    MTX[2,1,:] .= sinZ .* cosY 
    MTX[2,2,:] .= sinZ .* sinY .* sinX + cosZ .* cosX
    MTX[2,3,:] .= sinZ .* sinY .* cosX - cosZ .* sinX
    MTX[3,1,:] .= -1 * sinY 
    MTX[3,2,:] .= cosY .* sinX 
    MTX[3,3,:] .= cosY .* cosX 
 
    return MTX
end


"""
    ToEulerAngles(FRs::FiniteRotSph)
    ToEulerAngles(FRsArray::Array{FiniteRotSph})

Return the set of Euler angles (`::EulerAngles`) from a Finite Rotation.
"""
function ToEulerAngles(FRs::FiniteRotSph)

    MTX = ToRotationMatrix(FRs)[:,:,1]

    EAx = atan(MTX[3,2], MTX[3,3])
    EAy = atan(-1 * MTX[3,1], (MTX[3,2]^2 + MTX[3,3]^2)^0.5)
    EAz = atan(MTX[2,1], MTX[1,1])

    return EulerAngles(EAx, EAy, EAz)
end

function ToEulerAngles(FRsArray::Array{FiniteRotSph})

    MTX = ToRotationMatrix(FRsArray)

    EAx = atan.( MTX[3,2,:], MTX[3,3,:] )
    EAy = atan.( -1 * MTX[3,1,:], (MTX[3,2,:].^2 .+ MTX[3,3,:].^2).^0.5 )
    EAz = atan.( MTX[2,1,:], MTX[1,1,:] )

    return mapslices(v -> EulerAngles(v), [EAx EAy EAz], dims=(2))
end