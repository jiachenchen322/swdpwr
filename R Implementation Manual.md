# swdpwr: A SAS Macro and An R Package for Power Calculations in Stepped Wedge Cluster Randomized Trials
<img src="illustration.png" alt="illustration" height="250">
A pictorial representation of a stepped wedge trial, adapted from [Prof Karla Hemming & Prof Monica Taljaard. (2020). When is a stepped-wedge cluster randomised trial a good design choice? Research OUTREACH. (121)](https://researchoutreach.org/articles/stepped-wedge-cluster-randomised-trial-good-design-choice/) 

## 1. Methods implemented in swdpwr
<img src="method.png" alt="method overview" height="300">

## 2. R Package Installation
The R package has versions of **Package source**, **Windows binaries**, and **macOS binaries** maintained on CRAN: [https://CRAN.R-project.org/package=swdpwr](https://CRAN.R-project.org/package=swdpwr). The binary package can be installed by:
```r
install.packages("swdpwr")
library(swdpwr)
```

## 3. Usage
```r
swdpower(K, design, family = "binomial", model = "conditional", link = "identity", type = "cross-sectional", meanresponse_start = NA,
meanresponse_end0 = meanresponse_start, meanresponse_end1 = NA, effectsize_beta = NA, sigma2 = 0, typeIerror = 0.05,
alpha0 = 0.1, alpha1 = alpha0/2, alpha2 = NA)
```
