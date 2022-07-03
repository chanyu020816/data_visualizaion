### page 04 - 折線圖

## X軸變數
output$page04_ui_discrete_select1 <- renderUI({
  # 選項
  choices_x_04 = colTypeData()$cate
  names(choices_x_04) = colTypeData()$label_cate
  selectInput(
    'page04_discrete_select1',
    label = labelWithInfo('X 軸變數 (類別型)', 'page04_actionLink_discrete_x'),
    choices = choices_x_04
  )
})
## 說明視窗(X軸)
observeEvent(input$page04_actionLink_discrete_x, {
  shinyalert(
    text = '請選擇欲呈現於X軸之類別變數。
    (將以此變數按照資料順序做排序。)'
  )
})
## X軸標題
output$page04_ui_x_title_text1 <- renderUI({
  index_04_X = grep(input$page04_discrete_select1, colnames(data()))
  default_04_X = colTypeData()$label[index_04_X]
  textInput(
    'page04_x_title_text1',
    label = 'X軸標題',
    value = default_04_X
  )
})

## Y軸變數
output$page04_ui_group_select1 <- renderUI({
  # 選項
  choices_y_04 = colTypeData()$cont
  names(choices_y_04) = colTypeData()$label_cont
  selectInput(
    'page04_group_select1',
    label = labelWithInfo('Y 軸變數 (連續型)(可複選)','page04_actionLink_continuous'),
    choices = choices_y_04,
    selected = NULL,
    multiple = TRUE,
    selectize = T
  )
})
## 說明視窗(Y軸)
observeEvent(input$page04_actionLink_continuous, {
  shinyalert(
    text = '請選擇欲呈現於Y軸之連續變數。'
  )
})

## 說明視窗(呈現方式)
observeEvent(input$page04_actionLink_fun, {
  shinyalert(
    text = '總和 : 長條以總和方式呈現。
  平均數 : 長條以平均數方式呈現。
  最大值 : 長條以最大值方式呈現。
  最小值 : 長條以最小值方式呈現。
    '
  )
})

## 說明視窗(軸標題 + 右側圖示標題)
observeEvent(input$page04_actionLink_axis_title, {
  shinyalert(
    text = '包含右側圖示標題。'
  )
})

## 說明視窗(軸標籤 + 右側圖示標籤)
observeEvent(input$page04_actionLink_axis_label, {
  shinyalert(
    text = '包含右側圖示標籤。'
  )
})

## 顏色(動態生成 Y軸變數個數 個colourInput)
output$page04_group_colours <- renderUI({
  req(input$page04_group_colours_check1)
  colourInputList_04 <- list()
  for (i in 1:length(input$page04_group_select1)) {
    colourInputList_04[[i]] = colourInput(
      paste0('page4_colour_', i),
      label = paste0('第', i, '個變數'),
      palette = 'square',
      value = hue_pal()(i)[i]
    )
  }
  colourInputList_04
})

## 折線圖
group_continuous_1 <- reactive({
  input$page04_group_select1
})

observe({
  output$page04_lineChart <- renderPlot({
    # 檢核
    req(input$page04_discrete_select1)
    req(input$page04_group_select1)
    
    # 將資料轉換成長資料,選擇欄位
    df_group_1 <-
      pivot_longer(
        data(),
        group_continuous_1(),
        names_to = '變數',
        values_to = 'value'
      )
    
    # 標準化df_group_1中所選欄位值
    df_group_1 <- df_group_1 %>%
      group_by(變數) %>%
      mutate(scale_var = scale(value))
    
    # 判斷呈現方式(總和,平均數,最大值,最小值)
    if (input$page04_ui_fun_select1 == '總和'){
      fun = sum
    } else if (input$page04_ui_fun_select1 == '平均數'){
      fun = mean
    } else if (input$page04_ui_fun_select1 == '最大值'){
      fun = max
    } else {
      fun = min
    }
    
    # 顏色向量
    values <- c()
    for (i in 1:length(input$page04_group_select1)) {
      values[[i]] <- input[[paste0('page4_colour_', as.character(i))]]
    }
    # 判斷是否自設顏色
    if (input$page04_group_colours_check1 == T) {
      colour = scale_color_manual(values = unlist(values))
    } else {
      colour = NULL
    }
    
    # 判斷標準化
    if (input$page04_ui_checkbox1 == T) {
      aes = aes(x = !!sym(input$page04_discrete_select1), y = scale_var)
    } else {
      aes = aes(x = !!sym(input$page04_discrete_select1), y = value)
    }
    
    # ggplot 初始圖
    ggRoot_04 = ggplot(df_group_1, aes)
    
    # 畫圖
    ggRoot_04 +
      # 標題, x軸標題, y軸標題
      labs(
        title = input$page04_ui_title_text1,
        x = input$page04_x_title_text1,
        y = input$page04_ui_y_title_text1
      ) +
      theme(
        # 圖標題
        plot.title = element_text(
          size = input$page04_ui_title_num1,
          face = 'bold',
          hjust = 0.5
        ),
        # 軸標題
        axis.title = element_text(
          size = input$page04_ui_axis_title_num1,
          face = 'bold'
        ),
        # 軸標籤
        axis.text = element_text(
          size = input$page04_ui_axis_label_num1,
          face = 'bold'
        ),
        # x軸標籤(角度)
        axis.text.x = element_text(
          angle = input$page04_ui_axis_angle_slider1,
          vjust = 0.5
        ),
        # 右側圖示標題
        legend.title = element_text(size = input$page04_ui_axis_title_num1),
        # 右側圖示標籤
        legend.text = element_text(size = input$page04_ui_axis_label_num1)
      ) +
      geom_line(
        # 尺寸(線)
        size = input$page04_ui_line_num1,
        stat = 'summary',
        fun = fun,
        aes(colour = 變數, group = 變數),
        # 透明度(線)
        alpha = input$page04_ui_line_slider1
      ) +
      geom_point(
        # 尺寸(點)
        size = input$page04_ui_point_num1,
        stat = 'summary',
        fun = fun,
        aes(colour = 變數, group = 變數),
        # 透明度(點)
        alpha = input$page04_ui_point_slider1
      ) +
      colour +
      # 以所選X軸變數排序
      scale_x_discrete(
        limits = unlist(unique(df_group_1[,input$page04_discrete_select1]), use.names = F)
        )
  },
  # 顯示圖的寬高
  width = input$page04_ui_download_width_num1,
  height = input$page04_ui_download_height_num1
  )
})
# 下載
output$downloadPlot_1 <- downloadHandler(
  filename = function() {
    # 下載後的名字
    paste(input$page04_ui_title_text1, '.png', sep = ' ')
  },
  content = function(file) {
    ggsave(
      file,
      dpi = 'screen',
      units = 'px',
      width = input$page04_ui_download_width_num1,
      height = input$page04_ui_download_height_num1)
  }
)

outputOptions(output, 'page04_ui_x_title_text1', suspendWhenHidden = FALSE)