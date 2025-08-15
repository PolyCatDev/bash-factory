#HotIf WinActive("ahk_exe MirrorsEdge.exe")

XButton2:: {
    Click("Left")
    startTime := A_TickCount
    while (A_TickCount - startTime < 1000) { 
        Send(" ")
        Sleep(10)
    }
}

e:: {
    Click("Left")
    Sleep(300)
    Send("ee")
}


#HotIf  ; Ends context-sensitive hotkeys
