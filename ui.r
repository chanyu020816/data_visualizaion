# UI
dashboardPage(
  # 標題
  dashboardHeader(
    title = span(
      img(
        src = "pen-ruler-solid.png",
        height = "20px", width = "20px",
        style = "margin-left: 3px; margin-right: 7px"
      ),
      "Data Visualization",
      style = "font-weight: bold; font-size: 23px"
    ),
    status = "light"

  ),
  # 側邊選單
  sidebar = dashboardSidebar(
    sidebarMenu(
      # tab 01 - 資料
      menuItem(
        "Data",
        tabName = "page01_data",
        icon = icon(name = "database", lib = "font-awesome")
      ),
      menuItem(
        span(
            img(
              src = "chart-area-solid.png",
              height = "20px", width = "20px",
              style = "margin-left: 3px; margin-right: 7px"
            ),
            "Distribution"
          ),
        tabName = "Distribution"
      ),
      # tab 02 - 散佈圖
      menuItem(
        span(
          img(
            src = "scatter-chart.png",
            height = "20px", width = "20px",
            style = "margin-left: 3px; margin-right: 7px"
          ),
          "Correlation",
        ),
        tabName = "Correlation",
         menuSubItem(
          span(
            img(
              src = "scatter-chart.png",
              height = "20px", width = "20px",
              style = "margin-left: 3px; margin-right: 7px"
            ),
            "Scatter Plot"
          ),
          tabName = "correlation_scatter"
        )
      ),
      menuItem(
        span(
          img(
            src = "ranking-star-solid.png",
            height = "20px", width = "20px",
            style = "margin-left: 3px; margin-right: 7px"
          ),
          "Ranking"
        ),
        tabName = "Ranking",
        menuSubItem(
          "Bar Plot",
          tabName = "ranking_barChart",
          icon = icon(name = "chart-bar", lib = "font-awesome")
        )
      ),
      # tab 04 - 折線圖
      menuItem(
        span(
          img(
            src = "chart-line-solid.png",
            height = "20px", width = "20px",
            style = "margin-left: 3px; margin-right: 7px"
          ),
          "Evolution"
        ),
        tabName = "Evolution",
        menuSubItem(
          span(
            img(
              src = "chart-line-solid.png",
              height = "20px", width = "20px",
              style = "margin-left: 3px; margin-right: 7px"
            ),
            "Line Plot"
          ),
          tabName = "evolution_lineplot",
        )
      )
    ),
  skin = "light",
  minified = FALSE
  ),
  # 主要頁面
  body = dashboardBody(
    tabItems(
      # tab 01 - 資料
      source("./page_01_ui.r", encoding = "utf-8", local = T)$value,
      # tab 02 - 散佈圖
      source("./page_02_ui.r", encoding = "utf-8", local = T)$value,
      # tab 03 - 長條圖
      source("./page_03_ui.r", encoding = "utf-8", local = T)$value,
      # tab 04 - 折線圖
      source("./page_04_ui.r", encoding = "utf-8", local = T)$value
    )
  ) #,
  # # 頁尾
  # footer = dashboardFooter(
  #     actionButton("feeback_bttn", "Feeback", icon = icon("comment-dots"), status = "primary")
  #   # right = "業師：唐子鈞"
  # )
)


