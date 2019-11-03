fancyRpartPlot <- function(model, main="", ...)
{
  # Note that rpart.plot requires rpart >= 3.1.48 which is not
  # available on Windows R 2.12.2!
  
  require("rpart.plot")
  require("RColorBrewer")
  
  num.classes <- length(attr(model, "ylevels"))
  
  # Generate a colour pallete, with a range of 5 (palsize) colours for
  # each of the 6 (numpals) palettes. The pallete is collapsed into
  # one list. We index it according to the class.
  
  numpals <- 6
  palsize <- 5
  pals <- c(brewer.pal(9, "Greens")[3:7],
            brewer.pal(9, "Blues")[2:6],
            brewer.pal(9, "Oranges")[2:6],
            brewer.pal(9, "Purples")[2:6],
            brewer.pal(9, "Reds")[2:6],
            brewer.pal(9, "Greys")[2:6])
  
  # Extract the scores/percentages for each of the nodes for the
  # majority decision.  The decisions are in column 1 of yval2 and the
  # percentages are in the final num.classes columns.
  
  yval2per <- -(1:num.classes)-1
  per <- apply(model$frame$yval2[,yval2per], 1, function(x) x[1+x[1]])
  
  # The conversion of a tree in CORElearn to an rpart tree results in these
  # being character, so ensure wwe have numerics.
  
  per <- as.numeric(per)
  
  # Calculate an index into the combined colour sequence. Once we go
  # above numpals * palsize (30) start over.
  
  col.index <- ((palsize*(model$frame$yval-1) +
                   trunc(pmin(1 + (per * palsize), palsize))) %%
                  (numpals * palsize))
  
  # Define the contents of the tree nodes.
  
  my.node.fun <- function(x, labs, digits, varlen)
    paste(labs, "\n", round(100*per), "% of ",
          format(x$frame$n, big.mark=","),
          sep="")
  
  # Generate the plot and title.
  
  prp(model, type=1, extra=0,
      box.col=pals[col.index],
      nn=TRUE, varlen=0, shadow.col=0,
      node.fun=my.node.fun, ...)
  
  title(main=main,
        sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), 
                  Sys.info()["user"]))
}