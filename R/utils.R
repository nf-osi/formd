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

#' Create config object in global env
#'
#' The config object needs to be available to provide parameters to form input functions.
#' This first calls upon `readConfig` to read the YAML file.
#' However, depending on whether a global object `.F` aready exists,
#' it will append the new config.
#'
#' TO DO: Warn if input namespaces confict.
#' TO DO: Better way to handle/check .F global object?
#' @inheritParams readConfig
#' @export
getConfig <- function(yaml) {
  conf <- readConfig(yaml)
  inputs <- conf$Inputs
  if(exists(".F")) {
    # check for attribute "sourcefile", otherwise .F may not be what we think it is
    if(is.null(attr(".F", "sourcefile"))) stop("Config may not have been set properly via `getConfig`.")
    # append to .F
    .F <- get(.F)
    .F <- c(.F, inputs)
    return(.F)
  } else {
    attr(inputs, "sourcefile") <- yaml
    return(inputs)
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
  if(length(matches) > 1) warning("Duplicate ids found in schema, defaulting to using first.")
  range_ids <- sapply(matches[[1]]$`schema:rangeIncludes`, function(x) x$`@id`)
  range_labels <- Filter(function(x) x$`@id` %in% range_ids, graph) %>%
    sapply(function(x) x$`sms:displayName`)
  range_labels
}
