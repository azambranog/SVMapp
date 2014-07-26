library(e1071)
data2corner <- function(nred,ngreen) {
    if(nred <= 0) {
        nred <- 1
    }
    if(ngreen <= 0) {
        ngreen <- 1
    }
    
    red <- matrix(rnorm(ceiling(nred)*2 , mean = 3, sd = 1), ceiling(nred) ,2)
    green <- matrix(rnorm(ceiling(ngreen)*2, mean = 1, sd = 1), ceiling(ngreen), 2)
    points <- rbind(red, green)
    y <- as.factor(matrix(c(rep("red",ceiling(nred)),rep("green",ceiling(ngreen)))))
    return(data.frame(x = points[, 1], y = points[, 2], outcome = y))
}
data4corner <- function(nred,ngreen) {
    if(nred <= 1) {
        nred <- 2
    }
    if(ngreen <= 1) {
        ngreen <- 2
    }
    
    red1 <- matrix(c(rnorm(ceiling(nred/2), mean = 3, sd = 0.7), 
                     rnorm(ceiling(nred/2), mean = 3, sd = 0.7)), 
                   ceiling(nred/2) ,2)
    red2 <- matrix(c(rnorm(ceiling(nred/2), mean = 0, sd = 0.7), 
                     rnorm(ceiling(nred/2), mean = 0, sd = 0.7)), 
                   ceiling(nred/2) ,2)
    green1 <- matrix(c(rnorm(ceiling(ngreen/2), mean = 3, sd = 0.7), 
                       rnorm(ceiling(ngreen/2), mean = 0, sd = 0.7)), 
                     ceiling(ngreen/2) ,2)
    green2 <- matrix(c(rnorm(ceiling(ngreen/2), mean = 0, sd = 0.7), 
                       rnorm(ceiling(ngreen/2), mean = 3, sd = 0.7)), 
                     ceiling(ngreen/2) ,2)
    
    points <- rbind(red1, red2, green1, green2)
    y <- as.factor(matrix(c(rep("red",ceiling(nred/2)*2), rep("green",ceiling(ngreen/2)*2))))
    return(data.frame(x = points[, 1], y = points[, 2], outcome = y))
}
dataring <- function(nred,ngreen) {
    if(nred <= 0) {
        nred <- 1
    }
    if(ngreen <= 0) {
        ngreen <- 1
    }
    
    red <- matrix(rnorm(ceiling(nred)*2 , mean = 0, sd = 0.6), ceiling(nred) ,2)
    green <- data.frame(a=rnorm(ceiling(ngreen),2,1),b=rnorm(ngreen,-2,1),
                        c=rnorm(ceiling(ngreen),2,1),d=rnorm(ngreen,-2,1))
    index <- sample(c(1,2),ceiling(ngreen),replace=T)
    greenx <- green$a
    greenx[index==2]<-green$b[index==2]
    index <- sample(c(1,2),ceiling(ngreen),replace=T)
    greeny <- green$c
    greeny[index==2]<-green$d[index==2]
    
    points <- rbind(red, cbind(greenx,greeny))
    y <- as.factor(matrix(c(rep("red",ceiling(nred)),rep("green",ceiling(ngreen)))))
    return(data.frame(x = points[, 1], y = points[, 2], outcome = y))
}
model <- 0
 
data <- data2corner(50, 50)
    
shinyServer(function(input, output) {
    a<-reactive ({ 
            input$generate
            isolate({
                model <<- 0
                if (input$dataset == "Two Corners"){
                    data <<- data2corner(input$red, input$green)
                }
                if (input$dataset == "Four Corners"){
                    data <<- data4corner(input$red, input$green)
                }
                if (input$dataset == "Ring"){
                    data <<- dataring(input$red, input$green)
                }
                if (input$dataset == "Two Points"){
                    data <<- data2corner(1,1)
                }
            })
        })
    
    b<-reactive ({ 
        input$newpoint
        isolate({
            if (input$newpoint != 0){
                data <<- rbind(data,
                              data.frame(x = input$px, 
                                        y = input$py,
                                        outcome = input$poutcome))
            }
        })
        })
    
    c<- reactive({
        input$fit
        isolate({
            if (input$fit != 0) {
                model <<- 1
                modFit <<- svm(outcome ~., data = data, kernel = input$type)    
            }
            
        })
    })
    
    
    output$graph <- renderPlot({ 
        a()
        b()
        c()
        if (model == 0){
            plot(data$x, data$y,
                 col = as.character(data$outcome),
                 pch = 19,
                 xlab = 'x',
                 ylab = "y")
        }
        if (model == 1) {
            plot(modFit,data)
        }   
    })
    
    output$summary <- renderPrint({
        a()
        b()
        c()
        if (model == 0) {
            summary(data$outcome)       
        }
        else {
            modFit
        }
    })
    
})