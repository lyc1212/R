#Data Frame 생성####

name <- c("David", "Tom", "Ravindra", "Alice", "Sobia")
gender <- c("M", "M", "M", "F", "F")
age <- c(19,25,31,40,31)
marriage <- c(F,F,T,T,T)
HR <- data.frame(name, gender, age, marriage)
HR

str(HR)



#Data Frame 생성(2)####
HR <- data.frame(name, gender, age, marriage, stringsAsFactors = F)
str(HR)

#gender값은 통계적 기법을 사용할 때 Factor형에 어울림
HR$gender <- as.factor(HR$gender)
str(HR)

#Data Frame 생성(3)####
HR <- data.frame(Employee=name, Gender=gender, Age=age, Marriage=marriage, stringsAsFactors = F)
str(HR)

HR$Gender <- as.factor(HR$Gender)
str(HR)


#Data Frame 이름 주기####
colnames(HR)
rownames(HR)
HR


colnames(HR) <- c("Emp_name", "Emp_gend", "Emp_age", "Emp_mrg")
rownames(HR) <- paste0("Emp", 1:5)
rownames(HR)
HR


#Data Frame Subsetting####
HR[1,]
HR["Emp1",]
HR[HR$Emp_name == "David",]

#David를 제외한 근무자들의 정보 추출
HR[2:5,]
HR[-1,]
HR[HR$Emp_name!="David",]

#Tom, Sobia 정보 추출
HR[c("Emp2", "Emp5"),]
HR[HR$Emp_name == "Tom" | HR$Emp_name == "Sobia",]



# 열의 논리값 추출
HR[,c(F,T,T,T)]
#논리식 추출
HR[,colnames(HR) != "Emp_name"]



#Data 삽입####
#이름으로 값 삽입
HR$Emp_height <- c("180", "170", "171", "165", "155")
HR["Emp6",] <- list("tylor", "M", 50, T, "177")

#cbind, rbind로 값 삽입
HR <- cbind(HR, weight = c(80,70,65,48,55,100))
HR <- rbind(HR, Emp7=list("Merry", "F",20,F,"170",60))
HR


#Data 제거####
#자기 참조
HR <- HR[,-5]
HR
HR <- HR[-7,]
HR

#열에 한정하여 NULL
HR$weight <- NULL
HR


#Data handling(1)####
#어떤 데이터가 들어가 있는지 확인해보자

str(HR)

#attributes() 사용
attributes(HR)

#제일 앞에서부터 원하는 갯수만큼의 데이터만 살펴보기
head(HR, 2)
#제일 뒤에서부터 원하는 갯수만큼의 데이터만 살펴보기
tail(HR,2)


#Data handling(2)####
#subsetting 방식과 비슷하다
#data인 사람 이름으로 특정정보 가져오기
#David의 나이와 결혼여부

HR[HR$Emp_name == "David", c("Emp_age", "Emp_mrg")]

#Ravindra와 Tom의 정보 추출하기

HR[HR$Emp_name == "Tom" | HR$Emp_name == "Ravindra",]


#특징이 있는 그룹으로 데이터 나누기
#남자 직원과 여자직원 정렬하기

HR[order(HR$Emp_gend),]

#남자 직원들만 추출하기
M_Emp <- HR[HR$Emp_gend == "M",];M_Emp

#여자직원들만 추출
F_Emp <- HR[HR$Emp_gend == "F",];F_Emp

#남자 직원이 몇명인지 계산
nrow(HR[HR$Emp_gend == "M",])

#기혼자가 몇명인지 계산
nrow(HR[HR$Emp_mrg == "TRUE",])

#기혼자만 추출하기(data가 논리값)
HR[HR$Emp_mrg,]


#Data handling(3)####
#나이 순으로 정렬
HR[order(HR$Emp_age),]

#가장 노령자 추출
HR[order(HR$Emp_age, decreasing = T)[1],]
HR[HR$Emp_age == max(HR$Emp_age),]


#조건이 두개인 데이터 추출
# &연산자
#기혼자이고 남자인 직원

HR[HR$Emp_gend == "M" & HR$Emp_mrg,]

#미혼자이고 남자인 직원
HR[HR$Emp_gend == "M" &!HR$Emp_mrg,]

#Data handling(4)####
#subset()을 이용한 정보 추출
#사용법은 subset(변수, 조건식)
subset(HR, HR$Emp_name == "David" | HR$Emp_name == "Tom")
