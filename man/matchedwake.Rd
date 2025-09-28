\name{matchedwake}
\alias{matchedwake}
\title{
Estimate Treatment Effect for Sliding Spatiotemporal Windows
}
\description{
This function performs the Matched Wake Analysis (mwa), which consists of two steps: counts for previous and posterior events are established for different spatial and temporal offsets from treatment and control events. After that, the treatment effect is estimated in a difference-in-differences regression design. For performance reasons, the iterative counting is done in Java using the \pkg{rJava} interface.

\bold{IMPORTANT}: The size of the Java heap space has to be set before \bold{first} calling the package via \code{library(mwa)} since JVM size cannot change once it has been initialized. This also implies that R has to be restarted if another library was already using a JVM in order for the heap space option to have any effect. To set the heap space to 1 GB, for example, use \code{options(java.parameters = "-Xmx1g")} (512 MB is the default size).
}
\usage{
matchedwake(data, t_window, spat_window, treatment, control,
            dependent, matchColumns, t_unit = "days", estimation = "lm",
	    formula = "dependent_post ~ dependent_pre + treatment",
            weighted = FALSE, estimationControls = c(), TCM = FALSE,
            deleteSUTVA = FALSE, alpha1 = 0.05, alpha2 = 0.1,
            match.default = TRUE, match.details = FALSE, ...)
}
\arguments{
  \item{data}{
  \code{data.frame} containing the observations. See Details.  
}
  \item{t_window}{
  specification of temporal windows in \code{t_units}. See Details.
}
  \item{spat_window}{
  specification of spatial windows in kilometers. See Details.
}
  \item{treatment}{
  vector of Strings identifying which type of events serve as treatments. See Details.
}
  \item{control}{
  vector of Strings identifying which type of events serve as controls. See Details.
}
  \item{dependent}{
  vector of Strings identifying which type of events are affected by treatment. See Details.
}
  \item{matchColumns}{
  vector of Strings indicating the columns to match on. See Details.
}
  \item{t_unit}{
  String specifying the temporal units to be used, either \kbd{"days"}, \kbd{"hours"}, \kbd{"mins"} or \kbd{"secs"}. Default = \kbd{"days"}. See Details.
}
  \item{estimation}{
  String specifying method used for estimation, \kbd{"lm"}, \kbd{"att"} or \kbd{"nb"}. Default = \kbd{"lm"}. See Details.
}
\item{formula}{
  String specifying the model used for estimation. Default = \kbd{"dependent_post ~ dependent_pre + treatment"}. See Details.
}
  \item{weighted}{
  Boolean specifying whether regression is weighted (only affects estimations using \kbd{"lm"} or \kbd{"att"}). Default = \kbd{FALSE}.
}
  \item{estimationControls}{
  vector of Strings indicating additional control dimensions to be included in the estimation. See Details.
}    
  \item{TCM}{
  Boolean to select whether the method should match on counts of previous treatment and control instances. Default = \kbd{FALSE}.
}
  \item{deleteSUTVA}{
  Boolean to select whether overlapping treatment and control episodes are deleted. Default = \kbd{FALSE}.
}
  \item{alpha1}{
  first significance level used for the analysis and plots. Default = \kbd{0.05}.
}
  \item{alpha2}{
  second significance level used for the analysis and plots. Default = \kbd{0.1}.
}
  \item{match.default}{
  Boolean to select whether observations are matched using \code{cem}. Default = \kbd{TRUE}.
}
  \item{match.details}{
  Boolean to select whether detailed matching statistics are returned from \code{cem}. Default = \kbd{FALSE}.
}
  \item{\dots}{
  optional parameters that can be passed to the methods used for matching and estimation. See Details.
}
}
\details{
  The method expects \code{data} to be a \code{data.frame}. Dates must be given in column \kbd{timestamp} and formatted as a date string with format \kbd{"YYYY-MM-DD hh:mm:ss"}. Alternatively, a POSIX Date can be specified using the same format. \code{data} must also contain two entries called \code{lat} and \code{lon} for the geo location of each entry.

  \code{t_window} specifies the minimal and maximal temporal window sizes and corresponding steps used in the iteration. Required syntax is \kbd{c(min_window, max_window, step_size)} with \code{step_size} in units of \code{t_unit}. The spatial window \code{spat_window} is specified in the same way with kilometers as units.

  \code{treatment}, \code{control} and \code{dependent} define which category of events is considered to be treatment, control and dependent cases respectively. The required syntax is \kbd{c(column_name, value)} where \code{column_name} must be entered as String and \code{value} can be Numeric, Boolean, or a String. %This syntax allows to flexibly select cases to the three categories. 

  \code{matchColumns} selects the columns in \code{data} used for matching. Matching variables are expected to be coded together with every treatment and control type event and are assumed to reflect a set of suitable matching variables (what is suitable will, of course, vary from case to case).

  The optional argument \code{t_unit} specifies the temporal resolution for which the analysis is to be conducted, one of either \kbd{"days"}, \kbd{"hours"}, \kbd{"mins"} or \kbd{"secs"}. If the time stamps provided in \code{data} are more precise than the resolution they are truncated accordingly. 

  \pkg{mwa} estimates treatment effects using a diff-in-diffs regression design. By default this is specified as \kbd{"dependent_post ~ dependent_pre + treatment"} (where ``pre'' and ``post'' refer to pre and post intervention). Alternatively, \kbd{"dependent_post - dependent_pre ~ treatment"} is accepted. Only those two input specifications are allowed, any other input will result in an error.

   Three different estimation approaches can be chosen using \code{estimation}: a linear model (\kbd{"lm"}, \pkg{stats}), all models available through (\kbd{"att"}, \pkg{cem}) or a count dependent model (\kbd{"glm.nb"}, \pkg{MASS}). For regressions using \kbd{"lm"} or \kbd{"att"} \code{weighted} sets whether or not the regression is weighted by the number of treatment vs. control cases. Additional control variables can be specified via \code{estimationControls}. For example, if \kbd{estimationControls = c("covariate1")}, the package automatically modifies the default estimation formula to \kbd{"dependent_post ~ dependent_pre + covariate1 + treatment"} (analogously for the other specification). In this case the output then also not only returns the estimate and p value for \kbd{treatment} but further returns the coefficients and p values for all additional control variables. 

 The package supports full inheritance for optional arguments of the following methods: \code{\link[cem]{cem}} and \code{\link[cem]{att}} (\pkg{cem}), \code{\link[stats]{lm}} (\pkg{stats}), \code{\link[MASS]{glm.nb}} (\pkg{MASS}). To guarantee unique inputs for each method, options have to entered into \code{matchedwake()} using a prefix that consists of the method name separated by ``.''. For example, in order for \code{\link[cem]{cem}} to return an exactly balanced dataset simply add \code{cem.k2k = TRUE} as optional argument.
}
\value{
  Returns an object of class \code{matchedwake}, which is a list of objects with the following slots:
   \item{estimates}{
   \code{data.frame} with estimates and p values for all spatial and temporal windows considered. For \kbd{estimation = "lm"} it also returns a pseudo \eqn{R^2} value. If additional control dimensions were included in the estimation, it further returns the corresponding coefficients and p values.
}
   \item{matching}{
   \code{data.frame} with detailed matching statistics for all spatial and temporal windows considered. Returns the number of control and treatment episodes, L1 metric, percent common support. All values are given both pre and post matching.
}
   \item{SUTVA}{
   \code{data.frame} with detailed statistics on the degree of overlaps of the spatiotemporal cylinders. Returns the fraction of cases in which two or more treatment (or control) episodes overlap (``SO'': same overlap) and the fraction of overlapping treatment and control episodes (``MO'': mixed overlap). All values are given pre and post matching and for the full time window.
}
   \item{wakes}{
   \code{data.frame} providing the information for the spatiotemporal cylinders (or \code{wakes}) for all spatial and temporal windows considered. Returns the \code{eventID} (i.e. the index of the event in the time-ordered dataset), \code{treatment} (1: treatment episode, 0: control episode), counts of \code{dependent} events, overlaps (``SO'' and ``MO'') pre and post intervention, and the matching variables.
}
   \item{matched}{
   \code{data.frame} with details on which observations were matched for all spatial and temporal windows considered. Returns the \code{eventID} (i.e. the index of the event in the time-ordered dataset), \code{treatment} (1: treatment episode, 0: control episode) and \code{matched} (1: matched, 0: not matched).
}
   \item{bins}{
   \code{data.frame} with details for the bins used in cem matching for all spatial and temporal windows considered. Returns the bin information from cem (variable ``breaks'') for each \code{matchColumns}.
}
   \item{parameters}{
   \code{list} of all arguments passed to the method.
}
   \item{call}{
   the call.
}
	
}
\references{
Schutte, S., Donnay, K. (2014). ``Matched wake analysis: Finding causal relationships in spatiotemporal event data.'' \emph{Political Geography} 41:1-10.
}
\author{
  Sebastian Schutte and Karsten Donnay.
}
\seealso{
  \code{\link{mwa-package}}, \code{\link{slidingWake}}, \code{\link{slideWakeMatch}}, \code{\link{print.matchedwake}}, \code{\link{summary.matchedwake}}, \code{\link{plot.matchedwake}}
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