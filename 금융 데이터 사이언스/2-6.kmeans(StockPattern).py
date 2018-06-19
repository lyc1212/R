# K-Means Clustering 알고리즘으로 종가 패턴을 분류한다.
# 매 시점마다 최근 n-기간 동안의 종가 vector를 주가 패턴으로 정의하고 8개의 클러스터로 분류한다.
# -----------------------------------------------------------------------------------------
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from StockData import YahooData, ClosePattern
from sklearn.cluster import KMeans

# Yahoo site로부터 삼성전자 주가 데이터를 수집한다
#sam = YahooData.getStockData('005930.KS', '2007-01-01')

# 저장된 파일을 읽어온다
sam = pd.read_pickle('data/stockData/005930.KS')

# 최근 20일 동안의 종가 패턴을 가져온다. 패턴 데이터는 Z-Score normalized 되어 있음.
ft = ClosePattern.getClosePattern(sam, n=20)

# Pattern 몇 개를 확인해 본다
x=np.arange(20)
plt.plot(x,ft.iloc[0])
plt.plot(x,ft.iloc[10])
plt.plot(x,ft.iloc[50])
plt.show()
print(ft.head())

# K-means 알고리즘으로 Pattern 데이터를 8 그룹으로 분류한다 (k = 8)
k = 8
km = KMeans(n_clusters=k, init='random', n_init=10, max_iter=300, tol=1e-04, random_state=0)
km = km.fit(ft)
y_km = km.predict(ft)
ft['cluster'] = y_km

# Centroid pattern을 그린다
fig = plt.figure(figsize=(10, 6))
for i in range(k):
    s = 'pattern-' + str(i)
    p = fig.add_subplot(2,4,i+1)
    p.plot(km.cluster_centers_[i,:], color="rbgkmrbg"[i])
    p.set_title('Cluster-' + str(i))

plt.tight_layout()
plt.show()

# cluster = 0 인 패턴 몇 개만 그려본다
cluster = 0
plt.figure(figsize=(8, 5))
p = ft.loc[ft['cluster'] == cluster]
for i in range(5):
    plt.plot(x,p.iloc[i][0:20])
    
plt.title('Cluster-' + str(cluster))
plt.show()
