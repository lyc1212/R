#조건문, 반복문####

#for()문####

a <- c(1,2,4)
a
for (i in a) print(i)

for (i in c(1,2,4)) print(i)

#vector J의 짝수번째 데이터들만 출력하기####
j <- 10:1
j
for (i in seq(2, 10, by=2)){
  #j의 짝수번 순서
  print(paste0(i, "번째 데이터:"))
  #짝수번째 데이터만 불러와짐
  print(j[i])
}

#break

for (i in 1:10){
  print(i)
  break
}


#while()문####

i <- 1
while(i < 10){
  print(i)
  i=i+1
}



#조건문####

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


#else if 문

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


#조건문과 반복문을 같이 사용하기####
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

