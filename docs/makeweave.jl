using NeuralNetworkEconomics
docdir = normpath(joinpath(dirname(Base.pathof(NeuralNetworkEconomics)), "..","docs"))
using Pkg
Pkg.activate(docdir)
Pkg.instantiate()

runweave= "weave" ∈ ARGS
runnotebook= "notebook" ∈ ARGS

src=ARGS[1]

if runweave
  println("weaving markdown for $src")
  using Weave
  if !isdir("md")
    mkdir("md")
  end
  weave(src,out_path="md",
        cache=:refresh, cache_path="weavecache",
        doctype="github", mod=Main,
        args=Dict("md" => true))
end

if runnotebook  
  println("weaving notebook for $src")
  if !isdir("build")
    mkdir("build")
  end  
  using Weave
  notebook(src, out_path=joinpath(pwd(),"build"), nbconvert_options="--allow-errors")
end

if (isfile("build/temp.md"))
  rm("build/temp.md")
end

