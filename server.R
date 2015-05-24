library(shiny)
library(ggplot2)

data(mtcars)
carsG3 <- mtcars[mtcars$gear==3, ]
carsG4 <- mtcars[mtcars$gear==4, ]
carsG5 <- mtcars[mtcars$gear==5, ]
LM3 <- lm(mpg ~ wt, data = carsG3)
LM4 <- lm(mpg ~ wt, data = carsG4)
LM5 <- lm(mpg ~ wt, data = carsG5)

shinyServer(
    function(input, output) {
        mpgPred <- reactive({gears <- input$inputGears
                             weight <- input$inputWeight
                             if (gears == 3){
                                predict(LM3, newdata = data.frame(wt=weight))
                             } else if (gears == 4) {
                                predict(LM4, newdata = data.frame(wt=weight))
                             } else {
                                predict(LM5, newdata = data.frame(wt=weight))
                             }})
        output$mpgPrediction <- renderPrint(mpgPred()[[1]])
        output$mpgWeightOutput <- renderText(paste("For a car of weight <strong>", input$inputWeight*1000.0, "</strong> lbs,", sep = ""))
        output$mpgGearOutput <- renderText(paste("conditioned on having <strong>", input$inputGears, "</strong> gears,", sep = ""))
        output$mpgMpgOutput <- renderText(paste("the predicted fuel efficiency is <strong>", round(mpgPred(), digit=1), "</strong> mpg.", sep = ""))
        output$modelPlot <- renderPlot({gears <- input$inputGears
                                        weight <- input$inputWeight
                                        pred <- if (gears == 3){
                                                    predict(LM3, newdata = data.frame(wt=weight))
                                                 } else if (gears == 4) {
                                                    predict(LM4, newdata = data.frame(wt=weight))
                                                 } else {
                                                    predict(LM5, newdata = data.frame(wt=weight))
                                                 }
                                       if(gears == 3){
                                           dataset <- carsG3
                                           model <- LM3
                                       } else if (gears == 4) {
                                           dataset <- carsG4
                                           model <- LM4
                                       } else {
                                           dataset <- carsG5
                                           model <- LM5
                                       }
                                           q <- qplot(dataset$wt, dataset$mpg, xlab = "Weight (thousands of lb)", ylab = 'mpg')
                                           q <- q + geom_abline(intercept = model$coefficients[1],
                                                                slope = model$coefficients[2], col = "red", lwd=1.5)
                                           q <- q + geom_vline(xintercept = weight, col = 'blue', lwd=0.5)
                                           q <- q + geom_hline(yintercept = pred, col = 'blue', lwd=0.5)
                                           q
                                       }
                                      )
    }
)
