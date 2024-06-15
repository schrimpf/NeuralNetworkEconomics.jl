using Documenter,NeuralNetworkEconomics, DocumenterMarkdown

runweave=true
runnotebook=true
rerender=true
if runweave
  if !("DISPLAY" ∈ keys(ENV)) || ("INSIDE_EMACS" ∈ keys(ENV))
     # Make gr and pyplot backends for Plots work without a DISPLAY
     ENV["GKSwstype"]="nul"
     ENV["MPLBACKEND"]="Agg"
  end

  using Weave
  wd = pwd()
  try
    builddir=joinpath(dirname(Base.pathof(NeuralNetworkEconomics)),"..","docs","build")
    mkpath(builddir)
    cd(builddir)
    jmdfiles = filter(x->occursin(r".jmd$",x), readdir(joinpath("..","jmd")))
    for f in jmdfiles
      src = joinpath("..","jmd",f)
      target = joinpath("..","build",replace(f, r"jmd$"=>s"md"))
      if rerender || (stat(src).mtime > stat(target).mtime)
        weave(src,out_path=joinpath("..","build"),
              cache=:refresh,
              cache_path=joinpath("..","weavecache"),
              doctype="github",
              args=Dict("md" => true))
      end

      target = joinpath("..","build",replace(f, r"jmd$"=>s"ipynb"))
      if (runnotebook && stat(src).mtime > stat(target).mtime)
          notebook(src,out_path=joinpath("..","build"),
                   nbconvert_options="--allow-errors")
      end
    end
  finally
    cd(wd)
  end
  if (isfile("build/temp.md"))
    rm("build/temp.md")
  end

    # restore GR ability to display plots
    if "INSIDE_EMACS" ∈ keys(ENV)
        ENV["GKSwstype"]="gksqt"
    end
end

makedocs(
  modules=[NeuralNetworkEconomics],
  format=Markdown(),
  clean=false,
  pages=[
    "Home" => "index.md", # this won't get used anyway; we use mkdocs instead for interoperability with weave's markdown output.
  ],
  repo="https://github.com/schrimpf/NeuralNetworkEconomics.jl/blob/{commit}{path}#L{line}",
  sitename="NeuralNetworkEconomics.jl",
  authors="Paul Schrimpf <paul.schrimpf@gmail.com>",
)

run(`mkdocs build`)

#deploydocs(;
#    repo="github.com/schrimpf/NeuralNetworkEconomics.jl",
#)

deploy=true
if deploy || "deploy" in ARGS
  run(`mkdocs gh-deploy`)
end
