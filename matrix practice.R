#Matrix

#matrix ����####
matrix(1:10)

#�� �� ����
matrix(1:10, nrow = 2)

#�� �� ����
matrix(1:10 , ncol = 5)

#����� ������ ����
matrix(1:10, ncol = 5, byrow = T)

#��, �� �̸��ֱ� dimnames = list("���̸�", "���̸�")
matrix(1:10,
       ncol = 5,
       byrow = T,
       dimnames = list(c("X", "Y"),1:5))
#4*3 matrix ����
mat <- matrix(12:1, nrow = 4, ncol = 3)

#��*���� ��Ʈ���� ũ���ľ�
dim(mat)

#�� data ���� �ľ�
length(mat)


#�̸� �ֱ�
#��
rownames(mat) <- c("����1", "����2", "����3", "����4")
mat

#��
colnames(mat) <- c("�ܾ�1", "�ܾ�2", "�ܾ�3")
mat


#�� �߰��ϱ�
mat <- cbind(mat, 10:13)
mat

#�� �߰��ϱ�
mat <- rbind(mat, 20:23)
mat


#���� �̸� �ֱ�
colnames(mat) <- c("�ܾ�1", "�ܾ�2", "�ܾ�3", "�ܾ�4")
rownames(mat) <- c("����1", "����2", "����3", "����4", "����5")

#matrix ũ�� Ȯ��
dim(mat)
mat


#matrix subsetting(I)####

mat[1,]
mat[c(1,3),]
mat[2:3,]
mat[-1,]

#2��° ������ 3���� ū �� ����
mat[mat[,2]>3,]

#����2 ��
mat["����2",]

#1��° ��
mat[,1]
#1,3��° ��
mat[,c(1,3)]
mat[,2:3]
mat[,-1]
mat[,mat[2,]>3]
mat[, "�ܾ�2"]


#1�� 3��
mat[1,3]
mat[1:2,3]
mat[1:2, 3:4]
mat[c("����2", "����4"), c("�ܾ�1", "�ܾ�3")]


#matrix handling(I)####

x <- matrix(1:8, nrow = 2)
y <- matrix(8:1, nrow = 4, byrow = T)

#��İ� �� = x%*%y

#��� ����� ��
x*3

#���+���
x+x

#�� ����, �� ����
rowSums(mat)
colSums(mat)


#(numaeric data) ���� ��� ���� ����
mean(mat)
var(mat)
sd(mat)
summary(mat)


matrix handling(2)
#(Character data) matrix ����
char <- matrix(letters[1:24], nrow = 6, byrow = T)
char

#���� ����
table(char)

#��ҹ��� �����
capital <- toupper(char)
capital
lower <- tolower(capital)
lower