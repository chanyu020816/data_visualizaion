# server
function(input, output, session) {
  # 網頁標籤帶資訊按鈕 (label = 中文標籤, id = 按鈕 id)
  labelWithInfo = function(label, id) {
    HTML(
      label,
      as.character(
        actionLink(
          id,
          label = '',
          icon = icon(name = 'question-circle', lib = 'font-awesome', 'fa-xs')
        )
      )
    )
  }
  ### page 01 - 資料
  source("./page_01_server.r", encoding = "utf-8", local = TRUE)

  ### page 02 - 散佈圖
  source("./page_02_server.r", encoding = "utf-8", local = TRUE)

  ### page 03 - 長條圖
  source("./page_03_server.r", encoding = "utf-8", local = TRUE)
  
  ### page 04 - 折線圖
  source("./page_04_server.r", encoding = "utf-8", local = TRUE)

}
