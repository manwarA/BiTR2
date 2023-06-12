
#' While converting the names, BiTr usually returns a df with two columns, "fromType" & "toType", and it is oftenly difficult to match them
#' to the original dataset. This is a simple function around that concept that BiTr should bind to converted IDs back to the original df 
#' for easier downstream analysis

#' Dependencies:
#'  This package depends on the ClusterProfiler (4.4.4) function of BiTR, that can
#'  be installed using BiocManager::install("clusterProfiler")
#'  and package for Genome wide annotation for human (default, "org.Hs.eg.db"),
#'  and can be installed using BiocManager::install("org.Hs.eg.db")

#' @param input an R object/data frame that can be coercible to df
#' @param colName string; column name containing the ids. 
#' @param fromType string; the name of column that has to be converted; it must be one of types supported by BiTR
#' @param toType String; desired output; it must be one of types supported by BiTR
#' @param rm.duplicates Boolean; Duplicated names to be removed or not. 
#' @param moveToFirst if True, the new column will be moved to be the first column in the new df; default is FALSE

'%notin' <- Negate("%in%")

organism = "org.Hs.eg.db"
 

idTypes <- c('ACCNUM', 'ALIAS', 'ENSEMBL', 'ENSEMBLPROT', 'ENSEMBLTRANS', 'ENTREZID',
             'ENZYME', 'EVIDENCE', 'EVIDENCEALL', 'GENENAME', 'GENETYPE', 'GO',
             'GOALL', 'IPI', 'MAP', 'OMIM', 'ONTOLOGY', 'ONTOLOGYALL', 'PATH', 
             'PFAM', 'PMID', 'PROSITE', 'REFSEQ', 'SYMBOL', 'UCSCKG', 'UNIPROT')


#' The following function was an attempt to identify the ID name, however, it is 
#' reasonably difficult to guess the correct name, in case the provided ID is incorrect.
matchID <- function(unknown) {
    
    unknown = grep(unknown, idTypes, value = TRUE)
    unknown
    }

#' @export 
bitr2 <- function(df,
                  colName,
                  fromType,
                  toType,
                  moveToFirst = FALSE,
                  rm.duplicates = FALSE) {
    
    # df should be coeracble to type data frame
    if ( !(class(df) == "data.frame" || attr(as.data.frame(df),  "class" ))) 
    { print("data is not convertable to data frame type")
        break }
    
    # check whether the provided col name is valid
    if (colName != 0 && colName %notin% colnames(df) ) {
        message("Please provide a valid col id")
        break 
        } else if (colName == 0)
            {
            idColumn = row.names(df) 
            } else {
                idColumn = df[[colName]]
            }
        
    
    #upperType = sapply(list("fromType", "toType"), toupper)
    
    #for (i in upperType){ 
    #    if (i %notin% idTypes) {
    #        cat(i, "is not an acceptable ID types; please provide ID from one of: ", idTypes, sep = " ")
    
     #   }
      #  break
    #}
    
    
    fromType = toupper(fromType)
    #cat(fromType)
    if ( fromType %notin% idTypes ){
        message("fromType is not an acceptable ID types; please provide ID from 
            one of: ", idTypes)
        break
    }

    toType = toupper(toType)
    #cat(toType)
    if ( toType %notin% idTypes ){
        message("toType is not an acceptable ID types; please provide ID from 
            one of: ", idTypes)
        break
    }
    
    #cat(idColumn)
    
convertedID <- clusterProfiler::bitr(idColumn,
                                     fromType= fromType, 
                                     toType  = toType,
                                     OrgDb   = organism,
                                     drop=TRUE)

convertedID = as.data.frame(convertedID)
    print(head(convertedID))
    if (colName == 0) {
        df = merge(df, convertedID, by.x = 0, by.y= fromType, all.x = TRUE)
    } else {
        df = merge(df, convertedID, by.x = colName, by.y = fromType, all.x = TRUE)
    }

    if (rm.duplicates){
        df = df[ !duplicated(df$toType), ] 
    }
    
    if (moveToFirst) {
        df = df %>% select(toType, everything())
    }
    #df <- transform(df, logFC = as.numeric(logFC), ENTREZID = as.numeric(ENTREZID))
    #df <- df[complete.cases(df),]

    #cat("after removing NA: ", dim(df))
    
    df

}
