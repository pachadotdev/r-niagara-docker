#' Check for compiler tools
#' @details This function checks for the presence of compiler tools.
#' @export
compiler <- function() {
  output <- utils::capture.output(pkgbuild::check_build_tools(debug = TRUE, quiet = FALSE))

  tmp <- tempfile()

  writeLines(output, tmp)

  readLines(tmp)[2]
}
