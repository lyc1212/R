#���ǹ�, �ݺ���####

#for()��####

a <- c(1,2,4)
a
for (i in a) print(i)

for (i in c(1,2,4)) print(i)

#vector J�� ¦����° �����͵鸸 ����ϱ�####
j <- 10:1
j
for (i in seq(2, 10, by=2)){
  #j�� ¦���� ����
  print(paste0(i, "��° ������:"))
  #¦����° �����͸� �ҷ�����
  print(j[i])
}

#break

for (i in 1:10){
  print(i)
  break
}


#while()��####

i <- 1
while(i < 10){
  print(i)
  i=i+1
}



#���ǹ�####

#if-else####

x <- 1:10
is.numeric(x)
if(is.numeric(x)) print(x)

x<-91
if (x>90) {
  print("B")
  x= x + 10
    print(x)
} else{
  "C"
}


#else if ��

x <- 70
if(x <70){
  print("F")
} else if(x<80){
  print("C")
}else if(x<90){
  print("B")
} else{
  print("A")
}


#���ǹ��� �ݺ����� ���� ����ϱ�####
x <- 1:10
for (i in x) {
  if(i%%2 == 0){
    print(i)
  }  
}

#next####
for (i in 1:10) {
  if (i %% 2 == 0) {
    next
    
  }  
  print(i)
}
