#List

#List 생성####
letter <- letters
order <- 1:26
alphabet <- list(letter = letter, order = order)
alphabet

#리스트로 고객 정보 생성####

member_info <- list(name = "Kim", height = "180", childeren = 3, child.age = c(1,3,5))
member_info
str(member_info)

#첫번째 데이터의 서브리스트
alphabet[1]
member_info[1]

#첫번째 데이터의 서브리스트에 저장된 값(순서로 접근)
alphabet[[1]]

#첫번째 데이터의 서브리스트에 저장된 값(이름으로 접근)
alphabet$letter
member_info$name


#첫번째 서브리스트에 저장된 첫번째 데이터
alphabet[[1]][1]
member_info[[1]][1]

alphabet$test = 3
str(alphabet)


#서브리스트 삭제하기####
alphabet$order = NULL
str(alphabet)

#서브리스트 추가하기####
alphabet$order <- 1:26
str(alphabet)


#서브리스트에 리스트 포함하기####
alphabet$member_info = member_info
str(alphabet)

alphabet$matrix = matrix(1:16, nrow = 4)
str(alphabet)
