library(shiny)
library(ggplot2)
library(xlsx)
library(dplyr)
library(caret)
library(randomForest)

thedata<-read.xlsx2("2016_FE_Guide.xlsx",sheetName="FEguide")

usedData<-data.frame(Division=thedata$Division,EngDispl=thedata$Eng.Displ,
                     Cyl=thedata$X..Cyl,
                     CombFE=as.integer(thedata$Comb.FE..Guide....Conventional.Fuel),
                     Gears=thedata$X..Gears,FuelType=thedata$Fuel.Usage....Conventional.Fuel,
                     AirAspir=thedata$Air.Aspir.Method)
usedData$EngDispl<-as.character(usedData$EngDispl)
usedData$EngDispl<-as.numeric(usedData$EngDispl)

usedData<-usedData[is.na(usedData$EngDispl)==FALSE,] ## We exclude Cars with no Engine Displacement Information
usedData<-filter(usedData,FuelType!="DU") ## We exclude Diesel Cars
usedData<-filter(usedData,AirAspir!="TS") ## We exclude Cars with Air Aspiration Method as Turbocharged + Supercharged
## Cleaning Car Brand Names
usedData$Division<-tolower(usedData$Division)

## Cleaning includes a function to make first letter of every word a captital letter 
## It will be used on the brand names
capwords <- function(s, strict = FALSE) {
        cap <- function(s) paste(toupper(substring(s, 1, 1)),
                                 {s <- substring(s, 2); if(strict) tolower(s) else s},
                                 sep = "", collapse = " " )
        sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}
usedData$Division<-capwords(usedData$Division)
usedData$Division[usedData$Division=="Aston Martin Lagonda Ltd"]="Aston Martin"
usedData$Division[usedData$Division=="Bmw"]="BMW"
usedData$Division[usedData$Division=="Ferrari North America, Inc."]="Ferrari"
usedData$Division[usedData$Division=="Gmc"]="GMC"
usedData$Division[usedData$Division=="Hyundai Motor Company"]="Hyundai"
usedData$Division[usedData$Division=="Kia Motors Corporation"]="Kia"
usedData$Division[usedData$Division=="Mercedes-benz"]="Mercedez-Benz"
usedData$Division[usedData$Division=="Mitsubishi Motors Corporation"]="Mitsubishi"
usedData$Division[usedData$Division=="Ram"]="RAM"
usedData$Division[usedData$Division=="Roush Industries, Inc."]="Roush"
usedData$Division[usedData$Division=="Volvo Cars Of North America, Llc"]="Volvo"

## For Reference Only - Code Used To Create Random Forests Prediction Model and Save to file for the App to use.
# set.seed(12345)
# rfmodFit<-train(CombFE~EngDispl+factor(Cyl)+factor(Gears)+factor(AirAspir),data=usedData,method="rf",PROX=TRUE)
# save(rfmodFit,file="rfmodel.RData")

## Predicts with Random Forests
predictMPGM<-function(test){
        load(file="rfmodel.RData")
        prediction<-predict(rfmodFit,test)
        return(prediction)
}

## Counts the number of car models that match comparison criteria for each brand
countIt<-function(b1,b2,b3,Cyl,Gears,EngDispl,AirAspir){
        compare<-usedData[((usedData$Division==b1 | usedData$Division==b2 | usedData$Division==b3) & usedData$Cyl %in% Cyl 
                           & usedData$Gears %in% Gears & usedData$EngDispl>=EngDispl[1]
                           & usedData$EngDispl<=EngDispl[2] & usedData$AirAspir %in% AirAspir),]
        fullinfo<-data.frame(Brand=c(b1,b2,b3),Models=c(sum(compare$Division==b1),sum(compare$Division == b2),sum(compare$Division == b3)))
        return(fullinfo)
}

## Plots the Brand Comparison Boxplot
plotIt<-function(b1,b2,b3,Cyl,Gears,EngDispl,AirAspir){
        compare<-usedData[((usedData$Division==b1 | usedData$Division==b2 | usedData$Division==b3) & usedData$Cyl %in% Cyl
                           & usedData$Gears %in% Gears & usedData$EngDispl>=EngDispl[1] 
                           & usedData$EngDispl<=EngDispl[2] & usedData$AirAspir %in% AirAspir),]
                    
        g<- ggplot(compare, aes(Division,CombFE))+
                            geom_boxplot()+
                            stat_summary(fun.y=mean, colour="darkred", geom="point", aes(shape="mean"), size=3,show.legend = TRUE)+
                            scale_shape_manual("", values=c("mean"=18))+    
                            ggtitle("Boxplot of MPG by Brand for Car Models with Selected Features") +
                            theme(plot.title = element_text(face="bold"), text = element_text(size=18),legend.position="top")+ 
                            xlab("Brand") + ylab("Combined Fuel Economy (Miles Per Gallon)")
        
        if (nrow(compare)!=0){
            print(g)
        }
        else {
            print(plot.new())        
        }
}

## Counts the number of Car Models that match Comparison Criteria 
countIt2<-function(Cyl,Gears,EngDispl,AirAspir){
        thefilter<-usedData[(usedData$Cyl==Cyl & usedData$Gears==Gears & usedData$EngDispl==EngDispl & usedData$AirAspir==AirAspir),]
        count<-nrow(thefilter)
        return(count)
}

## Plots the MPG Boxplot for Car Models with Selected Features 
plotIt2<-function(CombFE,Cyl,Gears,EngDispl,AirAspir){
        thefilter<-usedData[(usedData$Cyl==Cyl & usedData$Gears==Gears & usedData$EngDispl==EngDispl & usedData$AirAspir==AirAspir),]
        themean<-mean(thefilter$CombFE)
        if (nrow(thefilter)!=0){
                print(boxplot(thefilter$CombFE,ylim=c(0,35),
                              main="Boxplot of MPG for Car Models with Selected Features",
                              ylab="Combined Fuel Economy (Miles Per Gallon)"),
                      points(x=c(1,1),y=c(CombFE,themean),col=c("green","darkred"),
                             pch=c(18,18),cex=c(1.5,1.5)),height=200)
                print(legend("topright",c("Your MPG", "Mean MPG of Similar Models"), 
                             pch = c(18,18), cex=c(1.2,1.2), col=c("green","darkred")))
        }
        else{
                print(plot.new())
        }
}

shinyServer(
        function(input, output) {
                
                ## First tabPanel has no server code as it has only documentation
                
                ## For Second tabPanel
                EngDisplR<-eventReactive(input$goButton1, {input$EngDispl})
                CylR<-eventReactive(input$goButton1,{input$Cyl})
                GearsR<-eventReactive(input$goButton1,{input$Gears})
                AirAspirR<-eventReactive(input$goButton1,{input$AirAspir})
                predictionRF<-eventReactive(input$goButton1, {
                        predictMPGM(test<-data.frame(EngDispl=input$EngDispl,Cyl=input$Cyl,Gears=input$Gears,AirAspir=input$AirAspir))})
                
                output$EngDispl <- renderText({paste("For a car with an Engine Displacement of:",EngDisplR())})
                output$Cyl <- renderText({paste("and a cylinder number of:",CylR())})
                output$Gears <- renderText({paste("and a gear number of:",GearsR())})
                output$AirAspir <- renderText({paste("and an engine air aspiration method of:",AirAspirR())})
                output$prediction<-renderText({paste("Predicted Miles Per Gallon:",round(predictionRF(),2))})
                
                ## For Third tabPanel
                statement1<-eventReactive(input$goButton2,{st1<-"The number of car models from each brand matching your selection criteria are:"})
                counter<-eventReactive(input$goButton2,{countIt(b1<-input$brand1, b2<-input$brand2, b3<-input$brand3, 
                                                                Cyl<-input$Cyl2, Gears<-input$Gears2, EngDispl<-input$EngDispl2,
                                                                AirAspir<-input$AirAspir2)})
                plotB<-eventReactive(input$goButton2,{plotIt(b1<-input$brand1, b2<-input$brand2, b3<-input$brand3,
                                                              Cyl<-input$Cyl2, Gears<-input$Gears2, EngDispl<-input$EngDispl2,
                                                              AirAspir<-input$AirAspir2)})
                
                output$statement1<-renderText({statement1()})
                output$count<-renderDataTable({counter()},options = list(paging=FALSE,searching=FALSE,pageLength=1))
                output$plot1<-renderPlot({plotB()})
               
                
                ## For Fourth tabPanel
                
                statement2<-eventReactive(input$goButton3,{st2<-"The total number of car models matching your selected features is:"})
                counter2<-eventReactive(input$goButton3,{countIt2(Cyl<-input$Cyl3, Gears<-input$Gears3, EngDispl<-input$EngDispl3,
                                                                AirAspir<-input$AirAspir3)})
                
                plotB2<-eventReactive(input$goButton3,{plotIt2(CombFE<-input$CombFE, Cyl<-input$Cyl3, Gears<-input$Gears3,
                                                               EngDispl<-input$EngDispl3, AirAspir<-input$AirAspir3)})
                
                output$statement2<-renderText({paste(statement2(),counter2())})
                
                output$plot2<-renderPlot({plotB2()})
     
        }
)