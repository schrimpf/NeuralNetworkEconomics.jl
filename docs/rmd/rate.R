d <- 2
beta <- rep(1,d)
f <- function(x) x%*%beta
x.p <- matrix(seq(0,1,length.out=50), ncol=1)
library(grf)
simulate <- function(n) {
  x <- matrix(runif(n*d), ncol=d)
  y <- f(x) + rnorm(n)
  rf <- regression_forest(x,y, tune.parameters=TRUE)
  f.p <- predict(rf, cbind(x.p, 0.5), estimate.variance=TRUE)
}
n <- seq(500,10000,500)
out <- sapply(n,simulate)
y.p <- matrix(unlist(out[1,]),ncol=length(n))
var <- matrix(unlist(out[2,]),ncol=length(n))

library(ggplot2)
df <- data.frame(x=x.p, f=f(cbind(x.p,0.5)), size="true", n=0)
for (i in 1:length(n)) {
  df.new <- data.frame(x=x.p)
  df.new$size <- as.character(n[i])
  df.new$n <- n[i]
  df.new$f <- y.p[,i]
  df <- rbind(df, df.new)
}
fig  <- ggplot(data=df, aes(x=x, y=f, colour=size)) + geom_line() +
  theme_minimal()
fig
dev.new()
qplot(n,colMeans(sqrt(var))*n^(1/(2+d)))
dev.new()
qplot(n,apply(y.p, 2, function(x) sqrt(mean((x - f(cbind(x.p,0.5)))^2)))*n^(1/(2+d))   )

qplot(n,apply(y.p, 2, function(x) sqrt(mean((x - f(cbind(x.p,0.5)))^2)))*n^(1/5)   )
