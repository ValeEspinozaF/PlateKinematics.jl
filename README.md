# PlateKinematics.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://valeespinozaf.github.io/PlateKinematics.jl/dev/)
[![Build Status](https://github.com/ValeEspinozaF/PlateKinematics.jl/workflows/CI/badge.svg)](https://github.com/ValeEspinozaF/PlateKinematics.jl/actions)

<!-- description -->
<p>
  <strong> Tools for easy handling of Plate Kinematics functions with Julia 🌏 📐. </strong>
</p>

This package provides types, functions and documentation for working with Finite Rotations, Euler Vectors 
and Surface Velocities. The knowledge builds from the framework layed down by Allan Cox in his book 
<a href="https://www.wiley.com/en-us/Plate+Tectonics%3A+How+It+Works-p-9781444314212">Plate Tectonics: How It Works</a>.


<!-- installation -->
## Installation

To install, use Julia's built-in package manager (accessed by pressing `]` in the Julia REPL command prompt) 
to add the package and also to instantiate/build all the required dependencies.

```@julia
julia> using Pkg
julia> Pkg.add("PlateKinematics")
```


# Getting started

```@julia
julia> using PlateKinematics
julia> ?PlateKinematics
```
Make sure you are running the latest version of PlateKinematics.jl by updating the package:

```@julia
julia> using Pkg
julia> Pkg.update("PlateKinematics")
```

To assign as alias to the module, you may use the following:

```@julia
const pk = PlateKinematics
``` 

## Examples

Some usage examples may be found under `examples/`. These examples are further explained in the package's [documentation]. 


<!-- reach out
## Getting help

Interested in PlateKinematics.jl? Encountered an issue? or simply trying to figure out how to use it? 
Please feel free to ask questions and get in touch! 
Check out the 
[examples](https://github.com/ValeEspinozaF/PlateKinematics.jl/tree/main/examples) and 
[open an issue](https://github.com/ValeEspinozaF/PlateKinematics.jl/issues/new) or 
[start a discussion](https://github.com/ValeEspinozaF/PlateKinematics.jl/discussions/new) 
if you have any questions, comments, suggestions, etc. 
-->



## Citing

If you use PlateKinematics.jl in research, teaching, or other activities, I would be grateful if you could mention PlateKinematics.jl and cite via Zenodo:

Valentina Espinoza. (2024). ValeEspinozaF/PlateKinematics.jl: v0.2.0 (v0.2.0). Zenodo. https://doi.org/10.5281/zenodo.12773819



[PlateKinematics.jl]: https://github.com/ValeEspinozaF/PlateKinematics.jl
[documentation]: https://valeespinozaf.github.io/PlateKinematics.jl/dev/