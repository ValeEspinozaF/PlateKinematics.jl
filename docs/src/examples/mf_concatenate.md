```@meta
CurrentModule = PlateKinematics
```

# Concatenate Finite Rotations

At time it may be useful to obtain the relative motion between two plates that do not share a divergent margin, or no boundary at all for that matter. The lack of common fracture zones and isochrons produces by a shared spreading center prevents the direct observation of the relative tectonic history between both plates. 

This obstacle can be circumvented by using a plate circuit that links both plates, say India and Eurasia, by a series of well-defined relative plate motion reconstructions. To connect the India plate to the Eurasian one, one may use the total reconstruction poles of Eurasia/North-America, North-America/Nubia, Africa/Antarctica, Antarctica/Australia and Australia/India.

This examples is taken from the book [Plate Tectonics: How it works](https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212/) from Allan Cox, and provides on how to calculate the relative motion between plates that do not share a divergent boundary. All the other plate-pairs mentioned do share a common spreading center, which allows researcher to estimate opening rates of the ocean floor from the magnetic lineations parallel to the ridge.

```@raw html
<img src="../assets/plate_circuit.png" alt="Plate circuit example" width="230" height="180">
```
![alt text](assets/plate_circuit.png)

Plate circuit example. Modified from [Plate Tectonics: How it works](https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212/).


In terms of Finite Rotations (FR), one would pose the circuit as:

```@raw html
FR<sub>IN/EU</sub> = FR<sub>IN/AU</sub> + FR<sub>AU/AN</sub> + FR<sub>AN/NB</sub> + FR<sub>NB/NA</sub> + FR<sub>NA/EU</sub> <br/><br/>
```  
  
In the posed equation, the fixed coordinate system was chosen to be Eurasia. This is also indicated with the subscripts on each individual relative motion, indicating both the moving and the fixed plate. For instance: 
```@raw html 
FR<sub>IN/EU</sub> <br/>
``` is the finite rotation describing the motion of India relative to a fixed Eurasia plate.

The equation is solved by performing each summation one by one, from left to right, adding relative motions from the moving plate towards the fixed reference frame. Following the books example, we want to find the position of India relative to Eurasia at 40 Ma. Total reconstruction poles available may not include the 40 Ma rotation:

```@raw html
<table>
    <thead>
        <tr>
            <th></th>
            <th>t(Ma)</th>
            <th>Longitude(°E)</th>
            <th>Latitude(°N)</th>
            <th>Angle(°)</th>
        </tr>
    </thead>
    <tbody>
        <tr style="border-bottom: 1px solid black;">
        <tr>
            <td>AU/IN</td>
            <td>50.0</td>
            <td>-</td>
            <td>-</td>
            <td>0.0</td>
        </tr>
        <tr>
            <td rowspan=2>AN/AU</td>
            <td>37.0</td>
            <td>34.4</td>
            <td>11.9</td>
            <td>-20.5</td>
        </tr>
        <tr>
            <td>42.0</td>
            <td>34.8</td>
            <td>10.3</td>
            <td>-23.6</td>
        </tr>
        <tr>
            <td>NB/AN</td>
            <td>40.0</td>
            <td>322.8</td>
            <td>5.8</td>
            <td>7.2</td>
        </tr>
        <tr>
            <td rowspan=2>NB/NA</td>
            <td>37.0</td>
            <td>341.3</td>
            <td>70.5</td>
            <td>10.4</td>
        </tr>
        <tr>
            <td>66.0</td>
            <td>351.4</td>
            <td>80.8</td>
            <td>22.5</td>
        </tr>
        <tr>
            <td rowspan=2>NA/EU</td>
            <td>37.0</td>
            <td>129.9</td>
            <td>68.0</td>
            <td>-7.8</td>
        </tr>
        <tr>
            <td>48.0</td>
            <td>142.8</td>
            <td>50.8</td>
            <td>-9.8</td>
        </tr>
        <tr style="border-bottom: 1px solid black;">
    </tbody>
</table>
<br/>
```

And indeed, some poles will require interpolation (e.g., AU/AN, NB/NA, NA/EU):

```julia
using PlateKinematics
using PlateKinematics: FiniteRotSph, Interpolate_FiniteRotation

FRs_AU_AN_37 = FiniteRotSph(34.4, 11.9, -20.5, 37.0);
FRs_AU_AN_42 = FiniteRotSph(34.8, 10.3, -23.6, 42.0);
FRs_AU_AN_40 = Interpolate_FiniteRotation(FRs_AU_AN_37, FRs_AU_AN_42, 40.0)
```

```REPL
FiniteRotSph:
        Lon        : -145.35
        Lat        : -10.89
        Angle      : 22.36
        Time       : 40.0
        Covariance : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```

Once we have obtained all total reconstruction poles for 40 Ma, we concatenate into a plate circuit. Note that, according to literature, no motion was registered between Australia and India prior to 50 Ma. This rotation is therefore ignored, as no relative motion is contributed to the end rotation.  

```julia
using PlateKinematics: Concatenate_FiniteRotations

FRs_IN_AU_40 = nothing;
FRs_AU_AN_40 = FiniteRotSph(-145.35, -10.89, 22.36, 40.0);
FRs_AN_AF_40 = FiniteRotSph(322.8, 5.8, 7.2, 40.0);
FRs_AF_NA_40 = FiniteRotSph(162.38, -72.57, 11.62, 40.0);
FRs_NA_EU_40 = FiniteRotSph(135.62, 62.65, 8.25, 40.0);

FRsList = [
    FRs_AU_AN_40,
    FRs_AN_AF_40,
    FRs_AF_NA_40,
    FRs_NA_EU_40,
];

FRs_EU_IN_40 = Concatenate_FiniteRotations(FRsList)
```
```REPL
FiniteRotSph:
        Lon        : -145.1
        Lat        : -17.21
        Angle      : 24.35
        Time       : nothing
        Covariance : PlateKinematics.Covariance(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
```