### page 03 - 長條圖

## x軸變數
output$page03_ui_discrete_x_select1 <- renderUI({
  # 選項
  choices_x = colTypeData()$cate
  names(choices_x) = colTypeData()$label_cate
  selectInput(
    'page03_discrete_x_select1',
    label = labelWithInfo('X-axis (Categorical)', 'page03_actionLink_discrete_x'),
    choices = choices_x
  )
})
## 說明視窗(x軸)
observeEvent(input$page03_actionLink_discrete_x, {
  shinyalert(
    text = 'Select the variable to show on X-axis'
  )
})
## x軸標題
output$page03_ui_x_title_text1 <- renderUI({
  index_03_X = grep(input$page03_discrete_x_select1, colnames(data()))
  default_03_X = colTypeData()$label[index_03_X]
  textInput(
    'page03_x_title_text1',
    label = 'X-axis Title',
    value = default_03_X
    )
})

## Y軸變數
output$page03_ui_continuous_select1 <- renderUI({
  # 選項
  choices_y = colTypeData()$cont
  names(choices_y) = colTypeData()$label_cont
  # 下拉選單
  selectInput(
    'page03_continuous_select1',
    label = labelWithInfo('Y-axis (Continuous)', 'page03_actionLink_continuous'),
    choices = choices_y
  )
})
## 說明視窗(Y軸)
observeEvent(input$page03_actionLink_continuous, {
  shinyalert(
    text = 'Select the variable to show on Y-axis'
  )
})
## Y軸標題
output$page03_ui_y_title_text1 <- renderUI({
  index_03_y = grep(input$page03_continuous_select1, colnames(data()))
  default_03_y = colTypeData()$label[index_03_y]
  textInput(
    'page03_y_title_text1',
    label = 'Y-axis Title',
    value = default_03_y
  )
})
output$barchart_fun_select1 <- renderUI({
  req(data())
  selectInput(
    'page03_ui_fun_select1',
    # 說明視窗
    label = HTML(
      'Measurement',
      ""
    ),
    choices = c("Sum" = '總和', "Mean" = '平均數', "Max" = '最大值', "Min" = '最小值', "Count" = '計數'),
    selected = '平均數'
  )
})
## 群組變數
output$page03_ui_discrete_group_select1 <- renderUI({
  # 選項
  choices_group = colTypeData()$cate[colTypeData()$cate != input$page03_discrete_x_select1]
  names(choices_group) = colTypeData()$label_cate[colTypeData()$cate != input$page03_discrete_x_select1]
  selectInput(
    'page03_discrete_group_select1',
    label = labelWithInfo('Group Variable (Categorical)', 'page03_actionLink_discrete_group'),
    choices = c('NULL', choices_group)
  )
})
## 說明視窗(群組)
observeEvent(input$page03_actionLink_discrete_group, {
  shinyalert(
    text = 'Select the categorical variable showed in different color in X-axis
      (NULL:Not chosing any variable)'
  )
})


## 說明視窗(軸標題 + 右側圖示標題)
observeEvent(input$page03_actionLink_axis_title, {
  shinyalert(
    text = 'Include label on the right'
  )
})

## 說明視窗(軸標籤 + 右側圖示標籤)
observeEvent(input$page03_actionLink_axis_label, {
  shinyalert(
    text = 'Include label on the right'
  )
})

## 顏色
output$page03_colours <- renderUI({
  req(input$page03_colours_check1)
  # 當群組變數 = NULL 時, 只輸出一個 colourInput
  if (input$page03_discrete_group_select1 == 'NULL') {
    colourInput(
      'page03_null_colour1',
      label = '',
      palette = 'square',
      value = '#00BFC4'
    )
  } else {
    # 當群組變數 != NULL 時, 動態生成 群組變數之類別個數 個 colourInput
    # 先判斷是否有遺失值
    if (T %in% is.na(data()[,input$page03_discrete_group_select1])) {
      colour_num_03 = nrow(unique(data()[,input$page03_discrete_group_select1])) - 1
    } else {
      colour_num_03 = nrow(unique(data()[,input$page03_discrete_group_select1]))
    }
    colourInputList_03 <- list()
    for (i in 1:colour_num_03) {
        colourInputList_03[[i]] = colourInput(
          paste0('page3_colour_', i),
          label = paste0('第', i, '個變數'),
          palette = 'square',
          value = hue_pal()(i)[i]
        )
    }
    colourInputList_03
  }
})

## 長條圖
observe({
  output$page03_barChart <- renderPlot({
    # 檢核
    req(input$page03_discrete_x_select1)
    req(input$page03_discrete_group_select1)
    req(input$page03_continuous_select1)
    
    # 判斷呈現方式(總和,平均數,最大值,最小值)
    if (input$page03_ui_fun_select1 == '總和'){
      fun = 'sum'
    } else if (input$page03_ui_fun_select1 == '平均數'){
      fun = 'mean'
    } else if (input$page03_ui_fun_select1 == '最大值'){
      fun = 'max'
    } else if (input$page03_ui_fun_select1 == '最小值') {
      fun = 'min'
    } else {
      fun = 'length'
    }
    
    # 顏色向量(群組變數 != NULL時)
    if (input$page03_discrete_group_select1 != 'NULL') {
      values_03 <- c()
      for (i in 1:nrow(unique(data()[,input$page03_discrete_group_select1]))) {
        values_03[[i]] <- input[[paste0('page3_colour_', as.character(i))]]
      }
    }
    
    # 判斷是否自訂顏色(群組變數 != NULL)
    if (input$page03_discrete_group_select1 != 'NULL' & input$page03_colours_check1 == T) {
      colour_03 = scale_fill_manual(values = unlist(values_03))
    } else {
      colour_03 = NULL
    }
    # 判斷是否自訂顏色(群組變數 == NULL)
    if (input$page03_discrete_group_select1 == 'NULL' & input$page03_colours_check1 == T) {
      fill = input$page03_null_colour1
    } else {
      fill = '#00BFC4'
    }

    # ggplot 初始圖
    ggRoot = ggplot(
      data(),
      aes_string(
        x = input$page03_discrete_x_select1,
        y = input$page03_continuous_select1
      )
    ) +
     # 標題, x軸標題, y軸標題
    labs(
      title = input$page03_ui_title_text1,
      x = input$page03_x_title_text1,
      y = input$page03_y_title_text1
    )

    # 是否要分組
    if(input$page03_discrete_group_select1 == 'NULL'){
      ggBar = geom_bar(
        # 不分組
        fill = fill,
        stat = 'summary',
        fun = fun,
        position = 'dodge',
        width = 0.5
      )
    } else {
      ggBar = geom_bar(
        # 分組
        aes_string(fill = input$page03_discrete_group_select1),
        stat = 'summary',
        fun = fun,
        position = 'dodge',
        width = 0.5
      )
    }
    
    # 畫圖
    ggRoot + ggBar + 
      theme(
        # 圖標題
        plot.title = element_text(
          size = input$page03_ui_title_num1,
          face = 'bold',
          hjust = 0.5
        ),
        # 軸標題
        axis.title = element_text(
          size = input$page03_ui_axis_title_num1,
          face = 'bold'
        ),
        # 軸標籤
        axis.text = element_text(
          size = input$page03_ui_axis_label_num1,
          face = 'bold'
        ),
        # x軸標籤(角度)
        axis.text.x = element_text(
          angle = input$page03_ui_axis_angle_slider1,
          vjust = 0.5
        ),
        # 右側圖示標題
        legend.title = element_text(size = input$page03_ui_axis_title_num1),
        # 右側圖示標籤
        legend.text = element_text(size = input$page03_ui_axis_label_num1)
      ) + colour_03
  },
  # 顯示圖的寬高
  width = input$page03_ui_download_width_num1,
  height = input$page03_ui_download_height_num1
  )
})
# 下載


output$page03_download_button <- renderUI({
  req(input$page01_file1)
  output$downloadPlot <- downloadHandler(
    filename = function() {
      # 下載後的名字
      paste(input$page03_ui_title_text1, '.png', sep = ' ')
    },
    content = function(file) {
      ggsave(
        file,
        dpi = 'screen',
        units = 'px',
        width = input$page03_ui_download_width_num1,
        height = input$page03_ui_download_height_num1
      )
    }
  )
})

outputOptions(output, 'page03_ui_x_title_text1', suspendWhenHidden = FALSE)
outputOptions(output, 'page03_ui_y_title_text1', suspendWhenHidden = FALSE)