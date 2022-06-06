#' Read YAML config file
#'
#' Form inputs are specified via a YAML config file.
#'
#' TODO: Validate config after read.
#' @param yaml YAML configuration file.
#' @export
readConfig <- function(yaml) {
  yaml::read_yaml(yaml)
}

#' Set input config object in global env
#'
#' The config object needs to be available to provide parameters to form input funs.
#' This first calls upon `readConfig` to read the YAML file.
#' Depending on whether a global object `.F` already exists,
#' it will APPEND the new config OR return a config.
#'
#' TO DO: Warn if input namespaces confict.
#' TO DO: Better way to handle/check .F global object?
#' @inheritParams readConfig
#' @export
setConfig <- function(yaml) {
  conf <- readConfig(yaml)
  inputs <- conf$Inputs
  if(exists(".F")) {
    # check for attribute "sourcefile", otherwise .F may not be what we think it is
    if(is.null(attr(.F, "sourcefile"))) stop("Config may not have been set properly via `getConfig`.")
    # append to .F
    current <- get(".F")
    .F <- c(current, inputs)
    attr(.F, "sourcefile") <- c(attr(current, "sourcefile"), yaml)
    return(.F)
  } else {
    .F <- inputs
    attr(.F, "sourcefile") <- yaml
    return(.F)
  }
}

#' Get classes from a JSON-LD schema
#'
#' Note: Assumes schematic-generated json-ld file.
#' This looks up defined valid values (range) given the `@id` as encoded in schema.
#' @param jsonld  URL or path to local json-ld file from which schema will be read.
#' @param id Id (i.e. in `@id`) for which to get range values.
#' @param warn Whether to warn if there are issues in the schema.
#' @export
schemaRange <- function(jsonld, id, warn = FALSE) {
  schema <- jsonlite::read_json(jsonld)
  graph <- schema$`@graph`
  matches <- Filter(function(x) x$`@id` == id, graph)
  if(!length(matches)) stop("Id not found in reference schema!")
  if(warn && length(matches) > 1) warning("Duplicate ids found in schema, defaulting to using first.")
  range_ids <- sapply(matches[[1]]$`schema:rangeIncludes`, function(x) x$`@id`)
  range_labels <- Filter(function(x) x$`@id` %in% range_ids, graph) %>%
    sapply(function(x) x$`sms:displayName`)
  range_labels
}

#' Read YAML config file
#'
#' Form inputs are specified via a YAML config file.
#'
#' TODO: Validate config after read.
#' @param yaml YAML configuration file.
#' @export
readConfig <- function(yaml) {
  yaml::read_yaml(yaml)
}



