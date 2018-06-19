# LSTM을 이용하여 Pairs Trading용 Spread 시계열을 예측한다
# ------------------------------------------------------
from keras.models import Sequential
from keras.layers import Dense, LSTM
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# SOIL과 SK이노베이션 주가를 읽어와서 Pairs Trading Spread를 생성한다.
soil = pd.read_pickle('data/stockData/010950.KS')
skin = pd.read_pickle('data/stockData/096770.KS')
pair = pd.DataFrame()
pair['soil'] = soil['Close']
pair['skin'] = skin['Close']
pair = pair.dropna()
pair['npaA'] = (pair['soil'] - np.mean(pair['soil'])) / np.std(pair['soil'])
pair['npaB'] = (pair['skin'] - np.mean(pair['skin'])) / np.std(pair['skin'])
pair['spread'] = pair['npaA'] - pair['npaB']
pair['mspread'] = pair['spread'].rolling(5).mean()
pair = pair.dropna()

# Normalized 주가를 그린다
plt.figure(figsize=(8, 3.5))
plt.plot(pair['npaA'], color='blue', label='SOIL', linewidth=1)
plt.plot(pair['npaB'], color='red', label='SK Innovation', linewidth=1)
plt.title('Normalized Price')
plt.legend()
plt.show()

# Spread와 Spread의 5-기간 이동평균을 그린다
plt.figure(figsize=(8, 3.5))
plt.plot(pair['spread'], color='blue', label='Spread', linewidth=1)
plt.plot(pair['mspread'], color='red', label='SMA(5)', linewidth=1)
plt.axhline(y=np.mean(pair['spread']), linewidth=1)
plt.title('Spread')
plt.legend()
plt.show()

# RNN 입력값과 출력 목표값을 생성한다
# ex : s = ([1,2,3,4,5,6,7,8,9,10])
#      x, y = TrainDataSet(s, prior = 3)
#
# x = array([[[1, 2, 3]],    y = array([4,   --> 1,2,3 다음에는 4가 온다
#            [[2, 3, 4]],               5,   --> 2,3,4 다음에는 5가 온다
#            [[3, 4, 5]],               6,
#            [[4, 5, 6]],               7,
#            [[5, 6, 7]],               8,
#            [[6, 7, 8]],               9,
#            [[7, 8, 9]]])              10,])
#
# 3개 데이터의 시퀀스를 이용하여 다음 시계열을 예측하기 위한 예시임.
# ----------------------------------------------------------------------
def TrainDataSet(data, prior=1):
    x, y = [], []
    for i in range(len(data)-prior):
        a = data[i:(i+prior)]
        x.append(a)
        y.append(data[i + prior])
    
    trainX = np.array(x)
    trainY = np.array(y)
    
    # RNN에 입력될 형식으로 변환한다. (데이터 개수, 1행 X prior 열)
    trainX = np.reshape(trainX, (trainX.shape[0], 1, trainX.shape[1]))

    return trainX, trainY

# 10개 데이터의 시퀀스로 다음 번 시계열을 예측함.
nPrior = 10

# 학습 데이터와 목표값 생성
data = pair['mspread'].values
trainX, trainY = TrainDataSet(data, nPrior)

# RNN 모델 빌드 및 fitting
model = Sequential()
model.add(LSTM(20, input_shape=(1,nPrior)))
model.add(Dense(1))
model.compile(loss='mse', optimizer='adam')
history = model.fit(trainX, trainY, batch_size=100, epochs = 500)

# 향후 10 기간 데이터를 예측한다
nFuture = 10
dx = np.copy(data)
estimate = [dx[-1]]
for i in range(nFuture):
    # 마지막 nPrior 만큼 입력데이로 다음 값을 예측한다
    x = dx[-nPrior:]
    x = np.reshape(x, (1, 1, nPrior))
    
    # 다음 값을 예측한다
    y = model.predict(x)[0][0]
    
    # 예측값을 저장해 둔다
    estimate.append(y)
    
    # 이전 예측값을 포함하여 또 다음 값을 예측하기위해 예측한 값을 저장해 둔다
    dx = np.insert(dx, len(dx), y)

# 원 시계열의 마지막 부분 100개와 예측된 시계열을 그린다
dtail = data[-100:]
ax1 = np.arange(1, len(dtail) + 1)
ax2 = np.arange(len(dtail), len(dtail) + len(estimate))
plt.figure(figsize=(8, 7))
plt.plot(ax1, dtail, color='blue', label='Spread', linewidth=1)
plt.plot(ax2, estimate, color='red', label='Estimate')
plt.axvline(x=ax1[-1],  linestyle='dashed', linewidth=1)
plt.title('Spread & Estimate')
plt.legend()
plt.show()
