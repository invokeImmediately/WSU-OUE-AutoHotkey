; ============================================================================================================
; AUTOHOTKEY SCRIPT IMPORT for Working with Github Desktop for Windows
; ============================================================================================================
; IMPORT DEPENDENCIES
;   This file has no import dependencies.
; ============================================================================================================
; IMPORT ASSUMPTIONS
;   This file makes no import assumptions.
; ============================================================================================================
; AUTOHOTKEY SEND LEGEND
; ! = ALT     + = SHIFT     ^ = CONTROL     # = WIN
; (see https://autohotkey.com/docs/commands/Send.htm for more info)
; ============================================================================================================

; ------------------------------------------------------------------------------------------------------------
; General FUNCTIONS used for multiple purposes
; ------------------------------------------------------------------------------------------------------------

doesVarExist(ByRef v) { ; Requires 1.0.46+ 
    return &v = &undeclared ? 0 : 1 
}

isVarEmpty(ByRef v) { ; Requires 1.0.46+ 
    return v = "" ? 1 : 0 
}

isVarDeclared(ByRef v) { ; Requires 1.0.46+ 
    return &v = &undeclared ? 0 : v = "" ? 0 : 1
}

InsertFilePath(ahkCmdName, filePath) {
	AppendAhkCmd(ahkCmdName)
    if (UserFolderIsSet()) {
        if (IsGitShellActive()) {
            SendInput % "cd """ . filePath . """{Enter}"
        }
        else {
            SendInput % filePath . "{Enter}"
        }
    }
}

LaunchApplicationPatiently(path, title)
{
    Run % path
    isReady := false
    while !isReady
    {
        IfWinExist, % title
        {
            isReady := true
            Sleep, 500
        }
        else
        {
            Sleep, 250
        }
    }
}

LaunchStdApplicationPatiently(path, title)
{
	Run, % "explorer.exe """ . path . """"
    isReady := false
    while !isReady
    {
        IfWinExist, % title
        {
            isReady := true
            Sleep, 500
        }
        else
        {
            Sleep, 250
        }
    }
}

MoveCursorIntoActiveWindow(ByRef curPosX, ByRef curPosY)
{
	WinGetPos, winPosX, winPosY, winW, winH, A
	if (curPosX < 0) {
		curPosX := 50
	}
	else if(curPosX > winW - 100) {
		curPosX := winW - 100
	}
	if (curPosY < 0) {
		curPosY := 100
	}
	else if(curPosY > winH - 100) {
		curPosY := winH - 100
	}
}

PasteText(txtToPaste) {
	if (clipboard != txtToPaste) {
		clipboard := txtToPaste
	}
	Sleep, 60
	SendInput, % "^v"
}

WaitForApplicationPatiently(title)
{
    isReady := false
    while !isReady
    {
        IfWinExist, % title
        {
            isReady := true
            Sleep, 500
        }
        else
        {
            Sleep, 250
        }
    }
}

; ------------------------------------------------------------------------------------------------------------
; SORTING functions
; ------------------------------------------------------------------------------------------------------------

Merge(ByRef arrayObj, l, m, r) {
	arrayAux := Object()
	i := m + 1
	while (i > l) {
		arrayAux[i - 1] := arrayObj[i - 1]
		i--
	}
	j := m
	while (j < r) {
		arrayAux[r + m - j] := arrayObj[j + 1]
		j++
	}
	k := l
	while (k <= r) {
		if (arrayAux[j] < arrayAux[i]) {
			arrayObj[k] := arrayAux[j--]
		} else {
			arrayObj[k] := arrayAux[i++]
		}
		k++
	}
}

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

MergeSort(ByRef arrayObj, l, r) {
	if (r > l) {
		m := floor((r + l) / 2)
		MergeSort(arrayObj, l, m)
		MergeSort(arrayObj, m + 1, r)
		Merge(arrayObj, l, m, r)
	}
}

; ------------------------------------------------------------------------------------------------------------
; UTILITY FUNCTIONS: For working with AutoHotkey
; ------------------------------------------------------------------------------------------------------------

:*:@checkIsUnicode::
	AppendAhkCmd(":*:@checkIsUnicode")
	Msgbox % "v" . A_AhkVersion . " " . (A_PtrSize = 4 ? 32 : 64) . "-bit " . (A_IsUnicode ? "Unicode" : "ANSI") . " " . (A_IsAdmin ? "(Admin mode)" : "(Not Admin)")
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getCurrentVersion::
	MsgBox % "Current installed version of AHK: " . A_AhkVersion
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getLastHotStrTime::
	MsgBox % "The last hotstring took " . (hotStrEndTime - hotStrStartTime) . "ms to run."
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getMousePos::
	AppendAhkCmd(":*:@getMousePos")
	MouseGetPos, windowMousePosX, windowMousePosY
	MsgBox % "The mouse cursor is at {x = " . windowMousePosX . ", y = " . windowMousePosY . "} relative to the window."
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getWinHwnd::
	AppendAhkCmd(":*:@getWinHwnd")
	WinGet, thisHwnd, ID, A
	MsgBox, % "The active window ID (HWND) is " . thisHwnd
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getWinPID::
	AppendAhkCmd(":*:@getWinPID")
	WinGet, thisPID, PID, A
	MsgBox, % "The active window PID is " . thisPID
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getWinPos::
	AppendAhkCmd(":*:@getWinPos")
	WinGetPos, thisX, thisY, thisW, thisH, A
	MsgBox, % "The active window is at coordinates " . thisX . ", " . thisY . "`rWindow's width = " . thisW . ", height = " . thisH
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getWinProcess::
	AppendAhkCmd(":*:@getWinProcess")
	WinGet, thisProcess, ProcessName, A
	MsgBox, % "The active window process name is " . thisProcess
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

:*:@getWinTitle::
	AppendAhkCmd(":*:@getWinTitle")
	WinGetTitle, thisTitle, A
	MsgBox, The active window is "%thisTitle%"
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

^+F1::
^!Numpad1::
	clpbrdLngth := StrLen(clipboard)
	MsgBox % "The clipboard is " . clpbrdLngth . " characters long."
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

^+F2::
^!Numpad2::
	clpbrdLngth := StrLen(clipboard)
	SendInput, +{Right %clpbrdLngth%}
	Sleep, 20
	SendInput, ^v
Return

; ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---  ---

^!q::
	IfWinExist % "Untitled - Notepad"
		WinActivate % "Untitled - Notepad"
	else
		Run Notepad
Return

; ------------------------------------------------------------------------------------------------------------
; Desktop Management Functions
; ------------------------------------------------------------------------------------------------------------
GetActiveMonitorWorkArea(ByRef monitorFound, ByRef monitorALeft, ByRef monitorATop, ByRef monitorARight, ByRef monitorABottom) {
    global
	local thisWinX
	local thisWinY
	local thisWinW
	local thisWinH
	local thisMinMax

	monitorFound := false
	WinGet, thisMinMax, MinMax, A
	if (thisMinMax != 0) {
		WinRestore, A
		Sleep 60
	}
	WinGetPos, thisWinX, thisWinY, thisWinW, thisWinH, A
	Loop, %sysNumMonitors% {
		if (thisWinX >= mon%A_Index%Bounds_Left && thisWinY >= mon%A_Index%Bounds_Top && (thisWinX + thisWinW) <= mon%A_Index%Bounds_Right && (thisWinY + thisWinH) <= mon%A_Index%Bounds_Bottom) {
			monitorFound := true
			monitorALeft := mon%A_Index%WorkArea_Left
			monitorATop := mon%A_Index%WorkArea_Top
			monitorARight := mon%A_Index%WorkArea_Right
			monitorABottom := mon%A_Index%WorkArea_Bottom
			break
		}
	}
	if (monitorFound = false) {
		monitorALeft := 0
		monitorATop := 0
		monitorARight := 0
		monitorABottom := 0
		MsgBox, % "Monitor not found. Window coordinates:`r"
			. "`tLeft: " . thisWinX . "`r"
			. "`tTop: " . thisWinY . "`r"
			. "`tRight: " . (thisWinX + thisWinW) . "`r"
			. "`tBottom: " . (thisWinY + thisWinH) . "`r"
	}
}
