﻿; ==================================================================================================
; AUTOHOTKEY SCRIPT IMPORT for Working with Github Desktop for Windows
; ==================================================================================================
; IMPORT DEPENDENCIES
;   This file has no import dependencies.
; ==================================================================================================
; IMPORT ASSUMPTIONS
;   This file makes no import assumptions.
; ==================================================================================================
; AUTOHOTKEY SEND LEGEND
; ! = ALT     + = SHIFT     ^ = CONTROL     # = WIN
; (see https://autohotkey.com/docs/commands/Send.htm for more info)
; ==================================================================================================
; Table of Contents
; ------------------------------------------------------------------------------------------------
;   §1: Window state checks.....................................................................86
;     >>> §1.1: isTargetProcessActive...........................................................90
;     >>> §1.2: areTargetProcessActive.........................................................102
;   §2: Variable state checks..................................................................125
;     >>> §2.1: doesVarExist...................................................................129
;     >>> §2.2: isVarEmpty.....................................................................136
;     >>> §2.3: isVarDeclared..................................................................143
;   §3: Error reporting........................................................................150
;     >>> §3.1: ErrorBox.......................................................................154
;   §4: Operating system manipulation..........................................................161
;     >>> §4.1: Functions......................................................................165
;       →→→ §4.1.1: DismissSplashText..........................................................168
;       →→→ §4.1.2: DisplaySplashText..........................................................175
;       →→→ §4.1.3: FallbackWinActivate........................................................183
;       →→→ §4.1.4: GetActiveWindowBorderWidths................................................201
;       →→→ §4.1.5: GetCursorCoordsToCenterInActiveWindow......................................229
;       →→→ §4.1.6: InsertFilePath.............................................................239
;       →→→ §4.1.7: LaunchApplicationPatiently.................................................268
;       →→→ §4.1.8: LaunchStdApplicationPatiently..............................................300
;       →→→ §4.1.9: MoveCursorIntoActiveWindow.................................................332
;       →→→ §4.1.10: PasteText.................................................................350
;       →→→ §4.1.11: RemoveMinMaxStateForActiveWin.............................................361
;       →→→ §4.1.12: SafeWinActivate...........................................................373
;       →→→ §4.1.13: WaitForApplicationPatiently...............................................402
;       →→→ §4.1.14: WriteCodeToFile...........................................................423
;     >>> §4.2: Hotkeys........................................................................447
;       →→→ §4.2.1: ^+F1, ^!Numpad1............................................................451
;       →→→ §4.2.2: ^+F2, ^!Numpad2............................................................460
;       →→→ §4.2.3: ^!q........................................................................471
;     >>> §4.3: Hotstrings.....................................................................481
;       →→→ §4.3.1: @getMousePos...............................................................484
;       →→→ §4.3.2: @getWinBorders.............................................................494
;       →→→ §4.3.3: @getWinExStyle.............................................................508
;       →→→ §4.3.4: @getWinHwnd................................................................518
;       →→→ §4.5.: @getWinInfo.................................................................527
;       →→→ §4.3.6: @getWinPID.................................................................551
;       →→→ §4.3.7: @getWinPos.................................................................560
;       →→→ §4.3.8: @getWinStyle...............................................................570
;       →→→ §4.3.9: @getWinProcess.............................................................580
;       →→→ §4.3.10: @getWinTitle..............................................................592
;   §5: AutoHotkey state inquiry and manipulation..............................................601
;     >>> §5.1: Functions......................................................................605
;       →→→ §5.1.1: ChangeMatchMode............................................................608
;       →→→ §5.1.2: ChangeMouseCoordMode.......................................................625
;       →→→ §5.1.3: GetDelay...................................................................642
;       →→→ §5.1.4: RestoreMatchMode...........................................................692
;       →→→ §5.1.5: RestoreMouseCoordMode......................................................706
;     >>> §5.2: Hotstrings.....................................................................720
;       →→→ §5.2.1: @checkIsUnicode............................................................723
;       →→→ §5.2.2: @getCurrentVersion.........................................................732
;       →→→ §5.2.3: @getLastHotStrTime.........................................................740
;   §6: Sorting functions......................................................................748
;     >>> §6.1: InsertionSort..................................................................752
;     >>> §6.2: Merge..........................................................................778
;     >>> §6.3: MergeSort......................................................................804
;     >>> §6.4: SwapValues.....................................................................820
;   §7: Desktop management functions...........................................................829
;     >>> §7.1: Functions......................................................................833
;       →→→ §7.1.1: AddWinBordersToMonitorWorkArea.............................................836
;       →→→ §7.1.2: ClipActiveWindowToMonitor..................................................851
;       →→→ §7.1.3: FindActiveMonitor..........................................................883
;       →→→ §7.1.4: FindNearestActiveMonitor...................................................903
;       →→→ §7.1.5: GetActiveMonitorWorkArea...................................................930
;       →→→ §7.1.6: RemoveWinBorderFromRectCoordinate..........................................971
;       →→→ §7.1.8: ResolveActiveMonitorWorkArea..............................................1010
;     >>> §7.2: Hotstrings....................................................................1045
;       →→→ §7.2.1: @clipActiveWindowToMonitor................................................1048
; ==================================================================================================

; --------------------------------------------------------------------------------------------------
;   §1: Window state checks
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §1.1: isTargetProcessActive

isTargetProcessActive(targetProcess, caller := "", notActiveErrMsg := "") {
	WinGet, thisWin, ProcessName, A
	targetProcessIsActive := thisWin = targetProcess
	if (!targetProcessIsActive && caller != "" && notActiveErrMsg != "") {
		ErrorBox(caller, notActiveErrMsg)
	}
	return targetProcessIsActive
}

;   ································································································
;     >>> §1.2: areTargetProcessActive

areTargetProcessesActive(targetProcesses, caller := "", notActiveErrMsg := "") {
	WinGet, thisWin, ProcessName, A
	numPossibleProcesses := targetProcesses.Length()
	activeProcessIndex := 0
	activeProcessName := ""
	Loop, %numPossibleProcesses%
	{
		if (thisWin = targetProcesses[A_Index]) {
			activeProcessIndex := A_Index
			Break
		}
	}
	if (!activeProcessIndex && caller != "" && notActiveErrMsg != "") {
		ErrorBox(caller, notActiveErrMsg)
	} else {
		activeProcessName := targetProcesses[activeProcessIndex]
	}
	return activeProcessName
}

; --------------------------------------------------------------------------------------------------
;   §2: Variable state checks
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §2.1: doesVarExist

doesVarExist(ByRef v) { ; Requires 1.0.46+ 
	return &v = &undeclared ? 0 : 1 
}

;   ································································································
;     >>> §2.2: isVarEmpty

isVarEmpty(ByRef v) { ; Requires 1.0.46+ 
	return v = "" ? 1 : 0 
}

;   ································································································
;     >>> §2.3: isVarDeclared

isVarDeclared(ByRef v) { ; Requires 1.0.46+ 
	return &v = &undeclared ? 0 : v = "" ? 0 : 1
}

; --------------------------------------------------------------------------------------------------
;   §3: Error reporting
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §3.1: ErrorBox

ErrorBox(whichFunc, errorMsg) {
	MsgBox, % 0x10, % "Error in " . whichFunc, % errorMsg
}

; --------------------------------------------------------------------------------------------------
;   §4: Operating system manipulation
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §4.1: Functions

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.1: DismissSplashText

DismissSplashText() {
	SplashTextOff
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.2: DisplaySplashText

DisplaySplashText(msg, displayTime := 1000) {
	SplashTextOn % StrLen(msg) * 8, 24, % A_ScriptName, % msg
	SetTimer DismissSplashText, % -1 * displayTime
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.3: FallbackWinActivate

FallbackWinActivate(titleToMatch, matchMode := 2) {
	global g_delayQuantum
	delay := g_delayQuantum * 7
	oldMatchMode := ChangeMatchMode(matchMode)

	WinGet, hWnd, ID, % titleToMatch
	if (hWnd) {
		DllCall("SetForegroundWindow", UInt, hWnd)
		Sleep, % delay
	}
	RestoreMatchMode(oldMatchMode)

	return WinActive(titleToMatch)
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.4: GetActiveWindowBorderWidths

; Determines the active window's border width from its left and bottom edges, and then assumes the 
; window has the same width of borders on its right and top edges.
;
; Additional Notes on Approach:
;     Current approach was adopted because for PowerShell, the width of the right-hand scroll bar 
; is deducted from the client rectangle. Moreover, for Sublime Text 3, the height of the menu is 
; deducted from the client rectangle. No cases have encountered so far where the width of a 
; window's border is not equal among all of its edges. Since the windows documentation treats 
; horizintal and vertical window borders separately, however, I decided that this function will 
; stay consistent with that convention.
GetActiveWindowBorderWidths() {
	WinGet, hwnd, ID, A
	winInfo := API_GetWindowInfo(hwnd)
	borderWidth := {}
	borderWidth.Horz := abs(winInfo.Window.Left - winInfo.Client.Left)
	if (borderWidth.Horz > winInfo.XBorders) {
		borderWidth.Horz := winInfo.XBorders
	}
	borderWidth.Vert := abs(winInfo.Window.Bottom - winInfo.Client.Bottom)
	if (borderWidth.Vert > winInfo.YBorders) {
		borderWidth.Vert := winInfo.YBorders
	}
	return borderWidth
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.5: GetCursorCoordsToCenterInActiveWindow

GetCursorCoordsToCenterInActiveWindow(ByRef newPosX, ByRef newPosY)
{
	WinGetPos, winPosX, winPosY, winW, winH, A
	newPosX := winW / 2
	newPosY := winH / 2
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.6: InsertFilePath

InsertFilePath(ahkCmdName, filePath, headerStr:="") {
	global lineLength
	AppendAhkCmd(ahkCmdName)
	if (UserFolderIsSet()) {
		if (IsGitShellActive()) {
			if (headerStr != "" && StrLen(headerStr) <= 108 && lineLength != undefined) {
				leftLength := Floor(lineLength / 2) - Floor(StrLen(headerStr) / 2)
				fullHeader := "write-host '``n"
				Loop, %leftLength% {
					fullHeader .= "-"
				}
				fullHeader .= headerStr
				rightLength := lineLength - leftLength - StrLen(headerStr)
				Loop, %rightLength% {
					fullHeader .= "-"
				}
				fullHeader .= "' -foreground 'green'{Enter}"
				SendInput, % fullHeader
			}
			SendInput, % "cd '" . filePath . "'{Enter}"
		} else {
			SendInput, % filePath . "{Enter}"
		}
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.7: LaunchApplicationPatiently

LaunchApplicationPatiently(path, title, matchMode := 2)
{
	global g_delayQuantum
	delay := g_delayQuantum * 32
	oldMatchMode := 0
	if (A_TitleMatchMode != matchMode) {
		oldMatchMode := A_TitleMatchMode
		SetTitleMatchMode, % matchMode
	}
	Run % path
	isReady := false
	while !isReady
	{
		IfWinExist, % title
		{
			isReady := true
			Sleep, % delay
		}
		else
		{
			Sleep, % delay / 2
		}
	}
	Sleep, % delay
	if (oldMatchMode) {
		SetTitleMatchMode, % oldMatchMode
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.8: LaunchStdApplicationPatiently

LaunchStdApplicationPatiently(path, title, matchMode := 2)
{
	global g_delayQuantum
	delay := g_delayQuantum * 32
	oldMatchMode := 0
	if (A_TitleMatchMode != matchMode) {
		oldMatchMode := A_TitleMatchMode
		SetTitleMatchMode, % matchMode
	}
	Run, % "explorer.exe """ . path . """"
	isReady := false
	while !isReady
	{
		IfWinExist, % title
		{
			isReady := true
			Sleep, % delay
		}
		else
		{
			Sleep, % delay / 2
		}
	}
	Sleep, % delay
	if (oldMatchMode) {
		SetTitleMatchMode, % oldMatchMode
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.9: MoveCursorIntoActiveWindow

MoveCursorIntoActiveWindow(ByRef curPosX, ByRef curPosY)
{
	WinGetPos, winPosX, winPosY, winW, winH, A
	if (curPosX < 0) {
		curPosX := 50
	} else if(curPosX > winW - 100) {
		curPosX := winW - 100
	}
	if (curPosY < 0) {
		curPosY := 100
	} else if(curPosY > winH - 100) {
		curPosY := winH - 100
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.10: PasteText

PasteText(txtToPaste) {
	if (clipboard != txtToPaste) {
		clipboard := txtToPaste
	}
	Sleep, 60
	SendInput, % "^v"
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.11: RemoveMinMaxStateForActiveWin

RemoveMinMaxStateForActiveWin() {
	delay := GetDelay("short")
	WinGet, thisMinMax, MinMax, A
	if (thisMinMax != 0) {
		WinRestore, A
		Sleep % delay
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.12: SafeWinActivate

SafeWinActivate(winTitle, matchMode := 2, maxTries := 0) {
	global g_maxTries
	global g_delayQuantum

	oldMatchMode := ChangeMatchMode(matchMode)
	delay := g_delayQuantum * 7
	counter := 0
	if (maxTries == 0) {
		maxTries := g_maxTries
	}
	WinActivate, %winTitle%
	Sleep, % delay * 2
	success := WinActive(winTitle)
	while (!success && counter < maxTries) {
		WinActivate, %winTitle%
		Sleep, % delay * 2
		success := WinActive(winTitle)
		counter++
	}
	RestoreMatchMode(oldMatchMode)
	if (!success) {
		success := FallbackWinActivate(titleToMatch, matchMode)
	}
	return success
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.13: WaitForApplicationPatiently

WaitForApplicationPatiently(title)
{
	delay := 250
	isReady := false
	while !isReady
	{
		IfWinExist, % title
		{
			isReady := true
			Sleep, % delay * 2
		}
		else
		{
			Sleep, % delay
		}
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.14: WriteCodeToFile

WriteCodeToFile(hsCaller, srcCode, srcFileToOverwrite) {
	errorMsg := ""
	if (UserFolderIsSet()) {
		srcFile := FileOpen(srcFileToOverwrite, "w")
		if (srcFile != 0) {
			srcFile.Write(srcCode)
			srcFile.Close()
			Sleep 100
		} else {
			errorMsg := "Failed to open file: " . srcFileToOverwrite
		}
	} else {
		errorMsg := "User folder is not set."
	}
	if (errorMsg != "") {
		MsgBox, % (0x0 + 0x10)
			, % "Error in " . hsCaller . " Function Call: WriteCodeToFile(...)"
			, % errorMsg
	}
}

;   ································································································
;     >>> §4.2: Hotkeys


;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.1: ^+F1, ^!Numpad1

^+F1::
^!Numpad1::
	clpbrdLngth := StrLen(clipboard)
	MsgBox % "The clipboard is " . clpbrdLngth . " characters long."
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.2: ^+F2, ^!Numpad2

^+F2::
^!Numpad2::
	clpbrdLngth := StrLen(clipboard)
	SendInput, +{Right %clpbrdLngth%}
	Sleep, 20
	SendInput, ^v
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.3: ^!q

^!q::
	IfWinExist % "Untitled - Notepad"
		WinActivate % "Untitled - Notepad"
	else
		Run Notepad
Return

;   ································································································
;     >>> §4.3: Hotstrings

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.1: @getMousePos

:*:@getMousePos::
	AppendAhkCmd(":*:@getMousePos")
	MouseGetPos, windowMousePosX, windowMousePosY
	MsgBox % "The mouse cursor is at {x = " . windowMousePosX . ", y = " . windowMousePosY 
		. "} relative to the window."
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.2: @getWinBorders

:*:@getWinBorders::
	AppendAhkCmd(A_ThisLabel)
	WinGet, hwnd, ID, A
	winInfo := API_GetWindowInfo(hwnd)
	if(!IsObject(winInfo)) {
		MsgBox, 0, WINDOWINFO, ERROR - ErrorLevel: %ErrorLevel%
	} else {
		MsgBox, % "XBorders = " . winInfo.XBorders . "`nYBorders = " . winInfo.YBorders
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.3: @getWinExStyle

:*:@getWinExStyle::
	AppendAhkCmd(A_ThisLabel)
	WinGet, hexExStyle, ExStyle, A
	;hasThickBorder := (hexStyle & 0x40000) != 0
	MsgBox, % "The active window's extended styles = " . hexExStyle
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.4: @getWinHwnd

:*:@getWinHwnd::
	AppendAhkCmd(":*:@getWinHwnd")
	WinGet, thisHwnd, ID, A
	MsgBox, % "The active window ID (HWND) is " . thisHwnd
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.5.: @getWinInfo

:*:@getWinInfo::
	AppendAhkCmd(A_ThisLabel)
	WinGet, hwnd, ID, A
	winInfo := API_GetWindowInfo(hwnd)
	if(!IsObject(winInfo)) {
		MsgBox, 0, WINDOWINFO, ERROR - ErrorLevel: %ErrorLevel%
	} else {
		MsgBox, % "Window Rect = " . winInfo.Window.Left . ", " . winInfo.Window.Top . ", "
			. winInfo.Window.Right . ", " . winInfo.Window.Bottom . "`nClient Rect = " 
			. winInfo.Client.Left . ", " . winInfo.Client.Top . ", " . winInfo.Client.Right 
			. ", " . winInfo.Client.Bottom . "`nStyles = " . winInfo.Styles . "`nExStyles = " 
			. winInfo.ExStyles . "`nStatus = " . winInfo.Status . "`nXBorders = " 
			. winInfo.XBorders . "`nYBorders = " . winInfo.YBorders . "`nType = " . winInfo.Type
			. "`nVersion = " . winInfo.Version
	}
Return

^!+F1::
	Gosub :*:@getWinInfo
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.6: @getWinPID

:*:@getWinPID::
	AppendAhkCmd(":*:@getWinPID")
	WinGet, thisPID, PID, A
	MsgBox, % "The active window PID is " . thisPID
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.7: @getWinPos

:*:@getWinPos::
	AppendAhkCmd(":*:@getWinPos")
	WinGetPos, thisX, thisY, thisW, thisH, A
	MsgBox, % "The active window is at coordinates " . thisX . ", " . thisY . "`rWindow's width = " 
		. thisW . ", height = " . thisH
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.8: @getWinStyle

:*:@getWinStyle::
	AppendAhkCmd(A_ThisLabel)
	WinGet, hexStyle, Style, A
	hasThickBorder := (hexStyle & 0x40000) != 0
	MsgBox, % "The active window's styles = " . hexStyle
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.9: @getWinProcess

:*:@getWinProcess::
	AppendAhkCmd(":*:@getWinProcess")
	WinGet, thisProcess, ProcessName, A
	WinGet, thisHwnd, ID, A
	WinGetClass, thisWinClass, A
	MsgBox, % "The active window process name is " . thisProcess . "`rHWND = " . thisHwnd
		. "`rClass name = " . thisWinClass
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.10: @getWinTitle

:*:@getWinTitle::
	AppendAhkCmd(":*:@getWinTitle")
	WinGetTitle, thisTitle, A
	MsgBox, The active window is "%thisTitle%"
Return

; --------------------------------------------------------------------------------------------------
;   §5: AutoHotkey state inquiry and manipulation
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §5.1: Functions

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.1.1: ChangeMatchMode

ChangeMatchMode(newMatchMode) {
	oldMatchMode := 0
	argValid := (newMatchMode == 1) || (newMatchMode == 2) || (newMatchMode == 3)
		|| (newMatchMode == RegEx)
	if (argValid && A_TitleMatchMode != newMatchMode) {
		oldMatchMode := A_TitleMatchMode
		SetTitleMatchMode % newMatchMode
	} else if (!argValid) {
		ErrorBox(A_ThisFunc, "I was passed an invalid argument, which contains the value: "
			. newMatchMode)
	}
	return oldMatchMode
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.1.2: ChangeMouseCoordMode

ChangeMouseCoordMode(newCoordMode) {
	oldCoordMode := 0
	argValid := (newCoordMode == Screen) || (newCoordMode == Relative) || (newCoordMode == Window)
		|| (newCoordMode == Client)
	if (argValid && A_CoordModeMouse != newCoordMode) {
		oldCoordMode := A_CoordModeMouse
		CoordMode Mouse, % newCoordMode
	} else if (!argValid) {
		ErrorBox(A_ThisFunc, "I was passed an invalid argument, which contains the value: "
			. newCoordMode)
	}
	return oldCoordMode
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.1.3: GetDelay
;
;   Allows for operational delays to be semantically set across scripts.
;
;   Concepts such as short, medium, and long delays are interpreted into consistent values. An
;   optional multiplier may also be applied, allowing the function to achieve any value of delay.
;
;   @param {string}         delayLength     Can have values of "xShort", "short", "medium", and
;												"long".
;   @param {number}			multiplier		Must be >=0; optional.

GetDelay(delayLength, multiplier := 0) {
	global
	local delay

	; Process delayLength into a scalar multiplier of the script's delay quantum
	if (delayLength == "shortest") {
		delay := 1
	} else if (delayLength == "xShort") {
		delay := g_extraShortDelay
	} else if (delayLength == "short") {
		delay := g_shortDelay
	} else if (delayLength == "medium") {
		delay := g_mediumDelay
	} else if (delayLength == "long") {
		delay := g_longDelay
	} else {
		delay := g_shortDelay
		ErrorBox(A_ThisLabel, "I was called with an incorrectly specified delayLength parameter, wh"
			. "ich had a value of: " . delayLength . ". I will assume a short delay is appropriate "
			. "and allow script execution to proceed.")
	}

	; If applicable, apply an additional multiplier to the basal scalar multiplier
	if (multiplier > 0) {
		delay *= multiplier
	} else if (multiplier < 0) {
		ErrorBox(A_ThisLabel, "I was called with an incorrectly specified multiplier parameter, whi"
			. "ich had a value of: " . multiplier . ". I will ignore it and allow execution to proc"
			. "eed.")
	}

	; Multiply by the script's delay quantum to produce the actual delay
	delay *= g_delayQuantum

	; Return processed delay for use in calling function
	return delay
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.1.4: RestoreMatchMode

RestoreMatchMode(oldMatchMode) {
	argValid := (oldMatchMode == 0) || (oldMatchMode == 1) || (oldMatchMode == 2)
		|| (oldMatchMode == 3) || (oldMatchMode == RegEx)
	if (argValid && oldMatchMode && A_TitleMatchMode != oldMatchMode) {
		SetTitleMatchMode % oldMatchMode
	} else if (!argValid) {
		ErrorBox(A_ThisFunc, "I was passed an invalid argument, which contains the value: "
			. oldMatchMode)
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.1.5: RestoreMouseCoordMode

RestoreMouseCoordMode(oldCoordMode) {
	argValid := (oldCoordMode == 0) || (oldCoordMode == Screen) || (oldCoordMode == Relative)
		|| (oldCoordMode == Window) || (oldCoordMode == Client)
	if (argValid && oldCoordMode && A_CoordModeMouse != oldCoordMode) {
		CoordMode Mouse, % oldCoordMode
	} else if (!argValid) {
		ErrorBox(A_ThisFunc, "I was passed an invalid argument, which contains the value: "
			. oldCoordMode)
	}
}

;   ································································································
;     >>> §5.2: Hotstrings

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.1: @checkIsUnicode

:*:@checkIsUnicode::
	AppendAhkCmd(A_ThisLabel)
	Msgbox % "v" . A_AhkVersion . " " . (A_PtrSize = 4 ? 32 : 64) . "-bit " 
		. (A_IsUnicode ? "Unicode" : "ANSI") . " " . (A_IsAdmin ? "(Admin mode)" : "(Not Admin)")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.2: @getCurrentVersion

:*:@getCurrentVersion::
	AppendAhkCmd(A_ThisLabel)
	MsgBox % "Current installed version of AHK: " . A_AhkVersion
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.3: @getLastHotStrTime

:*:@getLastHotStrTime::
	AppendAhkCmd(A_ThisLabel)
	MsgBox % "The last hotstring took " . (hotStrEndTime - hotStrStartTime) . "ms to run."
Return

; --------------------------------------------------------------------------------------------------
;   §6: Sorting functions
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §6.1: InsertionSort

InsertionSort(ByRef arrayObj, l, r) {
	i := r
	while (i > l) {
		if (arrayObj[i] < arrayObj[i - 1]) {
			objCopy := arrayObj[i]
			arrayObj[i] := arrayObj[i - 1]
			arrayObj[i - 1] := objCopy
		}
		i--
	}
	i := l + 2
	while (i <= r) {
		j := i
		objItem := arrayObj[i]
		while (objItem < arrayObj[j - 1]) {
			arrayObj[j] := arrayObj[j - 1]
			j--
		}
		arrayObj[j] := objItem
		i++
	}
}

;   ································································································
;     >>> §6.2: Merge

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

;   ································································································
;     >>> §6.3: MergeSort

MergeSort(ByRef arrayObj, l, r) {
	if (r > l) {
		if (r - l <= 10) {
			InsertionSort(arrayObj, l, r)
		} else {
			m := floor((r + l) / 2)
			MergeSort(arrayObj, l, m)
			MergeSort(arrayObj, m + 1, r)
			Merge(arrayObj, l, m, r)
		}
	}
}

;   ································································································
;     >>> §6.4: SwapValues

SwapValues(ByRef val1, ByRef val2) {
	valTemp := val2
	val2 := val1
	val1 := valTemp
}

; --------------------------------------------------------------------------------------------------
;   §7: Desktop management functions
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §7.1: Functions

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.1: AddWinBordersToMonitorWorkArea

; Adjust the work area of the monitor the active window is occupying by compensating for the width
; of the active window's borders. The intended effect of this compensation is restriction of the
; active window's client rectangle to the monitor's work area.
AddWinBordersToMonitorWorkArea(ByRef monitorWaLeft, ByRef monitorWaTop, ByRef monitorWaRight
		, ByRef monitorWaBottom) {
	borderWidth := GetActiveWindowBorderWidths()
	monitorWaLeft -= (borderWidth.Horz - 1)
	monitorWaTop -= (borderWidth.Vert - 1)
	monitorWaRight += (borderWidth.Horz - 1)
	monitorWaBottom += (borderWidth.Vert - 1)
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.2: ClipActiveWindowToMonitor

ClipActiveWindowToMonitor() {
	GetActiveMonitorWorkArea(monitorFound, monitorALeft, monitorATop, monitorARight, monitorABottom)
	WinGetPos, x, y, w, h, A
	; Set up clipping of the horizontal dimensions of the window.
	if (x >= monitorALeft && x + w > monitorARight) {
		w := monitorARight - x
	} else if (x < monitorALeft && x + w > monitorALeft && x + w <= monitorARight) {
		w := x + w - monitorALeft
		x := monitorALeft
	} else if (x < monitorALeft && x + w > monitorALeft && x + w > monitorARight) {
		x := monitorALeft
		w := monitorARight - x
	}

	; Now set up clipping of the vertical dimensions.
	if (y >= monitorATop && y + h > monitorABottom) {
		h := monitorABottom - y
	} else if (y < monitorATop && y + h > monitorATop && y + h <= monitorABottom) {
		h := y + h - monitorATop
		y := monitorATop
	} else if (y < monitorATop && y + h > monitorATop && y + h > monitorABottom) {
		y := monitorATop
		h := monitorABottom - y
	}

	; Perform clipping
	WinMove, A, , x, y, w, h
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.3: FindActiveMonitor

FindActiveMonitor() {
	whichMon := 0

	WinGetPos, x, y, w, h, A
	RemoveWinBorderFromRectCoordinate(0, x, y)
	Loop, %sysNumMonitors% {
		if (winCoords.x >= mon%A_Index%Bounds_Left && winCoords.y >= mon%A_Index%Bounds_Top
				&& winCoords.x < mon%A_Index%Bounds_Right
				&& winCoords.y < mon%A_Index%Bounds_Bottom) {
			whichMon := A_Index
			break
		}
	}

	return whichMon
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.4: FindNearestActiveMonitor

FindNearestActiveMonitor() {
	minDistance := -1
	winMidpt := {}
	monMidpt := {}

	WinGetPos, x, y, w, h, A
	RemoveWinBorderFromRectCoordinate(0, x, y)
	winMidpt.x := x + w / 2
	winMidpt.y := x + h / 2
	Loop, %sysNumMonitors% {
		monMidpt.x := mon%A_Index%Bounds_Left + (mon%A_Index%Bounds_Right 
			- mon%A_Index%Bounds_Left) / 2		
		monMidpt.y := mon%A_Index%Bounds_Top + (mon%A_Index%Bounds_Bottom
			- mon%A_Index%Bounds_Top)	/ 2
		distance := Sqrt((monMidpt.x - winMidpt.x)**2 + (monMidpt.y - winMidpt.y)**2)
		if (minDistance = -1 || distance < minDistance) {
			minDistance := distance
			correctMon := A_Index
		}
	}

	return correctMon
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.5: GetActiveMonitorWorkArea

GetActiveMonitorWorkArea(ByRef monitorFound, ByRef monitorALeft, ByRef monitorATop
		, ByRef monitorARight, ByRef monitorABottom) {
	global
	local whichMon
	local winCoords
	local x
	local y
	local w
	local h
	local whichVertex

	monitorFound := false
	RemoveMinMaxStateForActiveWin()
	whichMon := FindActiveMonitor()
	if (whichMon > 0) {
		monitorFound := true
		monitorALeft := mon%whichMon%WorkArea_Left
		monitorATop := mon%whichMon%WorkArea_Top
		monitorARight := mon%whichMon%WorkArea_Right
		monitorABottom := mon%whichMon%WorkArea_Bottom
	}

	if (monitorFound = false) {
		winCoords := {}
		WinGetPos, x, y, w, h, A
		whichVertex := 0
		RemoveWinBorderFromRectCoordinate(whichVertex, x, y)
		winCoords.x := x
		winCoords.y := y
		winCoords.w := w
		winCoords.h := h
		ResolveActiveMonitorWorkArea(monitorFound, monitorALeft, monitorATop, monitorARight
			, monitorABottom, winCoords)
	} else {
		AddWinBordersToMonitorWorkArea(monitorALeft, monitorATop, monitorARight, monitorABottom)
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.6: RemoveWinBorderFromRectCoordinate

; Remove the width of a window's border from one of its outer rectangle coordinates. This has the 
; effect of transforming an outer rectangle coordinate into a client rectangle coordinate.
;
; Additional Notes on arguments:
; ------------------------------------------------------
;    Value of whichVertex  |  Interpretation
; ------------------------------------------------------
;    0                        Top-left window vertex
;    1                        Top-right
;    2                        Bottom-left
;    3                        Bottom-right
;    Anything else            Leave coordinate unchanged
RemoveWinBorderFromRectCoordinate(whichVertex, ByRef coordX, ByRef coordY) {
	WinGet, hwnd, ID, A
	winInfo := API_GetWindowInfo(hwnd)
	borderWidth := {}
	if (whichVertex = 0) {
		borderWidth.Horz := abs(winInfo.Window.Left - winInfo.Client.Left)
		borderWidth.Vert := abs(winInfo.Window.Top - winInfo.Client.Top)
	} else if (whichVertex = 1) {
		borderWidth.Horz := -1 * abs(winInfo.Window.Right - winInfo.Client.Right)
		borderWidth.Vert := abs(winInfo.Window.Top - winInfo.Client.Top)
	} else if (whichVertex = 2) {
		borderWidth.Horz := abs(winInfo.Window.Left - winInfo.Client.Left)
		borderWidth.Vert := -1 * abs(winInfo.Window.Bottom - winInfo.Client.Bottom)
	} else if (whichVertex = 3) { ; Assume bottom-right vertex
		borderWidth.Horz := -1 * abs(winInfo.Window.Right - winInfo.Client.Right)
		borderWidth.Vert := -1 * abs(winInfo.Window.Bottom - winInfo.Client.Bottom)
	} else {
		borderWidth.Horz := 0
		borderWidth.Vert := 0
	}
	coordX += borderWidth.Horz
	coordY += borderWidth.Vert
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.1.8: ResolveActiveMonitorWorkArea

; Notes on arguments:
; -------------------
; winCoords = object with properties x, y, w, and h that have been set by call to WinGetPos
ResolveActiveMonitorWorkArea(ByRef monitorFound, ByRef monitorALeft, ByRef monitorATop
		, ByRef monitorARight, ByRef monitorABottom, winCoords) {
	global
	local distance
	local minDistance := -1
	local correctMon := 0
	local winMidpt := {}
	local monMidpt := {}
	winMidpt.x := winCoords.x + winCoords.w / 2
	winMidpt.y := winCoords.x + winCoords.h / 2
	Loop, %sysNumMonitors% {
		monMidpt.x := mon%A_Index%Bounds_Left + (mon%A_Index%Bounds_Right 
			- mon%A_Index%Bounds_Left) / 2		
		monMidpt.y := mon%A_Index%Bounds_Top + (mon%A_Index%Bounds_Bottom
			- mon%A_Index%Bounds_Top)	/ 2
		distance := Sqrt((monMidpt.x - winMidpt.x)**2 + (monMidpt.y - winMidpt.y)**2)
		if (minDistance = -1 || distance < minDistance) {
			minDistance := distance
			correctMon := A_Index
		}
	}
	monitorFound := true
	monitorALeft := mon%correctMon%WorkArea_Left
	monitorATop := mon%correctMon%WorkArea_Top
	monitorARight := mon%correctMon%WorkArea_Right
	monitorABottom := mon%correctMon%WorkArea_Bottom
	AddWinBordersToMonitorWorkArea(monitorALeft, monitorATop, monitorARight, monitorABottom)
}

;   ································································································
;     >>> §7.2: Hotstrings

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §7.2.1: @clipActiveWindowToMonitor

:*:@clipActiveWindowToMonitor::
	AppendAhkCmd(A_ThisLabel)
	ClipActiveWindowToMonitor()
Return
