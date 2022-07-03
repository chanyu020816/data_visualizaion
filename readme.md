### upgrade 
    1. linear regression line
    2. correlation coefficient
    3. automatic file type
    4. sheet select
    5. data structures
    6.plotly


```r
ggplot(data = iris, aes(Petal.Length, Petal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = c("setosa" = "red", "versicolor" = "blue", "virginica" = "yellow"))
```