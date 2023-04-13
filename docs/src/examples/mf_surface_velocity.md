```@meta
CurrentModule = PlateKinematics
```

# Calculate Surface Velocity

For given times, it may come handy finding the local velocity of a point in the Earth surface. For that, the general expression is:

```@raw HTML
<center> <em>V = ω × (R P) </em> </center>
$V = \omega \times (R P)$
```

where *V* is the velocity vector, *ω* is the Euler vector of rotation, *R* is the radius of the Earth, *P* is the position vector of the point in the Earth's surface.

Instead of a vector, [`Calculate_SurfaceVelocity`](@ref) report the velocity vector *V* in terms of i) northward and eastward components, ii) norm (total velocity), and iii) azimuth of the velocity vector as measured clockwise from the North. The function takes the Euler vector of rotation, and the geographical position of interest in the Earth's surface as inputs. For convenience, this point is not given as a vector (*P*), but rather as longitude and latitude coordinates. [`Calculate_SurfaceVelocity`](@ref) then uses the WGS-84 ellipsoid to calculate the cartesian coordinates of the position vector *P*. 

Take the following example values for the motion of the Anatolia plate relative to Eurasia, values taken from [Martin de Blas et al., 2022](https://doi.org/10.1093/gji/ggac020). For the geographical position of interest, we will use coordinates close to the boundary between both plate, a structure also known as the North Anatolia Fault.

```julia
using PlateKinematics
using PlateKinematics: EulerVectorSph, SurfaceVelocityVector
using PlateKinematics: Calculate_SurfaceVelocity

lon_NAF, lat_NAF = 33.5, 41.0;
EVs_AT_EU = EulerVectorSph(33.44, 33.19 , 1.7);
Calculate_SurfaceVelocity(EVs_AT_EU, lon_NAF, lat_NAF)
```

```REPL
SurfaceVelocityVector:
        Lon      : 33.5
        Lat      : 41.0
        EastVel  : -2.51
        NorthVel : 0.02
        TotalVel : 2.51
        Azimuth  : -89.62
```

As expected, we obtain a strong eastward component, compatible with the known right-lateral strike-slip behavior of the North Anatolia Fault.