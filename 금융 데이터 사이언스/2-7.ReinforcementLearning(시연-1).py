import numpy as np
from math import floor
from math import asin
import _pickle as cPickle
import matplotlib.pyplot as plt

# all possible actions
ACTION_REVERSE = -1
ACTION_ZERO = 0
ACTION_FORWARD = 1

# order is important
ACTIONS = [ACTION_REVERSE, ACTION_ZERO, ACTION_FORWARD]

# bound for position and velocity
POSITION_MIN = -1.2
POSITION_MAX = 0.5
VELOCITY_MIN = -0.07
VELOCITY_MAX = 0.07

# use optimistic initial value, so it's ok to set epsilon to 0
EPSILON = 0

numOfTilings = 8
alpha = 0.3

# 현재 위치 (oldX), 속도 (oldV)에서 액션 (A)을 취했을 때,
# 다음의 위치, 속도, 높이를 측정한다.
# -----------------------------------------------------
def takeAction(oldX, oldV, A):
    # 새로운 속도를 계산한다
    newV = oldV + 0.001 * A - 0.0025 * np.cos(3 * oldX)
    newV = min(max(VELOCITY_MIN, newV), VELOCITY_MAX)
    
    # 새로운 위치를 계산한다
    newX = oldX + newV
    newX = min(max(POSITION_MIN, newX), POSITION_MAX)
    if newX == POSITION_MIN:
        newV = 0.0
    
    # 경사의 높이를 계산한다
    Y = np.sin(3 * newX)
    
    # 결과를 리턴한다. reward는 항상 -1.0 이다.
    return newX, newV, Y, -1.0

# get action at @position and @velocity based on epsilon greedy policy and @valueFunction
def getAction(x, v, valueFunction):
    if np.random.binomial(1, EPSILON) == 1:
        return np.random.choice(ACTIONS)
    values = []
    for action in ACTIONS:
        values.append(valueFunction.value(x, v, action))
    return np.argmax(values) - 1

# Tile Coding Hash table 구축 (by Rich Sutton)
# 
# 사용법
# ht = IHT(2048)
# tiles(ht, 8, [-0.005, -0.003], [1]) ~ X = -0.005, V = -0.003, Action = +1 이 속한 tile 번호 8개
#
# hash 테이블 검색
# ht.dictionary
# -----------------------------------------------------------------------------------------------
basehash = hash

class IHT:
    "Structure to handle collisions"
    def __init__(self, sizeval):
        self.size = sizeval
        self.overfullCount = 0
        self.dictionary = {}

    def __str__(self):
        "Prepares a string for printing whenever this object is printed"
        return "Collision table:" + \
               " size:" + str(self.size) + \
               " overfullCount:" + str(self.overfullCount) + \
               " dictionary:" + str(len(self.dictionary)) + " items"

    def count (self):
        return len(self.dictionary)

    def fullp (self):
        return len(self.dictionary) >= self.size

    def getindex (self, obj, readonly=False):
        d = self.dictionary
        if obj in d: return d[obj]
        elif readonly: return None
        size = self.size
        count = self.count()
        if count >= size:
            if self.overfullCount==0: print('IHT full, starting to allow collisions')
            self.overfullCount += 1
            return basehash(obj) % self.size
        else:
            d[obj] = count
            return count

def hashcoords(coordinates, m, readonly=False):
    if isinstance(m, IHT): return m.getindex(tuple(coordinates), readonly)
    if isinstance(m, int): return basehash(tuple(coordinates)) % m
    if m is None: return coordinates

# 주어진 좌표가 속하는 tile 번호를 리턴한다.
# ex : floats = [-0.005, -0.003], int = [1] ~ X = -0.005, V = -0.003, A = +1
#
# displacement vector 는 1,3,5,...,2d-1을 사용함.
# 첫 번째 tiling : offset = w/k (1, 1)
# 두 번째 tiling : offset = w/k (1, 3)
# 세 번째 tiling : offset = w/k (2, 6)...
# 참고 : 2017 (draft), Sutton & Barto P.234
# ---------------------------------------------------------------------------
def tiles (ihtORsize, numtilings, floats, ints=[], readonly=False):
    """returns num-tilings tile indices corresponding to the floats and ints"""
    qfloats = [floor(f * numtilings) for f in floats]
    Tiles = []
    for tiling in range(numtilings):
        tilingX2 = tiling * 2
        coords = [tiling]
        b = tiling
        for q in qfloats:
            coords.append( (q + b) // numtilings )
            b += tilingX2
        coords.extend(ints)
        Tiles.append(hashcoords(coords, ihtORsize, readonly))
    return Tiles

# wrapper class for state action value function
class ValueFunction:
    # In this example I use the tiling software instead of implementing standard tiling by myself
    # One important thing is that tiling is only a map from (state, action) to a series of indices
    # It doesn't matter whether the indices have meaning, only if this map satisfy some property
    # View the following webpage for more information
    # http://incompleteideas.net/sutton/tiles/tiles3.html
    # @maxSize: the maximum # of indices
    def __init__(self, stepSize, numOfTilings=8, maxSize=2048):
        try:
            self.loadClass()
        except:
            self.maxSize = maxSize
            self.numOfTilings = numOfTilings
    
            # divide step size equally to each tiling
            self.stepSize = stepSize / numOfTilings
    
            self.hashTable = IHT(maxSize)
    
            # weight for each tile
            self.weights = np.zeros(maxSize)
        
    # get indices of active tiles for given state and action
    def getActiveTiles(self, position, velocity, action):
        return tiles(self.hashTable, self.numOfTilings, [position, velocity], [action])

    # estimate the value of given state and action
    def value(self, x, v, a):
        if x == POSITION_MAX:
            return 0.0
        activeTiles = self.getActiveTiles(x, v, a)
        return np.sum(self.weights[activeTiles])

    # learn with given state, action and target
    def learn(self, x, v, a, target):
        activeTiles = self.getActiveTiles(x, v, a)
        estimation = np.sum(self.weights[activeTiles])
        delta = self.stepSize * (target - estimation)
        
        for activeTile in activeTiles:
            self.weights[activeTile] += delta

    def saveClass(self):
        file = open('data/2-7.MountainCarValueFunction.class','wb')
        file.write(cPickle.dumps(self.__dict__))
        file.close()
       
    def loadClass(self):
        file = open('data/2-7.MountainCarValueFunction.class','rb')
        dataPickle = file.read()
        file.close()

        self.__dict__ = cPickle.loads(dataPickle)

# semi-gradient n-step Sarsa (p. 259)
# @valueFunction: state value function to learn
# @n: # of steps
def semiGradientNStepSarsa(valueFunction, n=1):
    # start at a random position around the bottom of the valley
    currentPosition = np.random.uniform(-0.6, -0.4)
    
    # initial velocity is 0
    currentVelocity = 0.0
    
    # get initial action. value가 높은 action을 선택한다.
    currentAction = getAction(currentPosition, currentVelocity, valueFunction)

    # track previous position, velocity, action and reward
    positions = [currentPosition]
    velocities = [currentVelocity]
    actions = [currentAction]
    rewards = [0.0]

    # track the time
    time = 0

    # the length of this episode
    T = float('inf')
    while True:
        # go to next time step
        time += 1

        if time < T:
            # 선택한 action을 수행하고, 다음 위치, 속도, reward를 측정한다.
            newPostion, newVelocity, height, reward = takeAction(currentPosition, currentVelocity, currentAction)
            
            # 새로운 위치,속도에서 최선의 action을 선택한다.
            newAction = getAction(newPostion, newVelocity, valueFunction)

            # track new state and action
            positions.append(newPostion)
            velocities.append(newVelocity)
            actions.append(newAction)
            rewards.append(reward)

            if newPostion == POSITION_MAX:
                T = time

        # get the time of the state to update
        updateTime = time - n
        if updateTime >= 0:
            returns = 0.0
        
            # calculate corresponding rewards
            for t in range(updateTime + 1, min(T, updateTime + n) + 1):
                returns += rewards[t]
            
            # add estimated state action value to the return
            if updateTime + n <= T:
                returns += valueFunction.value(positions[updateTime + n],
                                               velocities[updateTime + n],
                                               actions[updateTime + n])
            # update the state value function
            if positions[updateTime] != POSITION_MAX:
                valueFunction.learn(positions[updateTime], velocities[updateTime], actions[updateTime], returns)
        
        if updateTime == T - 1:
            break
        currentPosition = newPostion
        currentVelocity = newVelocity
        currentAction = newAction

    return time

# 학습을 수행한 후 학습 결과를 저장해 둔다.
def learn(nEpisode):
    valueFunction = ValueFunction(alpha, numOfTilings)
    
    print("Start Learning, nEpisode = %d" % nEpisode)
    for episode in range(0, nEpisode):
        semiGradientNStepSarsa(valueFunction)
    
    # valueFunction을 저장해 둔다
    valueFunction.saveClass()

# 현재 위치 (X), 속도에 대한 action-value을 확인한다
def ActionValue(x, v):
    valueFunction = ValueFunction(alpha, numOfTilings)
    
    # 위치 x에서 Forward action을 취할 때의 value
    value = valueFunction.value(x, v, ACTION_FORWARD)
    print(" Forward : %.2f" % value)
    
    # 위치 x에서 Stop action을 취할 때의 value
    value = valueFunction.value(x, v, ACTION_ZERO)
    print("    Zero : %.2f" % value)
    
    # 위치 x에서 Reverse action을 취할 때의 value
    value = valueFunction.value(x, v, ACTION_REVERSE)
    print(" Reverse : %.2f" % value)
    
# 학습 결과를 기반으로 최적 액션을 따라 자동차를 운행해서 우측 정상에 오른다.
def play():
    valueFunction = ValueFunction(alpha, numOfTilings)

    # 가장 낮은 점에서 시작하여 최적 Acion을 따라가본다
    # 경로는 sin(3x) 이고, 높이가 -1 인 지점에서 출발한다.
    X = asin(-1) / 3
    Y = np.sin(3 * X)
    V = 0
    sAction = ("Reverse", "   Zero", "Forward")
    action = ACTION_ZERO
    count = 1   # action 카운터
    k = 0       # 무한 루프 방지 카운터
    height = []      # 올라간 높이 추적용
    while Y < 0.99:
        k += 1
        oldAction = action
        
        # 현재 위치와 속도에서 최적 action을 검색한다
        action = getAction(X, V, valueFunction)
        
        # 최적 action으로 움직인다. X, V 는 다음 위치와 속도이다 (R은 reward = -1)
        X, V, Y, R = takeAction(X, V, action)
        
        # 높이를 계산한다
        height.append(Y)
        
        # 운행 경로를 출력한다
        print(sAction[oldAction+1], " (%3d) :" % count, "X = %.3f, Y = %.3f, V = %.3f" % (X, Y, V))
        count += 1
        
        if k > 10000:
            break

    # 올라간 높이를 표시한다
    plt.figure(1, figsize=(7,3.5))
    plt.plot(height, label='Height', color='red')
    plt.xlabel('Step')
    plt.ylabel('Height')
    plt.show()





