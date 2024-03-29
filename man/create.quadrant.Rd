% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_analysis.r
\name{create.quadrant}
\alias{create.quadrant}
\title{Create categories according to the quadrant position of each individual}
\usage{
create.quadrant(
  object,
  dim = c(1, 2),
  cut.min = -0.125,
  cut.max = 0.125,
  cut.radius = 0.25
)
}
\arguments{
\item{object}{a soc.ca class object}

\item{dim}{the dimensions}

\item{cut.min}{Minimum cut value}

\item{cut.max}{Maximum cut value}

\item{cut.radius}{Radius of the center category}
}
\value{
Returns a character vector with category memberships
}
\description{
Creates a vector from two dimensions from a soc.ca object. Labels are the 
cardinal directions with the first designated dimension running East - West.
The center category is a circle defined by \code{cut.radius}.
}
\examples{
example(soc.ca)
create.quadrant(result, dim = c(2, 1))
table(create.quadrant(result, dim = c(1, 3), cut.radius = 0.5))

}
\seealso{
\link{soc.mca}
}
