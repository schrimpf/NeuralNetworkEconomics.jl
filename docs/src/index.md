# NeuralNetworkEconomics.jl

This package focuses on the use of neural networks (and other machine
learning methods) in economics. 

The notes on machine learning in economics ([1](ml-intro.md),
[2](ml-methods.md), [3](ml-doubledebiased.md), [4](mlExamplePKH.md))
were originally written for [ECON
628](https://github.com/ubcecon/ECON628_2018). They remain a good
overview and valuable list of references, but the code is all in R. If
you want to use some existing methods based on the research of
Chernozhukov and coauthors or Athey and coauthors, then it makes a lot
of sense to use the R packages they developed (`hdm` and `grf`
respectively). However, if you want to write code to do something new,
it likely makes more sense to use Julia. 

A brief review of Julia packages for machine learning (with examples
focused on lasso) is in [ml-julia](ml-julia.md).

The notes on neural networks ([1](slp.md), [2], ... ) feature
examples in Julia using `Flux.jl`. 

<!-- ```@index -->
<!-- ``` -->

<!-- ```@autodocs -->
<!-- Modules = [NeuralNetworkEconomics] -->
<!-- ``` -->
