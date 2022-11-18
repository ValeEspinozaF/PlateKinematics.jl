module FiniteRotationsTransformations

using PlateKinematics: ToRadians, ToDegrees, sph2cart, cart2sph
using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix


export Finrot2Rad, Finrot2Deg, Finrot2Cart, Finrot2Sph, Finrot2Matrix


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
    return map(FRs -> Finrot2Matrix(FRs), FRsArray); end

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

function Finrot2Matrix(FRcArray::Matrix{FiniteRotCart})
    return map(FRc -> Finrot2Matrix(FRc), FRcArray); end
    
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

    # Magnitude in [radians]
    t = M[1,1] + M[2,2] + M[3,3]
    mag = ToDegrees( atan(mag, t-1) )
    
    return FiniteRotSph(lon, lat, mag); end


function Finrot2Sph(FRmArray::Matrix{FiniteRotMatrix})
    return map(FRm -> Finrot2Sph(FRm), FRmArray); end

"""
Converts a rotation matrix [radians], to the associated finite 
rotation in cartesian coordinates, with magnitude in [degrees]."""
function Finrot2Cart(FRm::FiniteRotMatrix)
    return Finrot2Cart(Finrot2Sph(FRm)); end

function Finrot2Cart(FRmArray::Matrix{FiniteRotMatrix})
    return map(FRm -> Finrot2Cart(FRm), FRmArray); end

end