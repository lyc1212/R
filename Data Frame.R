#Data Frame ����####

name <- c("David", "Tom", "Ravindra", "Alice", "Sobia")
gender <- c("M", "M", "M", "F", "F")
age <- c(19,25,31,40,31)
marriage <- c(F,F,T,T,T)
HR <- data.frame(name, gender, age, marriage)
HR

str(HR)



#Data Frame ����(2)####
HR <- data.frame(name, gender, age, marriage, stringsAsFactors = F)
str(HR)

#gender���� ����� ����� ����� �� Factor���� ��︲
HR$gender <- as.factor(HR$gender)
str(HR)

#Data Frame ����(3)####
HR <- data.frame(Employee=name, Gender=gender, Age=age, Marriage=marriage, stringsAsFactors = F)
str(HR)

HR$Gender <- as.factor(HR$Gender)
str(HR)


#Data Frame �̸� �ֱ�####
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

#David�� ������ �ٹ��ڵ��� ���� ����
HR[2:5,]
HR[-1,]
HR[HR$Emp_name!="David",]

#Tom, Sobia ���� ����
HR[c("Emp2", "Emp5"),]
HR[HR$Emp_name == "Tom" | HR$Emp_name == "Sobia",]



# ���� ������ ����
HR[,c(F,T,T,T)]
#������ ����
HR[,colnames(HR) != "Emp_name"]



#Data ����####
#�̸����� �� ����
HR$Emp_height <- c("180", "170", "171", "165", "155")
HR["Emp6",] <- list("tylor", "M", 50, T, "177")

#cbind, rbind�� �� ����
HR <- cbind(HR, weight = c(80,70,65,48,55,100))
HR <- rbind(HR, Emp7=list("Merry", "F",20,F,"170",60))
HR


#Data ����####
#�ڱ� ����
HR <- HR[,-5]
HR
HR <- HR[-7,]
HR

#���� �����Ͽ� NULL
HR$weight <- NULL
HR


#Data handling(1)####
#� �����Ͱ� �� �ִ��� Ȯ���غ���

str(HR)

#attributes() ���
attributes(HR)

#���� �տ������� ���ϴ� ������ŭ�� �����͸� ���캸��
head(HR, 2)
#���� �ڿ������� ���ϴ� ������ŭ�� �����͸� ���캸��
tail(HR,2)


#Data handling(2)####
#subsetting ��İ� ����ϴ�
#data�� ��� �̸����� Ư������ ��������
#David�� ���̿� ��ȥ����

HR[HR$Emp_name == "David", c("Emp_age", "Emp_mrg")]

#Ravindra�� Tom�� ���� �����ϱ�

HR[HR$Emp_name == "Tom" | HR$Emp_name == "Ravindra",]


#Ư¡�� �ִ� �׷����� ������ ������
#���� ������ �������� �����ϱ�

HR[order(HR$Emp_gend),]

#���� �����鸸 �����ϱ�
M_Emp <- HR[HR$Emp_gend == "M",];M_Emp

#���������鸸 ����
F_Emp <- HR[HR$Emp_gend == "F",];F_Emp

#���� ������ ������� ���
nrow(HR[HR$Emp_gend == "M",])

#��ȥ�ڰ� ������� ���
nrow(HR[HR$Emp_mrg == "TRUE",])

#��ȥ�ڸ� �����ϱ�(data�� ������)
HR[HR$Emp_mrg,]


#Data handling(3)####
#���� ������ ����
HR[order(HR$Emp_age),]

#���� ����� ����
HR[order(HR$Emp_age, decreasing = T)[1],]
HR[HR$Emp_age == max(HR$Emp_age),]


#������ �ΰ��� ������ ����
# &������
#��ȥ���̰� ������ ����

HR[HR$Emp_gend == "M" & HR$Emp_mrg,]

#��ȥ���̰� ������ ����
HR[HR$Emp_gend == "M" &!HR$Emp_mrg,]

#Data handling(4)####
#subset()�� �̿��� ���� ����
#������ subset(����, ���ǽ�)
subset(HR, HR$Emp_name == "David" | HR$Emp_name == "Tom")