# Installing Packages  

install.packages("psych")
install.packages("lattice")
install.packages("caret")
install.packages("corrplot")
install.packages("ggcorrplot")
install.packages("tidyverse")
install.packages("C50")
install.packages("dplyr")
install.packages("pacman")
install.packages("neuralnet")
install.packages("randomForest")
install.packages("e1071")
install.packages("ggpubr")

library(tidyverse)
library(readxl)
library(ggcorrplot)
library(corrplot)
library(psych)
library(lattice)
library(caret)
library(ggplot2)
library(lattice)
library(caret)
library(e1071)
library(Hmisc)
library(survival)
library(C50)
library(dplyr)
library(pacman)
library(neuralnet)
library(randomForest )
library(ggpubr)


#Customer Application Status File 
df1 <- read.csv('App.csv')

#Summary Statistics  
summary(df1)

# Credit Status File 
df2 <- read.csv('Record.csv')

#Summary Statistics s 
summary(df2)

#Assigning Points for credit record payment in status Column
#100 means very late and 800 Point for timely payment 
df2$STATUS[df2$STATUS == "5"] <- 100
df2$STATUS[df2$STATUS == "4"] <- 200
df2$STATUS[df2$STATUS == "3"] <- 300
df2$STATUS[df2$STATUS == "2"] <- 400
df2$STATUS[df2$STATUS == "1"] <- 500
df2$STATUS[df2$STATUS == "0"] <- 600
df2$STATUS[df2$STATUS == "X"] <- 700
df2$STATUS[df2$STATUS == "C"] <- 800

# Convert the Status to numeric 
df2$STATUS <- as.numeric(df2$STATUS)

#Convert negative month balance value to positive 
df2$MONTHS_BALANCE <- df2$MONTHS_BALANCE * (-1) + 1

# Summation of Status and maximum (given points)
df2<- df2 %>% group_by(ID) %>% 
  summarise(MONTHS_BALANCE = max(MONTHS_BALANCE), STATUS = sum(STATUS)) 

# Creating the target variable Credit Score 
df2$CREDIT_SCORE <- formatC(df2$STATUS / df2$MONTHS_BALANCE)
df2$CREDIT_SCORE <- as.numeric(df2$CREDIT_SCORE)
summary(df2)
# Merging the two data-frames by ID 
df3 <- merge(df1, df2 , by.x = "ID", by.y = "ID")

# checking the Unique ID in df3 
length(unique(df3$ID))

# Converting the Days Birth in to Age (years) rounding off to the nearest Integer 
df3$AGE<- ceiling(df3$DAYS_BIRTH / 365) * -1
glimpse(df3)


# Replacing unemployed & Converting the Days employed to Years employed  and rounding off 

df3$DAYS_EMPLOYED[df3$DAYS_EMPLOYED == 365243] <- 0

df3$YEARS_EMP<-ceiling(df3$DAYS_EMPLOYED / 365 ) * -1


#DATA VISUALISATION 

#Histogram for Continuous Variables 
par(mfrow=c(2,3))
hist(df3[,5], freq = FALSE, main = "CNT_CHILDREN", xlab = "Count of Children", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$CNT_CHILDREN), sd=sd(df3$CNT_CHILDREN)), add=TRUE, col="#eb5050")

hist(df3[,6], freq = FALSE, main = "AMT_INCOME_TOTAL", xlab = "Amount of Total Income", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$AMT_INCOME_TOTAL), sd=sd(df3$AMT_INCOME_TOTAL)), add=TRUE, col="#eb5050")

hist(df3[,18], freq = FALSE, xlim=c(0,20), main = "CNT_FAM_MEMBERS", xlab = "Count of Family Members", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$CNT_FAM_MEMBERS), sd=sd(df3$CNT_FAM_MEMBERS)), add=TRUE, col="#eb5050")

hist(df3[,22], freq = FALSE, xlim=c(10,80) ,ylim=c(0.000,0.040), main = "AGE", xlab = "Age of the customers", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$AGE), sd=sd(df3$AGE)), add=TRUE, col="#eb5050")

hist(df3[,23], freq = FALSE, main = "YEARS_EMP", xlab = "Total Employment in Years", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$YEARS_EMP), sd=sd(df3$YEARS_EMP)), add=TRUE, col="#eb5050")

hist(df3[,21], freq = FALSE, main = "CREDIT_SCORE", xlab = "Total Credit Score", col="#96b9e3", border = "black")
curve(dnorm(x, mean=mean(df3$CREDIT_SCORE), sd=sd(df3$CREDIT_SCORE)), add=TRUE, col="#eb5050")


#Bar Plot  for Categorical Variables 

A<-ggplot(data=df3,aes(NAME_EDUCATION_TYPE,fill=NAME_EDUCATION_TYPE))+
  geom_bar(position = "dodge")+
  theme(axis.text.x=element_text(angle = -45, hjust = 0, size = 15))

B<-ggplot(data=df3,aes(NAME_INCOME_TYPE,fill=NAME_INCOME_TYPE))+
  geom_bar(position = "dodge")+
  theme(axis.text.x=element_text(angle = -45, hjust = 0, size = 15))

C<-ggplot(data=df3,aes(NAME_FAMILY_STATUS,fill=NAME_FAMILY_STATUS))+
  geom_bar(position = "dodge")+
  theme(axis.text.x=element_text(angle = -45, hjust = 0, size = 15))

D<-ggplot(data=df3,aes(NAME_HOUSING_TYPE,fill=NAME_HOUSING_TYPE))+
  geom_bar(position = "dodge")+
  theme(axis.text.x=element_text(angle = -45, hjust = 0, size = 15))

figure <- ggarrange(A,B,C,D,labels = c("A","B","C","D"), ncol = 2, nrow = 2)
figure

ggplot(data=df3,aes(OCCUPATION_TYPE,fill=OCCUPATION_TYPE))+
geom_bar(position = "dodge")+theme(axis.text.x=element_text(angle = -45, hjust = 0, size = 15))

#Scatter Plot : Interaction Education Type, Credit Score and Age 
ggplot(data=df3, aes(x=NAME_EDUCATION_TYPE, col=AGE)) +
  geom_point(aes(y=CREDIT_SCORE), alpha=0.1)

#Scatter Plot : Interaction Family Status, Credit Score , Age and Income 
ggplot(data=df3, aes(x=AMT_INCOME_TOTAL,
                     size=AGE, shape=NAME_FAMILY_STATUS)) +
  geom_point(aes(y=CREDIT_SCORE), col="#438FFF", alpha=0.3)


# DATA PREPROCESSING
#Binning the Occupation Type 

unique(df3$OCCUPATION_TYPE)

df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "High skill tech staff" ] <- "High Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Medicine staff"] <- "High Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE ==  "IT staff" ] <- "High Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Realty agents" ] <- "High Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE ==  "Managers"] <- "High Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE ==  "Accountants"] <- "High Skilled"


df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Sales staff" ] <- "Medium Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Core staff" ] <- "Medium Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Private service staff" ] <- "Medium Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Secretaries" ] <- "Medium Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "HR staff" ] <- "Medium Skilled"

unique(df3$OCCUPATION_TYPE)

df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "unavailable" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Security staff" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE ==  "Laborers" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Drivers" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Cleaning staff" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Cooking staff" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Low-skill Laborers" ] <- "Low Skilled"
df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == "Waiters/barmen staff" ] <- "Low Skilled"

# Fixing Missing Values in Occupation Type 

df3$OCCUPATION_TYPE[df3$OCCUPATION_TYPE == ""] <- NA

df3$OCCUPATION_TYPE[is.na(df3$OCCUPATION_TYPE)] <- "unavailable"

unique(df3$OCCUPATION_TYPE)

df3$OCCUPATION_TYPE <- as.factor(df3$OCCUPATION_TYPE)

summary(df3)

# replacing all empty cell to NA 
df3[df3 == ""] <- NA

# checking any more missing value left 
sum(is.na(df3))

glimpse(df3)

#Creating the factors and levels for Name Income Type
df3$NAME_INCOME_TYPE <- factor(df3$NAME_INCOME_TYPE, levels = c("Commercial associate", "Working", "State servant" , "Pensioner" , "Student"))

levels(df3$NAME_INCOME_TYPE)

summary(df3$NAME_INCOME_TYPE)

# Checking the levels 
unique(df3$NAME_EDUCATION_TYPE)

#Creating the factors and levels for Name Education Type
df3$NAME_EDUCATION_TYPE <- factor(df3$NAME_EDUCATION_TYPE,levels = c("Academic degree" , "Higher education", "Incomplete higher", "Secondary / secondary special", "Lower secondary"))

# Checking the levels 
levels(df3$NAME_EDUCATION_TYPE)

summary(df3$NAME_EDUCATION_TYPE)

#Creating the factors and levels for Name Family Status

unique(df3$NAME_FAMILY_STATUS)

#convert civil marriage to married
df3$NAME_FAMILY_STATUS[df3$NAME_FAMILY_STATUS == "Civil marriage"] <- "Married"

#checking Family status 

unique(df3$NAME_FAMILY_STATUS)

df3$NAME_FAMILY_STATUS <- factor(df3$NAME_FAMILY_STATUS)

levels(df3$NAME_FAMILY_STATUS)

summary(df3$NAME_FAMILY_STATUS)

#Creating the factors and levels for Name House Type
unique(df3$NAME_HOUSING_TYPE)

df3$NAME_HOUSING_TYPE <- factor(df3$NAME_HOUSING_TYPE,
                                levels = c("House / apartment" , "Office apartment" , "Municipal apartment", "Co-op apartment","Rented apartment"  , "With parents"))

levels(df3$NAME_HOUSING_TYPE)

summary(df3$NAME_HOUSING_TYPE)

#Creating the factors and levels for Name Occupation Type

unique(df3$OCCUPATION_TYPE)

df3$OCCUPATION_TYPE <- factor(df3$OCCUPATION_TYPE)

levels(df3$OCCUPATION_TYPE)

summary(df3$OCCUPATION_TYPE)

# Convert to numeric data (YES=1 , MALE= 1 )

df3 <- df3 %>%
  mutate(CODE_GENDER = as.factor(ifelse(CODE_GENDER == "M",1,0))) %>%
  mutate(FLAG_OWN_CAR = as.factor(ifelse(FLAG_OWN_CAR == "Y",1,0))) %>%
  mutate(FLAG_OWN_REALTY = as.factor(ifelse(FLAG_OWN_REALTY == "Y",1,0)))


summary(df3$CODE_GENDER)

summary(df3$FLAG_OWN_CAR)

summary(df3$FLAG_OWN_REALTY)

summary(df3$FLAG_MOBIL)

#Note : Remove mobile because all customer have mobile 
# Removed ID , DAYS BIRTH , DAYS_EMPLOYED , MONTHS_BALANCE,STATUS & MOBILE )
df4 <- df3[ -c(1,11,12,13,19,20) ]

#

#correlation 
cor_df <- df4
cor_df$CODE_GENDER <- as.numeric(cor_df$CODE_GENDER)
cor_df$FLAG_OWN_CAR <- as.numeric(cor_df$FLAG_OWN_CAR)
cor_df$FLAG_OWN_REALTY <- as.numeric(cor_df$FLAG_OWN_REALTY)
cor_df$NAME_INCOME_TYPE <- as.numeric(cor_df$NAME_INCOME_TYPE)
cor_df$NAME_EDUCATION_TYPE <- as.numeric(cor_df$NAME_EDUCATION_TYPE)
cor_df$NAME_HOUSING_TYPE <- as.numeric(cor_df$NAME_HOUSING_TYPE)
cor_df$NAME_FAMILY_STATUS <- as.numeric(cor_df$NAME_FAMILY_STATUS)
cor_df$OCCUPATION_TYPE <- as.numeric(cor_df$OCCUPATION_TYPE)
correlation_matrix<- cor(cor_df)
correlation_matrix
corrplot(correlation_matrix)

#Creating Target Variable considering 1:Bad Credit Score, 0:Good Credit Score 
df4$CREDIT_STATUS <- ifelse(df4$CREDIT_SCORE < 600, 1, 0)

# Removed as multicollinearity Flag_own_car, Name_income_type, Count_Family_member, Credit_score)
df4 <- df4[ -c(2,6,14,15) ]
glimpse(df4)

df4$FLAG_PHONE <- as.factor(df4$FLAG_PHONE)
df4$FLAG_WORK_PHONE <- as.factor(df4$FLAG_WORK_PHONE)
df4$FLAG_EMAIL <- as.factor(df4$FLAG_EMAIL)


# Making the Target Field as categorical 
df4$CREDIT_STATUS<- as.factor(df4$CREDIT_STATUS)

# Scaling the Data except Target Field (only on Continuous Variable)
df4[,c(3,4,12,13)] <- scale(df4[,c(3,4,12,13)])
glimpse(df4)


#DATA MODELING 

# Testing & Training dataset 70:30 Ratio 
set.seed(123)
training_records<-round(nrow(df4)*(70/100))
training <- df4[1:training_records,]
testing <- df4[-(1:training_records),]

summary(testing$CREDIT_STATUS)

# Creating the c5.0 decision tree model
ModelC5 <- C5.0(CREDIT_STATUS ~ ., data = training)
summary(ModelC5)

#Predicting on test data'
Predicted_outcomes <- predict(ModelC5, newdata =testing[,1:ncol(testing)-1])

# Confusion Matrix for C5 70:30 
cm_C5 <- confusionMatrix(Predicted_outcomes,testing$CREDIT_STATUS)
print(cm_C5 )
table_C5 <- data.frame(confusionMatrix(Predicted_outcomes,testing$CREDIT_STATUS)$table)
plotTable_C5 <- table_C5 %>%
mutate(goodbad = ifelse(table_C5$Prediction == table_C5$Reference, "good", "bad")) %>%
group_by(Reference) %>%
mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix C5 70:30 
ggplot(data = plotTable_C5, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
theme_bw() +xlim(rev(levels(table_C5$Reference)))

summary(testing$CREDIT_STATUS)

# C5 - 80:20 RATIO 
set.seed(123)
training_records8020<-round(nrow(df4)*(80/100))
training8020 <- df4[1:training_records8020,]
testing8020 <- df4[-(1:training_records8020),]

# Creating the c5.0 decision tree model
ModelC5_8020 <- C5.0(CREDIT_STATUS ~ ., data = training8020)
summary(ModelC5_8020)

#Predicting on test data'
Predicted_outcomes_C5_8020 <- predict(ModelC5_8020, newdata =testing8020[,1:ncol(testing8020)-1])
# Confusion Matrix for C5 80:20  
cm_C5_8020 <- confusionMatrix(Predicted_outcomes_C5_8020 ,testing8020$CREDIT_STATUS)
print(cm_C5_8020 )
table_C5_8020 <- data.frame(confusionMatrix(Predicted_outcomes_C5_8020 ,testing8020$CREDIT_STATUS)$table)
plotTable_C5_8020 <- table_C5_8020 %>%
  mutate(goodbad = ifelse(table_C5_8020$Prediction == table_C5_8020$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix  C5 80:20 
ggplot(data = plotTable_C5_8020, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_C5_8020$Reference)))

# C5 - 90:10 RATIO 

set.seed(123)
training_records9010 <- round(nrow(df4)*(90/100))
training9010 <- df4[1:training_records9010,]
testing9010 <- df4[-(1:training_records9010),]

# Creating the c5.0 decision tree model
ModelC5_9010 <- C5.0(CREDIT_STATUS ~ ., data = training9010)
summary(ModelC5_9010)

#Predicting on test data
Predicted_outcomes_C5_9010 <- predict(ModelC5_9010, newdata =testing9010[,1:ncol(testing9010)-1])

# Confusion Matrix for C5 90:10 
cm_C5_9010 <- confusionMatrix(Predicted_outcomes_C5_9010,testing9010$CREDIT_STATUS)
print(cm_C5_9010)
table_C5_9010 <- data.frame(confusionMatrix(Predicted_outcomes_C5_9010,testing9010$CREDIT_STATUS)$table)
plotTable_C5_9010 <- table_C5_9010 %>%
  mutate(goodbad = ifelse(table_C5_9010$Prediction == table_C5_9010$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix C5 90:10 
ggplot(data = plotTable_C5_9010, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_C5_9010$Reference)))

#Random Forest 70:30 
ModelRF <- randomForest(CREDIT_STATUS ~ ., data = training, 
                        ntree = 100, 
                        mtry = 6,
                        replace = TRUE,
                        sampsize = 300 , 
                        nodesize = 5  ,
                        importance = TRUE, 
                        proximity = FALSE,
                        norm.votes=TRUE,
                        do.trace=TRUE , 
                        keep.forest=TRUE, 
                        keep.inbag=TRUE) 
plot(ModelRF)
Predicted_outcomes_RF <- predict(ModelRF, newdata =testing[,1:ncol(testing)-1])
# Confusion Matrix for RF 
cm_RF <- confusionMatrix( Predicted_outcomes_RF ,testing$CREDIT_STATUS)
print(cm_RF)

# Creating data frame for Confusion Matrix RF 70:30 
table_RF <- data.frame(confusionMatrix(Predicted_outcomes_RF ,testing$CREDIT_STATUS)$table)

plotTable_RF <- table_RF %>%
mutate(goodbad = ifelse(table_RF$Prediction == table_RF$Reference, "good", "bad")) %>%
group_by(Reference) %>%
mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix RF 70:30 
ggplot(data = plotTable_RF, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
theme_bw() +xlim(rev(levels(table_RF$Reference)))

#Random Forest 80:20 

ModelRF_8020 <- randomForest(CREDIT_STATUS ~ ., data = training8020, 
                             ntree = 100, 
                             mtry = 6,
                             replace = TRUE,
                             sampsize = 300 , 
                             nodesize = 5  ,
                             importance = TRUE, 
                             proximity = FALSE,
                             norm.votes=TRUE,
                             do.trace=TRUE , 
                             keep.forest=TRUE, 
                             keep.inbag=TRUE) 
plot(ModelRF_8020)
Predicted_outcomes_RF_8020 <- predict(ModelRF_8020, newdata =testing8020[,1:ncol(testing8020)-1])
# Confusion Matrix for RF 
cm_RF_8020 <- confusionMatrix(Predicted_outcomes_RF_8020 ,testing8020$CREDIT_STATUS)
print(cm_RF_8020)

# Creating data frame for Confusion Matrix RF_80:20
table_RF_8020 <- data.frame(confusionMatrix(Predicted_outcomes_RF_8020 ,testing8020$CREDIT_STATUS)$table)

plotTable_RF_8020 <- table_RF_8020 %>%
mutate(goodbad = ifelse(table_RF_8020$Prediction == table_RF_8020$Reference, "good", "bad")) %>%
group_by(Reference) %>%
mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix RF_80:20
ggplot(data = plotTable_RF_8020, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
theme_bw() +xlim(rev(levels(table_RF_8020$Reference)))


#Random Forest 90:10 

ModelRF_9010 <- randomForest(CREDIT_STATUS ~ ., data = training9010, 
                             ntree = 100, 
                             mtry = 6,
                             replace = TRUE,
                             sampsize = 300 , 
                             nodesize = 5  ,
                             importance = TRUE, 
                             proximity = FALSE,
                             norm.votes=TRUE,
                             do.trace=TRUE , 
                             keep.forest=TRUE, 
                             keep.inbag=TRUE) 
plot(ModelRF_9010)
Predicted_outcomes_RF_9010 <- predict(ModelRF_9010, newdata =testing9010[,1:ncol(testing9010)-1])
# Confusion Matrix for RF 
cm_RF_9010 <- confusionMatrix( Predicted_outcomes_RF_9010 ,testing9010$CREDIT_STATUS)
print(cm_RF_9010)

# Creating data frame for Confusion Matrix 
table_RF_9010 <- data.frame(confusionMatrix(Predicted_outcomes_RF_9010 ,testing9010$CREDIT_STATUS)$table)

plotTable_RF_9010 <- table_RF_9010 %>%
  mutate(goodbad = ifelse(table_RF_9010$Prediction == table_RF_9010$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix 
ggplot(data = plotTable_RF_9010, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_RF_9010$Reference)))


#Naive Bayes 70:30 
ModelNB <- naiveBayes(CREDIT_STATUS ~ ., data = training , laplace=5) 
#Predicting on test data: NB 
Predicted_outcomes_NB <- predict(ModelNB, newdata =testing[,1:ncol(testing)-1])
# Confusion Matrix: NB 
cm_NB <- confusionMatrix(as.factor(Predicted_outcomes_NB), as.factor(testing$CREDIT_STATUS))
print(cm_NB)
table_NB <- data.frame(confusionMatrix(Predicted_outcomes_NB,testing$CREDIT_STATUS)$table)
plotTable_NB <- table_NB %>%
  mutate(goodbad = ifelse(table_NB$Prediction == table_NB$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix : NB 
ggplot(data = plotTable_NB, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_NB$Reference)))

#naiveBayes 80:20 
ModelNB_8020 <- naiveBayes(CREDIT_STATUS ~ ., data = training8020 , laplace=5) 
#Predicting on test data: NB 
Predicted_outcomes_NB_8020 <- predict(ModelNB_8020, newdata =testing8020[,1:ncol(testing8020)-1])
# Confusion Matrix: NB 
cm_NB_8020 <- confusionMatrix(as.factor(Predicted_outcomes_NB_8020), as.factor(testing8020$CREDIT_STATUS))
print(cm_NB_8020)
table_NB_8020 <- data.frame(confusionMatrix(Predicted_outcomes_NB_8020 , testing8020$CREDIT_STATUS)$table)
plotTable_NB_8020 <- table_NB_8020 %>%
  mutate(goodbad = ifelse(table_NB_8020$Prediction == table_NB_8020$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix : NB 
ggplot(data = plotTable_NB_8020, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
theme_bw() +xlim(rev(levels(table_NB_8020$Reference)))


#Naive Bayes  90:10 
ModelNB_9010 <- naiveBayes(CREDIT_STATUS ~ ., data = training9010, laplace=5) 

#Predicting on test data: NB :90:10 
Predicted_outcomes_NB_9010 <- predict(ModelNB_9010, newdata =testing9010[,1:ncol(testing9010)-1])
# Confusion Matrix: NB : 90:10 
cm_NB_9010 <- confusionMatrix(as.factor(Predicted_outcomes_NB_9010), as.factor(testing9010$CREDIT_STATUS))
print(cm_NB_9010)
table_NB_9010 <- data.frame(confusionMatrix( Predicted_outcomes_NB_9010 , testing9010$CREDIT_STATUS)$table)
plotTable_NB_9010 <- table_NB_9010 %>%
  mutate(goodbad = ifelse(table_NB_9010$Prediction == table_NB_9010$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix : NB :90:10 
ggplot(data = plotTable_NB_9010, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_NB$Reference)))



#Creating data frame as numeric for Neural net 
df5 <- as.data.frame(sapply(df4,as.numeric))
df5$CREDIT_STATUS <- ifelse(df5$CREDIT_STATUS ==2 , 1 ,0)
df5$CREDIT_STATUS <- as.factor(df5$CREDIT_STATUS)

# Creating Test and train  on 70:30 for neural (as numeric Inputs)
set.seed(123)
training_records_nn<-round(nrow(df5)*(70/100))
training_nn <- df5[1:training_records_nn,]
testing_nn <- df5[-(1:training_records_nn),]
# Running Neural Network (In case of Categorical Target we have to put linear Output as False )
ModelNN <- neuralnet(CREDIT_STATUS ~ ., data = training_nn,hidden = 3 ,linear.output=FALSE)
summary(ModelNN)
plot(ModelNN)

#Predicting on test data of NN
Predicted_outcomes_nn <- predict(ModelNN, newdata =testing_nn[,1:ncol(testing_nn)-1])
Predicted_outcomes_nn <- as.data.frame(Predicted_outcomes_nn)
Predicted_outcomes_nn$CREDIT_STATUS <- ifelse(Predicted_outcomes_nn$V1 > 0.5, 1, 0)
Predicted_outcomes_nn$CREDIT_STATUS <- as.factor(Predicted_outcomes_nn$CREDIT_STATUS)
testing_nn$CREDIT_STATUS <- as.factor(testing_nn$CREDIT_STATUS)

# Confusion Matrix of NN
cm_NN <- confusionMatrix(Predicted_outcomes_nn$CREDIT_STATUS ,testing_nn$CREDIT_STATUS)
print(cm_NN)

table_nn <- data.frame(cm_NN$table)

plotTable_nn <- table_nn %>%
mutate(goodbad = ifelse(table_nn$Prediction == table_nn$Reference, "good", "bad")) %>%
group_by(Reference) %>%
mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix 
ggplot(data = plotTable_nn, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
theme_bw() +xlim(rev(levels(table_nn$Reference)))


# Neural Net 80:20 
set.seed(123)
training_records_nn_8020<-round(nrow(df5)*(80/100))
training_nn_8020 <- df5[1:training_records_nn_8020,]
testing_nn_8020 <- df5[-(1:training_records_nn_8020),]
# Running Neural Network (In case of Categorical Target we have to put linear Output as False )
ModelNN_8020 <- neuralnet(CREDIT_STATUS ~ ., data = training_nn_8020,hidden = 3 ,linear.output=FALSE)
summary(ModelNN_8020)
plot(ModelNN_8020)

#Predicting on test data of NN
Predicted_outcomes_nn_8020 <- predict(ModelNN_8020, newdata =testing_nn_8020[,1:ncol(testing_nn_8020)-1])
Predicted_outcomes_nn_8020 <- as.data.frame(Predicted_outcomes_nn_8020)
Predicted_outcomes_nn_8020$CREDIT_STATUS <- ifelse(Predicted_outcomes_nn_8020$V1 > 0.5, 1, 0)
Predicted_outcomes_nn_8020$CREDIT_STATUS <- as.factor(Predicted_outcomes_nn_8020$CREDIT_STATUS)
testing_nn_8020$CREDIT_STATUS <- as.factor(testing_nn_8020$CREDIT_STATUS)

# Confusion Matrix of NN
cm_NN_8020 <- confusionMatrix(Predicted_outcomes_nn_8020$CREDIT_STATUS,testing_nn_8020$CREDIT_STATUS,)
print(cm_NN_8020)

table_nn_8020 <- data.frame(cm_NN_8020$table)

plotTable_nn_8020 <- table_nn_8020 %>%
  mutate(goodbad = ifelse(table_nn_8020$Prediction == table_nn_8020$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix 
ggplot(data = plotTable_nn_8020, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_nn$Reference)))


# Neural Net 90:10 

set.seed(123)
training_records_nn_9010 <- round(nrow(df5)*(90/100))
training_nn_9010 <- df5[1:training_records_nn_9010,]
testing_nn_9010 <- df5[-(1:training_records_nn_9010),]

# Running Neural Network (In case of Categorical Target we have to put linear Output as False )
ModelNN_9010 <- neuralnet(CREDIT_STATUS ~ ., data = training_nn_9010,hidden = 3 ,linear.output=FALSE)
summary(ModelNN_9010)
plot(ModelNN_9010)

#Predicting on test data of NN
Predicted_outcomes_nn_9010 <- predict(ModelNN_9010, newdata =testing_nn_9010[,1:ncol(testing_nn_9010)-1])
Predicted_outcomes_nn_9010 <- as.data.frame(Predicted_outcomes_nn_9010)
Predicted_outcomes_nn_9010$CREDIT_STATUS <- ifelse(Predicted_outcomes_nn_9010$V1 > 0.5, 1, 0)
Predicted_outcomes_nn_9010$CREDIT_STATUS <- as.factor(Predicted_outcomes_nn_9010$CREDIT_STATUS)
testing_nn_9010$CREDIT_STATUS <- as.factor(testing_nn_9010$CREDIT_STATUS)

# Confusion Matrix of NN
cm_NN_9010 <- confusionMatrix(Predicted_outcomes_nn_9010$CREDIT_STATUS, testing_nn_9010$CREDIT_STATUS)
print(cm_NN_9010)

table_nn_9010 <- data.frame(cm_NN_9010$table)

plotTable_nn_9010 <- table_nn_9010 %>%
  mutate(goodbad = ifelse(table_nn_9010$Prediction == table_nn_9010$Reference, "good", "bad")) %>%
  group_by(Reference) %>%
  mutate(prop = Freq/sum(Freq))

# Creating the ggplot for Confusion Matrix 
ggplot(data = plotTable_nn_9010, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() + geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "#96b9e3", bad = "#eb5050")) +
  theme_bw() +xlim(rev(levels(table_nn$Reference)))



