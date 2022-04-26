#' RIA: Render Input Appropriately
#'
#' @param x Either an input specification (for HTML) or data value to render (for PDF).
#' @param mode (Optional) Render context, which can be extracted at run from variable set by `knitr`.
#' @export
RIA <- function(x, mode = knitr::opts_knit$get('rmarkdown.pandoc.to')) {
  if(mode == "latex") {
    pdfProcess(x)
  } else if(mode == "html") {
    newInput(x)
  } else {
    message("Input not processed:", x)
  }
}

#' Process to PDF
#'
#' @param x Input value.
#' @keywords internal
pdfProcess <- function(x) {
  if(is.null(x)) return("\\detokenize{_____}")
  if(class(x) %in% "data.frame") return(knitr::kable(x))
  if(length(x) == 1 && x %in% c("TRUE", "on")) return("\\detokenize{__X__}")
  # otherwise, response is some text
  if(length(x) == 1 && x == "") return("\\detokenize{_____}")
  if(length(x) > 1 && "hidden" %in% x) return("")
  if(length(x) > 1) return(paste(x, collapse = ", "))
  words <- strsplit(x, " ")[[1]]
  if(length(words) > 10) {
    sprintf("\\parbox{6in}{\\detokenize{%s}}", x)
  } else {
    sprintf("\\detokenize{%s}", x)
  }
}

#' Create HTML form input
#'
#' Handles common types `c("select", "text", "textarea", "date", "number", "email")`
#' as well as specially defined types called `table-inputs` and `select-schema`.
#'
#' @param input List containing input config.
newInput <- function(input) {
  type <- input$type
  if(!length(type)) stop("Input not defined in config!")
  switch(type,
         "table-inputs" = tableInputWrapper(input),
         "select-schema" = schemaSelectInput(input),
         "select" = customSelectInput(input),
         "textarea" = htmltools::div(
           htmltools::tags$textarea(name = input$name,
                                    form = input$form,
                                    class = input$class,
                                    placeholder = input$placeholder)),
         do.call(htmltools::tags$input, input)
         )
}

#' Batch dispatch to create HTML form inputs
#'
#' @keywords internal
newInputs <- function(inputs) {
  lapply(inputs, newInput)
}

#' Create form elements with table layout
#'
#' Sometimes it is highly preferable to organize repeated elements in a table,
#' similar to a banking form where one might have multiple rows each with columns:
#' bank account name, bank account type, bank account number.
#'
#' @param tabinput List containing specifications for table inputs.
#' @param nrow Number of rows, i.e. how many times to repeat.
#' @param removable Whether rows can be deleted, by default TRUE.
tableWithInput <- function(tabinput, nrow = 3, removable = TRUE) {
  inputs <- tabinput$inputs
  id <- tabinput$id
  rows <- htmltools::tagList()
  for(i in 1:nrow) {
    rows[[i]] <- newInputs(inputs) %>%
      newCell() %>%
      newRow(removable = removable)
  }
  rows <- rows %>% htmltools::tags$tbody()
  hcells <- lapply(inputs, function(input) newCell(input$display, header = TRUE))
  header <- hcells %>% newRow(removable = F) %>% htmltools::tags$thead()
  table <- htmltools::tags$table(id = id) %>% htmltools::tagAppendChildren(header, rows)
  table
}

#' Create button to add a row
#'
#' @inheritParams tableWithInput
#' @keywords internal
addRowBtn <- function(tabinput) {
  id <- tabinput$id
  stopifnot(!is.null(id))
  htmltools::tags$button(
    htmltools::tags$i(class = "glyphicon glyphicon-plus"), "entry",
    class = "add-button",
    onClick = sprintf("addRow('%s')", id)
  )
}

#' Wrapper to render table input
#'
#' @inheritParams tableWithInput
tableInputWrapper <- function(tabinput) {
  add <- tabinput$add # TRUE creates a button allowing new rows to be added to table
  tb <- tableWithInput(tabinput)
  btn <- if(add) addRowBtn(tabinput) else NULL
  htmltools::div(class = "table-input-container",
    htmltools::div(tb), btn
  )
}

#' Wrap content in a table cell
#'
#' @param content Content that becomes inner HTML of the cell.
#' @param header Whether this cell is part of a table header, default `FALSE`.
newCell <- function(content, header = FALSE) {
  cell <- lapply(content, function(x) if(header) htmltools::tags$th(x) else htmltools::tags$td(x))
  cell
}


#' Wrap cells in table row
#'
#' @param cells A list or taglist of table cell elements.
#' @param removable Whether this row is removable, which appends a button with
#' the functionality.
newRow <- function(cells, removable = TRUE) {
  row <- htmltools::tags$tr() %>% htmltools::tagAppendChildren(cells)
  if(removable) {
    # optional element at row end to remove the row
    x <- htmltools::tags$td(
      htmltools::tags$i(class = "glyphicon glyphicon-minus-sign",
             onclick = "removeRow(this);")
            )
    row <- row %>% htmltools::tagAppendChild(x)
  }
  row
}

#' Create select input with controlled values from schema
#'
#' Create a select input where options are schema-based,
#' i.e. defined by a specified class such as "Assay"
#' @inheritParams newInput
schemaSelectInput <- function(input) {
  options <- schemaRange(input$schema, input$range)
  customSelectInput(input, options)
}

#' Create custom select input
#'
#' @inheritParams newInput
#' @param options Vector of select options. If not given, will be extracted from input specs.
customSelectInput <- function(input, options = NULL) {
  select <- do.call(htmltools::tags$select, input)
  if(!is.null(input$multiple) && input$multiple == TRUE) select %>% htmltools::tagAppendAttributes("multiple" = NA)
  if(is.null(options)) options <- input$options # TO DO: Warn if no options from either
  if(!is.null(input$sort) && input$sort == TRUE) options <- sort(options) # alphabetize
  if(!is.null(input$blankstr) && input$blankstr == TRUE) options <- c("", options) # add "" default value
  options <- lapply(options, function(opt) htmltools::tags$option(value = opt, opt))
  select %>% htmltools::tagAppendChildren(options)
}

#' Create a checklist
#'
#' Wrapper to create a checklist element according to given configuration.
#'
#' @param config List with checklist configuration.
#' @export
newChecklist <- function(config) {
  items <- sapply(config$items, function(x) x$name)
  check_items <- lapply(items, makeCheckItem)
  divChecklist(check_items)
}

#' Create checklist parent element
#'
#' @keywords internal
divChecklist <- function(...) {
  htmltools::div(id = "checklist",
                 class = "note-card noprint",
                 htmltools::h4("My checklist")) %>%
    htmltools::tagAppendChildren(...)
}

#' Create checklist item
#'
#' @keywords internal
makeCheckItem <- function(name = "Item 1", class = "check-item") {
  id <- make.names(name)
  htmltools::div(
    htmltools::tags$input(type = "checkbox", name = name, class = class),
    htmltools::tags$label(`for` = id, name)
  )
}

#' Element to submit form
#'
#' Currently this is just a shorthand that calls`formSubmitButton` because
#' the only configuration allowed is a button.
#' @param config_submit List containing config for submit element.
#' @export
formSubmit <- function(config_submit) {

  formSubmitButton(id = config_submit$form,
                   action = config_submit$action)
}

#' Create button to submit form
#'
#' @param id Id of the form.
#' @param action Form action URL (defaults to a test URL).
#' @param label Button label.
formSubmitButton <- function(id,
                             action = "https://submit-form.com/echo",
                             label = "Submit"
                             ) {
  htmltools::tags$form(id = id,
                       method = "post",
                       action = action,
            htmltools::tags$button(type = "submit", label, class = "submit-button")
  )
}

