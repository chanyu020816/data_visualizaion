# tab 02 - 散佈圖
tabItem(
  tabName = "correlation_scatter",
  fluidRow(
    box(
      width = 4,
      headerBorder = FALSE,
      collapsible = FALSE,
      tabsetPanel(
        tabPanel(
          "Variable",
          # 變數 X
          uiOutput("page02_ui_select_x"),
          # 變數 Y
          uiOutput("page02_ui_select_y"),
          # 其他變數選擇結果
          uiOutput("page2_OthersVar")
        ),
        tabPanel(
          "Regression"
        ),
        tabPanel(
          "Appearance",
          # 輸入標題
          textInput("page2_title", "Title", value = "Scatter Plot"),
          splitLayout(
             # X軸標題
            uiOutput('page02_ui_x_title'),
            # Y軸標題
            uiOutput('page02_ui_y_title')
          ),
          h6('Font Size:', style = 'font-Weight: bold; font-size: 16px;'),
          # 選擇圖標題字體大小
          numericInput('page02_ui_title_num1', label = 'Title', value = 20),
          splitLayout(
            # 選擇軸標題字體大小
            numericInput(
              'page02_ui_axis_title_num1',
              'Axis Title ',
              value = 15
            ),
            # 選擇軸標籤字體大小
            numericInput(
              'page02_ui_axis_label_num1',
              'Axis Label',
              value = 10
            )
          ),
          # 顏色
          uiOutput("page02_colour"),
          uiOutput("page02_choose_color"),
          sliderInput(
            "dot_alpha",
            "Opacity (dot)：",
            min = 0, max = 1,
            value = 0.5
          ),
          uiOutput("page02_choose_size"),
          splitLayout(
            # 下載圖片的寬
            numericInput('page02_download_width', label = "Width(Download):", value = 600),
            # 下載圖片的高
            numericInput('page02_download_height', label = "Heigh(Download):", value = 400)
          )
        )
      )
    ),
    box(
      width = 8,
      headerBorder = FALSE,
      collapsible = FALSE,
      # loading 圖示
      withSpinner(
        plotOutput("page02_scatter", height = "100%"),
        color = "#0dc5c1"
      ),
      # 下載按鈕
      column(12, align = "right", id = "button",
             downloadButton("download", "Download"))
    )
  )
)
