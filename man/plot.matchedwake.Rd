\name{plot.matchedwake}
\alias{plot.matchedwake}
\title{
Plot Function for Objects of Class \code{matchedwake}
}
\description{
Overloads the default \code{plot()} for objects of class \code{matchedwake}. Returns a contour plot: The lighter the color the larger the estimated treatment effect. The corresponding standard errors are indicated by shading out some of the estimates: No shading corresponds to \eqn{p<alpha1} for the treatment effect in the diff-in-diffs analysis. Dotted lines indicate p-values between \code{alpha1} and \code{alpha2} and full lines indicate \eqn{p>alpha2}. The cells indicating effect size and significance level are arranged in a table where each field corresponds to one specific combination of spatial and temporal sizes.
}
\usage{
\method{plot}{matchedwake}(x, zlim = NA, plotNAs = TRUE, adjust = "none", ...)
}
\arguments{
  \item{x}{
  object of class \code{\link{matchedwake}}.
}
  \item{zlim}{
  Manually sets the range of the color map of the contour plot, required format is c(MINIMUM,MAXIMUM). \code{Default = NA}, i.e. the range is automatically set from the MINIMUM and MAXIMUM values of the estimates.
}
\item{plotNAs}{
  Boolean indicating whether or not to visualize NA estimates as ``no effect'' (i.e. 0). \code{Default = TRUE}.
}
\item{adjust}{
  Select p-value adjustment method for multiple testing, \code{Default = "none"}; takes values "none", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY" or "fdr", see `?p.adjust` (\pkg{stats}) for details (Credit: David Armstrong, github.com/davidaarmstrong)
}
  \item{\dots}{
  further arguments passed to or from other methods.
}
}
\references{
Schutte, S., Donnay, K. (2014). ``Matched wake analysis: Finding causal relationships in spatiotemporal event data.'' \emph{Political Geography} 41:1-10.
}
\author{
  Sebastian Schutte and Karsten Donnay.
}
\seealso{
  \code{\link{matchedwake}}
}