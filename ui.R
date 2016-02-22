shinyUI(navbarPage("Car Master 2016",
                   
        tabPanel("Documentation",
                            
                mainPanel(
                        h2('Documentation'),
                        h4('_____________________________________________________________________________________________________'),
                                    
                        h3('First Tab Panel'),
                                    
                        h5('The first tab panel shows the documentation and how to use the app. You are here :)'),
                                    
                        h3('Second Tab Panel'),

                        h4('Use Case:'),
                        h5('When you want to predict the Fuel Economy of a car in miles per gallon based on the car features.'),

                        h4('Details:'),
                        h5('You input the Engine Displacement (in Litres), the number of Cylinders, 
                            the number of Gears, and Air Aspiration Method. After you press the predict button we use
                            a random forests model to predict the Combined (Highway+City) Fuel Economy of the car
                            in miles per gallon (mpg).'),
                                    
                        h3('Third Tab Panel'),

                        h4('Use Case:'),
                        h5("When you want to compare the fuel economy of 3 brands' car models with certain features."),
                        
                        h4('Details:'),
                        h5('You select the three brands you want to compare and input the Engine Displacement range (in Litres), the number of Cylinders, 
                        the number of Gears, and Air Aspiration Method and then press the compare button.'),
                        
                        h4('Output Explained:'),
                        h5("At the top, you see a table with the number of car models from each brand matching your selected features.
                            Next, you see a boxplot showing the distribution of Combined (Highway+City) 
                            Fuel Economy and mean mpg of the 3 Brands' car models based on the selected features."),
                                    
                        h3('Fourth Tab Panel'),
                                    
                        h4('Use Case:'),
                        h5("When you have a car model in mind and you know its features including fuel economy and want to compare it's fuel
                           economy to other car models' with the same features."),
                        
                        h4('Details:'),
                        h5("You input your car model's fuel economy (in mpg), the Engine Displacement (in Litres), the number of Cylinders, 
                           the number of Gears, and Air Aspiration Method and then press the compare button."),
                        
                        h4('Output Explained:'),
                        h5("At the top, you see the number of car models in our data matching your selected features.
                           Next, you see a boxplot showing the distribution of Combined (Highway+City) 
                           Fuel Economy in mpg of all car models with the selected features. You can also see the mean mpg of those car models as well
                           as the mpg of your car to see where it falls in the distribution."),
                                    
                        h3('Data Source:'),
                                    
                        h5("This app uses Fuel economy data that are the result of vehicle testing done at the 
                            Environmental Protection Agency's National Vehicle and Fuel Emissions Laboratory in Ann Arbor,
                            Michigan, and by vehicle manufacturers with oversight by EPA."),
                       h5('This data is available from the fueleconomy.gov website. Fueleconomy.gov is the official
                           U.S. government source for fuel economy information.'),
                       h5('We use the 2016 datafile which can be accessed directly through the
                           link: https://www.fueleconomy.gov/feg/epadata/16data.zip
                           or from the webpage: https://www.fueleconomy.gov/feg/download.shtml'),
                       h5('Note that we disregard car models running on Diesel. We also disregard car models without Engine Displacement
                           information as well as car models with Engine Air Aspiration Method of "Turbocharged + Supercharged".')
                       )
             ), ## Closing first tabPanel
                
             tabPanel("Predict MPG from Multiple Features",
                  
                  sidebarPanel(
                         sliderInput("EngDispl", h3("Engine Displacement"), 
                                      min = 0.9, max = 8.4, value = 3.0, step= 0.1),
                                
                         radioButtons("Cyl", label = h3("Number of Cylinders"),
                                      c("3" = 3,
                                        "4" = 4,
                                        "5" = 5,
                                        "6" = 6,
                                        "8" = 8,
                                        "10"=10,
                                        "12"=12),
                                      selected = 6
                                               
                         ),
                                
                         radioButtons("Gears", label = h3("Number of Gears"),
                                      c("1" = 1,
                                        "4" = 4,
                                        "5" = 5,
                                        "6" = 6,
                                        "7" = 7,
                                        "8" = 8,
                                        "9" = 9),
                                      selected = 6
                                ),
                                
                         selectInput("AirAspir", label = h3("Air Aspiration Method"), 
                                     choices = list("Naturally Aspirated (NA)" = "NA",
                                                    "Supercharged (SC)" = "SC",
                                                    "Turbocharged (TC)" = "TC"),
                                     selected = 1),
    
                        actionButton("goButton1", "Predict!")
                 ),
                  
                 mainPanel(
                        h2('Predict Fuel Economy'),
                        h4('________________________________________________________________________________________________________'),
                        h4('This model uses the Engine Displacement, number of cylinders, number of gears, and engine air aspiration method
                           of a car model to predict the miles per gallon it will travel.'),
                        h4('________________________________________________________________________________________________________'),
                        br(),
                        
                        h4(textOutput('EngDispl')),
                        h4(textOutput('Cyl')),
                        h4(textOutput('Gears')),
                        h4(textOutput('AirAspir')),
                        h1(textOutput('prediction'))
                 )
            ), ## Closing second tabPanel
                  
            tabPanel("Compare MPG Between Brands",
                           
                sidebarPanel(
                                 
                        selectInput("brand1", label = h3("Select 1st Brand"), 
                                    choices = list("Acura","Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW",
                                                    "Buick", "Cadillac", "Chevrolet", "Chrysler","Dodge", "Ferrari",
                                                    "Fiat","Ford","GMC","Honda","Hyundai","Infinity","Jaguar", "Jeep",
                                                    "Kia","Land Rover","Lexus", "Lincoln","Maserati", "Mazda", "Mclaren",
                                                    "Mercedez-Benz", "Mini","Mitsubishi","Nissan","Porsche","RAM",
                                                    "Roush", "Scion", "Subaru", "Toyota", "Volkswagen","Volvo"),
                                     selected = "Audi"),
                                
                       selectInput("brand2", label = h3("Select 2nd Brand"), 
                                   choices = list("Acura","Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW",
                                                  "Buick", "Cadillac", "Chevrolet", "Chrysler","Dodge", "Ferrari",
                                                  "Fiat","Ford","GMC","Honda","Hyundai","Infinity","Jaguar", "Jeep",
                                                  "Kia","Land Rover","Lexus", "Lincoln","Maserati", "Mazda", "Mclaren",
                                                  "Mercedez-Benz", "Mini","Mitsubishi","Nissan","Porsche","RAM",
                                                  "Roush", "Scion", "Subaru", "Toyota", "Volkswagen","Volvo"), 
                                    selected = "BMW"),
                                
                       selectInput("brand3", label = h3("Select 3rd Brand"), 
                                   choices = list("Acura","Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW",
                                                  "Buick", "Cadillac", "Chevrolet", "Chrysler","Dodge", "Ferrari",
                                                  "Fiat","Ford","GMC","Honda","Hyundai","Infinity","Jaguar", "Jeep",
                                                  "Kia","Land Rover","Lexus", "Lincoln","Maserati", "Mazda", "Mclaren",
                                                  "Mercedez-Benz", "Mini","Mitsubishi","Nissan","Porsche","RAM",
                                                  "Roush", "Scion", "Subaru", "Toyota", "Volkswagen","Volvo"), 
                                   selected = "Mercedez-Benz"), 

                                
                       sliderInput("EngDispl2", label = h3("Engine Displacement Range"), min = 0.9, 
                                   max = 8.4, step = 0.1, value = c(2.0, 4.2)),
                                
                                
                       checkboxGroupInput("Cyl2", label=h3("Number of Cylinders To Include"),
                                          c("3" = 3,
                                            "4" = 4,
                                            "5" = 5,
                                            "6" = 6,
                                            "8" = 8,
                                            "10"= 10,
                                            "12"=12),
                                          selected = c(4,5,6,8)),
                                
                       checkboxGroupInput("Gears2", label=h3("Number of Gears To Include"),
                                          c("1" = 1,
                                            "4" = 4,
                                            "5" = 5,
                                            "6" = 6,
                                            "7" = 7,
                                            "8" = 8,
                                            "9" = 9),
                                          selected=c(6,7,8,9)),
                       
                       checkboxGroupInput("AirAspir2", label=h3("Air Aspiration Method To Include"),
                                          c("Naturally Aspirated (NA)" = "NA",
                                            "Supercharged (SC)" = "SC",
                                            "Turbocharged (TC)" = "TC"),
                                          selected=c("NA","SC","TC")),
         
                      actionButton("goButton2", "Compare!")
               ),
                           
               mainPanel(
                      h2("Compare Fuel Economy Between Multiple Brands' Car Models"),
                      h4('________________________________________________________________________________________________________'),
                      h5('Select the three brands you want to compare and input the Engine Displacement range (in Litres), the number of Cylinders, 
                        the number of Gears, and Air Aspiration Method and then press the compare button.'),
                      h4('________________________________________________________________________________________________________'),
                      br(),
                      h4(textOutput('statement1')),
                      dataTableOutput('count'),
                      
                      br(),
                      plotOutput('plot1')   
                                  
               )
          ), ## Closing third tabPanel
        
        tabPanel("Compare a Car Model's MPG To Similar Models",
                 
                 sidebarPanel(
                         
                         sliderInput("CombFE", h3("Miles Per Gallon"), 
                                     min = 2.0, max = 35, value = 20, step= 0.1),
                         
                         sliderInput("EngDispl3", h3("Engine Displacement"), 
                                     min = 0.9, max = 8.4, value = 2.0, step= 0.1),
                         
                         radioButtons("Cyl3", label = h3("Number of Cylinders"),
                                      c("3" = 3,
                                        "4" = 4,
                                        "5" = 5,
                                        "6" = 6,
                                        "8" = 8,
                                        "10"=10,
                                        "12"=12),
                                      selected = 4
                                      
                         ),
                         
                         radioButtons("Gears3", label = h3("Number of Gears"),
                                      c("1" = 1,
                                        "4" = 4,
                                        "5" = 5,
                                        "6" = 6,
                                        "7" = 7,
                                        "8" = 8,
                                        "9" = 9),
                                      selected = 6
                         ),
                         
                         selectInput("AirAspir3", label = h3("Air Aspiration Method"), 
                                     choices = list("Naturally Aspirated (NA)" = "NA",
                                                    "Supercharged (SC)" = "SC",
                                                    "Turbocharged (TC)" = "TC"),
                                     selected = 1),
                         
                         actionButton("goButton3", "Compare!")   
                 ),
                 
                 mainPanel(
                         h2("Compare a Car Model's Fuel Economy to Models with Similar Features"),
                         h4('________________________________________________________________________________________________________'),
                         h5("Input your car model's fuel economy (in mpg), the Engine Displacement (in Litres), the number of Cylinders, 
                           the number of Gears, and Air Aspiration Method and then press the compare button. You will then see how your 
                            car models's mpg compares to other car models' mpg. The car models used in the comparison all have the same
                            features you selected except the mpg being compared of course."),
                         h4('________________________________________________________________________________________________________'),
                         br(),
                         h4(textOutput('statement2')),
                         
                         br(),
                         plotOutput('plot2',height = "1000px")   
                         
                 )
                 
        ) ## Closing fourth tabPanel
))