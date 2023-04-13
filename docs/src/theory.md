# Theory

```@contents
Pages = ["theory.md"]
Depth = 3
```

# General background

Plate tectonics is the scientific theory that describes the motion and interaction between the portions of the outermost layer of the Earth, the lithosphere. This rigid layer is divided into a number of plates, which move relative to each other forming the landscape we see today. The theory is supported by a wide range of evidence, including geological observations, paleomagnetism, and numerical modeling. How these plates move can shed light into the shallow and internal geological processes that shaped our planet over time.

# Important terminology

## Reference frame

### Relative motion

Relative motion refers to the movement of one plate in relation to another. For present day measurement, scientist can resort to GPS (Global Positioning System) geodesy or other satellite observations.  

As for motion of plates in the past, scientists can resort to paleomagnetic data to determine the relative motion of plates. As plates diverge in spreading center, new rock is formed. These rocks host magnetic minerals and so record the polarity inversions of our Earth magnetic field. The geographic distance between two polarity inversions on opposite plates at a given point in time can yield the relative motion of the plates.  

### Absolute motion

Absolute motion describes the movement of a plate relative to a fixed point in space, such as the Earth's center. The most common way to measure absolute motion is by using hotspot tracks, i.e, the volcanic lineations left by pseudo-stationary sources of magma located beneath the Earth's crust. These sources are called mantle plumes, and commonly originate in the deep mantle, a proxy for the Earth's center. As the plates move over the plumes, a trail of volcanic rocks is formed, effectively recording the plate's motion in the past.


## Motion representations

### Euler Pole

Pivot point for a rotation in Euclidean geometry. In Spherical geometry, it is point on the surface of the Earth where the axis of rotation of a plate intersects the surface. This axis passes through the center of the Earth and naturally intercepts the surface at two opposite points. It is generally agreed among geoscientists to apply the *right-hand rule*, where a positive rotation has the thumb pointing towards the Euler Pole, and the fingers curl along the path of the body in motion. The pole on the opposite side is called *Anti-pole*.

### Finite Rotation

Rotation by a given angle about a fixed [Euler Pole](@ref). A Finite Rotation can be described with only three parameters: two describing the geographical location of the Euler Pole, and a third one reporting the rotation angle. 

It may also be represent as:

- Cartesian coordinates of the Euler Pole, and the rotation angle as norm. Keep in mind however, that Finite Rotations are not vectors, and have their own set of mathematical properties. 
- A rotation matrix, which is a 3x3 matrix that can be used to rotate a vector in 3D space.  
- A set of three Euler Angles, which are three angles on each mayor axis requires to compose the original rotation.   

### Euler Vector

Three dimensional rotation vector to describe the relative motion between any two plates. Can be described with three parameters: two describing the location of the [Euler Pole](@ref), and a third one reporting the rotation rate, assumed to be constant during the time spanned. Euler Vector may also be represented as Cartesian coordinates.    

## Time Range

### Total Rotation

Rotations to and from the present are called **total rotations**. Finite Rotations anchored to the present day means all reference frames are equal, allowing for special algebraic properties, e.g., fixed-plate inversion.

### Stage Rotation

Report the motion history of a pair of plates over a given time interval. Expressing the motion of a plate in terms of a series stage rotations implies that the Euler Pole has remained fixed during the stage and jumped between successive stages. Unlike total rotations, stage rotations are more delicate to manipulate, and can easily lead to errors when the rules of finite rotations are not respected. An in-depth overview of these rules can be found in the book [Plate Tectonics: How it works](https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212/) by Allan Cox.



## Time Orientation

### Forward Rotation   

Rotations going forward in time are called forward rotations. This is the way Euler Vectors are usually represented, as they report a motion rate, which can more easily visualized a plate velocity.

### Reconstruction Rotation

Is the rotation starting at a more recent point in time and going backwards, reconstructing the previous positions of the plates. 