#' Draft DSP with recommended bundle
#' 
#' This is a convenience function to bring all the "standard" 
#' paperwork templates into the draft space. 
#' It is updated to reflect the latest concept of what is standard, 
#' i.e. some sections might be added or removed from this bundle over time. 
#' 
#' @param dir Directory folder to create; forms will be organized here and it will be set as working directory. 
#' @param verbose Whether to be verbose.
#' @export
draftStandardDSP <- function(dir, verbose = TRUE) {
  wd <- getwd()
  if(verbose) message("Creating template bundle in '", dir, "'...")
  dir.create(dir)
  setwd(dir)
  standard <- c("DSP_Standard", "DSP_Core", "Section_Commitment", "Section_Data_Licensing", "Section_Data_Sharing")
  for(template in standard) {
    rmarkdown::draft(file = template, template = template, package = "formd", edit = FALSE)
  }
  if(verbose) message("Done. Happy drafting!")
}