# tab 04 - 折線圖
tabItem(
  tabName = 'evolution_lineplot',
  fluidRow(
    box(
      width = 4,
      headerBorder = FALSE,
      collapsible = FALSE,
      # 分頁
      tabsetPanel(
        tabPanel(
          'Variable',
          # 選擇x軸變數(類別)
          uiOutput('page04_ui_discrete_select1'),
          # 選擇群組變數(類別)
          uiOutput('page04_ui_group_select1'),
          # 是否標準化
          checkboxInput('page04_ui_checkbox1', label = 'Standardize'),
          # 選呈現方式(總和,平均數,最大值,最小值)
          selectInput(
            'page04_ui_fun_select1',
            # 說明視窗
            label = HTML(
              'Measurement',
              ""
            ),
            choices = c("Sum" = '總和', "Mean" = '平均數', "Max" = '最大值', "Min" = '最小值'),
            selected = '平均數'
          )
        ),
        tabPanel(
          'Appearance',
          # 圖標題
          textInput('page04_ui_title_text1', label = 'Title', value = 'Line Plot'),
          splitLayout(
            # X軸標題
            uiOutput('page04_ui_x_title_text1'),
            # Y軸標題
            textInput('page04_ui_y_title_text1', label = 'Y-axis Title', value = 'amount')
          ),
          h5('Font Size:', style = 'font-Weight:bold; font-size:16px;'),
          # 選擇圖標題字體尺寸
          numericInput('page04_ui_title_num1', label = 'Title', value = 20),
          splitLayout(
            #選擇軸標題字體尺寸
            numericInput(
              'page04_ui_axis_title_num1',
              label = HTML(
                'Axis Title',
                as.character(actionLink(
                  'page04_actionLink_axis_title',
                  label = '',
                  icon = icon(name = 'question-circle', lib = 'font-awesome', 'fa-xs')
                  )
                )
              ),
              value = 15
            ),
            #選擇軸標籤字體尺寸
            numericInput(
              'page04_ui_axis_label_num1',
              label = HTML(
                'Axis Label',
                as.character(actionLink(
                  'page04_actionLink_axis_label',
                  label = '',
                  icon = icon(name = 'question-circle', lib = 'font-awesome', 'fa-xs')
                  )
                )
              ),
              value = 10
            )
          ),
          #選擇軸標籤角度
          sliderInput(
            'page04_ui_axis_angle_slider1',
            label = 'Axis-label Angle:',
            min = 0,
            max = 90,
            value = 90
          ),
          #  線,點 尺寸
          splitLayout(
            # 尺寸(線)
            numericInput('page04_ui_line_num1', label = 'Size (Line):', value = 1),
            # 尺寸(點)
            numericInput('page04_ui_point_num1', label = 'Size (Dot):', value = 1)
          ),
          # 線,點 透明度
          splitLayout(
            # 透明度(線)
            sliderInput('page04_ui_line_slider1', label = 'Opacity (Line):', min = 0, max = 1, value = .6),
            # 透明度(點)
            sliderInput('page04_ui_point_slider1', label = 'Opacity (Dot):', min = 0, max = 1, value = .7)
          ),
          # 顏色
          checkboxInput('page04_group_colours_check1', label = 'Customise Color'),
          uiOutput('page04_group_colours'),
          splitLayout(
            # 下載圖片的寬
            numericInput('page04_ui_download_width_num1', label = "Width(Download):", value = 600),
            # 下載圖片的高
            numericInput('page04_ui_download_height_num1', label = "Height(Download):", value = 400)
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
        plotOutput('page04_lineChart', height = '100%'),
        color = '#0dc5c1'),
      # 下載
      column(12, align = 'right',
       uiOutput("page04_download_button")
      )
    )
  )
)
