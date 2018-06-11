#Factor - 명목 척도(I)
categories <- rep(1:4,10)
categories <- sample(categories,20)


#label로 코딩하여 factor형으로 전환####
job <- factor(categories, labels = c("학생", "회사원", "주부", "무직"))
job

#범주별 빈도 파악####
table(job)


#Factor - 명목 척도(2)
#levels####
factor(categories, levels = 1:3)
factor(categories, levels = 1:5)

job_test <- factor(categories, levels = c("학생", "회사원", "주부", "무직"))
job_test

#levels로 코딩####
job_factor <- factor(categories)
levels(job_factor) <- c("학생", "회사원", "주부", "무직")
job_factor

table(job_factor)


factor_both <- factor(categories, levels = 1:4, labels = c("학생", "회사원", "주부", "무직"))
factor_both



#Factor - 서열 척도
#서열척도 변수 생성####
score_sample <- rep(c("A","B","C","S"),10)
sample <- sample(score_sample, 20)
score <- factor(sample, levels = c('C', 'B', 'A', 'S', 'SS'), ordered = T)
score


#순서 확인####
score[1]>score[2]


#norminal과 ordinal 둘다 levels로 level order를 바꾸기####
job_fac_test <- factor(job, levels = c("학생", "회사원", "주부", "무직"))
job_fac_test

score_test <- factor(sample, levels = c("SS", "S", "A", "B", "C"), ordered = T)
score_test
