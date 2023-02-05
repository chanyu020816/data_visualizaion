# tab 01 - 資料
tabItem(
  tabName = "page01_data",
  fluidRow(
    box(
      width = 5,
      headerBorder = FALSE,
      collapsible = FALSE,
      tabsetPanel(
        tabPanel(
          "Data",
          fileInput(
            inputId = "page01_file1",
            "Data Upload：",
            buttonLabel = "Browse",
            placeholder = "csv, tsv, xlsx, ods Files",
            accept = c(".csv", ".tsv", ".xlsx", ".ods")
          ),
          uiOutput("page01_sheet_choices"),
          radioButtons(
            "encoding",
            "Encoding:",
            choices = c("UTF-8", "Big-5"),
            selected = "UTF-8",
            inline = TRUE
          ),
          uiOutput("encoding_problem"),
          splitLayout(
            uiOutput("rowNums"),
            uiOutput("colNums")
          ),
          h6(strong("Data_Summary")),
          uiOutput("data_summary")
        ),
        tabPanel(
          "Variables",
          uiOutput("page01_variables")
        ),
        tabPanel(
         "Missing Value",
          uiOutput("missvalue_select")
        )
      )
      # 上傳資料
    ),
    box(
      width = 7,
      headerBorder = FALSE,
      collapsible = FALSE,
      title = "",
      uiOutput("page01_ui_tables")
    )
  )
)
