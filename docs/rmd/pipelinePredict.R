load("~/natural-gas-pipelines/dataAndCode/pipelines.Rdata")
# replace NA weights with 0's
# data has problems before 1996 due to format change
data <- subset(data,report_yr>=1996)
data[,59:107][is.na(data[,59:107])] <- 0

names(data) <- gsub(" ",".",names(data))
xnames <-
  c("transPlant_bal_beg_yr",
    "reserve",
    "wellPrice",
    "cityPrice",
    "plantArea",
    "heatDegDays", #,"reserveGrowth",
    names(data)[59:107] )
yname <- "transProfit"
fmla <- paste(yname,"~",paste(xnames,collapse=" + "),"+ as.factor(report_yr)")
ols <- lm(fmla,data=data,x=TRUE,y=TRUE)
library(ggplot2)
y.hat.ols <- predict(ols)
qplot(ols$y,y.hat.ols)


fmla.l <- paste(yname,"~ (",
                paste(xnames,collapse=" + "),")*(report_yr + transPlant_bal_beg_yr +
    reserve + wellPrice + cityPrice + plantArea + heatDegDays) + ",
                paste(sprintf("I(%s^2)",xnames[1:6],collapse=" + "))
                )
reg <- lm(fmla.l, data=data, x=TRUE,y=TRUE)

#
Xl <- reg$x[,!(colnames(reg$x) %in% c("(Intercept)")) &
             !is.na(reg$coefficients)]
oX <- ols$x[,!(colnames(ols$x) %in% c("(Intercept)")) &
            !is.na(ols$coefficients)]
y <- reg$y

train <- runif(nrow(X))<0.75

#  lasso
library(glmnet)
#library(doMC)
#registerDoMC(cores=5)

lasso <- cv.glmnet(Xl[train,],y[train],alpha=1,parallel=FALSE,
                   standardize=TRUE, intercept=TRUE, nfolds = 50)
y.hat.lasso <- predict(lasso, Xl, s=lasso$lambda.1se, type="response")
summary((y[!train] - y.hat.lasso[!train])^2/var(y))
summary((y[train] - y.hat.lasso[train])^2/var(y))

df <- data.frame(y=y, y.hat=as.vector(y.hat.lasso), train=train, method="lasso")

ols <- lm(y ~ X)
y.hat.ols <- ols$coefficients[1] + X %*% ols$coefficients[2:(length(ols$coef))]
summary((y[!train] - y.hat.ols[!train])^2/var(y))
summary((y[train] - y.hat.ols[train])^2/var(y))

df <- rbind(df,
            data.frame(y=y, y.hat=y.hat.ols, train=train, method="ols"))

library(grf)
rf <- regression_forest(X[train,],y[train],tune.parameters = TRUE)
y.hat.rf  <-  predict(rf, X)$predictions
summary((y[!train] - y.hat.rf[!train])^2/var(y))
summary((y[train] - y.hat.rf[train])^2/var(y))

df <- rbind(df,
            data.frame(y=y, y.hat=y.hat.rf, train=train,
            method="random forest"))

lim <- quantile(y,c(0.0,1))
ggplot(data=df,aes(x=y,y=y.hat,colour=method,shape=train)) +
  #ylim(lim) + xlim(lim) +
  #scale_x_log10() + scale_y_log10() +
  geom_point(alpha=0.5) +
  geom_line(aes(y=y)) + theme_minimal()

lim <- quantile(y,c(0,1))

by(subset(df,!train), df$method[!train],  FUN=function(df) {
  with(df,c(mean((y.hat - y)^2)/var(y),
            mean(abs(y.hat - y))/mean(abs(y-mean(y)))
            ))
  })

by(subset(df,train), df$method[train],  FUN=function(df) {
  with(df,c(mean((y.hat - y)^2)/var(y),
            mean(abs(y.hat - y))/mean(abs(y-mean(y)))
            ))
  }
)
