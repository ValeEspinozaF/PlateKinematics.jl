using Documenter, DocumenterTools
using PlateKinematics

About = "Introduction" => "index.md"

Types = "Types" => "lib/types.md"

Functions = "Functions" => [
    "Main Functions" => "lib/main_functions.md",
    "Other Functions" => "lib/other_functions.md",
    "Auxiliary Functions" => "lib/auxiliary_functions.md",
    "Private Functions" => "lib/private_functions.md",
    ]

Examples = "Examples" => [
    "Concatenate Finite Rotations" => "examples/mf_concatenate.md",
    "Convert to Euler Vector" => "examples/mf_to_euler.md",
    ]

#License = "License" => "license.md"

format = Documenter.HTML(
    collapselevel = 3,
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets = ["assets/logo.ico"],
    )

PAGES = [
    About,
    Types,
    Functions,
    Examples,
    #License
    ]

makedocs(
    modules = [PlateKinematics],
    sitename = "PlateKinematics.jl",
    authors = "Valentina Espinoza",
    format = format,
    #clean = true,
    #checkdocs = :exports,
    pages = PAGES
)

# THROWS Warning: Documenter could not auto-detect the building environment Skipping deployment.
#deploydocs(repo = "github.com/ValeEspinozaF/PlateKinematics.jl")

#= deploydocs(
    devbranch = "master",
    repo   = "https://github.com/ValeEspinozaF/PlateKinematics.jl",
    deps   = Deps.pip("mkdocs", "pygments", "python-markdown-math"),
    make   = () -> run(`mkdocs build`),
    target = "site"
    ) =#