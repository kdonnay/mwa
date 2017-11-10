# mwa: Causal Inference in Spatiotemporal Event Data

`mwa` is a flexible methodological framework designed to analyze causal relationships in spatially and temporally referenced data. Specific types of events might affect subsequent levels of other events. To estimate the corresponding effect, treatment, control, and dependent events are selected from the empirical sample. Treatment effects are established through automated matching and a diff-in-diffs regression design. The analysis is repeated for various spatial and temporal offsets from the treatment events. 

# Installation
[![CRAN](https://www.r-pkg.org/badges/version/geomerge)](https://cran.r-project.org/package=mwa)
![Downloads](https://cranlogs.r-pkg.org/badges/mwa)

The package can be installed through the CRAN repository.

```R
install.packages("mwa")
```

Or the development version from Github

```R
# install.packages("devtools")
devtools::install_github("css-konstanz/mwa")
```
# Usage

The following simple illustrations use simulated event data that are included with the package. A more extensive user guide will be added shortly.

```R
data(mwa_data)

# Specify required parameters:
# - 2 to 10 days in steps of 2
t_window <- c(2,10,2)
# - 2 to 10 kilometers in steps of 2
spat_window <- c(2,10,2)
# - column and entries that indicate treatment events 
treatment <- c("type","treatment")
# - column and entries that indicate control events 
control  <- c("type","control")
# - column and entries that indicate dependent events 
dependent <- c("type","dependent")
# - columns to match on
matchColumns <- c("match1","match2")

# Specify optional parameters:
# - use weighted regression (default estimation method is "lm")
weighted <- TRUE
# - temporal units
t_unit <- "days" 
# - match on counts of previous treatment and control events
TCM <- TRUE

# Execute method:
results <- matchedwake(mwa_data, t_window, spat_window, treatment, control, dependent,
                       matchColumns, weighted = weighted, t_unit = t_unit, TCM = TCM)

# Plot results:
plot(results)

# Return detailed summary of results:
summary(results, detailed = TRUE)

```

## Meta
- Please [report any issues or bugs](https://github.com/css-konstanz/mwa/issues).
- License:  LGPL-3
- Get citation information for `mwa` in R using `citation(package = 'mwa')`
- CRAN: https://cran.r-project.org/package=mwa
