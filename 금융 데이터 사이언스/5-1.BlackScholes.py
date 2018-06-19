# 블랙-숄즈 옵션 가격 결정 모형 연습
# --------------------------------
import numpy as np
import scipy.stats as st
import matplotlib.pyplot as plt

# 블랙-숄즈 옵션 가격 결정 모형
def BlackScholes(S, K, r, s, T):
    
    d1 = (np.log(S/K) + (r + s**2 / 2) * T)/(s * np.sqrt(T))
    d2 = d1 - s * np.sqrt(T)
    
    nd1 = st.norm.cdf(d1)
    nd2 = st.norm.cdf(d2)
    
    call = S * nd1 - K * np.exp(-r * T) * nd2
    return call

S = 270.0
K = 277.5
T = 15 / 252
r = 0.02
s = 0.2

callPrice = BlackScholes(S, K, r, s, T)
print()
print("Call Price = ", callPrice)

# 잔존기간이 (T-t) 15일이고 S가 250 ~ 300 일 때의 옵션 가격 변화를 관찰한다.
callPrice15 = []
for S in np.arange(250, 300, 0.5):
    callPrice15.append(BlackScholes(S, K, r, s, T))

# 잔존기간이 (T-t) 3일이고 S가 250 ~ 300 일 때의 옵션 가격 변화를 관찰한다.
T = 3 / 252
callPrice3 = []
for S in np.arange(250, 300, 0.5):
    callPrice3.append(BlackScholes(S, K, r, s, T))
    
plt.figure(figsize=(8, 6))
ax = np.arange(250, 300, 0.5)
plt.plot(ax, callPrice15, label='T -t = 15 days')
plt.plot(ax, callPrice3, label='T -t = 3 days')
plt.axvline(x = K, linestyle='dashed', linewidth=1)
plt.xlabel('Underlying Asset Price (S)')
plt.ylabel('Call Option Price')
plt.legend()
plt.grid()
plt.show()
