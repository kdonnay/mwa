\name{slidingWake}
\alias{slidingWake}
\title{
Auxiliary Function to Iterate Through Sliding Spatiotemporal Windows
}
\description{
Method iterates through all spatial and temporal window sizes specified and counts dependent events with a given spatial window and for a given temporal window (symmetrically in forward and backward direction in time). For performance reasons, the iterative counting is done in Java using the \pkg{rJava} interface.

\bold{IMPORTANT}: The size of the Java heap space has to be set before \bold{first} calling the package via \code{library(mwa)} since JVM size cannot change once it has been initialized. This also implies that R has to be restarted if another library was already using a JVM in order for the heap space option to have any effect. To set the heap space to 1 GB, for example, use \code{options(java.parameters = "-Xmx1g")} (512 MB is the default size).
}
\usage{
slidingWake(data, t_unit, t_window, spat_window, treatment, control,
            dependent, matchColumns, estimationControls)
}
\arguments{
  \item{data}{
  \code{data.frame} containing the observations.
}
  \item{t_unit}{
  String specifying the temporal units to be used.
}
  \item{t_window}{
  specification of temporal windows in \code{t_units}.
}
  \item{spat_window}{
  specification of spatial windows in kilometers.
}
  \item{treatment}{
  vector of Strings identifying which type of events serve as treatments.
}
  \item{control}{
  vector of Strings identifying which type of events serve as controls.
}
  \item{dependent}{
  vector of Strings identifying which type of events are affected by treatment.
}
  \item{matchColumns}{
  vector of Strings indicating the columns to match on.
}
  \item{estimationControls}{
  vector of Strings indicating additional control dimensions to be included in the estimation.
}
}
\details{
   See the description of \code{\link{matchedwake}} for details.
}
\value{
  Returns a \code{data.frame}. See ``wakes'' in the description of \code{\link{matchedwake}} for details.
}
\references{
Schutte, S., Donnay, K. (2014). ``Matched wake analysis: Finding causal relationships in spatiotemporal event data.'' \emph{Political Geography} 41:1-10.
}
\author{
  Sebastian Schutte and Karsten Donnay.
}

\seealso{
  \code{\link{matchedwake}}, \code{\link{slideWakeMatch}}
}