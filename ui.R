library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Getting Familiar with Support Vector Machines (SVM)"),
    
    sidebarLayout(
        sidebarPanel(
            tabsetPanel(
                tabPanel("Documentation",
                         p("This app was created as part of the Data Products course. 
                           The source code can be found at",
                           a("github", href="https://github.com/azambranog/SVMapp")),
                         p("You can select from four interesting data distributions 
                            with two possible outcomes (green or red). For these
                            concentrations you can selected the ammount of points
                           for each outcome. Press Generate to generate a new set 
                           of random points"),
                         p("You can manually add points to the plot using the 
                           corresponding fields and then press the insert point Button.
                           We recommend that you only use this with the Two Points
                           distribution, to oberve the effect of new points in the SVM.
                           Each time you add a new point it will be automatically plotted.
                           You can see the amount of points below the plot"),
                         p("Press the fit model button to fit a SVM. The model classification
                           surface will be automatically plotted. You can choose from
                           several types of kernel to see the differences. A model
                           summary will be show below the plot"),
                         p("Enjoy")
                           
                ) ,
                tabPanel( "App Controls",
                          h5("Starting data"),
                          selectInput("dataset", 
                                      label = "Choose a Dataset to start",
                                      choices = list("Two Corners", "Four Corners",
                                                     "Ring", "Two Points"),
                                      selected = "Two Corners"),
                          fluidRow(
                              column(4,numericInput("green", "Number of Green Points", 100)),
                              column(4,numericInput("red", "Number of Red Points", 100))
                              ),
                          actionButton("generate", label = "Generate"),
                          tags$hr(),
                          h5("Add Points"),
                          fluidRow(column(3, numericInput('px', 'X', 0.0, step = 0.1)),
                                   column(3, numericInput('py', 'Y', 0.0, step = 0.1))
                          ),
                          fluidRow(column(3, radioButtons("poutcome", 
                                                          "Outcome", 
                                                          choices = list("Red" = "red", 
                                                                         "Green" = "green"),
                                                          selected = "red")),
                                   column(4, actionButton('newpoint', "Insert Point"))
                          ),
                          tags$hr(),
                          h5("SVM"),
                          fluidRow(column(3,radioButtons("type", 
                                                         "Kernel", 
                                                         choices = list("Radial" = "radial",
                                                                        "Linear" = "linear", 
                                                                        "Polynomial" = "polynomial",
                                                                        "Sigmoid" = "sigmoid"),
                                                         selected = "radial")),
                                   column(4,actionButton('fit', "Fit Model"))
                                   )
                          
            )
        )
        )
        ,
        
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("graph"),
            verbatimTextOutput("summary")
        )
    )
))