# BiTR2
Biological ID translator with merging to the original data frame
 While converting the names, BiTr usually returns a df with two columns, "fromType" & "toType", and it is oftenly difficult to match them
 to the original dataset. This is a simple function around that concept that BiTr should bind to converted IDs back to the original df 
 for easier downstream analysis

Dependencies:
This package depends on the ClusterProfiler (4.4.4) function of BiTR, that can
  be installed using BiocManager::install("clusterProfiler")
  and package for Genome wide annotation for human (default, "org.Hs.eg.db"),
  and can be installed using BiocManager::install("org.Hs.eg.db")

@param input an R object/data frame that can be coercible to df
@param colName string; column name containing the ids. 
@param fromType string; the name of column that has to be converted; it must be one of types supported by BiTR
@param toType String; desired output; it must be one of types supported by BiTR
@param rm.duplicates Boolean; Duplicated names to be removed or not. 
@param moveToFirst if True, the new column will be moved to be the first column in the new df; default is FALSE
