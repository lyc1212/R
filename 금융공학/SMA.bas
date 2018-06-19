Attribute VB_Name = "Module1"
Function SMA(data, vol)
        
    n = data.Rows.Count
    a = Application.Pi
    
    llf = 0 'log-likelyhood function
    
    
    For i = 1 To n
        llf = llf - Log(Sqr(2 * a) * vol) - 0.5 * (data(i) / vol) ^ 2
    Next i
    
    
    SMA = llf
    
    
    
End Function


Sub SMA_Scenario()
    vol = Range("d4").Value
    For i = 1 To 2000
        r = Application.NormSInv(Rnd) * vol
        Cells(i + 1, 8) = r
    Next i
    
    
    
End Sub
