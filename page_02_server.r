### page 02 - 散佈圖

# 變數 X

output$page02_ui_select_x <- renderUI({
  choices = colTypeData()$cont
  names(choices) = colTypeData()$label_cont
  selectInput(
    inputId = "page02_select_x",
    label = labelWithInfo("X 軸變數 (連續型)", "page2_actionLink_x"),
    choices = choices
  )
})
observeEvent(input$page2_actionLink_x, {
  shinyalert(
   text = "請選擇欲呈現於x軸之連續變數。"
  )
})
# 變數 Y
output$page02_ui_select_y <- renderUI({
  choices = colTypeData()$cont
  names(choices) = colTypeData()$label_cont
  List_y_without_x <- choices[choices != input$page02_select_x]
  selectInput(
    inputId = "page02_select_y",
    label = labelWithInfo("Y 軸變數 (連續型)", "page02_actionLink_y"),
    choices = List_y_without_x)
})
observeEvent(input$page02_actionLink_y, {
  shinyalert(
    text = "請選擇欲呈現於y軸之連續變數。"
  )
})
# x軸標題
output$page02_ui_x_title <- renderUI({
  index = grep(input$page02_select_x, colnames(data()))
  default = colTypeData()$label[index]
  textInput(
    'page02_ui_x_title_text1',
    label = 'X軸標題', 
    value = default
  )
})
# y軸變數
output$page02_ui_y_title <- renderUI({
  index = grep(input$page02_select_y, colnames(data()))
  default = colTypeData()$label[index]
  textInput(
    'page02_ui_y_title_text1',
    label = 'Y軸標題', 
    value = default
  )
})

# 額外變數清單
output$page2_OthersVar <- renderUI({
  variable = colTypeData()$variable
  names(variable) = colTypeData()$label
  choices_cont = colTypeData()$cont
  names(choices_cont) = colTypeData()$label_cont
  #  選擇資料當中為類別型資料的變數
  choice_cate = colTypeData()$cate
  tagList(
    selectInput(
      "select_color",
      labelWithInfo("顏色變數", "page02_select_color"),
      choices = c("NULL", variable)
    ),
    selectInput(
      "select_shape",
      labelWithInfo("形狀變數 (類別型)", "page02_select_shape"),
      choices = c("NULL", choice_cate)
    ),
    selectInput(
      "select_size",
      labelWithInfo("尺寸變數 (連續型)", "page02_select_size"),
      choices = c("NULL", choices_cont)
    )
  )
})
observeEvent(input$page02_select_color, {
  shinyalert(
    text = "請選擇是否要已顏色變數區分"
  )
})
observeEvent(input$page02_select_shape, {
  shinyalert(
    text = "請選擇是否要已形狀變數區分"
  )
})
observeEvent(input$page02_select_size, {
  shinyalert(
    text = "請選擇是否要已尺寸變數區分"
  )
})

# 是否要自訂顏色
output$page02_colour <- renderUI({
  req(input$select_color)
  check_box = checkboxInput(
    'page02_colors_check1',
    label = '自訂顏色'
  )
  if (input$select_color == "NULL") {
    check_box
  } else {
    ""
  }
})
# 點顏色選擇
output$page02_choose_color <- renderUI({
  req(input$select_color)
  req(input$page02_colors_check1)
  if (input$page02_colors_check1 == TRUE & input$select_color == "NULL") {
    colourpicker::colourInput(
      'page02_ui_colour',
      label = '顏色:',
      palette = 'square',
      value = '#00BFC4'
    )
  } else {
    ""
  }
})
# 點尺寸選擇
output$page02_choose_size <- renderUI({
  req(input$select_size)
  if (input$select_size == "NULL") {
    numericInput("page02_ui_size", "尺寸(點)",
    min = 1, value = 2)
  } else {
    ""
  }
})

# 散佈圖
observe({
  output$page02_scatter <- renderPlot({
    # 檢核
    req(input$page02_select_x)
    req(input$page02_select_y)
    geomPoint =  if (input$select_color == "NULL") {
      if (input$select_size == "NULL") {
        if (input$page02_colors_check1 == TRUE) {
          geom_point(
            color = input$page02_ui_colour,
            size = input$page02_ui_size,
            alpha = input$dot_alpha
          )
        } else {
          geom_point(
            color = '#00BFC4',
            size = input$page02_ui_size,
            alpha = input$dot_alpha
          )
        }
      } else {
        if (input$page02_colors_check1 == TRUE) {
          geom_point(
            color = input$page02_ui_colour,
            alpha = input$dot_alpha
          )
        } else {
          geom_point(
            color = '#00BFC4',
            alpha = input$dot_alpha
          )
        }
      }
    } else {
      if (input$select_size == "NULL") {
        geom_point(
          size = input$page02_ui_size,
          alpha = input$dot_alpha
        )
      } else {
        geom_point(
          alpha = input$dot_alpha
        )
      }
    }
    # 畫圖
    ggplot(
      data = data(),
      aes_string(
        x = input$page02_select_x,
        y = input$page02_select_y,
        color = input$select_color,
        shape = input$select_shape,
        size = input$select_size
      )
    ) +
    geomPoint +
    labs(
      title = input$page2_title,
      x = input$page02_ui_x_title_text1,
      y = input$page02_ui_y_title_text1
    ) +
    theme(
      # 標題大小
      plot.title = element_text(
        size = input$page02_ui_title_num1,
        face = "bold",
        hjust = 0.5
      ),
      # 軸標題
      axis.title = element_text(
        size = input$page02_ui_axis_title_num1,
        face = 'bold'
      ),
      # 軸標籤
      axis.text = element_text(
        size = input$page02_ui_axis_label_num1,
        face = 'bold'
      ),
      # 右側圖示標題
      legend.title = element_text(size = input$page02_ui_axis_title_num1),
      # 右側圖示標籤
      legend.text = element_text(size = input$page02_ui_axis_label_num1)
    )
    },
      width = input$page02_download_width,
      height = input$page02_download_height
  )
})
# 下載
output$download <- downloadHandler(
  filename = function() {
    paste0(input$page2_title, ".png")
  },
  content = function(file) {
    ggsave(
      file,
      dpi = 'screen',
      units = 'px',
      width = input$page02_download_width,
      height = input$page02_download_height
    )
  }
)

outputOptions(output, "page02_colour", suspendWhenHidden = FALSE)
outputOptions(output, "page02_choose_color", suspendWhenHidden = FALSE)
outputOptions(output, "page02_choose_size", suspendWhenHidden = FALSE)
outputOptions(output, "page02_ui_x_title", suspendWhenHidden = FALSE)
outputOptions(output, "page02_ui_y_title", suspendWhenHidden = FALSE)

###
# r
# ggplot(data = iris, aes(Petal.Length, Petal.Width, color = Species)) +
#   geom_point() +
#   scale_color_manual(values = c("setosa" = "red", "versicolor" = "blue", "virginica" = "yellow"))
###