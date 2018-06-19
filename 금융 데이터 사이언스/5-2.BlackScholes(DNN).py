# Neural Network로 Black Scholes 옵션 가격 모델을 학습한다.
#
# Reference : 
# Julia Bennell and Charle, 2013.5, Black-Scholes Versus Artificial Neural Networks in Pricing FTSE 100 Options
# Robert Culkin & Sanjiv R. Das, 2017.8, Machine Learning in Finance: The Case of Deep Learning for Option Pricing 
import numpy as np
from keras import optimizers
from keras.models import Sequential
from keras.layers import Dense
import matplotlib.pyplot as plt
import scipy.stats as st
import random

# 블랙-숄즈 옵션 가격 결정 모형
def BlackScholes(S, K, r, s, T):
    
    d1 = (np.log(S/K) + (r + s**2 / 2) * T)/(s * np.sqrt(T))
    d2 = d1 - s * np.sqrt(T)
    
    nd1 = st.norm.cdf(d1)
    nd2 = st.norm.cdf(d2)
    
    call = S * nd1 - K * np.exp(-r * T) * nd2
    return call

MIN_S = 260
MAX_S = 290
MIN_K = 260
MAX_K = 290
MIN_r = 0.01
MAX_r = 0.03
MIN_T = 1 / 252
MAX_T = 30 / 252
MIN_s = 0.1
MAX_s = 0.3

# 학습 데이터를 생성한다.
def DataSet(n):
    for i in range(n):
        # parameter를 랜덤하게 학습한다
        S = random.uniform(MIN_S, MAX_S)
        K = random.uniform(MIN_K, MAX_K)
        T = random.uniform(MIN_T, MAX_T)
        r = random.uniform(MIN_r, MAX_r)
        s = random.uniform(MIN_s, MAX_s)
        C = BlackScholes(S, K, r, s, T)
        
        # 입력층에 S와 K를 입력하지 않고, log(S/K)를 입력한다
        # 출력층의 target은 C/K 로 한다.
        if i == 0:
            d = np.zeros((1, 5))
            d[0] = [np.log(S/K), r, s, T, C/K]
        else:
            d = np.append(d, [[np.log(S/K), r, s, T, C/K]], axis=0)
    
    x = d[:, 0:4]
    y = d[:, 4]
    return x, y

model = Sequential()
model.add(Dense(100, input_dim=4, activation='relu'))
model.add(Dense(100, activation='relu'))
model.add(Dense(100, activation='relu'))
model.add(Dense(100, activation='relu'))
model.add(Dense(1, activation='linear'))
sgd = optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.5, nesterov=True)
model.compile(loss='mean_squared_error', optimizer=sgd)
try:
    model.load_weights("data/5-2.dnn_weight.h5")
    print("기존 학습 결과 Weight를 적용하였습니다.")
except:
    print("model Weight을 Random 초기화 하였습니다.")
    
# Black-Scholes를 학습한다
def learnBS(n):
    # 학습 데이터를 생성한다
    trainX, trainY = DataSet(n)
    
    # 학습 (Learning)
    model.fit(trainX, trainY, batch_size = 100, epochs = 100)
    
    # 학습 결과를 저장해 둔다
    model.save_weights("data/5-2.dnn_weight.h5")

# 신경망으로 옵션 가격을 추정한다
def CallPriceDNN(S, K, r, s, T):
    testX = np.array([[np.log(S/K), r, s, T]])
    return model.predict(testX)[0][0] * K

# 결과 확인
def check(S=270, K = 277.5, r = 0.02, s = 0.2, T = 15 / 252):
    print()
    print("Call Price (DNN) = ", CallPriceDNN(S, K, r, s, T))
    print("Call Price (BS ) = ", BlackScholes(S, K, r, s, T))
    
    # 잔존기간이 (T-t) 15일이고 S가 MIN_S ~ MAX_S 일 때의 옵션 가격 변화를 관찰한다.
    nnC = []
    bsC = []
    for S in np.arange(MIN_S, MAX_S, 0.5):
        nnC.append(CallPriceDNN(S, K, r, s, T))
        bsC.append(BlackScholes(S, K, r, s, T))
        
    plt.figure(figsize=(8, 6))
    ax = np.arange(MIN_S, MAX_S, 0.5)
    plt.plot(ax, bsC, label='Black Scholes')
    plt.plot(ax, nnC, label='Neural Network')
    plt.axvline(x = K, linestyle='dashed', linewidth=1)
    plt.xlabel('Underlying Asset Price (S)')
    plt.ylabel('Call Option Price')
    plt.legend()
    plt.grid()
    plt.show()

learnBS(1000)
check(S=270, K = 277.5, r = 0.02, s = 0.2, T = 15 / 252)
