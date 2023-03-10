using Documenter
using PlateKinematics

About = "Introduction" => "index.md"

Types = "Types" => "types.md"

Functions = "Functions" => "functions.md"


#= Examples = "Examples" => [
        "examples/flux.md"
    ]

License = "License" => "license.md" =#

format = Documenter.HTML(
    collapselevel = 2,
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets = ["assets/logo.ico"],
    )

PAGES = [
    About,
    Types,
    Functions,
    #Examples,
    #License
    ]

makedocs(
    #modules = [PlateKinematics],
    sitename = "PlateKinematics.jl",
    authors = "Valentina Espinoza",
    format = format,
    #clean = true,
    #checkdocs = :exports,
    pages = PAGES
)

# THROWS Warning: Documenter could not auto-detect the building environment Skipping deployment.
#deploydocs(repo = "github.com/ValeEspinozaF/PlateKinematics.jl")