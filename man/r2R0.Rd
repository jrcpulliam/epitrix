% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/r_to_R0_Wallinga_Lipsitch.R
\name{r2R0}
\alias{r2R0}
\alias{lm2R0_sample}
\title{Transform a growth rate into a reproduction number}
\usage{
r2R0(r, w, trunc = 1000)

lm2R0_sample(x, w, n = 100, trunc = 1000)
}
\arguments{
\item{r}{A vector of growth rate values.}

\item{w}{The serial interval distribution, either provided as a
\code{distcrete} object, or as a \code{numeric} vector containing
probabilities of the mass functions.}

\item{trunc}{The number of time units (most often, days), used for truncating
\code{w}, whenever a \code{distcrete} object is provided. Defaults to 1000.}

\item{x}{A \code{lm} object storing a a linear regression of log-incidence
over time.}

\item{n}{The number of draws of R0 values, defaulting to 100.}
}
\description{
The function \code{r2R0} can be used to transform a growth rate into a
reproduction number estimate, given a generation time distribution. This uses
the approach described in Wallinga and Lipsitch (2007, Proc Roy Soc B
274:599–604) for empirical distributions. The function \code{lm2R0_sample}
generates a sample of R0 values from a log-linear regression of incidence
data stored in a \code{lm} object.
}
\details{
It is assumed that the growth rate ('r') is measured in the same
time unit as the serial interval ('w' is the SI distribution, starting at
time 0).
}
\examples{

## Ebola estimates of the SI distribution from the first 9 months of
## West-African Ebola oubtreak

mu <- 15.3 # days
sigma <- 9.3 # days
param <- gamma_mucv2shapescale(mu, sigma / mu)

if (require(distcrete)) {
  w <- distcrete("gamma", interval = 1,
                 shape = param$shape,
                 scale = param$scale, w = 0)

  r2R0(c(-1, -0.001, 0, 0.001, 1), w)


## Use simulated Ebola outbreak and 'incidence' to get a log-linear
## model of daily incidence.

  if (require(outbreaks) && require(incidence)) {
    i <- incidence(ebola_sim$linelist$date_of_onset)
    plot(i)
    f <- fit(i[1:100])
    f
    plot(i[1:150], fit = f)

    R0 <- lm2R0_sample(f$model, w)
    hist(R0, col = "grey", border = "white", main = "Distribution of R0")
    summary(R0)
  }
}

}
\author{
Code by Anne Cori \email{a.cori@imperial.ac.uk}, packaging by
Thibaut Jombart \email{thibautjombart@gmail.com}
}
