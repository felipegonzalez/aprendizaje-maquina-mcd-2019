# función logística
h <- function(z) exp(z)/(1+exp(z))


# calculo de devianza para regresión logística
devianza_calc <- function(x, y){
    # devuelve la devianza no normalizada (no promedio)
    #x = matriz de datos de entradas (sin incluir columna de 1's)
    #y = respuesta (0 o 1)
    dev_fun <- function(beta){
        # beta: p+1 coeficientes
        x_beta <- as.matrix(cbind(1, x)) %*% beta
        -2 * mean(y * x_beta - log(1 + exp(x_beta)))
    }
    dev_fun
}

p_beta <- function(x, beta){
    h(as.matrix(cbind(1, x)) %*% beta) 
}

grad_calc <- function(x_ent, y_ent){
    # calcula el gradiente de la devianza
    salida_grad <- function(beta){
        n <- nrow(x_ent)
        p_beta <- h(as.matrix(cbind(1, x_ent)) %*% beta) 
        e <- y_ent - p_beta
        grad_out <- - 2 / n *as.numeric(t(cbind(1,x_ent)) %*% e)
        names(grad_out) <- c('Intercept', colnames(x_ent))
        grad_out
    }
    salida_grad
}

descenso <- function(n, z_0, eta, h_deriv){
    # iterar descenso en gradiente
    z <- matrix(0,n, length(z_0))
    z[1, ] <- z_0
    for(i in 1:(n-1)){
        z[i+1, ] <- z[i, ] - eta * h_deriv(z[i, ])
    }
    z
}