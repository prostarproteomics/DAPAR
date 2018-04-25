##' Build the text information to be saved after a process on an object of class \code{MSnSet}
##' 
##' @title  Build the text information to be saved
##' @param  name The name of the process in Prostar
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' buildLogText("Original", list(filename="foo.MSnset"))
buildLogText <- function(name, l.params){
    
    txt <- NULL
    switch(name, 
           Original = {txt <- getTextForNewDataset(l.params)},
           Filtering={txt <- getTextForFiltering(l.params)},
           Normalization = {txt <- getTextForNormalization(l.params)},
           Imputation = {txt <- getTextForImputation(l.params)},
           Aggregation = {txt <- getTextForAggregation(l.params)},
           anaDiff ={txt <- getTextForAnaDiff(l.params)},
           GOAnalysis = {txt <- getTextForGOAnalysis(l.params)}
    )
    
    return (txt)
}


##' Build the text information for a new dataset
##' 
##' @title  Build the text information for a new dataset
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForNewDataset(list(filename="foo.MSnset"))
getTextForNewDataset <- function(l.params){
    txt <- paste("Open : file ",l.params$filename, " opened")
    return (txt)
}


##' Build the text information for the filtering process
##' 
##' @title  Build the text information for the filtering process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForFiltering(list(mvFilterType="wholeMatrix",mvThNA=3))
getTextForFiltering <- function(l.params){ 
    # str(l.params) = list(mvFilterType ,
    #                 mvThNA,
    #                 stringFilter.df)
    
    txt <- NULL
    
    if (l.params$mvFilterType != "None"){
        txt <- paste(txt, "MV filter with ", l.params$mvFilterType, ", and minimal nb of values per lines = ", l.params$mvThNA,".\n")
    }
    if (!is.null(l.params$stringFilter.df) && nrow(l.params$stringFilter.df) > 1){
        txt <- paste(txt, "Text filtering based on", l.params$stringFilter.df$Filter)
    }
    
    return (txt)
}




##' Build the text information for the Normalization process
##' 
##' @title  Build the text information for the Normalization process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForNormalization(list(method="Sum by columns"))
getTextForNormalization <- function(l.params){ 
    
    # str(l.params) = list(method ,
    #                 type,
    #                 varReduction,
    #                 quantile,
    #                 otherQuantile)
    
    
    txt <- NULL
    if (l.params$method=="None") return (NULL)
    else if (l.params$method == "Global quantile alignment"){
        txt <- paste(txt,l.params$method)
    }
    
    else if  (l.params$method == "Sum by columns"){
        txt <- paste(txt,l.params$method, " - ", l.params$type)
    }
    
    else if  (l.params$method == "Mean Centering"){
        txt <- paste(txt,l.params$method, " - ", l.params$type)
        if ( isTRUE(l.params$varReduction )){
            txt <- paste(txt,"with variance reduction")
        }
    }
    
    else if  (l.params$method == "Quantile Centering"){
        txt <- paste(txt,l.params$method, " - ", l.params$type)
        quant <- ifelse (l.params$quantile == "Other",l.params$otherQuantile, l.params$quantile)
        txt <- paste(txt,"with quantile =", quant)
    }
    
    return (txt)
}



##' Build the text information for the Imputation process
##' 
##' @title  Build the text information for the Imputation process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForImputation(list(POV_algorithm="slsa",MEC_algorithm="fixedValue", MEC_fixedValue = 0))
getTextForImputation <- function(l.params){ 
    # l.params <- list(
    #    POV_algorithm,
    #    POV_detQuant_quantile,
    #    POV_detQuant_factor,
    #    POV_KNN_n,
    #    MEC_algorithm,
    #    MEC_detQuant_quantile,
    #    MEC_detQuant_factor,
    #    MEC_fixedValue)
    
    
    
    txt <- NULL
    if (!is.null(l.params$POV_algorithm)){
        if (l.params$POV_algorithm=="None") {
            return (NULL)
        } else {
            txt <- paste(txt,"POV imputed with ", l.params$POV_algorithm)
        }
        
        switch(l.params$POV_algorithm,
               slsa = {},
               detQuantile = {txt <- paste(txt,"quantile= ", l.params$POV_detQuant_quantile, 
                                           ", factor=",l.params$POV_detQuant_factor)
               },
               KNN = {txt <- paste(txt,"neighbors= ", l.params$POV_KNN_n)}
        )
    }
    
    if (!is.null(l.params$MEC_algorithm)){
        if (l.params$MEC_algorithm=="None") {
            return (NULL)
        } else {
            txt <- paste(txt,"POV imputed with ", l.params$MEC_algorithm)
        }
        
        switch(l.params$MEC_algorithm,
               detQuantile = {txt <- paste(txt,"quantile= ", l.params$MEC_detQuant_quantile, 
                                           ", factor=",l.params$MEC_detQuant_factor)
               },
               fixedValue = {txt <- paste(txt,"fixed value= ", l.params$MEC_fixedValue)}
        )
        
    }
    
    
    return (txt)
    
}


##' Builds the text information for the Aggregation process
##' 
##' @title  Build the text information for the Aggregation process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForAggregation(list(POV_algorithm="slsa",MEC_algorithm="fixedValue", MEC_fixedValue = 0))
getTextForAggregation <- function(l.params){ 
    
    # l.params <- list(withSharedPeptides,
    #                  agregMethod,
    #                  proteinId,
    #                  topN
    #                 )
    
    txt <- NULL
    if (is.null(l.params$proteinId) || (l.params$proteinId =="None")) { return (NULL)}
    
    txt <- paste(txt, "proteinId:", l.params$proteinId, " ")
    if (!is.null(l.params$agregMethod) && (l.params$agregMethod =="none")) {
        txt <- paste(txt, "method:", l.params$agregMethod," ")
        if (l.params$agregMethod =="sum on top n"){
            txt <- paste(txt, "n=", l.params$topN," ")
        }
    }
    
    if (!is.null(l.params$withSharedPeptides) ){
        term <- ifelse(isTRUE(l.params$withSharedPeptides), "with", "without")
        txt <- paste(txt, term," shared peptides")
    }
    return (txt)
    
}


##' Build the text information for the Aggregation process
##' 
##' @title  Build the text information for the Aggregation process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForAnaDiff(list(design="OnevsOne",method="Limma"))
getTextForAnaDiff <- function(l.params){ 
    
    # l.params <- list(design,
    #                  method,
    #                  ttest_options,
    #                  th_logFC,
    #                  AllPairwiseCompNames,
    #                  comp,
    #                  th_pval,
    #                  calibMethod,
    #                  fdr,
    #                  swapVolcano,
    #                  filterType,
    #                  filter_th_NA,
    #                  numValCalibMethod)
    
    
    
    txt <- NULL                 
    
    if (is.null(l.params$design) || (l.params$design =="None")) { return (NULL)}
    
    txt <- paste(txt, "design:", l.params$design, ", method:", l.params$method, "<br>")
    
    if (!is.null(l.params$ttest_options)){
        txt <- paste(txt, "t-test:", l.params$ttest_options, "<br>")
    } 
    
    txt <- paste(txt, "Threshold logFC = ", l.params$th_logFC, "<br>")
    
    if (!is.null(l.params$comp)){
        txt <- paste(txt, "Comparison: ", l.params$comp)
        
    }
    
    if (!is.null(l.params$filterType) && (l.params$filterType != "None")){
        txt <- paste(txt, "Filter type: ", l.params$filterType)
        txt <- paste(txt, "min nb values / lines: ", l.params$filter_th_NA)
    }
    
    if (!is.null(l.params$swapVolcano) && (isTRUE(l.params$swapVolcano))){
        txt <- paste(txt, "Swap volcano")
    }
    
    if (!is.null(l.params$calibMethod) ){
        txt <- paste(txt, "Calibration with ", l.params$calibMethod)
        if (!is.null(l.params$numValCalibMethod)){
            txt <- paste(txt, "num value = ", l.params$numValCalibMethod)
        }
    }
    
    if (!is.null(l.params$th_pval)){
        txt <- paste(txt, "Threshold pvalue = ", l.params$th_pval)
    }
    
    return (txt)
}


##' Build the text information for the Aggregation process
##' 
##' @title  Build the text information for the Aggregation process
##' @param l.params A list of parameters related to the process of the dataset
##' @return A string
##' @author Samuel Wieczorek
##' @examples
##' getTextForGOAnalysis(list())
getTextForGOAnalysis <-  function(l.params){
  { 
      if (is.null(l.params$whichGO2Save)){return(NULL)}
      switch(l.params$whichGO2Save,
           Both =
              {
              text <- paste(textGOParams,", GO grouping for level(s):",
                           input$GO_level,
                           ", GO enrichment with",
                           ", adj p-value cutoff = ", input$pvalueCutoff,
                           ", universe =", input$universe, sep= " ")
              },
           Enrichment ={
             text <- paste(textGOParams, " GO enrichment with",
                           ", adj p-value cutoff = ", input$pvalueCutoff,
                           ", universe =", input$universe, sep= " ")
              },
           Classification= {
             text <- paste(textGOParams,", GO grouping for level(s):",
                           input$GO_level,sep=" ")
            }
  )
  }
}