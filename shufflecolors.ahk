#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent start


offsetOdd := 28
offsetEven := 24
offsetColorPicker := 22

; main shuffle colors
shuffleColors := Object()
shuffleColors[0, 0] := ["river", 2]
shuffleColors[0, 1] := ["winter ice", 1]
shuffleColors[0, 2] := ["demure", 1]
shuffleColors[0, 3] := ["daffodil", 1]
shuffleColors[0, 4] := ["maroon", 1]

shuffleColors[1, 0] := ["spitfire", 1]
shuffleColors[1, 1] := ["orange spring", 1]
shuffleColors[1, 2] := ["demure", 1]
shuffleColors[1, 3] := ["daffodil", 1]
shuffleColors[1, 4] := ["maroon", 1]

shuffleColors[2, 0] := ["pastel rose", 1]
shuffleColors[2, 1] := ["heather", 1]
shuffleColors[2, 2] := ["fuchsia", 2]
shuffleColors[2, 3] := ["fog", 1]
shuffleColors[2, 4] := ["pastel peach", 1]

shuffleColors[3, 0] := ["envy", 1]
shuffleColors[3, 1] := ["ebony", 1]
shuffleColors[3, 2] := ["white gold", 1]
shuffleColors[3, 3] := ["iron", 1]
shuffleColors[3, 4] := ["royal purple", 1]

shuffleColors[4, 0] := ["orchid", 1]
shuffleColors[4, 1] := ["shylac", 1]
shuffleColors[4, 2] := ["celestial", 1]
shuffleColors[4, 3] := ["strawberry cream", 1]
shuffleColors[4, 4] := ["royal rose", 1]


; main shuffle layout
shuffleLayout := Object()
;river
shuffleLayout[0, 0] := [5, 1]
shuffleLayout[0, 1] := [8, 1]
shuffleLayout[0, 2] := [8, 2]
shuffleLayout[0, 3] := [9, 1]
;winter ice
shuffleLayout[1, 0] := [1, 1]
shuffleLayout[1, 1] := [3, 1]
shuffleLayout[1, 2] := [7, 1]
shuffleLayout[1, 3] := [11, 1]
;demure
shuffleLayout[2, 0] := [2, 2]
shuffleLayout[2, 1] := [4, 2]
;daffodil
shuffleLayout[3, 0] := [2, 1]
shuffleLayout[3, 1] := [4, 1]
shuffleLayout[3, 2] := [6, 2]
shuffleLayout[3, 3] := [10, 2]
shuffleLayout[3, 4] := [12, 2]
;maroon
shuffleLayout[4, 0] := [1, 2]
shuffleLayout[4, 1] := [3, 2]
shuffleLayout[4, 2] := [6, 1]
shuffleLayout[4, 3] := [10, 1]
shuffleLayout[4, 4] := [12, 1]


isSetUp := false
pickColors := false


#IfWinActive ahk_class ArenaNet_Dx_Window_Class
Numpad1::
    SetColors(0)
return

Numpad2::
    SetColors(1)
return

Numpad3::
    SetColors(2)
return

Numpad4::
    SetColors(3)
return

Numpad5::
    SetColors(4)
return


F9::
    if(!isSetUp)
    {
        return   
    }
    pickColors := true
return

F10::
    SetUpVariables()
    isSetUp := true
return


#IfWinActive


SetColors(num)
{
    global
    if(!pickColors)
    {
        return
    }
    
    local colorSet := shuffleColors[num]
    for i, col in colorSet
    {        
        PickColor(col)
        
        ColorArmor(shuffleLayout[i])
    }
    
    pickColors := false
}

ColorArmor(layout)
{
    ;global
    
    for i, position in layout
    {
        SetColor(position[1], position[2])
        sleep 10
    }
}

PickColor(col)
{
    global
    local mouseX := colorX + (offsetColorPicker * (col[2] - 1))
    local colName := col[1]
    Click %searchX%, %searchY%
    sleep 50
    ; workaround because ^a does not work ingame
    Send {Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}
    sleep 50
    Send %colName%
    sleep 100
    Click %mouseX%, %colorY%
    sleep 100
}

SetColor(row, column)
{
    global
    
    ; boxes start from 0
    local boxNum := Ceil(row/2) - 1
    
    local evens := 0
    local odds := 0
    
    Loop %row%
    {
        if(IsEven(a_index))
        {
            evens++
        }
        else
        {
            odds++
        }
    }
    
    local moveX := itemX + offsetEven * (column - 1)
    local moveY := (itemY + offsetOdd * odds + offsetEven * evens) -  offsetEven
    MouseMove moveX, moveY
    sleep 10
    Click
    sleep 10
}

IsEven(num)
{
    return ((num & 1) == 0)
}

SetUpVariables()
{
    global
    MsgBox Hover over the search box
    MouseGetPos searchX, searchY
    Click
    sleep 100
    ; workaround because ^a does not work ingame
    Send {Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Backspace}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}{Del}
    sleep 100
    Send celestial
    MsgBox Now hover over the celestial color
    MouseGetPos colorX, colorY
    MsgBox And for the last, hover over the top left head item color slot
    MouseGetPos itemX, itemY
}


; debug stuff
;;river
;shuffleLayout[0, 0] := [1, 1]
;shuffleLayout[0, 1] := [2, 1]
;shuffleLayout[0, 2] := [3, 1]
;shuffleLayout[0, 3] := [4, 1]
;;winter ice
;shuffleLayout[1, 0] := [5, 1]
;shuffleLayout[1, 1] := [6, 1]
;shuffleLayout[1, 2] := [7, 1]
;shuffleLayout[1, 3] := [8, 1]
;;demure
;shuffleLayout[2, 0] := [9, 1]
;shuffleLayout[2, 1] := [10, 1]
;;daffodil
;shuffleLayout[3, 0] := [11, 1]
;shuffleLayout[3, 1] := [12, 1]
;shuffleLayout[3, 2] := [1, 2]
;shuffleLayout[3, 3] := [2, 2]
;shuffleLayout[3, 4] := [3, 2]
;;maroon
;shuffleLayout[4, 0] := [4, 2]
;shuffleLayout[4, 1] := [5, 2]
;shuffleLayout[4, 2] := [6, 2]
;shuffleLayout[4, 3] := [7, 2]
;shuffleLayout[4, 4] := [8, 2]