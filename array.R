#array

#array ����####
sales <- array(1:64, dim = c(4,4,3) , dimnames = list(c("manu", "IT", "service", "retail"),c("1st Quater", "2nd Quater", "3th Quater", "4th Quater"), c(2013, 2014, 2015)))
sales

#array subsetting####
#��� matrix���� 1��° row ��������(manu)
sales[1,,]
sales["manu",,]

#��� matrix���� 1��° col ��������(1st Quater)
sales[,1,]
sales[, "1st Quater",]

sales[,,1]
sales[,,"2013"]