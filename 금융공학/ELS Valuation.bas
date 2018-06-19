Attribute VB_Name = "Module1"
Option Base 1


Sub ELS()
    
    S0 = Range("b1").Value: vol = Range("b2").Value
    r = Range("b3").Value: T = Range("b4").Value
    X = Range("b5").Value: cpn = Range("b6").Value
    KI = Range("b7").Value: n_sim = Range("b8").Value
    
    
    dt = 1 / 252
    N = 252 * T         '�� ��¥��
    
    Dim S(), C(), N_exer() As Double
    ReDim S(N)
    ReDim C(n_sim)
    ReDim N_exer(8)
    
    For i = 1 To n_sim
    
        ko = 0  '�����ȯ ���θ� check ����
        j = 0   'j��° ��¥�� �ǹ��ϴ� ����
        k = 1   'k��° �����ȯ�� �ǹ��ϴ� ����
        
        Do While ko = 0 And j < N   '�����ȯ�� ���� �ȵǰ�, ���� ���̸�
            e = Application.NormSInv(Rnd)
            
            If j = 0 Then
                S(j + 1) = S0 * Exp((r - 0.5 * vol ^ 2) * dt + vol * Sqr(dt) * e)
            Else
                S(j + 1) = S(j) * Exp((r - 0.5 * vol ^ 2) * dt + vol * Sqr(dt) * e)
            End If
            j = j + 1
            '�����ȯ üũ
            If j = k * 126 Then
                If S(j) >= X Then    '�����ȯ ok
                    C(i) = 10000 * (1 + cpn * k) * Exp(-r * 0.5 * k)
                    ko = 1
                    N_exer(k) = N_exer(k) + 1
                    
                End If
                k = k + 1
            End If
        Loop
        '���������� �����ȯ�� ������ �ȵǾ�����
        If j = N And ko = 0 Then
            S_min = Application.Min(S)
                If S_min < KI Then '���ݼս����� ����
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
