library(knitr)

slides=FALSE
args=commandArgs(trailingOnly=TRUE)
#args = c("rmd/ml-doubledebiased.Rmd", "temp.md")
opts_knit$set(output.dir=paste(getwd(),"md",sep="/"))
opts_knit$set(root.dir=paste(getwd(),"rmd",sep="/"))
opts_knit$set(base.dir=paste(getwd(),"md",sep="/"))
#opts_chunk$set(fig.path=paste(getwd(),"build/",sep="/"))
opts_knit$set(verbose=TRUE)
cat(args[1])
cat(args[2])

knit(args[1], output=args[2])
