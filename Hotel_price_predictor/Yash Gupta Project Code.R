# Project Title:  <Indian Hotel Industry>
# NAME: <YASH GUPTA>
# EMAIL: <yashhguptaa1@gmail.com>
# COLLEGE: <BVCOE> 

#1.Read the data into R


project<- read.csv(paste("Cities42.csv", sep=""))
View(project)

#2.All the libraries that are included

library(psych)
library(car)
library(lattice)
library(corrgram)
library(corrplot)
library(Hmisc)

#3.Summarize the data to understand the mean, median, standard deviation of each variable

attach(project)#allows to use vector name without specifying data frame
summary(project)
describe(project)[,c(2,3,4,5,8,9)]

#4.Data Types 

str(project)

#Tells how Mean Roomrent varies with Ranking of city 

by(project$RoomRent, project$CityRank, mean)

#Tells mean Roomrent for different star rating hotels in india

meanrent<-aggregate(RoomRent, by=list(StarRating = StarRating), mean)
meanrent
max(meanrent)
#tells no of star rating hotel depending on tourist destinaton

hotel1 <- xtabs(~ StarRating+IsTouristDestination, data=project)
hotel1
ftable(hotel1)

# Create a dataframe called tdhotel having the subset of cities that are tourist destinations were placed
tdhotel<- project[ which(project$IsTouristDestination==1) , ]
View(tdhotel)
summary(tdhotel)
mean(tdhotel$RoomRent)
mean(RoomRent)

# Take subset of maximum rent of hotel in india
maxRent<-subset(project,RoomRent==min(project$RoomRent))
maxRent

#Think of your problem as Y = F(x1, x2, x3..)

#Correlation Matrix

hotelpricing <- c("RoomRent","HasSwimmingPool","CityRank","IsMetroCity","StarRating","Airport","HotelCapacity","FreeWifi","FreeBreakfast","IsWeekend","IsTouristDestination","IsNewYearEve","Population")
corMatrix <- rcorr(as.matrix(project[,hotelpricing]))
corMatrix

hotelpricing1 <- c("RoomRent","HasSwimmingPool","CityRank","IsMetroCity","StarRating","Airport","HotelCapacity","FreeWifi","FreeBreakfast","IsWeekend","IsTouristDestination","IsNewYearEve","Population")
corMatrix1 <- rcorr(as.matrix(tdhotel[,hotelpricing1]))
corMatrix1

#Identify the Dependent Variable(s) (i.e. the Y in the Y = F(x)) in your dataset
### Y= RoomRent

#Identify the three most important Independent variables (i.e. x1, x2, x3) in your dataset.
### X1=HasSwimmingPool, X2=StarRating ,X3=HotelCapacity
#Draw a Corrgram of Y, x1, x2, x3  (Ignore other variables for now) 

#Visualize Y, x1, x2, x3 individually. Ignore other variables for now.

#x3 is continuous, draw a Box Plot for it.

boxplot(HotelCapacity, 
        main="Relative price of Premium tickets",
        horizontal=TRUE,
        col=c("yellow"),
        xlab="Price" )

# X1, X2 is categorical,  create a table() for it

table(StarRating)
table(HasSwimmingPool)

hotel2 <- xtabs(~ StarRating+HasSwimmingPool, data=project)
addmargins(hotel2)
ftable(hotel2) 

#Draw Scatter Plots to understand how are the variables correlated pair-wise

scatterplot(HasSwimmingPool,RoomRent , main="Room rent dependence on presence of swimming pool", xlab="HasSwimmingPool", ylab="RoomRent")

scatterplot(StarRating,RoomRent , main="Room rent dependence on StarRating", xlab="StarRating", ylab="RoomRent")

scatterplot(HotelCapacity, RoomRent , main="Room rent dependence on Hotel Capacity", xlab="HotelCapacity", ylab="RoomRent")


scatterplot(tdhotel$IsMetroCity, tdhotel$RoomRent , main="Relative Price Difference vs. Pitch", xlab="tdhotel$IsMetroCity", ylab="tdhotel$RoomRent")

scatterplotMatrix(
  project[
    ,c("RoomRent","HasSwimmingPool","StarRating","HotelCapacity")], 
  spread=TRUE, smoother.args=list(lty=2),
  main="Scatter Plot Matrix")


#Draw a Corrgram of Y, x1, x2, x3  (Ignore other variables for now) 

hotelpricing2 <- c("RoomRent","HasSwimmingPool","StarRating","HotelCapacity")
corrgram( project[,hotelpricing2], order=TRUE,
         main="Hotel Pricing in India",
         lower.panel=panel.pts, upper.panel=panel.pie,
         diag.panel=panel.minmax, text.panel=panel.txt)

#Create a Variance-Covariance Matrix for Y, x1, x2, x3

corMatrix <- rcorr(as.matrix(project[,hotelpricing2]))
corMatrix


#Articulate a Hypothesis (or two) that you could test using a Regression Model
#The Internal Factors have much greater influence in deciding Room Rent of Hotels than External factors.
#For all the hotels in tourist destinations,their room rent has an inverse relation with IsMetrocity(whether a city is a metro city or not)

#Run t.test to check validity of hypothesis

reg1<-cbind(RoomRent,HasSwimmingPool,HotelCapacity,StarRating) #Internal factors
reg2<-cbind(RoomRent,IsNewYearEve,IsMetroCity,IsTouristDestination,CityRank) #External Factors

#For H1
t.test(reg1,reg2)

#For H2
t.test(tdhotel$RoomRent,tdhotel$IsMetroCity)

#Formulate  Regression Model: 

# PREDICTING Room Rent FROM Internal Factors
#  Room Rent: Dependent variable 
#  StarRating , HotelCapacity ,HasSwimmingPool: Independent variables
#  Model:    RoomRent = b0 + b1*StarRating + b2*HotelCapacity +b3*HasSwimmingPool
# The lm() function in R gets (RoomRent,  StarRating , HotelCapacity ,HasSwimmingPool) as input
#      and returns beta coefficients {b0, b1,b2,b3} as output 


Model1<-RoomRent ~ StarRating + HotelCapacity +HasSwimmingPool
fit1 <- lm(Model1, data = project)
summary(fit1)

# b0 = -6896,  b1 = 3597 ,b2= -15 ,b3=2528
# Model:    RoomRent = b0 + b1*StarRating + b2*HotelCapacity +b3*HasSwimmingPool

#BETA COEFFICIENTS coefficients()
fit1$coefficients

# CONFIDENCE INTERVALS (95%)
confint(fit1)

# PREDICTING Room Rent FROM External Factors
#  Room Rent: Dependent variable 
#  IsNewYearEve,IsMetroCity,IsTouristDestination: Independent variables
#  Model:    RoomRent = b0 + b1*IsNewYearEve+b2*IsMetroCity+b3*IsTouristDestination
# The lm() function in R gets (RoomRent,  IsNewYearEve,IsMetroCity,IsTouristDestination) as input
#      and returns beta coefficients {b0, b1,b2,b3} as output 

Model2<-RoomRent~IsNewYearEve+IsMetroCity+IsTouristDestination
fit2 <- lm(Model2, data = project)
summary(fit2)

# Model:    RoomRent = b0 + b1*IsNewYearEve+b2*IsMetroCity+b3*IsTouristDestination
# b0 = 4201,  b1 = 863 ,b2= -1416 ,b3=2171 

#BETA COEFFICIENTS coefficients()
fit2$coefficients

# CONFIDENCE INTERVALS (95%)
confint(fit2)


# PREDICTING Room Rent of tourist destination hotel FROM IsMetroCity
#  Room Rent: Dependent variable 
#  IsMetroCity: Independent variable

#  Model:    RoomRent = b0 + b1*IsMetroCity 
# The lm() function in R gets (RoomRent,  IsMetroCity) as input
#      and returns beta coefficients {b0, b1} as output 


Model3<-tdhotel$RoomRent ~tdhotel$IsMetroCity
fit3 <- lm(Model3, data = tdhotel)
summary(fit3)

# Model:    PriceRelative = b0 + b1*IsMetroCity
# b0 = 6755,  b1 = -2049

#BETA COEFFICIENTS coefficients()
fit3$coefficients

# CONFIDENCE INTERVALS (95%)
confint(fit3)

# MODEL 1 fits better than MODEL 2, as indicated by AIC values

#For Model 1 
AIC(fit1)
#For Model 2
AIC(fit2)
AIC(fit3)
#Thus, Model 1 is our 'best' ordinary least squares model.

# For making Table 1: SUMMARY STATISTICS OF INDIAN HOTEL INDUSTRY

Delhi <- project[ which(project$CityName=="Delhi") , ] 
summary(Delhi)

Mumbai <- project[ which(project$CityName=="Mumbai") , ] 
summary(Mumbai)

Jaipur <- project[ which(project$CityName=="Jaipur") , ] 
summary(Jaipur)

Bangalore <- project[ which(project$CityName=="Bangalore") , ] 
summary(Bangalore)

Goa <- project[ which(project$CityName=="Goa") , ] 
summary(Goa)

Kochi <- project[ which(project$CityName=="Kochi") , ] 
summary(Kochi)

summary(project)


#-----------------------------------------------------------------THE END-----------------------------------------------------------------------------------------

