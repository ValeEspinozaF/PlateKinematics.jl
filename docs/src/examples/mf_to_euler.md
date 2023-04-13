```@meta
CurrentModule = PlateKinematics
```

# From Finite Rotation to Euler Vector

Here we will go through the process of transforming a [Finite Rotation](@ref), which provides the rotation angle of a [Total Rotation](@ref), to an [Euler Vector](@ref), which provide the rotation rate of a [Stage Rotation](@ref).

This process generally involves obtaining an stage Finite Rotation, and then transforming it to an Euler Vector. By general rule, we may obtain a stage Finite Rotation as:

```@raw html
<center> <sup>t2</sup>FR<sup>t1</sup> = − <sup>0</sup>FR<sup>t2</sup> + <sup>0</sup>FR<sup>t1</sup> </center> 
<br/>
```  

This equation involves two total poles, each one a [Reconstruction Rotation](@ref). Whether t1 is larger than t2 or viceversa will determine the direction of the rotation. For instance, if t1 > t2, the resulting Finite Rotation will represent a [Forward Rotation](@ref), the motion from a point further back in time, to a more recent one. Else the rotation will represent a [Reconstruction Rotation](@ref).

The final step is to transform the Finite Rotation to an Euler Vector. This is done by dividing the rotation angle (&#937;) by the time spanned between the two total reconstructions (Δt), and hence obtaining the rotation rate (ω):

```@raw html
<center> <sup>t2</sup>FR<sup>t1</sup>[&#937;] &#160 → &#160 <sup>t2</sup>EV<sup>t1</sup>[$\frac{&#937;}{&#8710;t}$] &#160 → &#160 <sup>t2</sup>EV<sup>t1</sup>[ω] </center>
<br/><br/>
```  


## From two Finite Rotations (Stage Euler Vector)

we start providing an example for the most general case, an Euler Vector obtained from two Finite Rotations. In this particular case, we will seek to obtain the Euler Vector describing the motion of Eurasia relative to North-America between the ages 83 to 53 Ma. The values are taken from Allan Cox' book [Plate Tectonics: How it works](https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212/), Table 7-1:

| t(Ma) | Longitude(°E) | Latitude(°N) | Angle(°) |
|-------|:-------------:|:------------:|:--------:|
| 37.0  | 129.9         | 68.0         | -7.8     |
| 48.0  | 142.8         | 50.8         | -9.8     |
| 53.0  | 145.0         | 40.0         | -11.4    |
| 83.0  | 150.1         | 70.5         | -20.3    |
| 90.0  | 152.9         | 75.5         | -24.2    |


```julia
using PlateKinematics
using PlateKinematics: FiniteRotSph, EulerVectorSph, Covariance
using PlateKinematics: ToEulerVector

FRs_53 = FiniteRotSph(145.0, 40.0, -11.4, 53.0);
FRs_83 = FiniteRotSph(150.1, 70.5, -20.3, 83.0);
ToEulerVector(FRs_83, FRs_53)
```

```REPL
EulerVectorSph:
        Lon         : -75.94
        Lat         : 78.09
        AngVelocity : 0.4
        TimeRange   : [83.0 53.0]
        Covariance  : Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```

Bear in mind that the Euler Vector here inherits the [Time Orientation](@ref) from the given order of Finite Rotations. In the above example, the Euler Vector reports the rotation from 83 Ma to 53 Ma, a [Forward Rotation](@ref). If we were to reverse the order of the Finite Rotations, the Euler Vector would be defined as the rotation rate of the stage rotation from 37 Ma to 42 Ma, a [Reconstruction Rotation](@ref). One could otherwise use the `reverseRot` keyword to reverse the time orientation of the Euler Vector:

```julia
ToEulerVector(FRs_83, FRs_53, reverseRot=true)
```

```REPL
EulerVectorSph:
        Lon         : -22.68
        Lat         : 80.44
        AngVelocity : 0.4
        TimeRange   : [53.0 83.0]
        Covariance  : Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```

This derives from the *negative rotation* property of Finite Rotations, where in general, the time-orientation may be inverted using the antipole or the inverse of the rotation angle:

```@raw html
<center> <sup>t2</sup><sub>A</sub>FR<sub>B</sub><sup>t1</sup> = − <sup>t1</sup><sub>A</sub>FR<sub>B</sub><sup>t2</sup> </center>
<br/><br/>
``` 

Know however that this is **not** generally true for inversion of the fixed plate:

```@raw html
<center> <sup>t2</sup><sub>A</sub>FR<sub>B</sub><sup>t1</sup> ≠ − <sup>t2</sup><sub>B</sub>FR<sub>A</sub><sup>t1</sup> </center>
<br/><br/>
``` 

but rather is only true for rotations to and from the present, that is, a [Total Rotation](@ref):

```@raw html
<center> <sup>0</sup><sub>A</sub>FR<sub>B</sub><sup>t</sup> = − <sup>0</sup><sub>B</sub>FR<sub>A</sub><sup>t</sup> </center>
<br/><br/> 
``` 

A more thorough explanation of this can be found in the book [Plate Tectonics: How it works](https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212/).





## From one Finite Rotation (total Euler Vector)

The same can be done for a single Finite Rotation, based on the general equation for stage rotations stated above: 

```@raw html
<center> <sup>t2</sup>FR<sup>t1</sup> = − <sup>0</sup>FR<sup>t2</sup> + <sup>0</sup>FR<sup>t1</sup>, </center>
<br/>

then t1 = 0, t2 = t, and <br/>

<center> <sup>t</sup>FR<sup>0</sup> =  − <sup>0</sup>FR<sup>t</sup> + <sup>0</sup>FR<sup>0</sup> </center>
<br/>
<center> <sup>t</sup>FR<sup>0</sup> =  − <sup>0</sup>FR<sup>t</sup> </center>
<br/><br/>
```  

For instance, we can obtain the Euler Vector describing the motion of North-America relative to Eurasia between the age 37 Ma and present day. 

```julia
using PlateKinematics: FiniteRotSph, EulerVectorSph, Covariance
using PlateKinematics: ToEulerVector

FRs_37 = FiniteRotSph(129.9, 68.0, 7.8, 37.0);
ToEulerVector(FRs_37)
```

```REPL
EulerVectorSph:
        Lon         : -50.1
        Lat         : -68.0
        AngVelocity : 0.21 
        TimeRange   : [37.0 0.0]
        Covariance  : Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```