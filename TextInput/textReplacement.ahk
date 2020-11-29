﻿; ==================================================================================================
; textReplacement.ahk
; --------------------------------------------------------------------------------------------------
; SUMMARY: An assortment of text replacement hotstrings.
;
; AUTHOR: Daniel Rieck [daniel.rieck@wsu.edu] (https://github.com/invokeImmediately)
; 
; REPOSITORY: https://github.com/invokeImmediately/WSU-AutoHotkey
;
; LICENSE: ISC - Copyright (c) 2020 Daniel C. Rieck.
;
;   Permission to use, copy, modify, and/or distribute this software for any purpose with or
;   without fee is hereby granted, provided that the above copyright notice and this permission
;   notice appear in all copies.
;
;   THE SOFTWARE IS PROVIDED "AS IS" AND DANIEL C. RIECK DISCLAIMS ALL WARRANTIES WITH REGARD TO
;   THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
;   DANIEL C. RIECK BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
;   DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
;   CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;   PERFORMANCE OF THIS SOFTWARE.
; ==================================================================================================
; TABLE OF CONTENTS:
; -----------------
;   §1: GENERAL text editing....................................................................44
;     >>> §1.1: Hotstrings......................................................................48
;     >>> §1.2: Hotkeys.........................................................................66
;       →→→ §1.2.1: Insertion of non-breaking spaces............................................69
;       →→→ §1.2.2: VIM-style cursor movement...................................................76
;   §2: FRONT-END web development..............................................................155
;     >>> §2.1: HTML editing...................................................................159
;     >>> §2.2: CSS editing....................................................................166
;     >>> §2.3: JS editing.....................................................................174
;   §3: NUMPAD mediated text insertion.........................................................179
;     >>> §3.1: GetCmdForMoveToCSSFolder.......................................................183
;     >>> §3.2: GetCmdForMoveToCSSFolder.......................................................201
;   §4: DATES and TIMES........................................................................219
;     >>> §4.1: Dates..........................................................................223
;     >>> §4.2: Times..........................................................................251
;   §5: CLIPBOARD modifying hotstrings.........................................................285
; ==================================================================================================

; --------------------------------------------------------------------------------------------------
;   §1: GENERAL text editing hotstrings
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §1.1: Hotstrings

:*:@a5lh::
	AppendAhkCmd(A_ThisLabel)
	SendInput, {Enter 5}
Return

:*:@ppp::
	AppendAhkCmd(A_ThisLabel)
	SendInput, news-events_events_.html{Left 5}
Return

:*:@shrug::
	AppendAhkCmd(A_ThisLabel)
	SendInput, % "¯\_(·_·)_/¯"
Return

;   ································································································
;     >>> §1.2: Hotkeys

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §1.2.1: Insertion of non-breaking spaces

>^>!Space::
	SendInput, % " "
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §1.2.2: VIM-style cursor movement

; TODO: Add timer-based deactivation of VIM-style cursor movement state.

>+CapsLock::
	ToggleVimyMode()
Return

ToggleVimyMode() {
	global execDelayer
	global g_vimyModeActive
	g_vimyModeActive := !g_vimyModeActive
	vimyModeState := g_vimyModeActive ? "on" : "off"
	DisplaySplashText( "VIM-style cursor movement mode toggled to " . vimyModeState, 500 )
	execDelayer.Wait( 500 )
}

; Word based movement

~m::
	HandleVimyKey( "^{Left}", "m" )
Return

~,::
	HandleVimyKey( "^{Right}{Right}^{Right}^{Left}", "," )
Return

~u::
	HandleVimyKey( "^{Left}{Left}^{Left}^{Right}", "u" )
Return

~i::
	HandleVimyKey( "^{Right}", "i" )
Return

; Character based movement

~j::
	HandleVimyKey( "{Left}", "j" )
Return

~k::
	HandleVimyKey( "{Right}", "k" )
Return

~l::
	HandleVimyKey( "{Up}", "l" )
Return

~;::
	HandleVimyKey( "{Down}", ";" )
Return

HandleVimyKey( vimyModeOnKey, vimyModeOffKey ) {
	global g_vimyModeActive
	if ( g_vimyModeActive ) {
		SendInput % "{Backspace}" . vimyModeOnKey 
	}
}

; VIM : 

^#j::
	SendInput {Left}
Return

^#k::
	SendInput {Up}
Return

^#l::
	SendInput {Down}
Return

^#;::
	SendInput {Right}
Return

; --------------------------------------------------------------------------------------------------
;   §2: FRONT-END web development
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §2.1: HTML editing

:*:@addClass::class=""{Space}{Left 2}

:*:@addNrml::{Space}class="oue-normal"

;   ································································································
;     >>> §2.2: CSS editing

:*:@doRGBa::
	AppendAhkCmd(A_ThisLabel)
	SendInput, rgba(@rval, @gval, @bval, );{Left 2}
Return

;   ································································································
;     >>> §2.3: JS editing

:R*:@findStrFnctns::^[^{\r\n]+{$\r\n(?:^(?<!\}).+$\r\n)+^\}$

; --------------------------------------------------------------------------------------------------
;   §3: NUMPAD mediated text insertion
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §3.1: @changeNumpadDiv

:*:@changeNumpadDiv::
	AppendAhkCmd(A_ThisLabel)
	Inputbox, inputEntered
		, % "@changeNumpadDiv: Change Numpad / Overwrite"
		, % "Enter a character/string that the Numpad- key will now represent once alternative "
		. "input is toggled on."
	if (!ErrorLevel) {
		numpadDivOverwrite := inputEntered
	} else {
		MsgBox, % (0x0 + 0x40)
			, % "@changeNumpadDiv: Numpad / Overwrite Canceled"
			, % "Alternative input for Numpad / will remain as " . numpadDivOverwrite
	}
Return

;   ································································································
;     >>> §3.2: @changeNumpadSub

:*:@changeNumpadSub::
	AppendAhkCmd(A_ThisLabel)
	Inputbox, inputEntered
		, % "@changeNumpadSub: Change Numpad- Overwrite"
		, % "Enter a character/string that the Numpad- key will now represent once alternative "
		. "input is toggled on."
	if (!ErrorLevel) {
		numpadSubOverwrite := inputEntered
	} else {
		MsgBox, % (0x0 + 0x40)
			, % "@changeNumpadSub: Numpad- Overwrite Canceled"
			, % "Alternative input for Numpad- will remain as " . numpadSubOverwrite
	}
Return

; --------------------------------------------------------------------------------------------------
;   §4: DATES and TIMES
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §4.1: Dates

:*:@datetime::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentDateTime, , yyyy-MM-dd HH:mm:ss
	SendInput, %currentDateTime%
Return

:*:@ddd::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentDate, , yyyy-MM-dd
	SendInput, %currentDate%
Return

:*:@dtfn::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentDateTime, , yyyy-MM-dd_HH:mm:ss
	updatedDateTime := StrReplace( currentDateTime, ":", "⋮" )
	SendInput, %updatedDateTime%
Return

:*:@mdys::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentDate, , MM/dd/yyyy
	SendInput, %currentDate%
Return

;   ································································································
;     >>> §4.2: Times

:*:@ttt::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentTime, , HH-mm-ss
	SendInput, %currentTime%
Return

:*:@ttc::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentTime, , HH:mm:ss
	SendInput, %currentTime%
Return

:*:@ttfn::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentTime, , HH:mm:ss
	updatedTime := StrReplace( currentTime, ":", "⋮" )
	SendInput, % updatedTime
Return

:*:@xccc::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, currentDate,, yyyy-MM-dd
	SendInput, / Completed %currentDate%
Return

:*:@xsss::
	AppendAhkCmd(A_ThisLabel)
	FormatTime, CurrentDateTime,, yyyy-MM-dd
	SendInput, (Started %CurrentDateTime%)
Return

; --------------------------------------------------------------------------------------------------
;   §5: CLIPBOARD modifying hotstrings
; --------------------------------------------------------------------------------------------------

:*:@reverseBackSlashes::
	AppendAhkCmd( A_ThisLabel )
	oldText := Clipboard
	execDelayer.Wait( "s" )
	newText := RegExReplace( Clipboard, "\\", "/" )
	execDelayer.Wait( "s" )
	Clipboard := newText
	execDelayer.Wait( "s" )
	DisplaySplashText( "Text in the clipboard has been modified such that back slashes have been "
	 . "reversed.", 3000 )
Return

:*:@reverseFwdSlashes::
	AppendAhkCmd( A_ThisLabel )
	oldText := Clipboard
	execDelayer.Wait( "s" )
	newText := RegExReplace( Clipboard, "/", "\" )
	execDelayer.Wait( "s" )
	Clipboard := newText
	execDelayer.Wait( "s" )
	DisplaySplashText( "Text in the clipboard has been modified such that foward slashes have been "
	 . "reversed.", 3000 )
Return

:*:@convertUrlToFileName::
	AppendAhkCmd( A_ThisLabel )
	oldText := Clipboard
	execDelayer.Wait( "s" )
	newText := RegExReplace( Clipboard, "/", "❘" )
	execDelayer.Wait( "s" )
	newText := RegExReplace( newText, "\.", "·" )
	execDelayer.Wait( "s" )
	newText := RegExReplace( newText, ":", "⋮" )
	execDelayer.Wait( "s" )
	Clipboard := newText
	execDelayer.Wait( "s" )
	DisplaySplashText( "Text in the clipboard has been modified such that colons have been "
	 . "replaced with vertical ellipses, foward slashes have been replaced with vertical bars, "
	 . "and periods have been replaced with middle dots.", 3000 )
Return
