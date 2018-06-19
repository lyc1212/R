# OHLCV 데이터에서 기술적 분석 지표들의 FeatureSet을 추출한다
# -------------------------------------------------------------
import pandas as pd

# OHLCV 데이터에서 종가 (Close)를 기준으로 과거 n-기간 동안의 Pattern을 구성한다
def getClosePattern(data, n):
    loc = tuple(range(1, len(data) - n, 3))
    
    # n개의 column을 가진 데이터프레임을 생성한다
    column = [str(e) for e in range(1, (n+1))]
    df = pd.DataFrame(columns=column)
    
    for i in loc:       
        pt = data['Close'].iloc[i:(i+n)].values
        pt = (pt - pt.mean()) / pt.std()
        df = df.append(pd.DataFrame([pt],columns=column, index=[data.index[i+n]]), ignore_index=False)
        
    return df

