# kaggle - []
# data load ####
train <- read.csv("train")
setwd("C:/Users/USER/Desktop/r")
getwd()

train <- read.csv("train.csv")# data - train
test <- read.csv("test.csv")# data - test : 제출용 test

# data wrangling ####
# train, validation, test set 분리 
sample(3, nrow(train), replace = T, prob = c(0.6,0.2,0.2))

split <- sample(3, nrow(train), replace = T, prob = c(0.6, 0.2, 0.2))

train$split <- split
train.split <- train[train$split ==1,]
train.split <- train.split[,-35]


test.split <- train[train$split == 2,]

test.split <- test.split[,-35]
validation.split <- train[train$split == 3,]
validation.split <- validation.split[,-35]

library(dplyr)
summary(train.split)
str(train.split)
train.split$T2_V11 %>% class()
int_ <- c()
factor_ <- c()
for (i in 1:length(train.split)){
  if(class(train.split[,i]) == 'integer'){
    int_<-rbind(int_,i)
  }else{
    factor_ <- rbind(factor_,i)
  }
}

train.int <- train.split[,int_]
trian.factor <- train.split[,factor_]
head(train.int,1)
train.int <- train.int[,c(-1,-2)]
train.y <- train.split[,2]

train.int %>% head(1)


correlation.train <- cor(train.int) 



library(corrplot)
corrplot(correlation.harzard)

corrplot(correlation.train, order="AOE", method="circle", tl.pos="lt", type="upper",        
         tl.col="black", tl.cex=0.6, tl.srt=45, 
         addCoef.col="black", addCoefasPercent = TRUE,
         p.mat = 1-abs(correlation.train), sig.level=0.50, insig = "blank") 

train_har <- cbind(train.int, train.y)

correlation.harzard <- cor(train_har)

#factor
plot(train_har$T1_V1,train.y)
plot(train_har$T1_V2, train.y)
plot(train_har$T1_V3, train.y)
plot(train_har$T1_V10, train.y)
plot(train_har$T1_V13, train.y)
plot(train_har$T1_V14, train.y)
plot(train_har$T2_V1, train.y)
plot(train_har$T2_V2, train.y)
plot(train_har$T2_V4, train.y)
plot(train_har$T2_V6, train.y)
plot(train_har$T2_V7, train.y)
plot(train_har$T2_V8, train.y)
plot(train_har$T2_V9, train.y)
plot(train_har$T2_V10, train.y)
plot(train_har$T2_V14, train.y)
plot(train_har$T2_V15, train.y)
plot(train.y)
#형변환 int -> factor 
str(train.split)
for (i in int_){
  train.split[,i] <- as.factor(train.split[,i])
}

train.split <- train.split[,-1]



test<-table(train.y, train.split$T2_V15) %>% chisq.test()
str(test)
print(test$p.value)
except <- c()
for (i in 1:length(train.split)){
  temp <-table(train.y, train.split[,i]) %>% chisq.test
  if (temp$p.value > 0.05){
    except <- cbind(except, i)
  }
}
train.split <- train.split[,-1*except]

hist(as.numeric(train.split$T1_V2))

