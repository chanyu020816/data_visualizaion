library(shiny)
library(bs4Dash)
library(DT)
library(shinycssloaders)
library(vroom)
library(ggplot2)
library(plotly)
library(shinyWidgets)
library(dplyr)
library(tidyr)
library(rlang)
library(tidyverse)
library(shinyalert)
library(colourpicker)
library(readxl)
library(readODS)
library(DMwR2)
library(scales)
library(stringr)
require(showtext)
library(googlesheets4)
library(gargle)
# 載入中文字體
showtext_auto()
font_add("msjh", "./msjh.ttc")
# gs4_auth(cache = ".secrets", email = TRUE, use_oob = TRUE)

# gs4_auth(
#   email = "trafalgarlaw0816@gmail.com",
#   path = jsonsecret,
#   scopes = "https://www.googleapis.com/auth/spreadsheets",
#   cache = gargle::gargle_oauth_cache(),
#   use_oob = gargle::gargle_oob_default(),
#   token = ".secret"
# )
?print
