\name{slideWakeMatch}
\alias{slideWakeMatch}
\title{
Auxiliary Function to Match Data and Estimate Treatment Effects
}
\description{
Method takes the output of \code{\link{slidingWake}}, matches observations using \code{\link{cem}} and estimates treatment effects using linear models (\code{\link{lm}} or \code{\link{att}}) or a count dependent variable model (\code{\link{glm.nb}}).
}
\usage{
slideWakeMatch(wakes, alpha1, matchColumns, estimation, formula, weighted,
               estimationControls, TCM, match.default, ...)
}
\arguments{
  \item{wakes}{
  \code{data.frame}. See ``wakes'' in the description of \code{\link{matchedwake}} for details.
}
  \item{alpha1}{
  significance level used for the analysis and plots. Default = \code{0.05}.
}
  \item{matchColumns}{
  vector of Strings indicating the columns to match on.
}
  \item{estimation}{
  String specifying method used for estimation.
}
  \item{formula}{
  String specifying the model used for estimation.
}
  \item{weighted}{
  Boolean specifying whether regression is weighted.
}
 \item{estimationControls}{
  vector of Strings indicating additional control dimensions to be included in the estimation.
}
  \item{TCM}{
  Boolean to select whether the method should match on counts of previous treatment and control instances.
}
\item{match.default}{
  Boolean to select whether observations are matched using \code{cem}.
}
  \item{\dots}{
  optional parameters that can be passed to the methods used for matching and estimation.
}
}
\details{
   See the description of \code{\link{matchedwake}} for details.
}
\value{
 Returns a \code{list} with the following slots:
   \item{estimates}{
   \code{data.frame} with estimates and p values for all spatial and temporal windows considered.
}
   \item{matching}{
   \code{data.frame} with detailed matching statistics for all spatial and temporal windows considered.
}
   \item{SUTVA}{
   \code{data.frame} with detailed statistics on the degree of overlaps of the spatiotemporal cylinders.
}
   \item{wakes}{
   \code{data.frame}.
}
See the description of \code{\link{matchedwake}} for details.
}
\references{
Schutte, S., Donnay, K. (2014). ``Matched wake analysis: Finding causal relationships in spatiotemporal event data.'' \emph{Political Geography} 41:1-10.
}
\author{
  Sebastian Schutte and Karsten Donnay.
}
\seealso{
  \code{\link{matchedwake}}, \code{\link{slidingWake}}
}
