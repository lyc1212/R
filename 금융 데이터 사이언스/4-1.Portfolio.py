# Yahoo site로 부터 대형주 종목 데이터를 수집하여 포트폴리오를 최적화한다
#
# 사용법 :
# 1. collectData() : Yahoo 사이트로부터 데이터를 수집하여 파일에 저장한다.
# 2. rv, C = makeRtnVol() : 저장된 데이터를 읽어서 수익률-변동성과 공분산 행렬을 계산한다.
# 3. plotPortfolio(rv) : 수익률-변동성 공간에 종목의 위치를 표시한다.
# 4. a = optPortfolio(rv, C) : 포트폴리오를 최적화한다. 종목별 비중과 성과를 확인한다.
# 5. plotPortfolio(a) : 수익률-변동성 공간에 최적 포트폴리오 위치를 표시한다.
# ------------------------------------------------------------------------------------
import pandas_datareader.data as web
import pandas as pd
import numpy as np
import datetime as dt
import matplotlib.pyplot as plt
import scipy.optimize as optimize

# plot에서 한글 처리를 위해 아래 폰트를 사용한다
from matplotlib import font_manager, rc
font_name = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
rc('font', family=font_name)

stocks = {'005930':'삼성전자', '005380':'현대차', '000660':'SK하이닉스', '015760':'한국전력',
          '005490':'POSCO', '035420':'NAVER', '017670':'SK텔레콤', '012330':'현대모비스',
          '055550':'신한지주', '000270':'기아차', '105560':'KB금융', '051910':'LG화학',
          '034220':'LG디스플레이', '066570':'LG전자',
          '086790':'하나금융지주', '009540':'현대중공업', '023530':'롯데쇼핑', '030200':'KT',
          '024110':'기업은행', '096770':'SK이노베이션', '006400':'삼성SDI', '004020':'현대제철',
          '010130':'고려아연', '035250':'강원랜드', '011170':'롯데케미칼', '010950':'S-OIL',
          '010140':'삼성중공업', '000720':'현대건설', '036460':'한국가스공사',
          '001040':'CJ', '036570':'엔씨소프트', '009150':'삼성전기', '078930':'GS',
          '008770':'호텔신라', '047050':'대우인터내셔널', '006800':'대우증권', '003490':'대한항공',
          '034020':'두산중공업', '000210':'대림산업', '042670':'두산인프라코어', '000080':'하이트진로',
          '006360':'GS건설', '012450':'삼성테크윈'}

# Yahoo site로부터 대형주 종목 데이터를 수집한다
# 수정주가를 반영하여 삼성전자 주가 데이터를 수집한다. 가끔 안들어올 때가 있어서 10번 시도한다.
def collectData():
    start = dt.datetime(2007, 1, 1)
    end = dt.date.today()
    n = 1
    for code in stocks.keys():
        s = pd.DataFrame()
        for i in range(0, 10):
            try:
                s = web.YahooDailyReader(code + '.KS', start, end, adjust_price=True).read()
            except:
                print("   %s not collected (%d) ... Retrying" % (stocks[code], i + 1))
                
            if not s.empty:
                break
        if s.empty:
            print("   %s (%s.KS) not collected : Failed" % (stocks[code], code))
        else:
            print("%d) %s (%s.KS)가 수집되었습니다." % (n, stocks[code], code))
    
        # 수집한 데이터를 파일에 저장한다.
        s.to_pickle('data/stockData/' + code + '.KS')
        n += 1

    # 저장한 데이터를 데이터프레임으로 읽어오려면...
    #s = pd.read_pickle('data/stockData/005930.KS')

# 저장된 주가 데이터를 읽어와서 종목 별로 연평균 수익률, 변동성 Sharp ratio를 계산한다
def makeRtnVol():
    rtnVol = pd.DataFrame(columns=['name', 'rtn', 'vol', 'sr'])
    rawRtn = pd.DataFrame()
    n = 0
    for code in stocks.keys():
        # 저장된 주가 데이터를 읽어온다
        file = code + '.KS'
        s = pd.read_pickle('data/stockData/' + file)
        s = s.dropna()

        # 일일 수익률을 계산한다.
        s[stocks[code]] = np.log(s.Close) - np.log(s.Close.shift(1))
        s = s.dropna()
        
        # 종목별 수익률로 한 데이터프레임에 모은다
        # 이 결과는 Covariance matrix 계산에 사용된다
        rawRtn = rawRtn.join(pd.DataFrame(s[stocks[code]]), how='outer')
        
        # 일일 수익률로 연평균 수익률, 연간 변동성, Sharp ratio를 계산한다.
        yRtn = np.mean(s[stocks[code]]) * 252
        yVol = np.std(s[stocks[code]]) * np.sqrt(252)
        sr = yRtn / yVol
        
        # 계산 결과를 data frame에 저장한다
        rtnVol.loc[n] = [stocks[code], yRtn, yVol, sr]
        n += 1
    
    rawRtn = rawRtn.dropna()
    return rtnVol, rawRtn.cov()

# 위험-수익률 공간에 각 종목을 배치한다.
# Yahoo 데이터가 정확하다고 가정함. 실제는 잘못된 값을 갖는 경우도 있으므로 데이터 전처리 과정이 필요함.
def plotPortfolio(p):
    fig, ax = plt.subplots(figsize=(12, 7.5))
    for row in p.itertuples():
        # sr이 음수이면 0.001로 설정한다
        if row.sr < 0:
            sr = 0.001
        else:
            sr = row.sr
            
        # 해당 종목을 배치한다. 원의 크기는 Sharp ratio로 한다.
        ax.scatter(row.vol, row.rtn, marker='o', alpha=0.5, s=sr * 5000)
        ax.annotate(row.name, (row.vol, row.rtn))

    ax.set_xlabel('변동성 (위험)')
    ax.set_ylabel('수익률')

# 포트폴리오 최적화를 위한 목표함수. Sharp Ratio를 최대화한다.
def targetFunc(w, *args):
    rtn = args[0]
    cm = args[1]
    reg = args[2]

    portRtn = np.dot(w, rtn)
    portVol = np.sqrt(np.dot(w, np.dot(cm, w.T))) * np.sqrt(252) + reg * np.sum(w ** 2)
    return (-1) * portRtn / portVol 

# 제한 조건. Weight의 총합 = 1.0
def constraint1(w):
    return np.sum(w) - 1.0

# 포트폴리오를 최적화한다.
# reg : Regularization constant
def optPortfolio(rv, C, reg=100, opt=True):
    # Weight 행렬을 균등하게 설정한다.
    W = np.ones(len(rv)) * 1/len(rv)
    R = rv.rtn.values
        
    if opt:
        # 최적 포트폴리오의 비율 (W)을 계산한다
        bnds = ((0.0, +1.0),) * len(W)
        cons = {'type' : 'eq', 'fun' : constraint1}
        p = optimize.minimize(fun=targetFunc, x0=W, args=(R, C, reg), method='SLSQP', bounds=bnds, constraints=cons)
        #print(p)
        
        # 포트폴리오 최적 비율
        W = p.x

    portRtn = np.dot(W, R)
    portVol = np.sqrt(np.dot(W, np.dot(C, W.T))) * np.sqrt(252)
    rv['weight'] = W
    
    # weight의 Bar plot을 그린다
    plt.figure(figsize=(12, 6))
    x = range(1, len(W) + 1)
    ax = rv['weight'].plot(kind='bar', width=0.8, alpha=0.5)
    ax.set_title("Portfolio Weights")
    ax.set_xlabel("종목")
    ax.set_ylabel("Wehghts")
    ax.set_xticklabels(x)
    
    labels = rv['name']
    for p, i in zip(ax.patches, x):
        ax.annotate(labels[i-1], (p.get_x() * 1.005, p.get_height() * 1.005))
    
    # 최적 포트폴리오 성과를 기록해 둔다
    ret = rv.copy()
    ret.loc[len(rv)] = ('maxSR', portRtn, portVol, portRtn / portVol, 0)
    
    # 최적 포트폴리오 성과를 출력한다.
    print()
    print("* 포트폴리오 수익률 = %.2f (%s)" % (portRtn * 100, '%'))
    print("* 포트폴리오 변동성 = %.2f (%s)" % (portVol * 100, '%'))
    print("* Sharp Ratio = %.2f" % (portRtn / portVol))
    
    return ret
    
