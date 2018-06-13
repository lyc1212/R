#Aggregating####
seg.df <- read.csv("http://goo.gl/qw303p")
head(seg.df)

summary(seg.df)
str(seg.df)

attach(seg.df)
mean(income[Segment == "Moving up"])

apply(seg.df[,c(1,3,4)], MARGIN = 2, FUN = mean)
