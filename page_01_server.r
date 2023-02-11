### page 01 - 資料
# 設定資料最大容量(mb)
max_mb = 30
options(shiny.maxRequestSize = max_mb * 1024 ^ 2)
# 資料上傳
data_upload = function() {
  type = unlist(str_split(input$page01_file1$datapath, "[.]"))
  file_type = type[length(type)]
  data <- if (file_type %in% c("csv", "tsv")) {
    text_sep = switch(
      file_type,
      "csv" = ",",
      "tsv" = "\t"
    )
    vroom(
      input$page01_file1$datapath,
      delim = text_sep,
      locale = locale(encoding = input$encoding)
    )
  } else {
    switch(
      file_type,
      xlsx = read_excel(
        input$page01_file1$datapath,
        sheet = input$sheet_select
      ),
      ods = read_ods(
        input$page01_file1$datapath,
        sheet = input$sheet_select
      )
    )
  }
  data
}
# 眾數方程式d
getmode <- function(x) {
  x <- x[which(!is.na(x))]
  uniqv <- unique(x)
  uniqv[which.max(tabulate(match(x, uniqv)))]
}

# 讀取表格
data <- reactive({
  # 檢核
  req(input$page01_file1)
  # 讀取資料
  data = data_upload()
  # 取代特殊符號
  data <- dplyr::rename_all(data, make.names)
  # 去除連續型資料中的逗號 $ 等等([.-])|
  for (i in colTypeData()$cont) {
    data[, i] = sapply(
      data[, i],
      function(x)
      as.numeric(gsub("([.-])|[[:punct:]]", "\\1", x))
    )
    #
    # data[, i] = sapply(data[, i], function(x) as.numeric(gsub("([.-])|[[:punct:]]", "", x)))
  }
  for (i in colTypeData()$cate) {
    data[, i] = sapply(data[, i], function(x) as.character(x))
  }
  ### 類別資料遺失值修正
  catedata = data[colnames(data) %in% colTypeData()$cate]
  # 有遺失值的類別變數
  mvcateCols = which(colSums(is.na(catedata)) > 0)
  if (length(mvcateCols) > 0) {
    mvColnames = colnames(catedata[mvcateCols])
    for (i in seq_len(length(mvColnames))) {
      col = paste0("page01_MVcatemethod", i)
      # 處理方式選單結果
      choices = strsplit(as.character(input[[as.character(col)]]), ":")
      if (choices[[1]][1] == "Mode") {
        # 以眾數作為取代值
        replace.col = names(sort(-table(data[[mvColnames[i]]])))[1]
      } else {
        replace.col = NA
      }
      # 取代遺失值
      na.row = is.na(data[mvColnames[i]])
      data[na.row, mvColnames[i]] = replace.col
      if (choices == "Delete Missing-Value") {
        data = data[!na.row, ]
      }
    }
  } else {
    data = data
  }
  ### 連續資料遺失值修正
  contdata = data[colnames(data) %in% colTypeData()$cont]
  # 有遺失值的連續變數
  mvcontCols = which(colSums(is.na(contdata)) > 0)
  if (length(mvcontCols) > 0) {
    mvColnames = colnames(contdata[mvcontCols])
    for (i in seq_len(length(mvColnames))) {
      cont_col = paste0("page01_MVcontmethod", i)
      # 處理方式選單結果
      choices = strsplit(as.character(input[[as.character(cont_col)]]), ":")[[1]][1]
      replace.col <- switch(choices,
        Mean = mean(data[[mvColnames[i]]], na.rm = TRUE),
        Median = median(data[[mvColnames[i]]], na.rm = TRUE),
        Mode = getmode(data[[mvColnames[i]]]),
        NA
        )
      # 取代遺失值
      na.row = is.na(data[mvColnames[i]])
      data[na.row, mvColnames[i]] = replace.col
      if (choices == "Delete Missing-Value") {
        data = data[!na.row, ]
      }
    }
  } else {
    data = data
  }
  data
})

output$encoding_problem <- renderUI({
  req(input$page01_file1)
  tryCatch(
    {
      data_upload()
      ""
    },
    error = function(cnd) {
      p(
        "讀取資料發生問題，請嘗試切換編碼。
        若還是有問題，代表為資料讀取問題，請自行處理成 R 可以讀取的資料格式。",
        style = "color: red"
      )
    }
  )
})
# xlsx | ods 選擇Sheet
output$page01_sheet_choices <- renderUI({
  req(input$page01_file1)
  type = unlist(str_split(input$page01_file1$datapath, "[.]"))
  file_type = type[length(type)]
  if (file_type == "xlsx") {
    sheet_name = excel_sheets(input$page01_file1$datapath)
    selectInput(
      "sheet_select",
      "Sheet",
      choices = sheet_name
    )
  } else if (file_type == "ods") {
    sheet_name = list_ods_sheets(input$page01_file1$datapath)
    selectInput(
      "sheet_select",
      "Sheet",
      choices = sheet_name
    )
  }
})

output$data_summary <- renderUI({
  req(data())
  req(colTypeData())
  summary <- data.frame(
    "Data Size" = nrow(data()),
    "Categorical" = length(colTypeData()$cate),
    "Continuous" = length(colTypeData()$cont)
  )
  output$summary_table <- renderTable({
    summary
  })
})

# 輸出變數選單
output$page01_variables <- renderUI({
  req(input$page01_file1)
  # 讀取資料
  data = data_upload()

  dataColnames = colnames(data)
  selectInputList = list()
  for (i in seq_len(length(dataColnames))) {
    selectInputList[[i]] = selectInput(
      paste0("page1_var", i),
      dataColnames[i],
      choices = c("Categorical", "Continuous"),
      # 判斷是何種類型
      selected = ifelse(class(as.data.frame(data)[, i]) == "numeric",
      "Continuous", "Categorical"
      )
    )
  }
  selectInputList
})
# 加載時先跑出第二個分頁內頁(變數清單)，以顯示資料
outputOptions(output, "page01_variables", suspendWhenHidden = FALSE)

output$rowNums <- renderUI({
  N <- nrow(data())
  numericInput(
    "row_nums",
    "Rows:",
    min = 1, max = N, value = 5)
})
output$colNums <- renderUI({
  N <- length(colnames(data()))
  numericInput(
    "col_nums",
    "Columns:",
    min = 1, max = N, value = 6)
})


# 類別、連續資料
colTypeData <- reactive({
  # 檢核
  req(input$page01_file1)
  # 讀取資料
  coldata = data_upload()
  label_data = coldata
  label = colnames(coldata)
  # 取代特殊符號
  coldata <- dplyr::rename_all(coldata, make.names)
  # 變數名稱
  dataColnames = colnames(coldata)
  cate_index = c()
  cont_index = c()
  for (i in seq_len(length(coldata))) {
    type <- paste0("page1_var", i)

    if (input[[as.character(type)]] == "Categorical") {
      cate_index = c(cate_index, i)
    } else {
      cont_index = c(cont_index, i)
    }
  }
  # 已經被改過的變數名稱，ex: 投籃...
  variable <- dataColnames
  cate <- colnames(select(coldata, all_of(cate_index)))
  cont <- colnames(select(coldata, all_of(cont_index)))
  # 還沒被改過的變數名稱，ex: 投籃(%)
  label_cate <- colnames(select(label_data, all_of(cate_index)))
  label_cont <- colnames(select(label_data, all_of(cont_index)))
  cat(variable)
  # return
  list(
    variable = variable,
    cate = cate,
    cont = cont,
    label = label,
    label_cate = label_cate,
    label_cont = label_cont
  )
})

# 類別、連續欄位表格
output$page01_ui_tables <- renderUI({
  # 檢核
  n = input$col_nums
  req(colTypeData())
  # cateCols <- colTypeData()$cate
  # contCols <- colTypeData()$cont
  data_label = data()
  colnames(data_label) = colTypeData()$label
  cateCols <- colTypeData()$label_cate
  contCols <- colTypeData()$label_cont
  
  for (i in seq_len(length(cateCols))) {
    local({
      # 如果 i 可以整除 6，或是已經到最後一筆
      if (i %% n == 0 || i == length(cateCols)) {
        # 目前頁數(商數 + 有餘數時+1)
        nowPage = i %/% n + ifelse(i %% n != 0, 1, 0)
        # 表格 id
        tableId = paste0("cateTable_", nowPage)
        # 表格資料
        index = (1:n) + (nowPage - 1) * n
        colname = na.omit(cateCols[index])
        data = head(data_label[, colname], input$row_nums)
        # output 表格資料
        output[[tableId]] <- renderTable({
          data
        })
      }
    })
  }
  for(i in seq_len(length(contCols))) {
    local({
      # 如果 i 可以整除 6，或是已經到最後一筆
      if (i %% n == 0 || i == length(contCols)) {
        # 目前頁數(商數 + 有餘數時+1)
        nowPage = i %/% n + ifelse(i %% n != 0, 1, 0)
        # 表格 id
        tableId = paste0("contTable_", nowPage)
        # 表格資料
        index = (1:n) + (nowPage - 1) * n
        colname = na.omit(contCols[index])
        data = head(data_label[, colname], input$row_nums)
        # output 表格資料
        output[[tableId]] <- renderTable({
          data
        })
      }
    })
  }
  ### 類別型資料
  # 計算將產生幾個列（六個變數一列）
  cate_dataPage <- length(cateCols) %/% n
  cont_dataPage <- length(contCols) %/% n
  # 最後會剩下幾個變數（不到六個）
  cate_left <- length(cateCols) %% n
  cont_left <- length(contCols) %% n
  # 動態產生類別型表格的資料
  # 迴圈
      # 輸出 result
    Result <- list(h5(strong('Categorical Data:')))
    # 產生前端的 tableOutput
    if (length(cateCols) == 0) {
      # 不明顯
      Result[2] = "No Categorical Data"
    } else {
      for(i in 1:(cate_dataPage + ifelse(cate_left > 0, 1, 0))) {
        catetableId = paste0("cateTable_", i)
        Result[[length(Result) + 1]] <- tableOutput(catetableId)
      }
    }
    ### 連續型資料
    Result[[length(Result) + 1]] <- list(h5(strong("Continuous Data:")))
    Start <- length(Result)
    if (length(contCols) == 0) {
      Result[Start + 1] = "No Continous Data"
    } else {
      for(i in 1:(cont_dataPage + ifelse(cont_left > 0, 1, 0))) {
        conttableId = paste0("contTable_", i)
        Result[[Start + 1]] <- tableOutput(conttableId)
        Start = Start + 1
      }

    }
  # return
  Result
})

# 遺失值處理方式選單
output$missvalue_select <- renderUI({
  req(input$page01_file1)
  data = data_upload()
  data <- dplyr::rename_all(data, make.names)
  # 計算遺失值數量
  catedata = data[colnames(data) %in% colTypeData()$cate]
  mvcateCols = which(colSums(is.na(catedata)) > 0)
  contdata = data[colnames(data) %in% colTypeData()$cont]
  mvcontCols = which(colSums(is.na(contdata)) > 0)
  MVselectInputList = list()
  MVcateselectInputList = list()
  # 連續型資料遺失值
  if (length(mvcontCols) > 0) {
    mvColnames = colnames(contdata[mvcontCols])
    #
    for (i in seq_len(length(mvColnames))) {
      MV_num = colSums(is.na(data))[mvColnames[i]]
      mean_value = mean(data[[mvColnames[i]]], na.rm = TRUE)
      median_value = median(data[[mvColnames[i]]], na.rm = TRUE)
      mode_value = getmode(data[[mvColnames[i]]])
      mean_label = paste0("Mean:", round(mean_value, 2))
      median_label = paste0("Median:", round(median_value, 2))
      mode_label = paste0("Mode:", mode_value)
      MVselectInputList[[i]] = selectInput(
        paste0("page01_MVcontmethod", i),
        paste0("Continuous：", mvColnames[i], ";    Num：", MV_num),
        choices = c("Retain" = "null", mean_label, median_label, mode_label,  "Delete Missing-Value"),
        selected = "null"
      )
    }
  } else {
    ""
  }
  # 類別型資料遺失值
  if (length(mvcateCols) > 0) {
    mvColnames = colnames(catedata[mvcateCols])
    for (i in seq_len(length(mvColnames))) {
      MV_num = colSums(is.na(data))[mvColnames[i]]
      mode_value = names(sort(-table(data[[mvColnames[i]]])))[1]
      mode_label = paste0("眾數:", mode_value)
      MVcateselectInputList[[i]] = selectInput(
        paste0("page01_MVcatemethod", i),
        paste0("Categorical：", mvColnames[i], ";   Num：", MV_num),
        choices = c("Keep" = "null", mode_label, "Delete Missing-Value"),
        # 判斷是何種類型
        selected = "null"
      )
    }
  } else {
    ""
  }
  # 選單
  list(
    MVselectInputList,
    MVcateselectInputList
  )
})
# 提前跑出選單
outputOptions(output, "missvalue_select", suspendWhenHidden = FALSE)
observeEvent(input$feeback_bttn, {
  showModal(
    modalDialog(
      title = "Feeback",
      textInput("feeback_text", "Write your feeback here!"),
      column(12, align = "right", id = "button",
        actionButton("feeback_submit", "Submit"))
    )
  )
})

formData <- reactive({
  data <- data.frame(
    c(as.character(Sys.time()), input$feeback_text)
  )
})
save_data_gsheets <- function(data) {
  sheet_append(
    data = as.data.frame(t(data)),
    ss = "1p2Tf67HFU0heTtxgBaWjnrvFclo3vyT3oKZ102EBhAo",
    sheet = "Sheet1"
  )
}
observeEvent(input$feeback_submit, {
  save_data_gsheets(formData())
})
observeEvent(input$feeback_submit, {
  showModal(
    modalDialog(
      title = "Thank You!!",
      "We have received your feeback, have a good day!"
    )
  )
})