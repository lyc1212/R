factor(categories,levels=1:3)
categories <- rep(1:4,10)
rep(1:4,10)
categories <- sample(categories,20)
job <- factor(categories,labels=c("학생","회사원","주부","무직"))

job
table(job)
job <- factor(categories,labels = c("무직","주부","회사원","학생"))
job
table(job)
job_fac_test <- factor(job,levels = c("학생","회사원","주부","무직"))
job_fac_test
score_test <- factor(categories, levels = c("SS","S","A","B","C"),ordered = T)
getwd()
setwd('C:/Users/예찬/R 프로그래밍/r')
setwd('C:/Users/USER/Desktop/r')
b<-load("vote.RData")
b
getwd()
matrix(1:10,nrow = 2)
matrix(1:10,ncol=5,byrow=T)
matrix(1:15,ncol=2)
matrix(1:10,ncol=5,byrow = T,dimnames = list(c("X","Y"),1:5))
mat <- matrix(12:1, nrow=4, ncol = 3)
mat       
dim(mat)
length(mat)
rownames(mat)<- c("문서1","문서2","문서3","문서4")
mat
colnames(mat) <- c("단어1","단어2","단어3")
mat
mat <- cbind(mat, 10:13)
mat
mat <- rbind(mat, 20:23) 
#matrix subsetting####
mat
mat[1,]
mat[c(1,3),]
mat[-1,]
mat[mat[,2]>6,]
mat["문서2",]
mat[c(T,T,F,T,F),]
mat[,1]
mat[,1:2]
mat[,c(1,3)]
mat[,2:3]
?c
mat[,mat[2,]>3]
x <- matrix(1:8,nrow = 2)
y <- matrix(8:1,nrow = 4, byrow = T)
x%*%y
x*3
x+x
rowSums(mat)
colSums(mat)
mean(mat)
var(mat)
sd(mat)
summary(mat)
char <- matrix(letters[1:24],nrow = 6, byrow = T)
char
table(char)
capital <- toupper(char)
capital
?toupper
lower <- tolower(capital)
lower
letter <- letters
order <- 1:26
alphabet <- list(letter=letter, order = order)
alphabet
member_info <- list(name = "Kim", height = "180", children = 3, child.age = c(1,3,5))
member_info
str(member_info)
alphabet[1]
member_info[2]
alphabet[1][2]
alphabet
alphabet$order=NULL
str(alphabet)
alphabet
alphabet$order <- 1:26
str(alphabet)
alphabet$member_info = member_info
str(alphabet)
alphabet$matrix = matrix(1:16,nrow = 4)
str(alphabet)
sales <- array(1:64, dim = c(4,4,3) , dimnames = list(c("m")))

#Data Frame 생성####
name <- c("David","Tom", "Ravindra", "Alice", "Sobia")
gender <- c("M","M","M","F","F")
age <- c(19, 25, 31, 40, 31)
marriage <- c(F,F,T,T,T)
HR <- data.frame(name, gender, age, marriage)
HR
str(HR)
HR <- data.frame(name,gender,age, marriage, stringsAsFactors = F)
str(HR)
HR$gender <- as.factor(HR$gender)
str(HR)
HR
HR <- data.frame(Employee = name, Gender = gender, Age = age, Marriage = marriage)
str(HR)
HR$gender <- as.factor(HR$gender)
HR$Gender <- as.factor(HR$Gender)
str(HR)
colnames(HR)
rownames(HR)
rownames(HR)=c(1, 2, 3, 4, 5)
rownmaes(HR)
rownames(HR)
HR
colnames(HR) <- c("Emp_name", "Emp_gend", "Emp_age", "Emp_mrg")
rownames(HR) <- paste0("Emp", 1:5)
colnames(HR)
rownames(HR)
HR
HR[1,]
HR["Emp1",]



#5월 8일 연습####
categories <- rep(1:4,10)
categories
categories <- sample(categories,20)
categories
job <- factor(categories, labels = c("학생", "회사원", "주부", "무직"))
job
table(job)
factor(categories,levels = 1:3)
factor(categories,levels = 1:5)


job_test <- factor(categories, levels = c("학생", "회사원", "주부", "무직"))
job_test


job_factor <- factor(categories)
levels(job_factor) <- c("학생", "회사원", "주부", "무직")
job_factor


table(job_factor)


factor_both <- factor(categories, levels = 1:4, labels = c("학생", "회사원", "주부", "무"))
factor_both


job_factor[1]>job_factor[2]


score_sample <- rep(c("A", "B", "C", "S"), 10)
sample <- sample(score_sample, 20)
score <- factor(sample, levels = c('C', 'B', 'A', 'S', 'SS'), ordered = T)
score
score[1]>score[2]
job_fac_test <- factor(job, levels = c("학생", "회사원", "주부", "무직"))
job_fac_test
score_test <- factor(sample, levels = c("SS", "S", "A", "B", "C"),ordered = T)
score_test


#Matrix####


matrix(1:10)
matrix(4:4)
matrix(1:4)
matrix(1:10)
matrix(1:10,nrow = 2)
matrix(1:4, nrow = 2)
matrix(1:16, nrow=4)
matrix(1:10, ncol=5)
matrix(1:10, ncol = 5, byrow=T)
matrix(1:10, ncol = 5, byrow = F)


#행, 열 이름주기####
matrix(1:10,
       ncol = 5,
       byrow = T,
       dimnames = list(c("X","Y"), 1:5))
mat <- matrix(12:1, nrow=4, ncol=3)       
mat

dim(mat)
length(mat)


rownames(mat) <- c("문서1", "문서2", "문서3", "문서4")
mat

colnames(mat) <- c("단어1", "단어2", "단어3")
mat


mat <- cbind(mat, 10:13)
mat <- rbind(mat, 20:23)
mat
colnames(mat) <- c("단어1", "단어2", "단어3", "단어4")
rownames(mat) <- c("문서1", "문서2", "문서3", "문서4", "문서5")
mat

dim(mat)
mat[1,]
mat[c(1,3),]
mat[2:3,]
mat[-1,]
mat[mat[,2]>3,]
mat["문서2",]
mat[c(T,T,F,T,F),]


mat[,1]
mat[,c(1,3)]
mat[,2:3]
mat[,-1]
mat[,mat[2,]>3]


mat[1,3]
mat[1:2,3]
mat[1:2, 3:4]


#matrix handling####

x<- matrix(1:8, nrow = 2)
y<- matrix(8:1, nrow = 4, byrow = T)
x%*%y
x*3
x+x
rowSums(mat)
colSums(mat)
mean(mat)
mean(mat)
var(mat)
sd(mat)
summary(mat)


char <- matrix(letters[1:24], nrow = 6, byrow = T)
char
table(char)


capital <- toupper(char)
capital
lower <- tolower(capital)
lower


load("ex2.RData")
ex2.RData
ex2
load("ex2.RData")

lower <- tolower(movie)
lower
mode(movie)
summary(movie)
table(movie)
x%*%y


#List####

letter <- letters
order <- 1:26
alphabet <-list(letter=letter, order=order)
alphabet


member_info <- list(name= "Kim", height ="180", children =3 , child.age = c(1,3,5))
member_info

str(member_info)


alphabet[1]
member_info[1]
alphabet[[1]]
alphabet[1][[1]]
member_info[[1]]
alphabet$letter
alphabet[[1]][1]
member_info[[1]][1]
alphabet$test = 3
str(alphabet)
alphabet$order = NULL
str(alphabet)
alphabet
alphabet$order <- 1:26
str(alphabet)
alphabet$member_info = member_info
str(alphabet)
alphabet$matrix = matrix(1:16, nrow = 4)
str(alphabet)
alphabet$matrix
alphabet$matrix[2,3]
alphabet$member_info$height


#array####

sales <- array(1:64, dim = c(4,4,3), dimnames = list(c("manu", "IT", "service", "retail"), c("1st Quater", "2nd Quater", "3st Quater", "4th Quater" ), c(2013, 2014, 2015)))
sales

str(sales)

sales[1,,]
sales["manu",,]


#Data Frame 생성####


name <- c("David", "Tom", "Ravindra", "Alice", "Sobia")
gender <- c("M", "M", "M", "F", "F")
age <- c(19, 25, 31, 40, 31)
marriage <- c(F,F,T,T,T)
HR <- data.frame(name, gender, age, marriage)
HR
str(HR)
HR <- data.frame(name, gender, age, marriage, stringsAsFactors = F)
str(HR)
HR$gender <- as.factor(HR$gender)
str(HR)
HR <- data.frame(Employee = name, Gender = gender, Age = age, Marriage = marriage, stringsAsFactors = F)
str(HR)
HR$Gender <- as.factor(HR$Gender)
str(HR)
colnames(HR)
rownames(HR)
HR
colnames(HR) <- c("Emp_name", "Emp_gend", "Emp_age", "Emp_mrg")
rownames(HR) <- paste0("Emp", 1:5)
colnames(HR)
rownames(HR)


HR[1,]
HR["Emp1",]
HR[HR$Emp_name == "David",]
HR[HR$Emp_name == "Tom"|HR$Emp_name == "Sobia",]
HR$Emp_height <- c("180", "170", "171", "165", "155")
HR["Emp6",] <- list("tylor", "M", 50, T, "177")
HR <- cbind(HR, weight = c(80, 70, 65, 48, 55, 100))
HR <- rbind(HR, Emp7 = list("Merry", "F", 20, F, "170", 60))
HR

HR <- cbind(HR, Bloodtype = c("A", "B" ,"A", "B", "O", "AB", "A", "A"))
HR <- rbind(HR, Emp8 = list("예찬", "M", 26 , F, "171", 68))
HR
