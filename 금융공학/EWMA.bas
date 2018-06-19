Attribute VB_Name = "Module2"
Function EWMA(data, lambda)
    n = data.Rows.Count
    a = Application.Pi
    
    llf = 0 'log-likelyhood function
    vol = Sqr(data(n) ^ 2) '최초변동성(sigma_0)
    
    
    
    
    For i = n - 1 To 1 Step -1
        vol = Sqr(lambda * vol ^ 2 + (1 - lambda) * data(i + 1) ^ 2)
        
        llf = llf - Log(Sqr(2 * a) * vol) - 0.5 * (data(i) / vol) ^ 2
    Next i
    
    
    EWMA = llf
End Function



Sub EWMA_scenario()
    lambda = Range("F3").Value
    vol = Range("D4").Value '최초 변동성 값
    
    
    For i = 1 To 2000
        r = Application.NormSInv(Rnd) * vol '수익률
        vol = Sqr(lambda * vol ^ 2 + (1 - lambda) * r ^ 2)
        Cells(i + 1, 9) = r
        
    Next i
    
    
    
    
        
    
    
End Sub
