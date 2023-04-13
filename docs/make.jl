#import Pkg; Pkg.add("Documenter")
using Documenter, DocumenterTools
using PlateKinematics

About = "Introduction" => "index.md"

Theory = "Theory" => "theory.md"

Types = "Types" => "lib/types.md"

Functions = "Functions" => [
    "Main Functions" => "lib/main_functions.md",
    "Other Functions" => "lib/other_functions.md",
    "Auxiliary Functions" => "lib/auxiliary_functions.md",
    "Private Functions" => "lib/private_functions.md",
    ]

Examples = "Examples" => [
    "Interpolate Finite Rotations" => "examples/mf_interpolate.md",
    "Concatenate Finite Rotations" => "examples/mf_concatenate.md",
    "Convert to Euler Vector" => "examples/mf_to_euler.md",
    "Calculate Surface Velocity" => "examples/mf_surface_velocity.md",
    ]

#License = "License" => "license.md"

format = Documenter.HTML(
    edit_link = "main",
    collapselevel = 3,
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets = ["assets/logo.ico", "assets/table.css"],
    canonical = "https://valeespinozaf.github.io/PlateKinematics.jl/",
    sidebar_sitename = false,
    )

PAGES = [
    About,
    Theory,
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


withenv("GITHUB_REPOSITORY" => "ValeEspinozaF/PlateKinematics.jl") do
    deploydocs(
        #devbranch = "main",
        branch = "gh-pages",
        repo   = "github.com/ValeEspinozaF/PlateKinematics.jl.git",
        #deps   = Deps.pip("mkdocs", "pygments", "python-markdown-math"),
        #make   = () -> run(`mkdocs build`),
        target = "build",
        push_preview = true,
        forcepush = true,
        )
end