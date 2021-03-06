% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{setConfig}
\alias{setConfig}
\title{Set input config object in global env}
\usage{
setConfig(yaml)
}
\arguments{
\item{yaml}{YAML configuration file.}
}
\description{
The config object needs to be available to provide parameters to form input funs.
This first calls upon \code{readConfig} to read the YAML file.
Depending on whether a global object \code{.F} already exists,
it will APPEND the new config OR return a config.
}
\details{
TO DO: Warn if input namespaces confict.
TO DO: Better way to handle/check .F global object?
}
