my_packages = c(
    "shiny",
    "bs4Dash",
    "DT",
    "shinycssloaders",
    "vroom",
    "ggplot2",
    "plotly",
    "shinyWidgets",
    "dplyr",
    "tidyr",
    "rlang",
    "tidyverse",
    "shinyalert",
    "colourpicker",
    "readxl",
    "readODS",
    "DMwR2",
    "scales",
    "stringrrequireshowtext"
)
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}
invisible(sapply(my_packages, install_if_missing))
# test