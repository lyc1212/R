Attribute VB_Name = "Module1"
Option Base 1



Sub Delta_portfolioHedge()
    S0 = 243.31: XP = 230: XC = 256: r = 0.0161: T = 1 / 12: vol = 0.128
    n_sim = 1000: opt_volume = 100
    N = Application.Round(T * 252, 0)
    dt = T / N
    mu = 0.12
    
    
    
    Dim S() As Double
    Dim delta() As Double
    Dim reb() As Double
    Dim B() As Double
    Dim cost() As Double
    Dim HC() As Double
    Dim TC() As Double
    
    ReDim S(N + 1): ReDim delta(N + 1): ReDim reb(N + 1)
    ReDim B(N + 1): ReDim cost(N + 1): ReDim HC(n_sim): ReDim HE(n_sim): ReDim TC(N + 1)
    
    
    
    BS_Portfolio = BSC(S0, XC, r, T, vol, "Call") * opt_volume - BSP(S0, XP, r, T, vol, "PUT") * opt_volume
    
    tc_rate = 0.003
    
    
    
    For i = 1 To n_sim
       
        
        S(1) = S0: delta(1) = -BS_deltaC(S0, XC, r, T, vol, "Call") * opt_volume + BS_deltaP(S0, XP, r, T, vol, "PUT") * opt_volume
        
        reb(1) = delta(1) * S0: cost(1) = reb(1): B(1) = 0: TC(1) = reb(1) * tc_rate
        
        
            
             For j = 2 To N + 1
            e = Application.NormSInv(Rnd)
            S(j) = S(j - 1) * Exp((mu - 0.5 * vol ^ 2) * dt + vol * Sqr(dt) * e)
        
           
            delta(j) = -BS_deltaC(S(j), XC, r, T - (j - 1) * dt, vol, "Call") * opt_volume + BS_deltaP(S(j), XP, r, T - (j - 1) * dt, vol, "PUT") * opt_volume
        
           
            reb(j) = (delta(j) - delta(j - 1)) * S(j)
            
            B(j) = cost(j - 1) * (Exp(r * dt) - 1)
           
            TC(j) = reb(j) * tc_rate
           
            cost(j) = cost(j - 1) + reb(j) + B(j) + TC(j)
            
            Next j
      
        option_payoff = Application.Max(S(N + 1) - XC, 0) * opt_volume - Application.Max(XP - S(N + 1), 0) * opt_volume
       
        HC(i) = option_payoff + cost(N + 1) - delta(N + 1) * S(N + 1)
        HC(i) = HC(i) * Exp(-r * T)
        '
        HE(i) = BS_Portfolio - HC(i)
        
        Cells(i, 3) = HE(i) / BS_Portfolio
        
        
        
    Next i
    
    Range("A1").Value = BS_Portfolio
    Range("A2").Value = Application.Average(HE)
    Range("A3").Value = Application.StDev(HE)
    
    
        
        
    
         
        
        
    
    
    
    
End Sub

Function BSC(S, XC, r, T, vol, flag)
    
    d1 = (Log(S / XC) + (r + 0.5 * vol ^ 2) * T) / (vol * Sqr(T))
    d2 = d1 - vol * Sqr(T)
    Nd1 = Application.NormSDist(d1)
    Nd2 = Application.NormSDist(d2)
    
    C = S * Nd1 - XC * Exp(-r * T) * Nd2
    
        If flag = "Call" Then
            BSC = C
            
        Else
            BSC = C + XC * Exp(-r * T) - S
            
        End If
        
End Function

Function BSP(S, XP, r, T, vol, flag)
    
    d1 = (Log(S / XP) + (r + 0.5 * vol ^ 2) * T) / (vol * Sqr(T))
    d2 = d1 - vol * Sqr(T)
    Nd1 = Application.NormSDist(d1)
    Nd2 = Application.NormSDist(d2)
    
    C = S * Nd1 - XP * Exp(-r * T) * Nd2
    
        If flag = "Call" Then
            BSP = C
            
        Else
            BSP = C + XP * Exp(-r * T) - S
            
        End If
        
End Function


Function BS_deltaC(S, XC, r, T, vol, flag)

If T > 0 Then
     d1 = (Log(S / XC) + (r + 0.5 * vol ^ 2) * T) / (vol * Sqr(T))
     
     If flag = "Call" Then
        BS_deltaC = Application.NormSDist(d1)
     Else
        BS_deltaC = Application.NormSDist(d1) - 1
     End If
     
Else
    If flag = "Call" Then
        If S > X Then
            BS_deltaC = 1
        Else
            BS_deltaC = 0
        End If
    Else
        If S > X Then
            BS_deltaC = 0
        Else
            BS_deltaC = -1
        End If
    End If
End If



        
    
End Function

Function BS_deltaP(S, XP, r, T, vol, flag)

If T > 0 Then
     d1 = (Log(S / XP) + (r + 0.5 * vol ^ 2) * T) / (vol * Sqr(T))
     
     If flag = "Call" Then
        BS_deltaP = Application.NormSDist(d1)
     Else
        BS_deltaP = Application.NormSDist(d1) - 1
     End If
     
Else
    If flag = "Call" Then
        If S > XP Then
            BS_deltaP = 1
        Else
            BS_deltaP = 0
        End If
    Else
        If S > XP Then
            BS_deltaP = 0
        Else
            BS_deltaP = -1
        End If
    End If
End If



        
    
End Function
