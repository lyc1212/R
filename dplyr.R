#dplyr####

install.packages("nycflights13")
library(nycflights13)
library(dplyr)

dim(flights)
head(flights)


#filter####
#filter함수는 데이터 프레임에서 행의 부분집합을 선택하게끔 한다.

filter(flights, month == 1, day == 1)
#위의 코드를 r에서 구현하면

flights[flights$month == 1 & flights$day == 1,]

#filter함수 다시쓰기
filter(flights, month == 1 | month == 2)

slice(flights, 1:10)


#arrange####
arrange(flights, year, month, day)
#desc를 쓰면 특정된 열을 배열하게끔 한다
arrange(flights, desc(arr_delay))


#select####
#select는 관심있는 데이터만 불러오기 가능
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

select(flights, tail_num = tailnum)
rename(flights, tail_num = tailnum)


#distinct####
#select 함수와 같이쓰면 특정한 데이터열만 불러오기 가능
distinct(select(flights, tailnum))
distinct(select(flights, origin, dest))


#mutate####
#새로운 열을 삽입할때 사용됨
mutate(flights, 
       gain = arr_delay - dep_delay,
       speed = distance / air_time *60)

mutate(flights,
       gain = arr_delay - dep_delay,
       gain_per_hour = gain / (air_time / 60))

#새로운 변수만 뽑아내고 싶을땐 transmute 사용
transmute(flights,
          gain = arr_delay - dep_delay,
          gain_per_hour = gain / (air_time / 60))


#summarise####
#데이터 프레임을 하나의 열로 나타냄 예를들어 평균이나 분산

summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE))


#sample_n and sample_frac()####
#무작위의 샘플열들을 뽑아냄
#여기서 sample_n은 갯수를 sample_frac은 퍼센트지만큼 뽑아냄

sample_n(flights, 10)

sample_n(flights, 0.01)


#group by를 이용한 응용####
library(ggplot2)
by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


destinations <- group_by(flights, dest)
summarise(destinations,
          planes = n_distinct(tailnum),
          flights = n())
daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, flights = n())

per_month <- summarise(per_day, flights = sum(flights))
per_year <- summarise(per_month, flights = sum(flights))


#Chaining####
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
    ) %>%
  filter(arr>30 | dep>30)
