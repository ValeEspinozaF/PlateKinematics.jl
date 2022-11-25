module FiniteRotationsTransformations

using PlateKinematics: ToRadians, ToDegrees, sph2cart, cart2sph
using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix, EulerAngles


export Finrot2Rad, Finrot2Deg, Finrot2Cart, Finrot2Sph, Finrot2Matrix, Finrot2Array3D, EuAngle2Array3D


"""
Converts the magnitude of a finite rotation from [degrees]
to [radians]."""
function Finrot2Rad(FRs::FiniteRotSph)
    return FiniteRotSph(FRs.Lon, FRs.Lat, ToRadians(FRs.Angle), FRs.Covariance); end

function Finrot2Rad(FRsArray::Matrix{FiniteRotSph})
    return map(FRs -> Finrot2Rad(FRs), FRsArray); end

function Finrot2Rad(FRc::FiniteRotCart)
    return FiniteRotCart(ToRadians(FRc.X), ToRadians(FRc.Y), ToRadians(FRc.Z), FRc.Covariance); end

function Finrot2Rad(FRcArray::Matrix{FiniteRotCart})
    return map(FRc -> Finrot2Rad(FRc), FRcArray); end

"""
Converts the magnitude of a finite rotation from [radians]
to [degrees]."""
function Finrot2Deg(FRs::FiniteRotSph)
    return FiniteRotSph(FRs.Lon, FRs.Lat, ToDegrees(FRs.Angle), FRs.Covariance); end

function Finrot2Deg(FRsArray::Matrix{FiniteRotSph})
    return map(FRs -> Finrot2Deg(FRs), FRsArray); end

function Finrot2Deg(FRc::FiniteRotCart)
    return FiniteRotCart(ToDegrees(FRc.X), ToDegrees(FRc.Y), ToDegrees(FRc.Z), FRc.Covariance); end

function Finrot2Deg(FRcArray::Matrix{FiniteRotCart})
    return map(FRc -> Finrot2Deg(FRc), FRcArray); end
"""
Converts a finite rotation from spherical coordinates [degrees]
to cartesian coordinates [degrees]."""
function Finrot2Cart(FRs::FiniteRotSph)
    x, y, z = sph2cart(FRs.Lon, FRs.Lat, FRs.Angle)
    return FiniteRotCart(x, y, z, FRs.Covariance); end

function Finrot2Cart(FRsArray::Matrix{FiniteRotSph})
    return map(FRs -> Finrot2Cart(FRs), FRsArray); end


"""
Converts a finite rotation from cartesian coordinates [degrees] 
to spherical coordinates [degrees]."""
function Finrot2Sph(FRc::FiniteRotCart)
    lon, lat, angle = cart2sph(FRc.X, FRc.Y, FRc.Z)
    return FiniteRotSph(lon, lat, angle, FRc.Covariance); end

function Finrot2Sph(FRcArray::Matrix{FiniteRotCart})
    return map(FRc -> Finrot2Sph(FRc), FRcArray); end
""" 
Converts a finite rotation in spherical coordinates [degrees]
to the associated rotation matrix [radians]."""
function Finrot2Matrix(FRs::FiniteRotSph)

    x, y, z = sph2cart(FRs.Lon, FRs.Lat, 1)
    a = ToRadians(FRs.Angle);

    b = 1-cos(a)

    # Rotation matrix in [radians]
    FRm = FiniteRotMatrix([ cos(a)+x^2*b x*y*b-z*sin(a) x*z*b+y*sin(a);
                            y*x*b+z*sin(a) cos(a)+y^2*b y*z*b-x*sin(a);
                            z*x*b-y*sin(a) z*y*b+x*sin(a) cos(a)+z^2*b])

    return FRm; end


function Finrot2Matrix(FRsArray::Matrix{FiniteRotSph})

    x, y, z = sph2cart([FRs.Lon for FRs in FRsArray], [FRs.Lat for FRs in FRsArray], 1)
    
    a = ToRadians([FRs.Angle for FRs in FRsArray]);
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
 
    return mapslices(mtx -> FiniteRotMatrix(mtx), MTX, dims=(1,2)); end

"""
Converts a finite rotation in Cartesian coordinates [degrees] 
to the associated rotation matrix [radians]."""
function Finrot2Matrix(FRc::FiniteRotCart)

    # Magnitud in [radians]
    a = ToRadians((FRc.X^2 + FRc.Y^2 + FRc.Z^2)^0.5)

    # Unit vector in Cartesian coordinates [radians]
    x = FRc.X / ToDegrees(a)
    y = FRc.Y / ToDegrees(a)
    z = FRc.Z / ToDegrees(a)
    
    b = 1-cos(a)

    # Rotation matrix in [radians]
    FRm = FiniteRotMatrix([ cos(a)+x^2*b x*y*b-z*sin(a) x*z*b+y*sin(a);
                            y*x*b+z*sin(a) cos(a)+y^2*b y*z*b-x*sin(a);
                            z*x*b-y*sin(a) z*y*b+x*sin(a) cos(a)+z^2*b])

    return FRm; end

"""
Converts a rotation matrix [radians], to the associated finite 
rotation in spherical coordinates, with pole and magnitude in [degrees]."""
function Finrot2Sph(FRm::FiniteRotMatrix)

    M = FRm.Values

    # Partial cartesian coordinates in [radians]
    x = M[3,2] - M[2,3]
    y = M[1,3] - M[3,1]
    z = M[2,1] - M[1,2]

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees]
    t = M[1,1] + M[2,2] + M[3,3]
    mag = ToDegrees( atan(mag, t-1) )
    
    return FiniteRotSph(lon, lat, mag); end


function Finrot2Sph(MTX::Array{Float64, 3})

    if size(MTX)[1:2] != (3,3)
        throw("Error. Input 3D array must be of size (3, 3, n).")
    end

    x = MTX[3,2,:] - MTX[2,3,:]
    y = MTX[1,3,:] - MTX[3,1,:]
    z = MTX[2,1,:] - MTX[1,2,:]

    # Turn to spherical coordinates, pole in [deg]
    lon, lat, mag = cart2sph(x, y, z)

    # Magnitude in [degrees]
    t = MTX[1,1,:] + MTX[2,2,:] + MTX[3,3,:]
    mag = ToDegrees( atan.(mag, t .- 1) )

    return mapslices(v -> FiniteRotSph(v), [lon lat mag], dims=(2)); end

"""
Converts a rotation matrix [radians], to the associated finite 
rotation in cartesian coordinates, with magnitude in [degrees]."""
function Finrot2Cart(FRm::FiniteRotMatrix)
    return Finrot2Cart(Finrot2Sph(FRm)); end

function Finrot2Cart(FRmArray::Matrix{FiniteRotMatrix})
    return map(FRm -> Finrot2Cart(FRm), FRmArray); end

"""
Converts a finite rotation in spherical coordinates [degrees] 
into the corresponding set of Euler angles along x, y and z axis."""
function Finrot2EuAngle(FRs::FiniteRotSph)

    MTX = Finrot2Matrix(FRs).Values

    EAx = atan(MTX[3,2], MTX[3,3])
    EAy = atan(-1 * MTX[3,1], (MTX[3,2]^2 + MTX[3,3]^2)^0.5)
    EAz = atan(MTX[2,1], MTX[1,1])

    return EulerAngles(EAx, EAy, EAz); end


"""
Converts a set of Euler angles into the corresponding finite 
rotation in spherical coordinates [degrees]."""
function EuAngle2Sph(EA::EulerAngles)

    MTX = Array{Float64}(undef, 3, 3)

    MTX[1,1] = cos(EA.Z) * cos(EA.Y)
    MTX[1,2] = cos(EA.Z) * sin(EA.Y) * sin(EA.X) - sin(EA.Z) * cos(EA.X)
    MTX[1,3] = cos(EA.Z) * sin(EA.Y) * cos(EA.X) + sin(EA.Z) * sin(EA.X)
    MTX[2,1] = sin(EA.Z) * cos(EA.Y) 
    MTX[2,2] = sin(EA.Z) * sin(EA.Y) * sin(EA.X) + cos(EA.Z) * cos(EA.X)
    MTX[2,3] = sin(EA.Z) * sin(EA.Y) * cos(EA.X) - cos(EA.Z) * sin(EA.X)
    MTX[3,1] = -1 * sin(EA.Y) 
    MTX[3,2] = cos(EA.Y) * sin(EA.X) 
    MTX[3,3] = cos(EA.Y) * cos(EA.X) 

    return Finrot2Sph(FiniteRotMatrix(MTX)); end

function EuAngle2Array3D(EAx::Union{Matrix, Vector}, EAy::Union{Matrix, Vector}, EAz::Union{Matrix, Vector})

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
 
    return MTX; end
"""
Converts a finite rotation [degrees] into a 3D array
of rotation matrices."""
function Finrot2Array3D(FRmArray::Matrix{FiniteRotMatrix})
    MTXarray = [FRm.Values for FRm in FRmArray]
    return reshape(reduce(hcat, MTXarray), 3, 3, :); end

function Finrot2Array3D(FRsArray::Matrix{FiniteRotSph})

    x, y, z = sph2cart([FRs.Lon for FRs in FRsArray], [FRs.Lat for FRs in FRsArray], 1)
    
    a = ToRadians([FRs.Angle for FRs in FRsArray]);
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
 
    return MTX; end
end