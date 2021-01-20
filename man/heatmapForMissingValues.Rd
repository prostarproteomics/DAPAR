% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots_heatmaps.R
\name{heatmapForMissingValues}
\alias{heatmapForMissingValues}
\title{This function is inspired from the function \code{\link{heatmap.2}} 
that displays quantitative data in the \code{exprs()} table of an object of
class \code{MSnSet}. For more information, please refer to the help 
of the heatmap.2 function.}
\usage{
heatmapForMissingValues(
  x,
  col = heat.colors(100),
  srtCol = NULL,
  labCol = NULL,
  labRow = NULL,
  key = TRUE,
  key.title = NULL,
  main = NULL,
  ylab = NULL
)
}
\arguments{
\item{x}{A dataframe that contains quantitative data.}

\item{col}{colors used for the image. Defaults to heat colors (heat.colors).}

\item{srtCol}{angle of column conds, in degrees from horizontal}

\item{labCol}{character vectors with column conds to use.}

\item{labRow}{character vectors with row conds to use.}

\item{key}{logical indicating whether a color-key should be shown.}

\item{key.title}{main title of the color key. If set to NA no title will 
be plotted.}

\item{main}{main title; default to none.}

\item{ylab}{y-axis title; default to none.}
}
\value{
A heatmap
}
\description{
Heatmap inspired by the heatmap.2 function.
}
\examples{
utils::data(Exp1_R25_pept, package='DAPARdata')
obj <- mvFilter(Exp1_R25_pept, "WholeMatrix", 6)
qData <- Biobase::exprs(obj)
heatmapForMissingValues(qData)

}
\author{
Samuel Wieczorek
}