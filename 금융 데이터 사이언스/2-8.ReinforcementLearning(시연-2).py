# Optimal Stopping Time
# GBM 모형에서 최적 매도 시점을 찾는다
# 학습 알고리즘 :  Double-Sarsa Control with Fourier Basis FA
# Double-Sarsa 근거 : Michael Ganger, Ethan Duryea, WeiHu (2016),
#                    Double Sarsa and Double Expected Sarsa with Shallow and Deep Learning
#
# *** 이 버전은 교육용 Trial version (Draft)으로, 개선의 여지가 많음.
#
# 교육자료 : Reinforcement Learning for Finance
# 작성자 : 아마추어 퀀트 (blog.naver.com/chunjein)
# 작성일 : 2017.8.8
# -------------------------------------------------------------------------------------------
import pandas as pd
import numpy as np
import itertools as it
import matplotlib.pyplot as plt
np.set_printoptions(threshold=np.inf, precision=3, linewidth = 200)

ALPHA =  2 / (10000 + 1)     # 최근 10,000 번 방문시 평균 정도에 해당. (ALPHA = 0.0002 정도)
GAMMA = 1.0
EPSILON = 0.1

# Action
STOP = 0
HOLD = 1
sAction = ['STOP', 'HOLD']

def myArgmax(d):
    maxValue = np.max(d)
    indices = np.where(np.asarray(d) == maxValue)[0]
    return np.random.choice(indices)

def ChooseAction(state):
    if (np.random.rand() < EPSILON):
        # epsilon = 0.1, Exploration. 아무거나 선택한다
        return np.random.choice([STOP, HOLD])
    else:
        # 평균 가치가 높은 action을 취한다
        # action-value (Q-function)를 계산한다. Double-Sarsa
        X = GetFeatureVector(state, nOrder)
        Q1 = [np.dot(W1[i], X) for i in (STOP, HOLD)]
        Q2 = [np.dot(W2[i], X) for i in (STOP, HOLD)]
        Q = [Q1[0] + Q2[0], Q1[1] + Q2[1]]
        return myArgmax(Q)

# Fourier basis function으로 Feature voctor를 생성한다
def GetFeatureVector(state, pOrder):
    gFeatureComb = it.product(range(0, nOrder + 1), repeat = len(state))
    features = []
    for c in gFeatureComb:
        features.append(np.cos(np.pi * np.dot(c, state)))
    return features

def SarsaLearning(data):
    # 학습을 시작한다. data 뒤에서 부터 앞으로 이동하면서 weight를 업데이트한다.
    # Bottom-up 방식으로 data를 알고 있는 상태에서 Supervised Learning 처럼 학습한다.
    # ----------------------------------------------------------------------------
    for i in range(len(data) - 1, 0, -1):
        # 업데이트할 상태 (현재 상태)
        currMdd = data['mdd'][i-1]
        currTime = data['time'][i-1]

        if i == len(data) - 1:
            # Reward는 Profit을 적용할 수도 있고, Regret을 적용할 수도 있음.
#            reward = data['price'][i] - data['price'][0]
            reward = -(data['price'].max() - data['price'][i]) ** 2

            # W1, W2를 업데이트 한다
            # currQ를 계산한다. W1을 사용한다
            currX = GetFeatureVector([currMdd, currTime], nOrder)
            
            currQ = np.dot(W1[STOP], currX)
            W1[STOP] += ALPHA * np.dot(reward - currQ, currX)
            
            currQ = np.dot(W1[HOLD], currX)
            W1[HOLD] += ALPHA * np.dot(reward - currQ, currX)
            
            currQ = np.dot(W2[STOP], currX)
            W2[STOP] += ALPHA * np.dot(reward - currQ, currX)
            
            currQ = np.dot(W2[HOLD], currX)
            W2[HOLD] += ALPHA * np.dot(reward - currQ, currX)
            continue
         
        currAction = ChooseAction([currMdd, currTime])
        
        # 다음 상태
        nextMdd = data['mdd'][i]
        nextTime = data['time'][i]
        if i == len(data) - 2:
            nextAction = STOP
        else:
            nextAction = ChooseAction([nextMdd, nextTime])
            
        # 선택한 action에 따라 reward를 계산한다
        if currAction == STOP:
            # Reward는 Profit을 적용할 수도 있고, Regret을 적용할 수도 있음.
#            reward = data['price'][i] - data['price'][0]
            reward = -(data['price'].max() - data['price'][i]) ** 2
        else:   # HOLD
            # 이 경우는 아래에서 다음 상태의 bootstrapping value가 업데이트 되므로,
            # 지금 HOLD 했다가 나중에 reward 크면 여기에 반영될 것임. (Back-propagation)
            reward = 0

        # Double-Sarsa로 W1, W2를 업데이트 한다
        if np.random.rand() > 0.5:
            if currAction == STOP:   # Terminal
                G = reward
                
                # currQ를 계산한다. W1을 사용한다
                currX = GetFeatureVector([currMdd, currTime], nOrder)
                currQ = np.dot(W1[currAction], currX)
                
                # W1을 update한다
                W1[currAction] += ALPHA * np.dot(G - currQ, currX)
                
                # 여기가 Terminal이 아니고 계속 이어지도록 한다.
                # 아래에 HOLD 측 W 도 업데이트 한다
                currAction = HOLD
                reward = 0
            
            # nextQ로 G를 계산한다. W2 (Q2)를 사용하여 nextQ를 계산한다. Bootstrapping
            nextX = GetFeatureVector([nextMdd, nextTime], nOrder)
            nextQ = np.dot(W2[nextAction], nextX)
            G = reward + GAMMA * nextQ      # reward = 0
        
            # currQ를 계산한다. W1을 사용한다
            currX = GetFeatureVector([currMdd, currTime], nOrder)
            currQ = np.dot(W1[currAction], currX)
            
            # W1을 update한다
            W1[currAction] += ALPHA * np.dot(G - currQ, currX)
        else:
            if currAction == STOP:   # Terminal
                G = reward
                
                # currQ를 계산한다. W2를 사용한다
                currX = GetFeatureVector([currMdd, currTime], nOrder)
                currQ = np.dot(W2[currAction], currX)
                
                # W2를 update한다
                W2[currAction] += ALPHA * np.dot(G - currQ, currX)
                
                # 여기가 Terminal이 아니고 계속 이어지도록 한다.
                # 아래에 HOLD 측 W 도 업데이트 한다
                currAction = HOLD
                reward = 0
            
            # nextQ로 G를 계산한다. W1 (Q1)을 사용하여 nextQ를 계산한다. Bootstrapping
            nextX = GetFeatureVector([nextMdd, nextTime], nOrder)
            nextQ = np.dot(W1[nextAction], nextX)
            G = reward + GAMMA * nextQ      # reward = 0
        
            # currQ를 계산한다. W2를 사용한다
            currX = GetFeatureVector([currMdd, currTime], nOrder)
            currQ = np.dot(W2[currAction], currX)
            
            # W2를 update한다
            W2[currAction] += ALPHA * np.dot(G - currQ, currX)
            
# Feature를 계산한다. 
def CalFeature(bm):
    s = bm.copy()
    
    # 전 고점 (Previous max)을 찾는다
    s['pmax'] = 0.0
    s['pmax'][0] = s['price'][0]
    for i in range(1, len(s)):
        if s['price'][i] > s['pmax'][i-1]:
            s['pmax'][i] = s['price'][i]
        else:
            s['pmax'][i] = s['pmax'][i-1]
    
    # 전 고점과 현재 주가의 차이 (MDD)를 계산한다.
    s['mdd'] = s['pmax'] - s['price']
    
    # 종료 시점까지 남은 시간을 0 ~ 1 사이 값으로 부여한다
    s['time'] = 0.0
    for i in range(1, len(s)):
        s['time'][i] = s['time'][i-1] + 1.0 / (len(s) - 1)
        if s['time'][i] > 1:
            s['time'][i] = 1
    
    return s

# T 기간 동안의 가상 주가를 생성한다
def BrownianMotion(T):
    B = []
    X = 0
    for i in range(0, T):
        # Brownian Motion.
        if np.random.rand() > 0.5:
            X += 1
        else:
            X += -1
        B.append(X)
        
    return B / np.sqrt(T)

# 학습을 시작한다
nOrder = 5
nStateDimension = 2
nAction = 2
T = 500
nEpisode = 10

try:
    W1 = np.load("data/2-7.OST(DSarsa)_W1.npy")
    W2 = np.load("data/2-7.OST(DSarsa)_W2.npy")
except:
    W1 = np.zeros((nAction, (nOrder + 1) ** nStateDimension))
    W2 = np.zeros((nAction, (nOrder + 1) ** nStateDimension))
    
for i in range(0, nEpisode):
    bm = pd.DataFrame(BrownianMotion(T), columns=['price'])
    fs = CalFeature(bm)
    SarsaLearning(fs)    
    print("Episode = ", i)

# 학습 결과를 저장해 둔다
np.save("data/2-7.OST(DSarsa)_W1", W1)
np.save("data/2-7.OST(DSarsa)_W2", W2)

# 결과를 확인한다
def recall():
    bm = pd.DataFrame(BrownianMotion(T), columns=['price'])
    fs = CalFeature(bm)
    
    # True OST를 그려 둔다.
    # ----------------------
    fs['dbound'] = 1.12 * np.sqrt(1 - fs['time'])
    
    # Optimal Stopping Time을 찾는다
    for i in range(0, len(fs)):
        if fs['mdd'][i] > fs['dbound'][i]:
            trueOst = i
            trueProfit = fs['price'][i] - fs['price'][0]
            break
        
    # 마지막까지 OST를 못 찾은 경우
    if i >= len(fs) - 1:
        trueOst = i
        trueProfit = fs['price'][len(fs)-1] - fs['price'][0]
        
    x = np.arange(0, len(fs))
    plt.figure(1, figsize=(10, 6))
    plt.plot(x, fs['price'], linewidth=1.5, label="Stock Price", color='blue')
    plt.plot(x, fs['pmax'], linewidth=1, label="Previous max", color='orange')
    plt.plot(x, fs['mdd'], linewidth=1, label="MDD", color='lightgrey')
    plt.plot(x, fs['dbound'], linewidth=1, label="Decision boundary", color='lightgreen')
    plt.axhline(y=0, linewidth=1, color='black')
    plt.axvline(x=trueOst, linewidth=1.5, label="True OST", color='red', linestyle='--')
    plt.title("Optimal Stopping Time")
    plt.xlabel("time")
    plt.ylabel("Stock Price")
    
    # 강화학습으로 학습한 OST를 찾는다
    # -------------------------------
    for i in range(0, len(fs)):
        state = [fs['mdd'][i], fs['time'][i]]
        X = GetFeatureVector(state, nOrder)
        Q1 = [np.dot(W1[i], X) for i in [STOP, HOLD]]
        Q2 = [np.dot(W2[i], X) for i in [STOP, HOLD]]
        Q = [Q1[0] + Q2[0], Q1[1] + Q2[1]]
        action = myArgmax(Q)
        
        if action == STOP:
            rlOst = i
            rlProfit = fs['price'][i] - fs['price'][0]
            break
    
    # 마지막까지 OST를 못 찾은 경우
    if i >= len(fs) - 1:
        rlOst = i
        rlProfit = fs['price'][len(fs)-1] - fs['price'][0]
        
    plt.axvline(x = rlOst, linewidth = 1.5, linestyle='--', label="RL OST")
    plt.legend()
    plt.show()
    
    print("True OST = %d, RL OST = %d" % (trueOst, rlOst))
    print("True Profit = %.2f, RL Profit = %.2f" % (trueProfit, rlProfit))
    
# 결과를 확인한다
def trade(nTrade):
    ostProfitTraj = []
    rlProfitTraj = []
    randomProfitTraj = []
    ostProfit = 0
    rlProfit = 0
    randomProfit = 0
    for n in range(0, nTrade):
        bm = pd.DataFrame(BrownianMotion(T), columns=['price'])
        fs = CalFeature(bm)
        
        # True OST profit을 구한다
        fs['dbound'] = 1.12 * np.sqrt(1 - fs['time'])
        
        # Optimal Stopping Time을 찾는다
        for i in range(0, len(fs)):
            if fs['mdd'][i] > fs['dbound'][i]:
                ostProfit += fs['price'][i] - fs['price'][0]
                ostProfitTraj.append(ostProfit)
                break
        
        # 마지막까지 OST를 못 찾은 경우
        if i >= len(fs)-1:
            ostProfit += fs['price'][i] - fs['price'][0]
            ostProfitTraj.append(ostProfit)
            
        # 강화학습에 의한 Profit을 구한다
        for i in range(0, len(fs)):
            state = [fs['mdd'][i], fs['time'][i]]
            X = GetFeatureVector(state, nOrder)
            Q1 = [np.dot(W1[i], X) for i in [STOP, HOLD]]
            Q2 = [np.dot(W2[i], X) for i in [STOP, HOLD]]
            Q = [Q1[0] + Q2[0], Q1[1] + Q2[1]]
            
            if Q[STOP] > Q[HOLD]:     # STOP action에 대한 Q가 더 크면... Stopping time
                rlProfit += fs['price'][i] - fs['price'][0]
                rlProfitTraj.append(rlProfit)
                break
        
        # 마지막까지 OST를 못 찾은 경우
        if i >= len(fs)-1:
            rlProfit += fs['price'][i] - fs['price'][0]
            rlProfitTraj.append(rlProfit)
        
        # Random하게 청산한 Profit과 비교해 본다
        r = int(np.random.uniform(0, T))
        randomProfit += fs['price'][r] - fs['price'][0]
        randomProfitTraj.append(randomProfit)
        
        if n % 10 == 0:
            print("nTrade = ", n)
    
    plt.figure(1, figsize=(10, 7))
    plt.plot(ostProfitTraj, label = "OST Profit", linewidth = 1)
    plt.plot(rlProfitTraj, label = "RL Profit", linewidth = 1)
    plt.plot(randomProfitTraj, label = "Random Profit", linewidth = 1, color="grey")
    plt.axhline(y=0, linewidth = 1, color = "black")
    plt.title("Accumulated Profit by Fourier BF (%d iterations)" % nTrade)
    plt.xlabel("time")
    plt.ylabel("Profit")
    plt.legend()
    plt.show()
    
    print("Total Profit = %.2f, %.2f (OST, RL)" % (ostProfitTraj[-1], rlProfitTraj[-1]))