#List

#List ����####
letter <- letters
order <- 1:26
alphabet <- list(letter = letter, order = order)
alphabet

#����Ʈ�� ���� ���� ����####

member_info <- list(name = "Kim", height = "180", childeren = 3, child.age = c(1,3,5))
member_info
str(member_info)

#ù��° �������� ���긮��Ʈ
alphabet[1]
member_info[1]

#ù��° �������� ���긮��Ʈ�� ����� ��(������ ����)
alphabet[[1]]

#ù��° �������� ���긮��Ʈ�� ����� ��(�̸����� ����)
alphabet$letter
member_info$name


#ù��° ���긮��Ʈ�� ����� ù��° ������
alphabet[[1]][1]
member_info[[1]][1]

alphabet$test = 3
str(alphabet)


#���긮��Ʈ �����ϱ�####
alphabet$order = NULL
str(alphabet)

#���긮��Ʈ �߰��ϱ�####
alphabet$order <- 1:26
str(alphabet)


#���긮��Ʈ�� ����Ʈ �����ϱ�####
alphabet$member_info = member_info
str(alphabet)

alphabet$matrix = matrix(1:16, nrow = 4)
str(alphabet)