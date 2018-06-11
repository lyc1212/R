#Factor - ���� ô��(I)
categories <- rep(1:4,10)
categories <- sample(categories,20)


#label�� �ڵ��Ͽ� factor������ ��ȯ####
job <- factor(categories, labels = c("�л�", "ȸ���", "�ֺ�", "����"))
job

#���ֺ� �� �ľ�####
table(job)


#Factor - ���� ô��(2)
#levels####
factor(categories, levels = 1:3)
factor(categories, levels = 1:5)

job_test <- factor(categories, levels = c("�л�", "ȸ���", "�ֺ�", "����"))
job_test

#levels�� �ڵ�####
job_factor <- factor(categories)
levels(job_factor) <- c("�л�", "ȸ���", "�ֺ�", "����")
job_factor

table(job_factor)


factor_both <- factor(categories, levels = 1:4, labels = c("�л�", "ȸ���", "�ֺ�", "����"))
factor_both



#Factor - ���� ô��
#����ô�� ���� ����####
score_sample <- rep(c("A","B","C","S"),10)
sample <- sample(score_sample, 20)
score <- factor(sample, levels = c('C', 'B', 'A', 'S', 'SS'), ordered = T)
score


#���� Ȯ��####
score[1]>score[2]


#norminal�� ordinal �Ѵ� levels�� level order�� �ٲٱ�####
job_fac_test <- factor(job, levels = c("�л�", "ȸ���", "�ֺ�", "����"))
job_fac_test

score_test <- factor(sample, levels = c("SS", "S", "A", "B", "C"), ordered = T)
score_test