# tab 03 - 長條圖
tabItem(
  tabName = 'ranking_barChart',
  fluidRow(
    box(
      width = 4,
      headerBorder = FALSE,
      collapsible = FALSE,
      tabsetPanel(
        # 變數分頁
        tabPanel(
          'Variable',
          # 選擇x軸變數(類別)
          uiOutput('page03_ui_discrete_x_select1'),
          # 選擇y軸變數(連續)
          uiOutput('page03_ui_continuous_select1'),
          # 選擇群組變數(類別)
          uiOutput('page03_ui_discrete_group_select1'),
          # 選呈現方式(總和,平均數,最大值,最小值)
          uiOutput("barchart_fun_select1")
        ),
        # 外觀分頁
        tabPanel(
          'Appearance',
          # 圖標題
          textInput('page03_ui_title_text1', label = 'Title', value = 'Bar Chart'),
          splitLayout(
            # X軸標題
            uiOutput('page03_ui_x_title_text1'),
            # Y軸標題
            uiOutput('page03_ui_y_title_text1')
          ),
          # 字體尺寸設定
          h5('Font Size:', style = 'font-Weight: bold; font-size: 16px;'),
          # 選擇圖標題字體尺寸
          numericInput('page03_ui_title_num1', label = 'Title', value = 20),
          splitLayout(
            # 選擇軸標題字體尺寸
            numericInput(
              'page03_ui_axis_title_num1',
              label = HTML(
                'Axis Title',
                as.character(actionLink(
                  'page03_actionLink_axis_title',
                  label = '',
                  icon = icon(name = 'question-circle', lib = 'font-awesome', 'fa-xs')
                  )
                )
              ),
              value = 15
            ),
            # 選擇軸標籤字體大小
            numericInput(
              'page03_ui_axis_label_num1',
              label = HTML(
                'Axis Label',
                as.character(actionLink(
                  'page03_actionLink_axis_label',
                  label = '',
                  icon = icon(name = 'question-circle', lib = 'font-awesome', 'fa-xs')
                  )
                )
              ),
              value = 10
            )
          ),
          # 選擇軸標籤角度
          sliderInput(
            'page03_ui_axis_angle_slider1',
            label = 'Axis-lable Angle:',
            min = 0,
            max = 90,
            value = 90
          ),
          # 顏色
          checkboxInput('page03_colours_check1', label = 'Color Customier'),
          uiOutput('page03_colours'),
          splitLayout(
            # 下載圖片的寬
            numericInput(
              'page03_ui_download_width_num1',
              label = "Width(Download):",
              value = 600
            ),
            # 下載圖片的高
            numericInput(
              'page03_ui_download_height_num1',
              label = "Height(Download):",
              value = 400
            )
          )
        )
      )
    ),
    box(
      width = 8 ,
      headerBorder = FALSE,
      collapsible = FALSE,
      # loading 圖示
      withSpinner(
        plotOutput('page03_barChart', height = '100%'),
        color = '#0dc5c1'
        ),
      # 下載
      column(12, align = 'right', 
        uiOutput("page03_download_button")
      )
    )
  )
)