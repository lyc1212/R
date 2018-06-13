#reshape, magrittr####

#reshape2####
#wide와 long 포맷으로 바꿔주는 패키지

#wide 포맷 데이터를 long 포맷으로 전환하기
#melt####
library(reshape2)
names(airquality) <- tolower(names(airquality))
head(airquality)
aql <- melt(airquality)
head(aql)

#일단위 오존량, 태양 복사열, 풍속, 온도
aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)

#열 이름 지정하기
aql <- melt(airquality, id.vars = c("month", "day"),
            variable.name = "climate_variable",
            value.name = "climate_value")
head(aql)

#long -> wide cast####
aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)
aqw <- dcast(aql, month + day ~ variable)
head(aqw)


#Aggregation####
dcast(aql, month ~variable, fun.aggregate = mean,
      na.rm =TRUE)



#magrittr####

library(magrittr)

car_data <- 
  mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~cyl, data = ., FUN = . %>% mean %>% round(2)) %>%
  transform(kpl = mpg %>% multiply_by(0.4251)) %>%
  print
