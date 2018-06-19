Attribute VB_Name = "Module4"
Function BS_Price(S, X, r, T, vol, flag)
    
    d1 = (Log(S / X) + (r + 0.5 * vol ^ 2) * T) / (vol * Sqr(T))
    d2 = d1 - vol * Sqr(T)
    Nd1 = Application.NormSDist(d1)
    Nd2 = Application.NormSDist(d2)
    
    C = S * Nd1 - X * Exp(-r * T) * Nd2
    
        If flag = "Call" Then
            BS_Price = C
            
        Else
            BS_Price = C + X * Exp(-r * T) - S
            
        End If
        
End Function


Sub IV_calc()


    
    solverreset
    For rownum = 3 To 23
       solverok "K" & rownum, 3, 0, "I" & rownum
        solversolve (True)
        solverreset
        solverfinish
    Next rownum
    
'solverok "K3", 3, 0, "I3"
'solversolve (True)

End Sub
