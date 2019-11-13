rm(list=ls())
n <- 5000
dz <- 10
sz <- 3
dx <- 1
V <- matrix(c(1, 0.5, 0.5, 1), nrow=2)

simulate <- function(n,dz,sz,dx,V) {
  x <- matrix(rnorm(dx*n), nrow=n)
  z <- matrix(rnorm(dz*n), nrow=n)
  alphaz <- rep(0,dz)
  alphaz[1:sz] <- 1/sz
  alphax <- rep(1,dx)
  beta <- rep(1,dx)

  e <- matrix(rnorm(2*n), nrow=n) %*% chol(V)

  dstar <- x%*%alphax + z%*%alphaz + e[,1]
  p <- pnorm(x%*%alphax + z%*%alphaz)
  imills <- dnorm(x%*%alphax + z%*%alphaz)/p
  d <- dstar>0
  ystar <- x%*%beta + e[,2]
  y <- ystar
  y[!d] <- NA
  df <- data.frame(y, d, ystar, dstar,p, imills, x, z)
  names(df)[(ncol(df)-dz+1):ncol(df)] <- c(sprintf("z%d", 1:dz))
  df
}

df <- simulate(n,dz,sz,dx,V)
summary(lm(y ~ x, data=df))
summary(lm(y ~ x + imills, data=df))


