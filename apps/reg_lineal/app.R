#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(DT)
library(shiny)

casas <- read_csv("../../datos/houseprices/house-prices.csv")
casas <- mutate(casas, 
                precio_miles = SalePrice / 1000,
                habitable_100_m2 = (GrLivArea * 0.092903) / 100,
                calidad = OverallQual - 5, # una medida entre -5 y 5
                calidad_m2 = calidad * habitable_100_m2)
set.seed(13)
casas_ent <- sample_frac(casas, 0.7)
graf_ent_f <- ggplot(casas_ent, #%>% filter(calidad > -3, precio_miles < 600), 
                     aes(x = habitable_100_m2, y = precio_miles)) + 
    geom_point(size=1, alpha = 0.5) + facet_wrap(~calidad) 
preds_fun <- function(x_ent){
    function(beta){
        cbind(1, x_ent) %*% beta
    }
}
x_ent <- casas_ent %>% select(habitable_100_m2, calidad_m2) %>% as.matrix
y <- casas_ent$precio_miles
preds <- preds_fun(x_ent)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Precios de casas"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("beta_0",
                        "b_0",
                        min =  0,
                        max = 200,
                        value = 30),
            sliderInput("beta_1",
                        "b_1",
                        min =  -100,
                        max = 100,
                        value = 0),
            sliderInput("beta_2",
                        "b_0",
                        min =  -100,
                        max = 100,
                        value = 0)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tableOutput("error"),
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$error <- renderTable({
        beta <- c(input$beta_0, input$beta_1, input$beta_2)
        y_hat <- preds(beta)
        ecm <- mean( (y_hat - y)^2)
        tab <- tibble(Entrenamiento = c("Precio medio","Error cuadrático", "Raíz de error cuadrático"),
                valor = c(mean(y), ecm, sqrt(ecm)))
        tab
    })
    output$distPlot <- renderPlot({
        beta <- c(input$beta_0, input$beta_1, input$beta_2)
        y_hat <- preds(beta)
        graf_ent_f + 
            geom_line(data = casas_ent %>% mutate(preds = y_hat), #%>% 
                          #filter(calidad > -3, precio_miles < 600),
                      aes(x = habitable_100_m2, y = preds, col = "red"))
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
