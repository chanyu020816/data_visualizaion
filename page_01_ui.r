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
          "資料",
          fileInput(
            inputId = "page01_file1",
            "上傳資料：",
            buttonLabel = "瀏覽",
            placeholder = "csv, tsv, xlsx, ods檔案",
            accept = c(".csv", ".tsv", ".xlsx", ".ods")
          ),
          uiOutput("page01_sheet_choices"),
          radioButtons(
            "encoding",
            "請選擇資料編碼:",
            choices = c("UTF-8", "Big-5"),
            selected = "UTF-8",
            inline = TRUE
          ),
          uiOutput("encoding_problem"),
          splitLayout(
            uiOutput("rowNums"),
            uiOutput("colNums")
          ),
          h6(strong("資料摘要")),
          uiOutput("data_summary")
        ),
        tabPanel(
          "變數",
          uiOutput("page01_variables")
        ),
        tabPanel(
          "遺失值",
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
