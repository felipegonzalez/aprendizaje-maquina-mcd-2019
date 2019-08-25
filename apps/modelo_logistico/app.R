#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

simular_impago <- function(n = 500){
    # suponemos que los valores de x están concentrados en valores bajos,
    # quizá la manera en que los créditos son otorgados
    x <- pmin(rexp(n, 100 / 40), 1)
    # las probabilidades de estar al corriente:
    probs <- p_1(x)
    # finalmente, simulamos cuáles clientes siguen en al corriente y cuales no:
    g <- ifelse(rbinom(length(x), 1, probs) == 1 , 1, 0)
    dat_ent <- tibble(x = x, p_1 = probs, g = g)
    dat_ent
}

crear_p <- function(beta_0, beta_1){
    function(x){
        h(beta_0 + beta_1 * x)
    }
}

devianza <- function(p, g) {
    -2 * (g * log(p) + (1-g) * log(1-p))
}

set.seed(1933)
dat_ent  <- simular_impago() %>% select(x, g) 
dat_ent %>% sample_n(20)
df_grid <- tibble(x = seq(0, 1, 0.01))

graf_1 <- ggplot(dat_ent, aes(x = x)) +
    geom_jitter(aes(colour = factor(g), y = g), 
                width=0.0, height=0.1) + ylab("") + 
    labs(colour = "Clase")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Regresión logística"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("beta_0",
                        "beta_0",
                        min = -6,
                        max = 6,
                        value = 0, step = 0.01),
            sliderInput("beta_1", "beta_1",
                        min = -6, max = 6, value = 0, step = 0.01)
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
    funcion_pred <- reactive({
        beta_0 <- input$beta_0
        beta_1 <- input$beta_1
        fun <- crear_p(beta_0, beta_1)
        fun
    })
    output$distPlot <- renderPlot({
        df_curva <- df_grid %>% mutate(prob_est = funcion_pred()(x))
        graf_1 + geom_line(data = df_curva, aes(x = x, y = prob_est))
    })
    output$error <- renderTable({
        dev_ent <- dat_ent %>% mutate(prob_est = funcion_pred()(x)) %>% 
            mutate(devianza = devianza(prob_est, g)) %>% 
            summarise(devianza_ent = mean(devianza))
        dev_ent
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
