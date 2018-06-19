Attribute VB_Name = "Module1"
Option Base 1


Sub ELS()
    
    S0 = Range("b1").Value: vol = Range("b2").Value
    r = Range("b3").Value: T = Range("b4").Value
    X = Range("b5").Value: cpn = Range("b6").Value
    KI = Range("b7").Value: n_sim = Range("b8").Value
    
    
    dt = 1 / 252
    N = 252 * T         '총 날짜수
    
    Dim S(), C(), N_exer() As Double
    ReDim S(N)
    ReDim C(n_sim)
    ReDim N_exer(8)
    
    For i = 1 To n_sim
    
        ko = 0  '조기상환 여부를 check 변수
        j = 0   'j번째 날짜를 의미하는 변수
        k = 1   'k번째 조기상환을 의미하는 변수
        
        Do While ko = 0 And j < N   '조기상환이 아직 안되고, 만기 전이면
            e = Application.NormSInv(Rnd)
            
            If j = 0 Then
                S(j + 1) = S0 * Exp((r - 0.5 * vol ^ 2) * dt + vol * Sqr(dt) * e)
            Else
                S(j + 1) = S(j) * Exp((r - 0.5 * vol ^ 2) * dt + vol * Sqr(dt) * e)
            End If
            j = j + 1
            '조기상환 체크
            If j = k * 126 Then
                If S(j) >= X Then    '조기상환 ok
                    C(i) = 10000 * (1 + cpn * k) * Exp(-r * 0.5 * k)
                    ko = 1
                    N_exer(k) = N_exer(k) + 1
                    
                End If
                k = k + 1
            End If
        Loop
        '마지막까지 조기상환이 충족이 안되었을때
        If j = N And ko = 0 Then
            S_min = Application.Min(S)
                If S_min < KI Then '원금손실조건 충족
                    C(i) = 10000 * S(N) / S0 * Exp(-r * T)
                    N_exer(8) = N_exer(8) + 1
                    
                Else
                    C(i) = 10000 * (1 + cpn * 6) * Exp(-r * T)
                    N_exer(7) = N_exer(7) + 1
                    
                    
                End If
        End If
    Next i
    
    ELS_value = Application.Average(C)
    Range("b9").Value = ELS_value
    
    For i = 1 To 8
        Cells(i, 5) = N_exer(i) / n_sim
    Next i
    
    
            
                
            
        
    
End Sub
