# RSquamataBase

An R package to interface with the SquamataBase web API.

## Installation

```R
install.packages("devtools")
library(devtools)
install_github("SquamataBase/RSquamataBase")
```

## Useage

```
# find all prey records for snakes in the family Colubridae
get_foodrecords(predator="Colubridae")

# find all records of colubrid snakes eating frogs
get_foodrecords(predator="Colubridae", prey="Anura")

# find all records of colubrid snakes hylid frogs
get_foodrecords(predator="Colubridae", prey="Hylidae")
```
