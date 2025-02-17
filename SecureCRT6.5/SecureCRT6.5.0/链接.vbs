#$language = "VBScript" 
#$interface = "1.0" 
Option Explicit 
Function mysubstring(srcString,bChar,eChar) 
    Dim fIndex,sIndex     
    fIndex=InStr(srcString,bChar) 
      sIndex=InStrRev(srcString,eChar) 
      mysubstring=Mid(srcString,fIndex+1,sIndex-fIndex-1)       
End Function 
'用来得到一个时间字符串，该字符串用来设置路由器的时间和日期 
Function ciscoDate() 
      dim      em, y,m,d,h 
      Dim nowDate 
      nowDate=Now() 
      em=Array 
("January","February","March","April","May","June","July","August","September","October"
,"November","December") 
 
      y=Year(nowDate)     
      m=em(Month(nowDate)-1) 
      d=Day(nowDate)     
      h=Time() 
    ciscoDate=h & " " & m & " " & d & " " & y 
     
End Function 
Sub main 
      On Error Resume Next 
       
      crt.Screen.Synchronous = True 
      crt.Screen.WaitForString "Console port" 
      crt.Screen.Send    VbCr 
       
      '得到第一行显示文本，主要从中提取设备名称 
      Dim firstLine 
      '用来存储标签的标题，也就是设备的名称 
      Dim tabTitle 
      firstLine=crt.Screen.Get2(1,1,1,100) '得到第一行文本 
      tabTitle=mysubstring(firstLine,"""","""")  '调用方法取两个双引号之间的文
本 
      crt.Window.Caption= tabTitle 
       
      'Dim result 
      'result = crt.screen.WaitForStrings("'yes' or 'no'", "[yes/no]:", "RETURN") 
      'If result = 1 Then 
      '    crt.Screen.Send VbCr 
      'ElseIf result = 2 Then 
      '    crt.Screen.Send "no" & VbCr 
      'ElseIf result = 3 Then 
      '    crt.Screen.Send VbCr       
      'Else 
      ' crt.Screen.Send VbCr 
      'End If 
      If crt.Screen.WaitForString("[yes/no]") Then         
          crt.Screen.Send "no" & VbCr 
      End If 
      crt.Screen.Send VbCr &VbCr 
      crt.Screen.WaitForString "Router>"       
      crt.Screen.Send    "enable" & VbCr 
      crt.Screen.Send "conf terminal" & VbCr 
      crt.Screen.Send "no ip domain-lookup " & VbCr 
      crt.Screen.Send "hostname " & tabTitle & VbCr 
      crt.Screen.Send "line con 0" & VbCr       crt.Screen.Send "exec-timeout 0 0" & VbCr       
      crt.Screen.Send "logging synchronous" & VbCr             
      crt.Screen.Send "end" & VbCr 
       
    crt.Screen.Send "clock set " & ciscoDate() & VbCr     
      crt.Screen.Synchronous = False 
     
End Sub 