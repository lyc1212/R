#Matrix

#matrix 생성####
matrix(1:10)

#행 수 설정
matrix(1:10, nrow = 2)

#열 수 설정
matrix(1:10 , ncol = 5)

#행부터 데이터 삽입
matrix(1:10, ncol = 5, byrow = T)

#행, 열 이름주기 dimnames = list("행이름", "열이름")
matrix(1:10,
       ncol = 5,
       byrow = T,
       dimnames = list(c("X", "Y"),1:5))
#4*3 matrix 생성
mat <- matrix(12:1, nrow = 4, ncol = 3)

#행*열로 매트릭스 크기파악
dim(mat)

#총 data 갯수 파악
length(mat)


#이름 주기
#행
rownames(mat) <- c("문서1", "문서2", "문서3", "문서4")
mat

#열
colnames(mat) <- c("단어1", "단어2", "단어3")
mat


#열 추가하기
mat <- cbind(mat, 10:13)
mat

#열 추가하기
mat <- rbind(mat, 20:23)
mat


#새로 이름 주기
colnames(mat) <- c("단어1", "단어2", "단어3", "단어4")
rownames(mat) <- c("문서1", "문서2", "문서3", "문서4", "문서5")

#matrix 크기 확인
dim(mat)
mat


#matrix subsetting(I)####

mat[1,]
mat[c(1,3),]
mat[2:3,]
mat[-1,]

#2번째 열에서 3보다 큰 행 추출
mat[mat[,2]>3,]

#문서2 행
mat["문서2",]

#1번째 열
mat[,1]
#1,3번째 열
mat[,c(1,3)]
mat[,2:3]
mat[,-1]
mat[,mat[2,]>3]
mat[, "단어2"]


#1행 3열
mat[1,3]
mat[1:2,3]
mat[1:2, 3:4]
mat[c("문서2", "문서4"), c("단어1", "단어3")]


#matrix handling(I)####

x <- matrix(1:8, nrow = 2)
y <- matrix(8:1, nrow = 4, byrow = T)

#행렬간 곱 = x%*%y

#행렬 상수간 곱
x*3

#행렬+행렬
x+x

#행 총합, 열 총합
rowSums(mat)
colSums(mat)


#(numaeric data) 기초 통계 적용 가능
mean(mat)
var(mat)
sd(mat)
summary(mat)


matrix handling(2)
#(Character data) matrix 생성
char <- matrix(letters[1:24], nrow = 6, byrow = T)
char

#갯수 세기
table(char)

#대소문자 만들기
capital <- toupper(char)
capital
lower <- tolower(capital)
lower
