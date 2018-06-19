# keras 설치 -----------------------------
# conda install theano
# conda install -c conda-forge tensorflow
# conda install -c conda-forge keras
# 인공신경망 XOR 예시 
# ---------------------------------------
import numpy as np
from keras import optimizers
from keras.models import Sequential
from keras.layers import Dense
import matplotlib.pyplot as plt

# XOR 계산을 위한 학습용 데이터를 구성한다
trainX = np.array([[0,0], [0,1], [1,0], [1,1]])     # 입력값 : 4 x 2 행렬
trainY = np.array([[0],[1],[1],[0]])                # 출력값 : 4 x 1 행렬

model = Sequential()
model.add(Dense(4, input_dim=2, activation='sigmoid'))
model.add(Dense(1, activation='sigmoid'))
adam = optimizers.Adam(lr = 0.05)
model.compile(loss='mse', optimizer=adam)
history = model.fit(trainX, trainY, batch_size = 1, epochs = 300)

# 학습 데이터 성능 곡선을 그린다
plt.figure(1, figsize=(7, 4))
plt.plot(history.history['loss'])
plt.xlabel('Epoch')
plt.ylabel('Error')
plt.title('Error History')
plt.show()

# 학습 데이터에 대한 인공신경망의 출력을 확인한다
predY = model.predict(trainX)
print("출력층 output:")
print(predY)
