#dplyr####

install.packages("nycflights13")
library(nycflights13)
library(dplyr)

dim(flights)
head(flights)


#filter####
#filter�Լ��� ������ �����ӿ��� ���� �κ������� �����ϰԲ� �Ѵ�.

filter(flights, month == 1, day == 1)
#���� �ڵ带 r���� �����ϸ�

flights[flights$month == 1 & flights$day == 1,]

#filter�Լ� �ٽþ���
filter(flights, month == 1 | month == 2)

slice(flights, 1:10)


#arrange####
arrange(flights, year, month, day)
#desc�� ���� Ư���� ���� �迭�ϰԲ� �Ѵ�
arrange(flights, desc(arr_delay))


#select####
#select�� �����ִ� �����͸� �ҷ����� ����
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

select(flights, tail_num = tailnum)
rename(flights, tail_num = tailnum)


#distinct####
#select �Լ��� ���̾��� Ư���� �����Ϳ��� �ҷ����� ����
distinct(select(flights, tailnum))
distinct(select(flights, origin, dest))


#mutate####
#���ο� ���� �����Ҷ� ����
mutate(flights, 
       gain = arr_delay - dep_delay,
       speed = distance / air_time *60)

mutate(flights,
       gain = arr_delay - dep_delay,
       gain_per_hour = gain / (air_time / 60))

#���ο� ������ �̾Ƴ��� ������ transmute ���
transmute(flights,
          gain = arr_delay - dep_delay,
          gain_per_hour = gain / (air_time / 60))


#summarise####
#������ �������� �ϳ��� ���� ��Ÿ�� ������� ����̳� �л�

summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE))


#sample_n and sample_frac()####
#�������� ���ÿ����� �̾Ƴ�
#���⼭ sample_n�� ������ sample_frac�� �ۼ�Ʈ����ŭ �̾Ƴ�

sample_n(flights, 10)

sample_n(flights, 0.01)


#group by�� �̿��� ����####
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