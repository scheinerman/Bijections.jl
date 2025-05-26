# execute this file in the docs directory with this
# julia --color=yes --project make.jl

using Documenter, Bijections
makedocs(;
    pages=[
        "Getting Started" => "index.md",
        "Using Bijections" => "usage.md",
        "Operations" => "operations.md",
        "Mutable Objects" => "mutable.md",
    ],
    sitename="Bijections",
)
