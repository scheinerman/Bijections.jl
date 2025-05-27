using Bijections
using Documenter
using DocumenterInterLinks
using Pkg: Pkg

PROJECT_TOML = Pkg.TOML.parsefile(joinpath(@__DIR__, "..", "Project.toml"))
VERSION = PROJECT_TOML["version"]
NAME = PROJECT_TOML["name"]
AUTHORS = join(PROJECT_TOML["authors"], ", ") * " and contributors"
GITHUB = "https://github.com/scheinerman/Bijections.jl"

links = InterLinks("Julia" => "https://docs.julialang.org/en/v1/")

PAGES = [
    "Getting Started" => "index.md",
    "Using Bijections" => "usage.md",
    "Operations" => "operations.md",
    "Mutable Objects" => "mutable.md",
    "API" => "api.md",
]

println("Starting makedocs")

makedocs(;
    authors=AUTHORS,
    sitename="$NAME.jl",
    pages=PAGES,
    format=Documenter.HTML(;
        prettyurls=true,
        canonical="https://scheinerman.github.io/Bijections.jl",
        edit_link="master",
        footer="[$NAME.jl]($GITHUB) v$VERSION docs powered by [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl).",
        assets=String[],
    ),
    plugins=[links],
)

println("Finished makedocs")

deploydocs(;
    repo="github.com/scheinerman/Bijections.jl", devbranch="master", push_preview=true
)
