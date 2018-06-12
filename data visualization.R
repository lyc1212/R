z <- lm(mpg~wt, data=mtcars)
#고수준 시각화 함수
plot(mtcars$wt, mtcars$mpg)
#저수준 시각화 함수
## 추세선
## Y축 접선
abline(h=20)
abline(h=30)
#x축 접선
abline(v=3, col="blue")
abline(z, lty=2, lwd=2, col="green")
abline(z, lty=3, lwd=2, col="red")


plot(1:15)
grid(15,3)
box("plot", col="red")
abline(h=8, col="red")
abline(v=5, col="blue")
rect(1,6,3,8)
segments(5,2,2,5,col="yellow")
arrows(1,1,5,5,col="purple")
text(8,9,"테스트",srt=45)
title("TEST", "SUB")
title("TEST","SUB")
legend(12,5,c("h=8", "v=5", "segments", "arrows"),cex=0.9,col=c("red", "blue", "yellow", "purple"),lty=1)



var1 <- 1:5
plot(var1)
var2 <- rep(2,5)
plot(var2)


x <- 1:5
y <- 5:1
plot(x,y)


x<-1:5
y<-5:1
plot(x,y,xlim=c(1,10),ylim=c(1,5))


#인수를 사용하여 plot 그리기####
v1 <- c(100,130,120,160,150)
#line chart 그리기
plot(v1, type="o", col="red", ylim=c(0,200), axes = F, ann=F)
#X축 그리기
axis(1, at=1:5, lab=c("Mon", "TUE", "WED", "WHU", "FRI"))
#Y축 그리기
axis(2, ylim=c(0,200))
#title
title(main = "FRUIT", col.main= "red", font.main=4)
title(xlab= "DAY", col.lab= "blue")
title(ylab = "PRICE", col.lab="green")


#화면 분할해서 각 type 확인하기####
par(mfrow=c(1,3))
plot(v1, type = "o")
plot(v1, type = "s")
plot(v1, type = "l")
par(mfrow=c(1,1))


v1 <- 1:5
v2 <- 5:1
v3 <- 3:7
plot(v1, type= "o", col= "red")
#그래프 중첩 명령어, default는 F
par(new=T)
plot(v2,type = "l", col = "blue")
par(new = T)
plot(v3, type = "s", col="yellow")
#이렇게 하면 x축 범례와 y축 범례가 겹쳐져 이상한 그래프가 그려진다
#해결법: 축의 값을 넉넉히준다, lines라는 저수준 함수를 써서 그린다
plot(v1, type = "o", col = "red", ylim = c(0,10))
lines(v2, type = "l", col="blue")
lines(v3, type = "s", col = "yellow")
legend(4.5,10,c("V1","V2","V3"), cex = 0.9, col = c("red","blue","yellow"), lty = 1)


#barplot 그리기####
x <- 1:5
barplot(x)
barplot(x, horiz = T)


x <- matrix(5:2,2,2)
x
barplot(x, beside = T, names = c(5,3), col = c("green", "blue"))
barplot(x, names=c(5,3), col=c("green", "blue"), ylim = c(0,12))
x <- matrix(c(5,4,3,2),2,2)
x
barplot(x, names = c(5,3), beside = T, col = c("green", "yellow"), horiz = T)
barplot(x, horiz = T, names = c("green", "yellow"), xlim = c(0,12))



#여러 막대 그래프 한번에 그리기####
v1 <- c(100,120,140,160,180)
v2 <- c(120,130,150,140,170)
v3 <- c(140,170,120,110,160)
qty <- data.frame(BANANA=v1, CHERRY=v2, ORANGE = v3)
qty

barplot(as.matrix(qty), main = "Fruit's Sales QTY", beside = T, col = rainbow(nrow(qty)), ylim = c(0,400))
#범례
legend(14, 400, c("MON", "TUE", "WED", "THU", "FRI"), cex=0.8, fill = rainbow(nrow(qty)))


#하나의 막대 그래프에 여러가지 내용을 한꺼번에 출력하기
barplot(t(qty), main = "Fruits Sales QTY", ylim = c(0,900), col = rainbow(length(qty)), space = 0.1, cex.axis = 0.8, las=1, names.arg = c("MON", "THU", "WED", "THU", "FRI"), cex = 0.8)
#범례
legend(0.2, 800, names(qty), cex = 0.7, fill = rainbow(length(qty)))


v1 <- c(sample(1:10, 200, replace=T), 20)
v2 <- sample(1:20, 200, replace= T)
v3 <- c(sample(10:20, 200, replace = T), -10)
lst <- list(v1,v2,v3)
lst
boxplot(v1)
boxplot(v1,v2)
boxplot(lst)


#boxplot(다변량, 식 사용)####
head(ToothGrowth)
ToothGrowth
boxplot(len~dose, data = ToothGrowth)


x<-1:5
boxplot(x, border = "magenta", col = c("lightblue"))


#par####
#layout() 함수
(m <- matrix(c(1,1,2,3), ncol = 2, byrow = T))
layout(mat = m)
plot(cars, main = "scatter plot of cars data", pch = 19, col = 4)
hist(cars$speed)
hist(cars$dist)


#ggplot####
library(ggplot2)


head(mtcars)

p <- ggplot(data = mtcars, aes(x = wt, y = mpg, colour = cy1))
class(p)
#산점도로 그릴 것을 지정
p <- p + geom_point()
p
attributes(p)


#ggplot2로 barplot 그리기####
p <- ggplot(data = mtcars, aes(x=factor(cyl), fill = factor(cyl)))
#bar의 넓이를 정의
p <- p + geom_bar(width=.5)
#기어 개수에 따른 facet 분할
p <- p + facet_grid(.~gear)
#출력
p

p <- ggplot(mtcars, aes(wt,mpg))
#산점도 그리기
p <- p+geom_point()
p






install.packages("nycflights13")
install.packages("dplyr")
library(nycflights13)
library(dplyr)


dim(flights)
head(flights)
summary(flights)


?filter

flights[flights$month == 1 & flights$day == 1,]
filter(flights, month == 1, day == 1)


slice(flights, 1:10)
filter(flights, month ==1 | month == 2)
flights


arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))

select(flights, year, month, day)
flights[, c("year", "month" , "day")]
select(flights, year:day)
select(flights, -(year:day))
select(flights, tail_num = tailnum)


distinct(select(flights, tailnum))
distinct(select(flights, origin, dest))
mutate(flights, gain = arr_delay - dep_delay, speed = distance / air_time *60)


summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

sample_n(flights, 10)



library(ggplot2)
by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
                   count = n(),
                   dist = mean(distance , na.rm = TRUE),
                               delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)
ggplot(delay, aes(dist, delay)) + 
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


destinations <- group_by(flights, dest)
destinations <- summarise(destinations,
          planes = n_distinct(tailnum),
          flights = n()
          )
ggplot(destinations, aes(planes, flights)) +
  geom_point()


daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, flights = n())



a4 <- filter(
  summarise(
    select(
      group_by(flights, year, month, day), arr_delay, dep_delay
      ),
                       arr = mean(arr_delay, na.rm = TRUE),
                       dep = mean(dep_delay, na.rm = TRUE))
             , arr > 30 | dep > 30)


flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)

Group <- c(rep(1,4),rep(2,4),rep(3,4))
Year <- c(2006:2009,2006:2009,2006:2009)
Qtr.1 <- c(15,12,22,10,12,16,13,23,11,13,17,14)
Qtr.2 <- c(16,13,22,14,13,14,11,20,12,11,12,9)
Qtr.3 <- c(19,27,24,20,25,21,29,26,22,27,23,31)
Qtr.4 <- c(17,23,20,16,18,19,15,20,16,21,19,24)
DF <- data.frame(Group,Year,Qtr.1,Qtr.2,Qtr.3,Qtr.4)
DF

install.packages("tidyr")
library(tidyr)

long_DF <- DF %>% gather(Quarter, Revenue, Qtr.1 : Qtr.4)
head(long_DF, 24)


head(iris)


filter(iris, Species == "setosa")
distinct(select(iris, Species, Sepal.Length, Sepal.Width, Petal.Length))
summarise(iris, MeanOflength = mean(Sepal.Length, na.rm = TRUE))
summarise(iris, MeanOfWidth = mean(Sepal.Width, na.rm = TRUE))
summarise(iris, MeanOfpetal = mean(Petal.Length, na.rm = TRUE))


by_Species <- group_by(iris, Species)
Mean <- summarise(by_Species,
                  length = mean(Sepal.Length, na.rm = TRUE),
                  width = mean(Sepal.Width, na.rm = TRUE),
                  petalwidth = mean(Petal.Width, na.rm = TRUE),
                  petallength = mean(Petal.Length, na.rm = TRUE))
Mean             


library(reshape2)
names(airquality) <- tolower(names(airquality))
head(airquality)
aq1 <- melt(airquality)
aq1
aq1 <- melt(airquality, id.vars = c("month", "day"))
head(aq1)
aq1 <- melt(airquality, id.vars = c("month", "day"),
            variable.name = "climate_variable",
            value.name = "climate_value")
head(aq1)


head(ChickWeight)
chick_m <- melt(ChickWeight, id.vars = c("Time", "Chick", "Diet"))
chick_m


aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)
aqw <- dcast(aql, month + day ~ variable)
head(aqw)


chick_w <- dcast(chick_m, Time + Chick + Diet ~ variable)
chick_w
head(chick_w)


dcast(aql, month ~ variable, fun.aggregate = mean, na.rm = TRUE)
dcast(chick_m, Diet ~ variable, fun.aggregate = mean, na.rm = TRUE)
head(dcast(aql, month + day ~ variable, sum, margins = TRUE), 32)


library(magrittr)
car_data <- 
  mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl, data = ., FUN = . %>% mean %>% round(2)) %>%
  transform(kpl = mpg %>% multiply_by(0.4251)) %>%
  print




library(nycflights13)
library(dplyr)

head(flights)


filter(flights, month == 1, day == 1)
flights[flights$month == 1 & flights$day == 1, ]
filter(flights, month == 1 | month == 2)

slice(flights, 1:10)
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
select(flights, tail_num = tailnum)
distinct(select(flights, tailnum))
distinct(select(flights, origin, dest))


mutate(flights,
       gain = arr_delay - dep_delay,
       speed = distance / air_time *60)


transmute(flights,
          gain = arr_delay - dep_delay,
          gain_per_hour = gain / (air_time / 60))
head(flights)


summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE))


sample_n(flights, 10)



library(ggplot2)
by_tailnum  <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count >20, dist < 2000)


ggplot(delay , aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


destinations <- group_by(flights, dest)
summarise(destinations, 
          planes = n_distinct(tailnum),
          flights = n())


daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, flights = n())
per_day


a1 <- group_by(flights, year, month, day)
a2 <- select(a1, arr_delay, dep_delay)
a3 <- summarise(a2, 
                arr = mean(arr_delay , na.rm = TRUE),
                dep = mean(dep_delay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)


flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE) 
  ) %>%
  filter(arr > 30 | dep > 30)



library(reshape2)
names(airquality) <- tolower(names(airquality))
head(airquality)

aql <- melt(airquality)


head(aql)
aql <- melt(airquality, id.vars = c("month",  "day"))
head(aql)


aql <- melt(airquality, id.vars = c("month", "day"),
            variable.name = "climate_variable",
            value.name = "climate_value")
head(aql)


head(ChickWeight)

chick_m <- melt(ChickWeight, id.vars = c("Time", "Chick", "Diet"))
chick_m

head(aql)

aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)
aqw <- dcast(aql, month + day ~ variable)
head(aqw)

chick_d <- dcast(chick_m, Time + Chick + Diet ~ variable)
head(chick_d)


#Aggregation####
dcast(aql, month ~ variable, fun.aggregate = mean,
      na.rm = TRUE)

dcast(chick_m, Diet ~ variable, fun.aggregate = mean, na.rm = TRUE)


head(dcast(aql, month + day ~ variable, sum, margins = TRUE), 32)
head(dcast(chick_m, Diet + Time ~ variable, mean, margins = TRUE), 14)


library(magrittr)


car_data <-
  mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl, data = ., FUN = . %>% mean %>% round)
  %>%
  transform(kpl = mpg %>% multiply_by(0.4251)) %>%
  print


library(magrittr)

car_data <-
  mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl, data = ., FUN = . %>% mean %>% round(2)) %>%
  transform(kpl = mpg %>% multiply_by(0.4251)) %>%
  print



electro <- read.csv("https://raw.githubusercontent.com/halrequin/data/master/2013%20electronic%20sales.csv",encoding = "utf8",stringsAsFactors = F)
electro


library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)

electro <- read.csv("https://raw.githubusercontent.com/halrequin/data/master/2013%20electronic%20sales.csv",encoding = "utf8",stringsAsFactors = F)
electro

elec_long <- melt(electro, id.vars = c("년도", "월별"))
elec_long
dcast(elec_long, 년도 +  월별 ~ variable, fun.aggregate = sum, na.rm = TRUE)
dcast(elec_long, 년도 ~ variable, fun.aggregate = sum, na.rm = TRUE)


by_value <- group_by(electro, "월별")
graph <- electro %>%
  melt(. , id.vars = c("년도", "월별")) %>%
  ggplot(., aes(월별)) + geom_bar(aes(value))


p <- ggplot(elec_long, aes(월별, value))
p <- p + geom_bar(aes(fill = factor(variable)))
p





p <- ggplot(data = mtcars, aes(x = factor(cyl), fill=factor(cyl)))
p
p <- p+ geom_bar(width = .5)
p
p <- p+ facet_grid(.~gear)
p


p <- ggplot(mtcars, aes(cyl))
p
p <- p + geom_bar()
p


p <- ggplot(mtcars, aes(factor(cyl)))
p
p <- p + geom_bar(aes(fill = cyl), colour = "black")
p

p <- ggplot(mtcars, aes(factor(cyl)))
p
p <- p+geom_bar(aes(fill=factor(gear)))
p

library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)

electro <- read.csv("https://raw.githubusercontent.com/halrequin/data/master/2013%20electronic%20sales.csv",encoding = "utf8",stringsAsFactors = F)
electro
graph <- electro %>%
  melt(. , id.vars = c("년도", "월별"))
p <- ggplot(graph, aes(월별))
p
p <- p + geom_bar(aes(월별,value))
p
