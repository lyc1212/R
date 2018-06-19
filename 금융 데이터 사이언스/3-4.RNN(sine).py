# RNN을 이용하여 시계열을 예측한다
# ------------------------------
from keras.models import Sequential
from keras.layers import Dense, SimpleRNN
import numpy as np
import matplotlib.pyplot as plt

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

# 시계열 데이터 (sin)
data = np.sin(2 * np.pi * 0.125 * np.arange(50))

# 3개 데이터의 시퀀스로 다음 번 시계열을 예측함.
nPrior = 4

# 학습 데이터와 목표값 생성
trainX, trainY = TrainDataSet(data, nPrior)

# RNN 모델 빌드 및 fitting
model = Sequential()
model.add(SimpleRNN(4, input_shape=(1,nPrior)))
model.add(Dense(1))
model.compile(loss='mse', optimizer='adam')
history = model.fit(trainX, trainY, epochs = 500)

# 향후 5 기간 데이터를 예측한다
nFuture = 5
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

# 원 시계열과 예측된 시계열을 그린다
ax1 = np.arange(1, len(data) + 1)
ax2 = np.arange(len(data), len(data) + len(estimate))
plt.figure(figsize=(8, 7))
plt.ylim(-1.5, 1.5)
plt.plot(ax1, data, 'b-o', color='blue', label='Time series', linewidth=1)
plt.plot(ax2, estimate, 'b-o', color='red', label='Estimate')
plt.axvline(x=ax1[-1],  linestyle='dashed', linewidth=1)
plt.legend()
plt.show()
