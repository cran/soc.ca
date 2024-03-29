# Tools, exports and other helpful functions

#' Cut a continuous variable into categories with a specified minimum
#' 
#' Many continuous variables are very unequally distributed, often with many individuals in the lower categories and fewer in the top.
#' As a result it is often difficult to create groups of equal size, with unique cut-points.
#' By defining the wanted minimum of individuals in each category, but still allowing this minimum to be surpassed, it is easy to create ordinal variables from continuous variables. 
#' The last category will not neccessarily have the minimum number of individuals.
#' 
#' @param x is a continuous numerical variable
#' @param min.size is the minimum number of individuals in each category
#' @return a numerical vector with the number of each category
#' @export
#' @examples
#' a <- 1:1000
#' table(min_cut(a))
#' b <- c(rep(0, 50), 1:500)
#' table(min_cut(b, min.size = 20))
#' 

min_cut <- function(x, min.size = length(x)/10){
  
  x.na <- x[is.na(x) == FALSE]
  p.x <- cumsum(prop.table(table(x.na)))
  t.x <- cumsum(table(x.na))
  bm  <- cbind(table(x.na),t.x)
  dif <- vector(length = nrow(bm))
  for (i in 2:length(dif)) dif[i] <- bm[i,2] - bm[i-1,2]
  dif[1] <- bm[1, 2]
  bm <- cbind(bm, dif)
  
  group <- vector(length = nrow(bm))
  g <- 1 
  collect <- 0
  for (i in 1:nrow(bm)){
    if (dif[i] >= min.size | collect >= min.size-1){
      group[i] <- g
      g <- g + 1
      collect <- 0
    }else{
      group[i] <- g
      collect  <- collect + dif[i]
    }
  }
  
  x.group <- vector(length = length(x))
  group.levels <- as.numeric(levels(as.factor(group)))
  values <- as.numeric(rownames(bm))
  levs   <- vector()
  # Assigning group to the original x
  for (i in 1:length(group.levels)){
    g   <- group.levels[i]
    val <- values[group == g]
    g   <- paste(min(val), ":", max(val), sep = "")
    x.group[x %in% val]  <- g
    levs                 <- c(levs, paste(min(val), ":", max(val), sep = ""))
  }
  x.group[is.na(x)] <- NA
  factor(x.group, labels = levs, ordered = TRUE)
}

#' Cut ordinal variables
#' 
#' If we are in a hurry and need to cut a lot of likert-scale or similar type of variables into MCA-friendly ordered factors this function comes in handy.
#' cowboy_cut will try its best to create approx 3-5 categories, where the top and the bottom are smaller than the middle. Missing or other unwanted categories are recoded but still influence the categorization. So that when cowboy_cut tries to part the top of a variable with a threshold around 10% of cases it is 10% including the missing or NA cases.
#' Make sure that levels are in the right order before cutting. 
#' @param x a factor
#' @param top.share approximate share in top category
#' @param bottom.share approximate share in bottom category
#' @param missing a character vector with all the missing or unwanted categories.
#'
#' @return a recoded factor
#' @export

cowboy_cut <- function(x, top.share = 0.10, bottom.share = 0.10,  missing = "Missing"){
  x[x %in% missing] <- NA
  x <- droplevels(x)
  x <- as.ordered(x)
  x <- as.numeric(x)
  
  x.top <- x
  x.bottom <- x
  x.top[is.na(x)] <- -Inf
  x.bottom[is.na(x)] <- Inf
  
  top <- quantile(x.top, probs = seq(0, 1, by = top.share), na.rm = TRUE, type = 3) %>% tail(2) %>% head(1)
  bottom <- quantile(x.bottom, probs = seq(0, 1, by = bottom.share), na.rm = TRUE, type = 3) %>% head(2) %>% tail(1)
  mid  <- x[x != 0 & x < top] %>% quantile(probs = seq(0, 1, by = 0.33), type = 3, na.rm = TRUE)
  mid  <- mid[-1]
  mid  <- mid[-3]
  breaks <- c(-Inf, bottom, mid, top, Inf)
  o <- x %>% as.numeric() %>% cut(breaks = unique(breaks), include.lowest = TRUE)
  levels(o) <- paste0(1:nlevels(o), "/", nlevels(o)) 
  o %>% fct_explicit_na(na_level = "Missing")
}


#' Export results from soc.ca
#'
#' Export objects from the soc.ca package to csv files.
#' @param object is a soc.ca class object
#' @param dim is the dimensions to be exported
#' @param file is the path and name of the .csv values are to be exported to
#' @return A .csv file with various values in UTF-8 encoding
#' @seealso \link{soc.mca}, \link{contribution}
#' @export

export <- function(object, file = "export.csv", dim = 1:5) {
  if (is.matrix(object) == TRUE|is.data.frame(object) == TRUE){
    write.csv(object, file, fileEncoding = "UTF-8")}

    if ((class(object) == "tab.variable") == TRUE){
      
      ll    <- length(object)
      nam   <- names(object)
      a     <- object[[1]]
      coln  <- ncol(a)
      line  <- c(rep("", coln))
      line2 <- c(rep("", coln))
      a     <- rbind(line, a, line2)      
      
    for (i in 2:ll){
      line <- c(rep("", coln))
      line2 <- c(rep("", coln))
      a <- rbind(a,line, object[[i]], line2)
      line2  <- c(rep("", coln))
    }
    rownames(a)[rownames(a) == "line"] <- nam
    rownames(a)[rownames(a) == "line2"] <- ""
    out <- a
    write.csv(out, file, fileEncoding = "UTF-8")  
    }

    if ((class(object) == "soc.mca") == TRUE){
    coord.mod     <- object$coord.mod[,dim]
    coord.sup     <- object$coord.sup[,dim]
    coord.ind     <- object$coord.ind[,dim]
    names.mod		  <- object$names.mod
    names.sup  	  <- object$names.sup
    names.ind     <- object$names.ind
    coord         <- round(rbind(coord.mod, coord.sup, coord.ind), 2)
    names         <- c(names.mod, names.sup, names.ind)
    rownames(coord) <- names
    
    ctr.mod       <- object$ctr.mod[,dim]
    ctr.sup       <- matrix(nrow = nrow(coord.sup), ncol = ncol(coord.sup))
    ctr.ind       <- object$ctr.ind[,dim]
    ctr           <- round(1000*rbind(ctr.mod, ctr.sup, ctr.ind))
    
    cor.mod       <- round(100*object$cor.mod[,dim], 1)
    cor.sup       <- matrix(nrow = nrow(coord.sup), ncol = ncol(coord.sup))
    cor.ind       <- matrix(nrow = nrow(coord.ind), ncol = ncol(coord.ind))
    cor           <- rbind(cor.mod, cor.sup, cor.ind)
    
    out           <- cbind(coord, ctr, cor)
    colnames(out) <- c(paste("Coord:", dim), paste("Ctr:", dim), paste("Cor:", dim))
    write.csv(out, file, fileEncoding = "UTF-8")
  
  }
  
}

#' Invert the direction of coordinates
#' 
#' Invert one or more axes of a correspondence analysis. The principal coordinates of the analysis are multiplied by -1.
#' @details This is a convieniency function as you would have to modify coord.mod, coord.ind and coord.sup in the soc.ca object.
#' 
#' @param x is a soc.ca object
#' @param dim is the dimensions to be inverted
#' @return a soc.ca object with inverted coordinates on the specified dimensions
#' @seealso \link{soc.mca}, \link{add.to.label}
#' @examples
#' example(soc.ca)
#' inverted.result  <- invert(result, 1:2)
#' result$coord.ind[1, 1:2]
#' inverted.result$coord.ind[1, 1:2]
#' @export

invert <- function(x, dim = 1) {
  x$coord.mod[,dim] <- x$coord.mod[,dim] * -1
  x$coord.all[, dim] <- x$coord.all[, dim] * -1
  x$coord.ind[,dim] <- x$coord.ind[,dim] * -1
  x$coord.sup[,dim] <- x$coord.sup[,dim] * -1
  return(x)
}


#' Convert to MCA class from FactoMineR
#'
#' @param object is a soc.ca object
#' @param active the active variables
#' @param dim a numeric vector
#'
#' @return an FactoMineR class object
to.MCA <- function(object, active, dim = 1:5) {
  
  rownames(active)         <- object$names.ind
  rownames(object$coord.ind) <- object$names.ind
  
  var                      <- list(coord = object$coord.mod[,dim], 
                                   cos2  = object$cor.mod[,dim], 
                                   contrib = object$ctr.mod[,dim])
  ind <- list(coord = object$coord.ind[,dim], 
              cos2 = object$cor.ind[,dim], 
              contrib = object$ctr.ind[,dim])
  call <- list(marge.col = object$mass.mod, 
               marge.row = 1/object$n.ind,
               row.w = rep(1, object$n.ind),
               X = active,
               ind.sup = NULL)
  eig <- matrix(0, nrow = length(dim), ncol = 3)
  rownames(eig) <- paste("dim ", dim, sep="")
  colnames(eig) <- c("eigenvalue", "percentage of variance", "cumulative percentage of variance")
  eig[,1] <- object$eigen[dim]
  eig[,2] <- eig[,1]/sum(object$eigen) *100
  eig[,3] <- cumsum(eig[,2])
  res <- list(eig=eig, var=var, ind=ind, call=call)                                          
  class(res) <- c("MCA", "list")
  return(res)
}

barycenter <- function(object, mods = NULL, dim = 1){
  new.coord <- sum(object$mass.mod[mods] * object$coord.mod[mods, dim]) / sum(object$mass.mod[mods])
  new.coord
}

#' MCA Eigenvalue check
#'
#' Two variables that have perfectly or almost perfectly overlapping sets of categories will skew an mca analysis. This function tries to find the variables that do that so that we may remove them from the analysis or set some of the categories as passive.
#' An MCA is run on all pairs of variables in the active dataset and we take first and strongest eigenvalue for each pair.
#' Values range from 0.5 to 1, where 1 signifies a perfect or near perfect overlap between sets of categories while 0.5 is the opposite - a near orthogonal relationship between the two variables.
#' While a eigenvalue of 1 is a strong candidate for intervention, probably exclusion of one of the variables, it is less clear what the lower bound is. But values around 0.8 are also strong candidates for further inspection.  

#' @param active a data.frame of factors
#' @param passive a character vector with the full or partial names of categories to be set as passive. Each element in passive is passed to a grep function.
#'
#' @return a tibble
#' @export
#'
#' @examples
#' example(soc.mca)
#' mca.eigen.check(active)

mca.eigen.check <- function(active, passive = "Missing"){
  
  get.eigen <- function(x, y, passive = "Missing"){
    d <- data.frame(x, y)
    r <- soc.mca(d, passive = passive)
    
    burt <- t(r$indicator.matrix.active) %*% r$indicator.matrix.active
    
    burt.s <- burt / diag(burt)
    diag(burt.s) <- 0
    max(burt.s)
    
    o <- c("First eigen" = r$eigen[1], "Passive categories" = length(r$names.passive), "Max overlap (%)" = max(burt.s))
    o
  }
  
  comb <- active %>% colnames() %>% combn(., 2, simplify = T) %>% t() %>% as_tibble()
  colnames(comb) <- c("x", "y")
  
  values           <- purrr::map2_df(.x = comb$x, .y = comb$y,  ~get.eigen(x = active[[.x]], y = active[[.y]], passive = passive))
  o                <- bind_cols(comb, values)
  o
}
