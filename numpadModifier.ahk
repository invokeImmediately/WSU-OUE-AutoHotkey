﻿; ==================================================================================================
; AHK SCRIPT FOR MODIFYING THE BEHAVIOR OF NUMPAD KEYS
; ==================================================================================================
; AutoHotkey Send Legend:
; ! = ALT     + = SHIFT     ^ = CONTROL     # = WIN
; (see https://autohotkey.com/docs/commands/Send.htm for more info)
; ==================================================================================================
; TABLE OF CONTENTS:
; ------------------------------------------------------------------------------------------------
;   §1: Hotkeys.................................................................................17
;     >>> §1.1: NumpadDiv.......................................................................21
;     >>> §1.2: NumpadSub.......................................................................55
;     >>> §1.3: NumpadDel.......................................................................89
; ==================================================================================================

; --------------------------------------------------------------------------------------------------
;   §1: Hotkeys
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §1.1: NumpadDiv

NumpadDiv::
	if (bitNumpadDivToggle) {
		SendInput, % numpadDivOverwrite
	}
	else {
		SendInput, /
	}
Return

^NumpadDiv::
	Gosub :*:@toggleNumpadDiv
Return

^+NumpadDiv::
	Gosub :*:@changeNumpadDiv
Return

:*:@toggleNumpadDiv::
	AppendAhkCmd(":*:@toggleNumpadDiv")
	toggleMsg := "The NumPad / key has been toggled to "
	bitNumpadDivToggle := !bitNumpadDivToggle
	if (bitNumpadDivToggle) {
		toggleMsg .= numpadDivOverwrite
	} else {
		toggleMsg .=  "/"
	}
	MsgBox, % (0x0 + 0x40)
		, % "@toggleNumpadDiv: NumPad / Toggled"
		, % toggleMsg
Return

;   ································································································
;     >>> §1.2: NumpadSub

NumpadSub::
	if (bitNumpadSubToggle) {
		SendInput, % numpadSubOverwrite
	}
	else {
		SendInput, -
	}
Return

^NumpadSub::
	Gosub :*:@toggleNumpadSub
Return

^+NumpadSub::
	Gosub :*:@changeNumpadSub
Return

:*:@toggleNumpadSub::
	AppendAhkCmd(":*:@toggleNumpadSub")
	toggleMsg := "The NumPad- key has been toggled to "
	bitNumpadSubToggle := !bitNumpadSubToggle
	if (bitNumpadSubToggle) {
		toggleMsg .= numpadSubOverwrite
	} else {
		toggleMsg .=  "-"
	}
	MsgBox, % (0x0 + 0x40)
		, % "@toggleNumpadSub: NumPad- Toggled"
		, % toggleMsg
Return

;   ································································································
;     >>> §1.3: NumpadDel

^!NumpadDel::
	Gosub, :*:@toggleNpBoxArt
Return

:*:@toggleNpBoxArt::
	HandleToggleNpBoxArt()
Return

HandleToggleNpBoxArt() {
	global npBoxArtActive
	global npArrowArtActive
	npArrowArtActive := False
	toggleMsg := "Numpad box art toggled to "
	if (npBoxArtActive) {
		npBoxArtActive := False
		toggleMsg .= "OFF"
	} else {
		npBoxArtActive := True
		toggleMsg .= "ON"
	}
	DisplaySplashText(toggleMsg)
}

^!#NumpadDel::
	Gosub, :*:@toggleNpArrowArt
Return

:*:@toggleNpArrowArt::
	HandleToggleNpArrowArt()
Return

HandleToggleNpArrowArt() {
	global npBoxArtActive
	global npArrowArtActive
	npBoxArtActive := False
	toggleMsg := "Numpad arrow art toggled to "
	if (npArrowArtActive) {
		npArrowArtActive := False
		toggleMsg .= "OFF"
	} else {
		npArrowArtActive := True
		toggleMsg .= "ON"
	}
	DisplaySplashText(toggleMsg)
}

Numpad7::
	HandleNumpad7()
Return

HandleNumpad7() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┌"
	} else if (npArrowArtActive) {
		SendInput, % "↰"
	} else {
		SendInput, % "7"
	}
}

Numpad8::
	HandleNumpad8()
Return

HandleNumpad8() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "─"
	} else if (npArrowArtActive) {
		SendInput, % "↑"
	} else {
		SendInput, % "8"
	}
}

Numpad9::
	HandleNumpad9()
Return

HandleNumpad9() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┐"
	} else if (npArrowArtActive) {
		SendInput, % "↱"
	} else {
		SendInput, % "9"
	}
}

Numpad4::
	HandleNumpad4()
Return

HandleNumpad4() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "│"
	} else if (npArrowArtActive) {
		SendInput, % "←"
	} else {
		SendInput, % "4"
	}
}

Numpad5::
	HandleNumpad5()
Return

HandleNumpad5() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "├"
	} else if (npArrowArtActive) {
		SendInput, % "├"
	} else {
		SendInput, % "5"
	}
}

Numpad6::
	HandleNumpad6()
Return

HandleNumpad6() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┤"
	} else if (npArrowArtActive) {
		SendInput, % "→"
	} else {
		SendInput, % "6"
	}
}

Numpad1::
	HandleNumpad1()
Return

HandleNumpad1() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "└"
	} else if (npArrowArtActive) {
		SendInput, % "↲"
	} else {
		SendInput, % "1"
	}
}

Numpad2::
	HandleNumpad2()
Return

HandleNumpad2() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┬"
	} else if (npArrowArtActive) {
		SendInput, % "↓"
	} else {
		SendInput, % "2"
	}
}

Numpad3::
	HandleNumpad3()
Return

HandleNumpad3() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┘"
	} else if (npArrowArtActive) {
		SendInput, % "↳"
	} else {
		SendInput, % "3"
	}
}

Numpad0::
	HandleNumpad0()
Return

HandleNumpad0() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┴"
	} else if (npArrowArtActive) {
		SendInput, % "│"
	} else {
		SendInput, % "0"
	}
}

NumpadDot::
	HandleNumpadDot()
Return

HandleNumpadDot() {
	global npBoxArtActive
	global npArrowArtActive
	if (npBoxArtActive) {
		SendInput, % "┼"
	} else if (npArrowArtActive) {
		SendInput, % "└"
	} else {
		SendInput, % "."
	}
}
