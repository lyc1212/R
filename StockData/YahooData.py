# Yahoo site로 부터 대형주 종목 데이터를 수집하여 파일에 저장한다.
# -------------------------------------------------------------
import pandas_datareader.data as web
import pandas as pd
import datetime as dt

# Yahoo site로 부터 주가 데이터를 수집한다. 가끔 안들어올 때가 있어서 10번 시도한다.
# 수정 주가로 환산하여 읽어온다
def getStockData(stockCode, start='', end=''):
    # 수집 기간
    if start == '':
        start = dt.datetime(2007, 1, 1)
    else:
        start = dt.datetime.strptime(start, '%Y-%m-%d')
    
    if end == '':
        end = dt.date.today()
    else:
        end = dt.datetime.strptime(end, '%Y-%m-%d')
    
    stock = pd.DataFrame()
    for i in range(0, 10):
        try:
            stock = web.YahooDailyReader(stockCode, start, end, adjust_price=True).read()
        except:
            print("%s not collected (%d)" % (stockCode, i + 1))
            
        if not stock.empty:
            break
        
    if stock.empty:
        print("%s not collected" % stockCode)
    
    # 수정주가 비율은 이미 적용되었으므로 제거한다
    stock = stock.drop('Adj_Ratio', 1)
    
    # Volume이 0 인 경우가 있으므로, 이를 제거한다 
    stock = stock.drop(stock[stock.Volume < 10].index)
    return stock
    