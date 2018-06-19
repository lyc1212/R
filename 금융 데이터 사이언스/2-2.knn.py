# KNN 알고리즘으로 주가의 향후 방향을 예측한다.
# ------------------------------------------
import matplotlib.pyplot as plt
import pandas as pd
from StockData import YahooData, FeatureSet
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier

# Yahoo site로부터 삼성전자 주가 데이터를 수집한다
#sam = YahooData.getStockData('005930.KS', '2007-01-01')

# 저장된 파일을 읽어온다
sam = pd.read_pickle('data/stockData/005930.KS')

# 주가 데이터 (OHLCV)로부터 기술적분석 지표들을 추출한다
# u = 0.8 : 수익률 표준편차의 0.8 배 이상이면 주가 상승 (class = 2)
# d = -0.8 : 수익률 표준편차의 -0.8배 이하이면 주가 하락 (class = 1)
# 아니면 주가 횡보 (classs = 0)
ft = FeatureSet.getFeatureSet(sam, u=0.8, d=-0.7, period=20)

# Feature DataSet의 뒷 부분을 확인한다
ft.tail(10)

# class = (0, 1, 2)가 균등한지 확인하고, 균등하지 않으면 위의 u,d를 조정하여 균등하게 만든다.
plt.hist(ft['class'])
plt.show()

# Train 데이터 세트와 Test 데이터 세트를 구성한다
x = ft.iloc[:, 0:6]
y = ft['class']
trainX, testX, trainY, testY = train_test_split(x, y, test_size = 0.2, random_state=None)

# KNN 으로 Train 데이터 세트를 학습한다.
knn = KNeighborsClassifier(n_neighbors=50, p=2, metric='minkowski')
knn.fit(trainX, trainY)

# Test 세트의 Feature에 대한 class를 추정하고, 정확도를 계산한다
predY = knn.predict(testX)
accuracy = 100 * (testY == predY).sum() / len(predY)
print()
print("* 시험용 데이터로 측정한 정확도 = %.2f" % accuracy, '%')

# Train 세트의 Feature에 대한 class를 추정하고, 정확도를 계산한다
predY = knn.predict(trainX)
accuracy = 100 * (trainY == predY).sum() / len(predY)
print("* 학습용 데이터로 측정한 정확도 = %.2f" % accuracy, '%')

# k를 변화시켜가면서 정확도를 측정해 본다
testAcc = []
trainAcc = []
for k in range(5, 100):
    # KNN 으로 Train 데이터 세트를 학습한다.
    knn = KNeighborsClassifier(n_neighbors=k, p=2, metric='minkowski')
    knn.fit(trainX, trainY)
    
    # Test 세트의 Feature에 대한 정확도
    predY = knn.predict(testX)
    testAcc.append((testY == predY).sum() / len(predY))
    
    # Train 세트의 Feature에 대한 정확도
    predY = knn.predict(trainX)
    trainAcc.append((trainY == predY).sum() / len(predY))

plt.figure(figsize=(8, 5))
plt.plot(testAcc, label="Test Data")
plt.plot(trainAcc, label="Train Data")
plt.legend()
plt.xlabel("k")
plt.ylabel("Accuracy")
plt.show()

# 시험용 데이터의 마지막 데이터를 금일 데이터로 가정하고 향후 주가의 방향을 추정한다
# 금일 측정된 Feature가 아래와 같다면, 향후 주가의 방향은 ?
todayX = pd.DataFrame([(-0.23,-1.45,0.85,0.43,-0.38,0.5)], columns=['macd', 'rsi', 'obv', 'liquidty', 'parkinson', 'volatility'])
predY = knn.predict(todayX)
print()

if predY == 0.0:
    print("* 향후 주가는 횡보할 것으로 예상됨.")
elif predY == 1.0:
    print("* 향후 주가는 하락할 것으로 예상됨.")
else:
    print("* 향후 주가는 상승할 것으로 예상됨.")
predProb = knn.predict_proba(todayX)
print("* 확률 척도 : ", predProb)

# 2개 Feature를 선택하여 2-차원 상에서 각 Feature에 대한 class를 육안으로 확인한다
# 전체 Feature의 6-차원 공간의 확인은 불가하므로 2-차원으로 확인한다
ftX = 0     # x-축은 macd
ftY = 4     # y-축은 parkinson's volatility
cnt = 100   # 100개만 그린다
class0 = ft[ft['class'] == 0].iloc[0:cnt, [ftX, ftY]]
colX = class0.columns[0]
colY = class0.columns[1]

plt.figure(figsize=(8, 7))
plt.scatter(class0[colX], class0[colY], color='blue', marker='x', s=100, alpha=0.5, label='FLAT')

class1 = ft[ft['class'] == 1].iloc[0:cnt, [ftX, ftY]]
plt.scatter(class1[colX], class1[colY], color='red', marker='s', s=100, alpha=0.5, label='DOWN')

class2 = ft[ft['class'] == 2].iloc[0:cnt, [ftX, ftY]]
plt.scatter(class2[colX], class2[colY], color='green', marker='o', s=100, alpha=0.5, label='UP')
plt.xlabel(colX)
plt.ylabel(colY)
plt.legend()
plt.show()
