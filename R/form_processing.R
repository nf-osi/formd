#' Contextual handler for rendering input as HTML form or PDF doc
#' 
#' Given `mode` (which is expected to be set via `knitr` runtime parameters 
#' so it doesn't need to be passed in), this takes care of logic for 
#' reading in the correct input dependency and any additional processing for said input.
#' If `mode` == "html", we expect to read a `config_file`. 
#' If `mode` == "latex", we expect to read JSON data and process it to correct format.
#' 
#' @param config_file Path to YAML config file
#' @param data Path to JSON data.
#' @param mode The render mode.
#' @export
formInputContext <- function(config_file = NULL, data = NULL,
                            mode = knitr::opts_knit$get('rmarkdown.pandoc.to')) { 
  if(mode == "html") {
    .F <- setConfig(config_file)
    invisible(.F)
  } else if(mode == "latex") {
    .F <<- jsonlite::read_json(data)[[1]]$data
    .F <<- fromRadioButtonInput(.F)
    .F <<- fromTableInput(.F)
  }
}

#' Contextual handler for creating a form checklist
#' 
#' This only make sense for HTML version of the form.
#' @inheritParams formInputContext
#' @export
formChecklistContext <- function(config_file,
                                 mode = knitr::opts_knit$get('rmarkdown.pandoc.to')) {
  if(mode == "html") {
    Checklist <- readConfig(config_file)$Checklist
    if(!is.null(Checklist)) newChecklist(Checklist)
  }
}


#' Reconstruct radio button inputs
#'
#' Radio button inputs have two inputs for "Yes" and "No",
#' e.g. Input_1_Y and Input_1_N, both tied to Input_1.
#' Since the data returned will be Input_1 and either "Y"or "No" as the value,
#' we reconstruct "Input_1_*" by taking the value present in Input_1.
#' If it's "Y", "Input_1_Y" will be constructed, or "Input_1_N" if otherwise.
#' Currently the input specs have to make sure that input names match the
#' value option for reconstruction to work.
#' This is also currently hard-coded for Addendum inputs but should be generalized
#' for all radio button inputs (relying on the config to do so).
#'
#' @param .F Form data object.
#' @export
fromRadioButtonInput <- function(.F) {
  .F[[paste0("govSA_", .F$govSA)]] <- "TRUE"
  .F[[paste0("govAD2_A1_", .F$govAD2_A1)]] <- "TRUE"
  .F[[paste0("govAD2_A2_", .F$govAD2_A2)]] <- "TRUE"
  .F[[paste0("govAD2_A3_", .F$govAD2_A3)]] <- "TRUE"
  .F[[paste0("govAD2_A4_", .F$govAD2_A4)]] <- "TRUE"
  .F[[paste0("govAD2_A5_", .F$govAD2_A5)]] <- "TRUE"
  .F[[paste0("govAD2_B1_", .F$govAD2_B1)]] <- "TRUE"
  .F[[paste0("govAD2_B2_", .F$govAD2_B2)]] <- "TRUE"
  return(.F)
}


#' Reconstruct table inputs
#'
#' Inputs from table needs to be set into the parent as a `data.frame`.
#'
#' @export
#' @inheritParams fromRadioButtonInput
fromTableInput <- function(.F) {
  .F$depositTable <- data.frame(Label = unlist(.F$depositLabel),
                                 Assay = unlist(.F$depositAssay),
                                 Samples = unlist(.F$depositSamples),
                                 Species = unlist(.F$depositSpecies),
                                 UploadDeadline = unlist(.F$depositDeadline))
  return(.F)
}
