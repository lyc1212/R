# OHLCV 데이터에서 기술적 분석 지표들의 FeatureSet을 추출한다
# -------------------------------------------------------------
import pandas as pd
import numpy as np
import math
from scipy.stats import norm
from scipy import ndimage

# OHLCV 데이터로부터 Feature Set을 구성한다
def getFeatureSet(data, u, d, period):
    
    # Feature value를 계산한 후 Z-score Normalization 한다
    fmacd = scale(MACD(data, 12, 26, 9))
    frsi = scale(RSI(data, 40))
    fobv = scale(OBV(data, ext=True))
    fliquidity = scale(Liquidity(data))
    fparkinson = scale(ParkinsonVol(data, 10))
    fvol = scale(CloseVol(data, 10))
    
    ft = pd.DataFrame()
    ft['macd'] = fmacd
    ft['rsi'] = frsi
    ft['obv'] = fobv
    ft['liquidity'] = fliquidity
    ft['parkinson'] = fparkinson
    ft['volatility'] = fvol
    ft['class'] = getUpDnClass(data, u, d, period)
    ft = ft.dropna()
    
    # Feature들의 value (수준) 보다는 방향 (up, down)을 분석하는 것이 의미가 있어 보임.
    # 방향을 어떻게 검출할 지는 향후 연구 과제로 한다

    return ft

# Supervised Learning을 위한 class를 부여한다
# 
# up : 목표 수익률 표준편차
# dn : 손절률 표준편차
# period : holding 기간
# return : 0 - 주가 횡보, 1 - 주가 하락, 2 - 주가 상승
# ---------------------------------------------------
def getUpDnClass(data, up, dn, period):
    # 주가 수익률의 표준편차를 측정한다
    r = []
    for curr, prev in zip(data.itertuples(), data.shift(1).itertuples()):
        if math.isnan(prev.Close):
            continue
        r.append(np.log(curr.Close / prev.Close))
    s = np.std(r)
    
    # 목표 수익률과 손절률을 계산한다
    uLimit = up * s * np.sqrt(period)
    dLimit = dn * s * np.sqrt(period)
    
    # 가상 Trading을 통해 미래 주가 방향에 대한 Class를 결정한다
    rclass = []
    for i in range(len(data) - 1):
        # 매수 포지션을 취한다
        buyPrc = data.iloc[i].Close
        y = np.nan
            
        # 매수 포지션 이후 청산 지점을 결정한다
        for k in range(i+1, len(data)):
            sellPrc = data.iloc[k].Close
            
            # 수익률을 계산한다
            rtn = np.log(sellPrc / buyPrc)
            
            # 목표 수익률이나 손절률에 도달하면 루프를 종료한다
            if k > i + period:
                # hoding 기간 동안 목표 수익률이나 손절률에 도달하지 못했음
                # 주가가 횡보한 것임
                y = 0
                break
            else:
                if rtn > uLimit:
                    y = 2       # 수익
                    break
                elif rtn < dLimit:
                    y = 1       # 손실
                    break

        rclass.append(y)
    
    rclass.append(np.nan)
    return pd.DataFrame(rclass, index=data.index)

# MACD 지표를 계산한다
# MACD Line : 12-day EMA - 26-day EMA
# Signal Line : 9-day EMA of MACD line
# MACD oscilator : MACD Line - Signal Line
# ----------------------------------------
def MACD(ohlc, nFast=12, nSlow=26, nSig=9, percent=True):
    ema1 = EMA(ohlc.Close, nFast)
    ema2 = EMA(ohlc.Close, nSlow)
    
    if percent:
        macdLine =  100 * (ema1 - ema2) / ema2
    else:
        macdLine =  ema1 - ema2
    signalLine = EMA(macdLine, nSig)
    
    return pd.DataFrame(macdLine - signalLine, index=ohlc.index)

# 지수이동평균을 계산한다
# data : Series
def EMA(data, n):
    ma = []
    
    # data 첫 부분에 na 가 있으면 skip한다
    x = 0
    while True:
        if math.isnan(data[x]):
            ma.append(data[x])
        else:
            break;
        x += 1
        
    # x ~ n - 1 기간까지는 na를 assign 한다
    for i in range(x, x + n - 1):
        ma.append(np.nan)
    
    # x + n - 1 기간은 x ~ x + n - 1 까지의 평균을 적용한다
    sma = np.mean(data[x:(x + n)])
    ma.append(sma)
    
    # x + n 기간 부터는 EMA를 적용한다
    k = 2 / (n + 1)
    
    for i in range(x + n, len(data)):
        #print(i, data[i])
        ma.append(ma[-1] + k * (data[i] - ma[-1]))
    
    return pd.Series(ma, index=data.index)

# RSI 지표를 계산한다. (Momentum indicator)
# U : Gain, D : Loss, AU : Average Gain, AD : Average Loss
# smoothed RS는 고려하지 않았음.
# --------------------------------------------------------
def RSI(ohlc, n=14):
    closePrice = pd.DataFrame(ohlc.Close)
    U = np.where(closePrice.diff(1) > 0, closePrice.diff(1), 0)
    D = np.where(closePrice.diff(1) < 0, closePrice.diff(1) * (-1), 0)
    
    U = pd.DataFrame(U, index=ohlc.index)
    D = pd.DataFrame(D, index=ohlc.index)
    
    AU = U.rolling(window=n).mean()
    AD = D.rolling(window=n).mean()

    return 100 * AU / (AU + AD)
    
# On Balance Volume (OBV) : buying and selling pressure
# ext = False : 기존의 OBV
# ext = True  : Extended OBV. 가격 변화를 이용하여 거래량을 매수수량, 매도수량으로 분해하여 매집량 누적
# -------------------------------------------------------------------------------------------------
def OBV(ohlcv, ext=True):
    obv = [0]
    
    # 기존의 OBV
    if ext == False:
        # 기술적 지표인 OBV를 계산한다
        for curr, prev in zip(ohlcv.itertuples(), ohlcv.shift(1).itertuples()):
            if math.isnan(prev.Volume):
                continue
            
            if curr.Close > prev.Close:
                obv.append(obv[-1] + curr.Volume)
            if curr.Close < prev.Close:
                obv.append(obv[-1] - curr.Volume)
            if curr.Close == prev.Close:
                obv.append(obv[-1])
    # Extendedd OBV
    else:
        # 가격 변화를 측정한다. 가격 변화 = 금일 종가 - 전일 종가
        deltaClose = ohlcv['Close'].diff(1)
        deltaClose = deltaClose.dropna(axis = 0)
        
        # 가격 변화의 표준편차를 측정한다
        stdev = np.std(deltaClose)
        
        for curr, prev in zip(ohlcv.itertuples(), ohlcv.shift(1).itertuples()):
            if math.isnan(prev.Close):
                continue
            
            buy = curr.Volume * norm.cdf((curr.Close - prev.Close) / stdev)
            sell = curr.Volume - buy
            bs = abs(buy - sell)
            
            if curr.Close > prev.Close:
                obv.append(obv[-1] + bs)
            if curr.Close < prev.Close:
                obv.append(obv[-1] - bs)
            if curr.Close == prev.Close:
                obv.append(obv[-1])
        
    return pd.DataFrame(obv, index=ohlcv.index)

# 유동성 척도를 계산한다
def Liquidity(ohlcv):
    k = []
    
    i = 0
    for curr in ohlcv.itertuples():
        dp = abs(curr.High - curr.Low)
        if dp == 0:
            if i == 0:
                k = [np.nan]
            else:
                # dp = 0 이면 유동성은 매우 큰 것이지만, 계산이 불가하므로 이전의 유동성을 유지한다
                k.append(k[-1])
        else:
            k.append(np.log(curr.Volume) / dp)
        i += 1
        
    return pd.DataFrame(k, index=ohlcv.index)

# 전일 Close price와 금일 Close price를 이용하여 변동성을 계산한다
def CloseVol(ohlc, n):
    rtn = pd.DataFrame(ohlc['Close']).apply(lambda x: np.log(x) - np.log(x.shift(1)))
    vol = pd.DataFrame(rtn).rolling(window=n).std()

    return pd.DataFrame(vol, index=ohlc.index)
    
# 당일의 High price와 Low price를 이용하여 Parkinson 변동성 (장 중 변동성)을 계산한다.
def ParkinsonVol(ohlc, n):
    vol = []
    for i in range(n-1):
        vol.append(np.nan)
        
    for i in range(n-1, len(ohlc)):
        sigma = 0
        for k in range(0, n):
            sigma += np.log(ohlc.iloc[i-k].High / ohlc.iloc[i-k].Low) ** 2
        vol.append(np.sqrt(sigma / (n * 4 * np.log(2))))
        
    return pd.DataFrame(vol, index=ohlc.index)

# Z-score normalization
def scale(data):
    col = data.columns[0]
    return (data[col] - data[col].mean()) / data[col].std()

# 시계열을 평활화한다
def smooth(data, s=5):
    y = data[data.columns[0]].values
    w = np.isnan(y)
    y[w] = 0.
    sm = ndimage.gaussian_filter1d(y, s)
    return pd.DataFrame(sm)