Attribute VB_Name = "Module3"
Function GARCH(data, alpha, beta, gamma, Vl)
    n = data.Rows.Count
    a = Application.Pi
    
    llf = 0 'log-likelyhood function
    vol = Sqr(data(n) ^ 2) '최초변동성(sigma_0)
    
    
    
    
    For i = n - 1 To 1 Step -1
        vol = Sqr(gamma * Vl + beta * vol ^ 2 + alpha * data(i + 1) ^ 2)
        
        llf = llf - Log(Sqr(2 * a) * vol) - 0.5 * (data(i) / vol) ^ 2
    Next i
    
    
    GARCH = llf
End Function


Sub GARCH_scenario()
    alpha = Range("L2").Value
    beta = Range("L3").Value
    gamma = Range("L4").Value
    Vl = Range("L5").Value
    
    vol = Range("D4").Value '최초 변동성 값
    
    
    For i = 1 To 2000
        r = Application.NormSInv(Rnd) * vol '수익률
        vol = Sqr(gamma * Vl + beta * vol ^ 2 + alpha * r ^ 2)
        Cells(i + 1, 14) = r
        
    Next i
End Sub
