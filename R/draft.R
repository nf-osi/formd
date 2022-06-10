#' Draft DSP with recommended bundle
#' 
#' Bring all the "standard" template components into the draft space. 
#' This should reflect the latest concept of what is standard, 
#' i.e. some sections might be added or removed from this bundle over time. 
#' 
#' @param version Desired version of document; defaults to latest, which is v2.
#' @param verbose Whether to be verbose.
#' @export
draftStandardDSP <- function(version = c("v2", "v1"), verbose = TRUE) {
  wd <- getwd()
  dir <- dsp_version <- paste("DSP_Standard", version, sep = "_")
  dir.create(dir)
  setwd(dir)
  if(verbose) message("Creating template bundle '", dir, "'...")
  
  if(version == "v1") {
    standard <- c(dsp_version, "DSP_Core", 
                  "Section_Commitment", "Section_Data_Licensing", "Section_Data_Sharing", 
                  "Sensitivity_Assessment", "Addendum_1", "Addendum_2")
  }
  if(version == "v2") {
    standard <- c(dsp_version, "DSP_Core", 
                  "Section_Commitment", "Section_Data_Licensing", "Section_Data_Sharing")
  }
  
  for(template in standard) {
    rmarkdown::draft(file = template, 
                     template = template, 
                     package = "formd", 
                     edit = FALSE)
  }
  if(verbose) message("Done. Happy drafting!")
}
