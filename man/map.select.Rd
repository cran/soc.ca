% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_plot.r
\name{map.select}
\alias{map.select}
\title{Map select modalities and individuals}
\usage{
map.select(object, dim = c(1, 2), ctr.dim = 1, list.mod = NULL,
  list.sup = NULL, list.ind = NULL, point.shape = "variable",
  point.alpha = 0.8, point.fill = "whitesmoke", point.color = "black",
  point.size = "freq", label = TRUE, label.repel = FALSE,
  label.alpha = 0.8, label.color = "black", label.size = 4,
  label.fill = NULL, map.title = "select", labelx = "default",
  labely = "default", legend = NULL, ...)
}
\arguments{
\item{object}{a soc.ca class object as created by \link{soc.mca} and 
\link{soc.csa}}

\item{dim}{the dimensions in the order they are to be plotted. The first 
number defines the horizontal axis and the second number defines the 
vertical axis.}

\item{ctr.dim}{the dimensions of the contribution values}

\item{list.mod}{a numerical vector indicating which active modalities to 
plot. It may also be a logical vector of the same length and order as the 
modalities in object$names.mod.}

\item{list.sup}{a numerical vector indicating which supplementary modalities 
to plot. It may also be a logical vector of the same length and order as 
the modalities in object$names.sup.}

\item{list.ind}{a numerical vector indicating which individuals to plot. It 
may also be a logical vector of the same length and order as the modalities
in object$names.ind.}

\item{point.shape}{a numerical value defining the shape of the points. If set
to its default, the default scale is used. It may be mapped to a variable 
with a suitable length and order.}

\item{point.alpha}{defines the alpha of the points. Values range from 0 to 1.
It may be mapped to a variable with a suitable length and order.}

\item{point.fill}{defines the fill color of the points. It may be mapped to a
variable with a suitable length and order.}

\item{point.color}{defines the color of the points. It may be mapped to a
variable with a suitable length and order. See \link{colors} for some of
the valid values.}

\item{point.size}{a numerical value defining the size of the points. If set 
to its default, the size is determined by the frequency of each modality. 
It may be defined by a variable with a suitable length.}

\item{label}{if TRUE each point is assigned its label, defined in the soc.ca 
object. See \link{assign.label} and \link{add.to.label} for ways to alter 
the labels.}

\item{label.repel}{if TRUE overlapping labels are rearranged, see \link{geom_text_repel} or \link{geom_label_repel}.}

\item{label.alpha}{defines the alpha of the labels. Values range from 0 to 1.
It may be mapped to a variable with a suitable length and order.}

\item{label.color}{defines the color of the labels. It may be mapped to a
variable with a suitable length and order. See \link{colors} for some of
the valid values.}

\item{label.size}{defines the size of the labels. It may be mapped to a
variable with a suitable length and order.}

\item{label.fill}{defines the color of the box behind the labels. It may be mapped to a
variable with a suitable length and order. This only works if label.repel is TRUE. See \link{geom_label_repel}.}

\item{map.title}{the title of the map. If set to its default the standard 
title is used.}

\item{labelx}{the label of the horizontal axis. If set to NULL a standard 
label is used.}

\item{labely}{the label of the vertical axis. If set to NULL a standard label
is used.}

\item{legend}{if set to TRUE a legend is provided. Change the legend with the
\link{guides}, \link{theme} and \link{guide_legend} functions from the
ggplot2 package.}

\item{...}{further arguments are currently ignored.}
}
\description{
Creates a map of selected modalities or individuals
}
\examples{
example(soc.ca)
map.select(result, map.title = "Map of the first ten modalities", list.mod = 1:10)
select   <- active[, 3]
select   <- select == levels(select)[2]
map.select(result, map.title = "Map of all individuals sharing a particular value",
 list.ind = select, point.size = 3)
map.select(result, map.title = "Map of both select individuals and modalities",
 list.ind = select, list.mod = 1:10)
}

