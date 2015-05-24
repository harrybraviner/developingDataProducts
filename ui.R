shinyUI(
    pageWithSidebar(
        headerPanel("Car fuel efficiency prediction"),
        sidebarPanel(
            numericInput('inputWeight', 'Weight (thousands of lb)', 2, min=1, max = 6, step = 0.2),
            radioButtons('inputGears', "Number of gears",
                         c("3" = 3, "4" = 4, "5" = 5)),
            submitButton('Submit')
        ),
        mainPanel(
            h4('Written by Harry Braviner as part of the Coursera course Developing Data Products'),
            h2('Instructions'),
            p('This Shiny app use the mtcars dataset to create prediction for the fuel efficiency (in mpg) of a car given its weight, conditioned on the number of gears it has.'),
            p('The output is shown below. The linear model used to create the prediction is shown as the red line in the plot below. The data used to fit the linear model as shown (black points), and the predictor and prediction are shown by the blue lines.'),
            p('The user should pay careful attention to this plot. If the predictor weight is outside of the range of weights used to generate the model, or the model has been fitted to a very small number of data points, then the prediction may be unreliable.'),
            p('Use the sidebar on the left to enter the weight and number of gears. The prediction and the plot will not update until the submit button is pressed.'),
            h2('Predicted fuel efficiency'),
            htmlOutput('mpgWeightOutput'),
            htmlOutput('mpgGearOutput'),
            htmlOutput('mpgMpgOutput'),
            h3('Linear model used'),
            plotOutput('modelPlot')
        )
    )
)
