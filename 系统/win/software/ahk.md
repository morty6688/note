```ahk
; 音量加减设置为Pause键和ScrollLock键
Pause::SendInput("{Volume_Down}")
ScrollLock::SendInput("{Volume_Up}")

; win键和方向键组合实现home键等效果
; #IfWinActive, ahk_exe Code.exe
<#Left::SendInput("{Home}")
<#Right::SendInput("{End}")
<#Up::SendInput("{PgUp}")
<#Down::SendInput("{PgDn}")
+<#Left::Send("{LShift down}{Home}")
+<#Right::Send("{LShift down}{End}")
+<#Up::Send("{LShift down}{PgUp}")
+<#Down::Send("{LShift down}{PgDn}")

; 禁用win键弹出开始菜单
; ~LWin::Send("{Bind}{vkE8}")

; 禁用ctrl+空格切换中文输入法
^Space::ControlSend("^{Space}", , "A")

; 禁用ctrl+,切换搜狗输入法
^,::ControlSend("^{,}", , "A")
^.::ControlSend("^{`.}", , "A")
```

