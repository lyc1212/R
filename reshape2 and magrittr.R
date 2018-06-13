#reshape, magrittr####

#reshape2####
#wide�� long �������� �ٲ��ִ� ��Ű��

#wide ���� �����͸� long �������� ��ȯ�ϱ�
#melt####
library(reshape2)
names(airquality) <- tolower(names(airquality))
head(airquality)
aql <- melt(airquality)
head(aql)

#�ϴ��� ������, �¾� ���翭, ǳ��, �µ�
aql <- melt(airquality, id.vars = c("month", "day"))
head(aql)

#�� �̸� �����ϱ�
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