\name{mwa-package}
\alias{mwa-package}
\docType{package}
\title{
Matched Wake Analysis (mwa): Analyzing causal relationships in spatiotemporal event data	
}
\description{
The package is designed to analyze causal relationships in spatially and temporally referenced data. Specific types of events might affect subsequent levels of other events. To estimate the corresponding effect, treatment, control, and dependent events are selected from the empirical sample. Treatment effects are established through automated matching and a diff-in-diffs regression design. The analysis is repeated for various spatial and temporal offsets from the treatment events.     

}
\details{
The full functionality of \pkg{mwa} is given through \code{\link{matchedwake}}, which relies on a small set of auxiliary methods. Note that \code{print()}, \code{summary()} and \code{plot()} commands are overloaded to return outputs specific to class \code{matchedwake}. For performance reasons, the iterative counting is done in Java using the \pkg{rJava} interface.

\bold{IMPORTANT}: The size of the Java heap space has to be set before \bold{first} calling the package via \code{library(mwa)} since JVM size cannot change once it has been initialized. This also implies that R has to be restarted if another library was already using a JVM in order for the heap space option to have any effect. To set the heap space to 1 GB, for example, use \code{options(java.parameters = "-Xmx1g")} (512 MB is the default size).
}
\author{
Sebastian Schutte and Karsten Donnay
}
\references{
Schutte, S., Donnay, K. (2014). ``Matched wake analysis: Finding causal relationships in spatiotemporal event data.'' \emph{Political Geography} 41:1-10.
}
\seealso{
   \code{\link{matchedwake}}, \code{\link{slidingWake}}, \code{\link{slideWakeMatch}}, \code{\link{print.matchedwake}}, \code{\link{summary.matchedwake}}, \code{\link{plot.matchedwake}}
}
\examples{
# Loading sample data
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

\donttest{
# Execute method:
results <- matchedwake(mwa_data, t_window, spat_window, treatment, control, dependent,
                       matchColumns, weighted = weighted, t_unit = t_unit, TCM = TCM)

# Plot results:
plot(results)

# Return detailed summary of results:
summary(results, detailed = TRUE)
}

}
