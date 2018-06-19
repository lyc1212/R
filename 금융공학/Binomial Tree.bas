Attribute VB_Name = "Module3"
Sub B_tree()
    S = Range("b1").Value: X = Range("b2").Value: vol = Range("b3").Value
    r = Range("b6").Value: T = Range("b7").Value: flag = Range("b9").Value
    N = Range("b11").Value
    Dim V() As Double: Dim St() As Double
    ReDim V(N, N): ReDim St(N, N)
    
    
    '주가 트리 구성
    
    dt = T / N: u = Exp(vol * Sqr(dt)): d = 1 / u
    p = (Exp(r * dt) - d) / (u - d) '위험중립확률
    For i = 0 To N
        For j = 0 To i
            St(i, j) = S * (u ^ j) * (d ^ (i - j))
        Next j
    Next i
    
    'Call/Put 에 따른 구분
    
    If flag = "Call" Then
        Y = 1
    Else
        Y = -1
    End If
    
    '옵션가치 계산
    
    '(1) 만기조건 (boundary condition)
    For j = 0 To N
        V(N, j) = Application.Max(Y * (St(N, j) - X), 0)
        
    Next j
    
    
    
    '(2) Backward induction
    For i = N - 1 To 0 Step -1
        For j = 0 To i
            V(i, j) = Exp(-r * dt) * (p * V(i + 1, j + 1) + (1 - p) * V(i + 1, j))
            V(i, j) = Application.Max(V(i, j), Y * (St(i, j) - X))
            
        Next j
    Next i
    
    Range("b14").Value = V(0, 0)
    
    
    
    
End Sub
