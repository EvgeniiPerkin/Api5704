Attribute VB_Name = "RequestModule"
Option Explicit

'��������: 2024-06-27

'������ ������� API
Const CURR_API As String = "1.2"
Const NEXT_API As String = "1.3"
Const NEXT_DATE As Date = #7/10/2024# 'M/DD/YYYY (en-us)

'����� ��� ���������� ��������
Const OUTPUT_PATH As String = "C:\TEMP"

'���
Const INN As String = "7831001422"

'����
Const OGRN As String = "1027800000095"

'�������������������
Const KVP As String = "3"

'��������������������
Const PRRF As String = "1"

'������������������
Const BANK As String = "����������� �������� ""���� ������ ����"""

'�����������������������
Const BNK As String = "�� ""���� ������ ����"""

Public Sub CreateDlRequest()
    Dim XDoc As Object, xmlVersion As Object, root As Object
    Dim abonent As Object, person As Object, elem As Object
    Dim request As Object, src As Object, doc As Object
    Dim I As Integer
    
    I = 2
    '--������--
    
    '�������������
    Dim iz As String: iz = Cells(ActiveCell.Row, I).Text
    If Len(iz) = 0 Then
        iz = CreateGuidStr()
        Cells(ActiveCell.Row, I) = iz
    End If
    I = I + 1

    '����
    Dim dz As String: dz = Cells(ActiveCell.Row, I).Text
    If Len(dz) = 0 Then
        dz = Format(Now, "yyyy-MM-dd")
        Cells(ActiveCell.Row, I) = Now
    Else
        dz = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd")
    End If
    I = I + 1
    
    '����
    Dim cz As String: cz = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�������� ���� ���� (99)
    Dim ocz As String: ocz = Cells(ActiveCell.Row, I).Text: I = I + 1
    '������
    Dim vz As String: vz = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����
    Dim sz As String: sz = Replace(Cells(ActiveCell.Row, I).Text, " ", ""): I = I + 1
    
    '--�������--
    
    '�������
    Dim fioF As String: fioF = Cells(ActiveCell.Row, I).Text: I = I + 1
    '���
    Dim fioI As String: fioI = Cells(ActiveCell.Row, I).Text: I = I + 1
    '��������
    Dim fioO As String: fioO = Cells(ActiveCell.Row, I).Text: I = I + 1
    
    '�������2
    Dim fio2F As String: fio2F = Cells(ActiveCell.Row, I).Text: I = I + 1
    '���2
    Dim fio2I As String: fio2I = Cells(ActiveCell.Row, I).Text: I = I + 1
    '��������2
    Dim fio2O As String: fio2O = Cells(ActiveCell.Row, I).Text: I = I + 1
    
    '���� ��������
    Dim dr As String: dr = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd"): I = I + 1
    
    '��������
    Dim id As String: id = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����
    Dim sd As String: sd = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����
    Dim nd As String: nd = Cells(ActiveCell.Row, I).Text: I = I + 1
    '���� ������
    Dim vd As String: vd = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd"): I = I + 1
    
    '��������2
    Dim id2 As String: id2 = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����2
    Dim sd2 As String: sd2 = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����2
    Dim nd2 As String: nd2 = Cells(ActiveCell.Row, I).Text: I = I + 1
    '���� ������2
    Dim vd2 As String: vd2 = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd"): I = I + 1
    
    '���
    Dim inn2 As String: inn2 = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�����
    Dim snils2 As String: snils2 = SnilsFormatter(Cells(ActiveCell.Row, I).Text): I = I + 1
    
    '--��������--
    
    '������
    Dim ds As String: ds = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd"): I = I + 1
    '����
    Dim ss As String: ss = Cells(ActiveCell.Row, I).Text: I = I + 1
    
    '��������� 'TODO?? (� ��� ��� ���������� ��������?)
    'Dim os As String: os = Cells(ActiveCell.Row, i).Text: i = i + 1
    
    '������ �����
    Dim cs As String: cs = Cells(ActiveCell.Row, I).Text: I = I + 1
    '�������� ���� ���� (99)
    Dim ocs As String: ocs = Cells(ActiveCell.Row, I).Text: I = I + 1
    '������� ���� ���� 3
    Dim dog As String: dog = Format(Cells(ActiveCell.Row, I), "yyyy-MM-dd"): I = I + 1
    '������: "C:\Program Files (x86)\Crypto Pro\CSP\cpverify.exe" -mk -alg GR3411_2012_256 file.pdf
    Dim Hash As String: Hash = HashFormatter(Cells(ActiveCell.Row, I).Text): I = I + 1
    
    '--XML--
    
    Set XDoc = CreateObject("MSXML2.DOMDocument")
    Set xmlVersion = XDoc.createProcessingInstruction("xml", "version=""1.0"" encoding=""UTF-8""")
    XDoc.appendChild xmlVersion

    '�����������������������
    Set root = XDoc.createElement("�����������������������")
    XDoc.appendChild root
    root.SetAttribute "������", IIf(Now < NEXT_DATE, CURR_API, NEXT_API)
    root.SetAttribute "��������������������", iz
    
    '1 � ������� ����������� �������� ������ � �������������� ��� (�� 01.07.2024);
    '2 � ������� ����������� �������� ���� ��� ����� ��������� � ���� ���� (����� ����� ����).
    root.SetAttribute "����������", "2"
    
    '�������
    Set abonent = XDoc.createElement("�������")
    
        '���������������
        Set person = XDoc.createElement("���������������")
    
            '���
            Set elem = XDoc.createElement("���")
            elem.Text = INN 'const
            person.appendChild elem
    
            '����
            Set elem = XDoc.createElement("����")
            elem.Text = OGRN 'const
            person.appendChild elem
    
        '/���������������
        abonent.appendChild person
        
    '/�������
    root.appendChild abonent
    
    '������
    Set request = XDoc.createElement("������")
    
        '��������
        Set src = XDoc.createElement("��������")
        
            '���������������
            Set person = XDoc.createElement("���������������")
            person.SetAttribute "�������������������", KVP
            person.SetAttribute "��������������������", PRRF
    
                '���
                Set elem = XDoc.createElement("���")
                elem.Text = INN 'const
                person.appendChild elem
    
                '����
                Set elem = XDoc.createElement("����")
                elem.Text = OGRN 'const
                person.appendChild elem
    
                '������������������
                Set elem = XDoc.createElement("������������������")
                elem.Text = BANK 'const
                person.appendChild elem
    
                '�����������������������
                Set elem = XDoc.createElement("�����������������������")
                elem.Text = BNK 'const
                person.appendChild elem
    
            '/���������������
            src.appendChild person
            
        '/��������
        request.appendChild src
    
        '�������
        Set abonent = XDoc.createElement("�������")
            '���
            Set person = XDoc.createElement("���")
    
                '�������
                Set elem = XDoc.createElement("�������")
                elem.Text = fioF
                person.appendChild elem
    
                '���
                Set elem = XDoc.createElement("���")
                elem.Text = fioI
                person.appendChild elem
    
                If Len(fioO) > 0 Then 'optional
                    '��������
                    Set elem = XDoc.createElement("��������")
                    elem.Text = fioO
                    person.appendChild elem
                End If
    
            '/���
            abonent.appendChild person
    
            If Len(fio2F) + Len(fio2I) + Len(fio2O) > 0 Then 'optional
                '��� ����������
                Set person = XDoc.createElement("���")
                
                    '�������
                    Set elem = XDoc.createElement("�������")
                    elem.Text = fio2F
                    person.appendChild elem
        
                    '���
                    Set elem = XDoc.createElement("���")
                    elem.Text = fio2I
                    person.appendChild elem
        
                    If Len(fio2O) > 0 Then 'optional
                        '��������
                        Set elem = XDoc.createElement("��������")
                        elem.Text = fio2O
                        person.appendChild elem
                    End If
        
                '/��� ����������
                abonent.appendChild person
            End If
    
            '������������
            Set elem = XDoc.createElement("������������")
            elem.Text = dr
            abonent.appendChild elem
    
            '����������������
            Set doc = XDoc.createElement("����������������")
            
            '������:
            '14 ���� ��������, ���������� �������������� ������� (??)
            '21 ������� ���������� ���������� ���������
            '22.1 ������� ���������� ���������� ���������, �������������� ��� ��������
            '�� ��������� ���������� ���������� ���������
            '22.2 ��������������� �������, �������������� �������� ����������
            '���������� ��������� �� ��������� ���������� ���������� ���������
            '22.3 ��������� �������, �������������� �������� ���������� ����������
            '��������� �� ��������� ���������� ���������� ���������
            '23 ������������� �������� ������
            '24 ������������� �������� ���������������
            '25 ������� ����� ���������������
            '26 ��������� ������������� �������� ���������� ���������� ���������,
            '���������� �� ������ ���������� �������� ���������� ���������� ���������
            '27 ������������� � �������� ���������� ���������� ���������
            '28 ���� ��� ���������� ���������� ��������� � ������������ �
            '����������������� ���������� ���������
            '31 ������� ������������ ���������� ���� ���� ��������, �������������
            '����������� ������� ��� ������������ � ������������ � �������������
            '��������� ���������� ��������� � �������� ���������, ���������������
            '�������� ������������ ����������
            '32 ��������, �������� ����������� ������������ � ������������ �
            '������������ � ������������� ��������� ���������� ��������� � ��������
            '���������, ��������������� �������� ���� ��� �����������
            '35 ���� ��������, ������������ ����������, �������������� �������� ����
            '��� ����������� � ������������ � ����������������� ���������� ��������� �
            '������������� ��������� ���������� ���������
            '37 ������������� �������
            '38 ������������� ������������ �����������
            '999 ���� ��������
            doc.SetAttribute "������", id
            
                If Len(sd) > 0 Then 'optional
                    '�����
                    Set elem = XDoc.createElement("�����")
                    elem.Text = sd
                    doc.appendChild elem
                End If
                
                '�����
                Set elem = XDoc.createElement("�����")
                elem.Text = nd
                doc.appendChild elem
                
                '����������
                Set elem = XDoc.createElement("����������")
                elem.Text = vd
                doc.appendChild elem
            
                '�����������
                Set elem = XDoc.createElement("�����������")
                elem.Text = "643" 'TODO
                doc.appendChild elem
            
            '/����������������
            abonent.appendChild doc
            
            If Len(id2) + Len(sd2) + Len(nd2) + Len(vd2) > 0 Then 'optional
                '���������������� ����������
                Set doc = XDoc.createElement("����������������")
                doc.SetAttribute "������", id2
                
                    If Len(sd2) > 0 Then 'optional
                        '�����
                        Set elem = XDoc.createElement("�����")
                        elem.Text = sd2
                        doc.appendChild elem
                    End If
                    
                    '�����
                    Set elem = XDoc.createElement("�����")
                    elem.Text = nd2
                    doc.appendChild elem
                    
                    '����������
                    Set elem = XDoc.createElement("����������")
                    elem.Text = vd2
                    doc.appendChild elem
                
                '/���������������� ����������
                abonent.appendChild doc
            End If
    
            If Len(inn2) > 0 Then 'optional
                '���
                Set elem = XDoc.createElement("���")
                elem.Text = inn2
                abonent.appendChild elem
            End If
    
            If Len(snils2) > 0 Then 'optional
                '�����
                Set elem = XDoc.createElement("�����")
                elem.Text = snils2
                abonent.appendChild elem
            End If
    
        '/�������
        request.appendChild abonent
    
        '��������
        Set doc = XDoc.createElement("��������")
        doc.SetAttribute "����������", ds
        
        '������������:
        '1 �������� ������������� � ������� ����� ������� �� ��� ��� ����������
        '2 �������� ������������� � ������� ���� �� ��� ��� ����������
        '3 � ������� ����� �������� �������� � ��������� ��������� ������� ����
        '��������� ������� ����� (�������), ������� �������, ������� ������, �������
        '��������������, ������ ����������� ��������
        doc.SetAttribute "������������", ss
        
        '��������� �������� � ������ ������� �������� � ������������
        '��������� �������, ������������� �������� � �������������� �������� ��������,
        '�� �������� � ����� ������� ����� ��������� �������� ��������:
        '1 �������� �������� �������� �������������� �� ������������ ��������
        '����� (�������) ��� ����� ��������, ���������� �� �������������� ��
        '������� ���������� � ���
        '2 �������� �������� �������� ��������� �����������, ��������������
        '������������ �������� ���������� �� �������� ����� (�������),
        '����������� ������������������� ����������� �������� ��� ���������� ������
        'doc.setAttribute "�����������������", os 'TODO??
        
        '������������� ������������ �������� � ���������������� �� ����������
        '�������� �� ��������� � (���) ��������������� ����������, ������������ ���������
        '�������, ���������� ��������� ���������� ������, ��������������� �������� 5.53 � 14.29
        '������� ���������� ��������� �� ���������������� ���������������
        doc.SetAttribute "�����������������������������", "1" 'const
        
            '������
            Set src = XDoc.createElement("������")
            
                '���������������
                Set person = XDoc.createElement("���������������")
                
                    '���
                    Set elem = XDoc.createElement("���")
                    elem.Text = INN 'const
                    person.appendChild elem
                    
                    '����
                    Set elem = XDoc.createElement("����")
                    elem.Text = OGRN 'const
                    person.appendChild elem
                    
                    '������������������
                    Set elem = XDoc.createElement("������������������")
                    elem.Text = BANK 'const
                    person.appendChild elem
                
                '/���������������
                src.appendChild person
                
            '/������
            doc.appendChild src
        
            '���� ��������:
            '���� ����� ������ �������� ��������� ������������ ��������� �������:
            
            '���������� �������� � ������������:
            '1 ��������������� ���� (������) �� ������������ ����������
            '2 ��������������� ���������
            '3 ��������������� ���� (������) ���������
            '4 ��������������� ���� (������) � ��������� ������� (��������� �����, ���������)
            '5 ���� ��������������� ���� (������)
            '6 �������������� ����������-�����������
            '7 �������, ��������������� �����������-������������
            '8 ���� �����, ��������������� �����������-������������
            '9 ���� ��������������� �������
            
            '���������� ������, �� ����������� �������� � ������������:
            '10 ���� (������) �� �������� �������
            '11 ���� (������) �� ���������� ��������� �������
            '12 ���� (������) �� ������� ������������
            '13 ���� (������) �� �������������
            '14 ���� (������) �� ������������ ������ �����
            '15 ���� ���� (������)
            '16 ������
            '17 ����������� ��������
            '18 ��������������
            '19 �����������
            '20 �������
            '21 ���� �����
            '22 ���� �������
            
            '���� ���� ������ �������� ���������:
            '23 ��������� ���������� � ������ ������������ ��������
            '24 ����� �� ������
            '25 ������������� ������������
            '26 ������� ������������
            '27 �������� ������
            '99 ���� (��������� ��������� ���� ��������)
            
            Dim A() As String: A = Split(cs, ",")

            For I = LBound(A) To UBound(A)
                Set elem = XDoc.createElement("����")
                doc.appendChild elem
                elem.SetAttribute "�������", A(I)
                
                If A(I) = "99" Then elem.SetAttribute "��������", ocs
            Next
        
            '�������
            If ss = "3" Then '������������ = 3
                Set elem = XDoc.createElement("�������")
                doc.appendChild elem
                elem.SetAttribute "����", dog
            End If
        
            '������ ��� �������� ��������, ���������������
            '��������� ����� ������ �� 11 ��� 2021 ���� � 5791-� �� ����������� � ������� � �������
            '������� � �������������� ���������� ������, �������� ������ ���� ��������� �������
            '���������� � �������� ��������� ������� � ����� ������������� ������� ��������
            '�������� ��������� �������, ������������������ ������������� ������� ����������
            '��������� 15 ���� 2021 ���� � 63883.
            Set elem = XDoc.createElement("������")
            elem.Text = Hash
            doc.appendChild elem
        
        '/��������
        request.appendChild doc
    
        '���� �������
        Set elem = XDoc.createElement("����")
        request.appendChild elem
        elem.SetAttribute "�������", cz
        If cz = "99" Then elem.SetAttribute "��������", ocz
        
        If Len(sz) > 0 Then
            '������������������
            Set elem = XDoc.createElement("������������������")
            elem.Text = sz
            request.appendChild elem
            elem.SetAttribute "������", vz
        End If
        
    '/������
    root.appendChild request
    request.SetAttribute "����", dz
    
    '/�����������������������
    Dim File As String: File = NameFile(fioF, fioI, fioO, dz, iz)
    XDoc.Save File
    
    MsgBox "������ �������� � ���� " & File, , ActiveWorkbook.Name
End Sub

'�������.�.�.yyyy-mm-dd.guid.xml
Public Function NameFile(F As String, I As String, O As String, ymd As String, guid As String) As String
    NameFile = OUTPUT_PATH & "\" & F & "." & Left(I, 1) & "." & Left(O, 1) & "." & ymd & "." & guid & ".xml"
End Function

Public Function SnilsFormatter(s As String) As String
    s = Replace(s, " ", "")
    s = Replace(s, "-", "")
    SnilsFormatter = Left(s, 3) & "-" & Mid(s, 4, 3) & "-" & Mid(s, 7, 3) & " " & Right(s, 2)
End Function

Public Function HashFormatter(s As String) As String
    HashFormatter = LCase(s)
End Function

Public Sub SnilsFormat()
    ActiveCell.Value = SnilsFormatter(ActiveCell.Text)
End Sub

Public Sub HashFormat()
    ActiveCell.Value = HashFormatter(ActiveCell.Text)
End Sub
