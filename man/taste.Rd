% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_documentation.r
\docType{data}
\name{taste}
\alias{taste}
\title{Taste dataset}
\value{
The variables included in the dataset: \item{Preferred TV program}{(8
categories): news, comedy, police, nature, sport, films, drama, soap operas}
\item{Preferred Film}{(8 categories): action, comedy, costume drama,
documentary, horror, musical, romance, SciFi} \item{Preferred type of Art}{(7
categories): performance, landscape, renaissance, still life, portrait,
modern, impressionsism} \item{Preferred place to Eat out}{(6 categories):
fish & chips, pub, Indian restuarant, Italian restaurant, French restaurant,
steak house}
}
\description{
The taste example dataset used by Le Roux & Rouanet(2010):
}
\examples{
\dontrun{
# The taste example
data(taste)
data_taste           <- taste[which(taste$Isup == 'Active'), ]
active               <- data.frame(data_taste$TV, data_taste$Film, data_taste$Art, data_taste$Eat)
sup                  <- data.frame(data_taste$Gender, data_taste$Age, data_taste$Income)

# Multiple Correspondence Analysis
result.mca     <- soc.mca(active, sup)
str(result.mca)
result.mca

variance(result.mca) # See p.46 in Le Roux(2010)

contribution(result.mca, 1)
contribution(result.mca, 2)
contribution(result.mca, 1:3, mode = "variable")

map.active(result.mca, point.fill = result.mca$variable)
map.active(result.mca,
 map.title="Map of active modalities with size of contribution to 1. dimension",
 point.size=result.mca$ctr.mod[, 1])
map.active(result.mca,
 map.title="Map of active modalities with size of contribution to 2. dimension",
 point.size=result.mca$ctr.mod[, 2])

map.ind(result.mca)
map.ind(result.mca, dim=c(1, 2), point.color=result.mca$ctr.ind[, 1],
 point.shape=18) + scale_color_continuous(low="white", high="black")

# Plot of all dublets
map.ind(result.mca, map.title="Map of all unique individuals", point.color=duplicated(active))
map.ind(result.mca, map.title="Map with individuals colored by the TV variable",
 point.color=active$TV)

# Ellipse
map             <- map.ind(result.mca)
map.ellipse(result.mca, map, as.factor(data_taste$Age == '55-64'))

##### Specific Multiple Correspondence Analysis
options(passive= c("Film: CostumeDrama", "TV: Tv-Sport"))
result.smca     <- soc.mca(active, sup)
result.smca
result.smca$names.passive

##### Class Specific Correspondence Analysis
options(passive=NULL)

class.age     <- which(data_taste$Age == '55-64')
result.csca   <- soc.csa(result.mca, class.age, sup)
str(result.csca)
# Correlations
csa.measures(result.csca)
variance(result.csca)
contribution(result.csca, 1)
contribution(result.csca, 2)
contribution(result.csca, 1:3, mode = "variable")

# Plots
map.ind(result.csca)
map.csa.mca(result.csca)
map.csa.mca.array(result.csca)
}
}
\references{
Le Roux, Brigitte, Henry Rouanet, Mike Savage, og Alan Warde.
  2008. "Class and Cultural Division in the UK". Sociology 42(6):1049-1071.

Le Roux, B., og H. Rouanet. 2010. Multiple correspondence
  analysis. Thousand Oaks: Sage.
}
\author{
Brigitte Le Roux
}
\keyword{data}
