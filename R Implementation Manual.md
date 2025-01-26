# swdpwr: A SAS Macro and An R Package for Power Calculations in Stepped Wedge Cluster Randomized Trials
<img src="illustration.png" alt="illustration" height="250">
A pictorial representation of a stepped wedge trial, adapted from [Prof Karla Hemming & Prof Monica Taljaard. (2020). When is a stepped-wedge cluster randomised trial a good design choice? Research OUTREACH. (121)](https://researchoutreach.org/articles/stepped-wedge-cluster-randomised-trial-good-design-choice/) 

## 1. Methods and Scenarios Implemented in swdpwr
<img src="method.png" alt="method overview" height="300">

## 2. R Package Installation
The R package has versions of **Package source**, **Windows binaries**, and **macOS binaries** maintained on CRAN: [https://CRAN.R-project.org/package=swdpwr](https://CRAN.R-project.org/package=swdpwr). The binary package can be installed by:
```r
install.packages("swdpwr")
library(swdpwr)
```

## 3. Usage
```r
swdpower(K, design, family, model, link, type, meanresponse_start, meanresponse_end0, meanresponse_end1, effectsize_beta, sigma2, typeIerror, alpha0, alpha1, alpha2)
```
## 4. Arguments
<img src="argument.png" alt="argument" height="600">

## 5. Details
This function `swdpwr` performs power calculations for stepped wedge cluster randomized trials under different scenarios (presented in Section 1). 
### A note on assumptions on time effects
The default setting assumes no time effect, meaning the anticipated mean response in the control group at the end of the study (`meanresponse_end0`) is equal to that at the start of the study (`meanresponse_start`). To incorporate time effects, you can manually set `meanresponse_start` and `meanresponse_end0` to different values. For a model with time effects but approximating a "zero time trend", this can be achieved by setting `meanresponse_start` and `meanresponse_end0` to values that are close but slightly different, such as `meanresponse_start = x` and `meanresponse_end0 = x + 0.001` (with the difference being greater than 1e-5).
