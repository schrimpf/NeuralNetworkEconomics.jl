using Documenter, NeuralNetworkEconomics

makedocs(;
    modules=[NeuralNetworkEconomics],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/schrimpf/NeuralNetworkEconomics.jl/blob/{commit}{path}#L{line}",
    sitename="NeuralNetworkEconomics.jl",
    authors="Paul Schrimpf <paul.schrimpf@gmail.com>",
    assets=String[],
)
