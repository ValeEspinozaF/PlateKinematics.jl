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
    #prettyurls = get(ENV, "CI", nothing) == "true",
    prettyurls = CI,
    assets = ["assets/logo.ico"],
    canonical = "https://valeespinozaf.github.io/PlateKinematics.jl/"
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

Examples = "Examples" => [
    "GITHUB_REPOSITORY" => "ValeEspinozaF/PlateKinematics.jl",
    "GITHUB_EVENT_NAME" => "push",
    "GITHUB_REF" => "stable",
    "GITHUB_TOKEN" => 
    ]


# THROWS Warning: Documenter could not auto-detect the building environment Skipping deployment.
#deploydocs(repo = "github.com/ValeEspinozaF/PlateKinematics.jl")
withenv("GITHUB_REPOSITORY" => "ValeEspinozaF/PlateKinematics.jl") do
    deploydocs(
        devbranch = "stable",
        repo   = "github.com/ValeEspinozaF/PlateKinematics.jl.git",
        #deps   = Deps.pip("mkdocs", "pygments", "python-markdown-math"),
        #make   = () -> run(`mkdocs build`),
        target = "build",
        push_preview = true,
        #forcepush = true,
        )
end