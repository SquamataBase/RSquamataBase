# RSquamataBase

An R package to interface with the SquamataBase web API.

# Installation

```R
install.packages("devtools")
library(devtools)
install_github("SquamataBase/RSquamataBase")
```

# Useage

```
# find all food records for snakes in the family Colubridae
get_foodrecords(predator="Colubridae")
```
