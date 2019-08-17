#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

# Preparar datos
casas_ent <- read_rds("../../temp/casas_ent.rds")
casas_val <- read_rds("../../temp/casas_val.rds")
preds_fun <- function(x_ent){
    function(beta){
        cbind(1, x_ent) %*% beta
    }
}
x_ent <- casas_ent %>% select(calidad, tiene_piso_2) %>% as.matrix
y <- casas_ent$precio_m2_miles
preds <- preds_fun(x_ent)
graf_ent <- ggplot(casas_ent, aes(x = calidad, y = precio_m2_miles)) +
            geom_jitter(width = 0.25, alpha = 0.5) + facet_wrap(~tiene_piso_2)
graf_ent_2 <- ggplot(casas_ent %>% filter(calidad > -3), 
                     aes(x = habitable_m2, y = precio_miles, colour = factor(tiene_piso_2),
                                    group = tiene_piso_2)) +
    geom_jitter(width = 0.25, alpha = 0.5, size = 0.5) + facet_wrap(~calidad, scales="free") 

# Aplicación
ui <- fluidPage(

    titlePanel("Precios de casas"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("beta_0",
                        "b_0 (ordenada)",
                        min =  -3,
                        max = 3,
                        value = 0,
                        step = 0.02),
            sliderInput("beta_1",
                        "b_1  (calidad)",
                        min =  -1,
                        max = 1,
                        step = 0.02, value = 0),
            sliderInput("beta_2",
                        "b_2  (tiene 2 pisos)",
                        min =  -1,
                        max = 1,
                        value = 0, step = 0.02)
        ),

        mainPanel(
           p("precio_m2_miles = b_0 + b_1 * calidad +  b_2 * tiene_2_pisos "),
           tableOutput("error"),
           plotOutput("pm2Plot"),
           plotOutput("precioPlot")
        )
    )
)

server <- function(input, output) {
    calc_preds <- reactive({
        beta <- c(input$beta_0, input$beta_1, input$beta_2)
        y_hat <- preds(beta)
        ecm <- mean( (y_hat - y)^2)
        list(y_hat = y_hat, ecm = ecm)
    })
    output$error <- renderTable({
        tab <- tibble(Entrenamiento = c("Error cuadrático", "Raíz de error cuadrático"),
                valor = c( ecm, sqrt(calc_preds()$ecm)))
        tab
    })
    output$pm2Plot <- renderPlot({
            graf_ent + 
            geom_line(data = casas_ent %>% mutate(preds = calc_preds()$y_hat), 
                      aes(x = calidad, y = preds, col = "red"), size = 0.5, alpha = 1)
    })
    output$precioPlot <- renderPlot({
        graf_ent_2 + 
            geom_line(data = casas_ent %>% 
                          mutate(preds = habitable_m2*calc_preds()$y_hat)%>% filter(calidad > -3), 
                      aes(y = preds), size = 0.5, alpha = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
