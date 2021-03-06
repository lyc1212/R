# minimize [x1 * x4 * (x1 + x2 + x3) + x3]
# s.t. x1 * x2 * x3 * x4 >= 25
#      x1^2 + x2^2 + x3^2 + x4^2 = 40
#      1 <= x1, x2, x3, x4 <= 5
#      x0 = [1, 5, 5, 5]
# reference : https://www.youtube.com/watch?v=cXHvC_FGx24
# -------------------------------------------------------
import scipy.optimize as optimize

def objective(x):
    x1 = x[0]
    x2 = x[1]
    x3 = x[2]
    x4 = x[3]
    
    return x1 * x4 * (x1 + x2 + x3) + x3

def constraint1(x):
    return x[0] * x[1] * x[2] * x[3] - 25.0

def constraint2(x):
    sum_sq = 0
    for i in range(4):
        sum_sq += x[i] ** 2
    return sum_sq - 40

x0 = [1, 5, 5, 1]
print(objective(x0))

b = (1.0, 5.0)
bnds = (b, b, b, b)
con1 = {'type' : 'ineq', 'fun' : constraint1}
con2 = {'type' : 'eq', 'fun' : constraint2}
cons = [con1, con2]

sol = optimize.minimize(objective, x0, method='SLSQP', bounds=bnds, constraints=cons)

print()
print("x1 = %.2f" % sol.x[0])
print("x2 = %.2f" % sol.x[1])
print("x3 = %.2f" % sol.x[2])
print("x4 = %.2f" % sol.x[3])
print("Objective의 최솟값 = %.2f" % sol.fun)
