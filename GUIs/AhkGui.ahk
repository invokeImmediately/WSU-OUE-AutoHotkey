; ==================================================================================================
; ▄▀▀▄ █  █ █ ▄▀ █▀▀▀ █  █ ▀█▀   ▄▀▀▄ █  █ █ ▄▀ 
; █▄▄█ █▀▀█ █▀▄  █ ▀▄ █  █  █    █▄▄█ █▀▀█ █▀▄  
; █  ▀ █  ▀ ▀  ▀▄▀▀▀▀  ▀▀  ▀▀▀ ▀ █  ▀ █  ▀ ▀  ▀▄
;
; Prototype for all GUIs created by the WSU-DAESA-Autohotkey script.
;
; @version 0.0.0
;
; @author Daniel Rieck [daniel.rieck@wsu.edu] (https://github.com/invokeImmediately)
; @link https://github.com/invokeImmediately/WSU-AutoHotkey/blob/master/GUIs/AhkGui.ahk
; @license MIT Copyright (c) 2021 Daniel C. Rieck.
;   Permission is hereby granted, free of charge, to any person obtaining a copy of this software
;     and associated documentation files (the “Software”), to deal in the Software without
;     restriction, including without limitation the rights to use, copy, modify, merge, publish,
;     distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
;     Software is furnished to do so, subject to the following conditions:
;   The above copyright notice and this permission notice shall be included in all copies or
;     substantial portions of the Software.
;   THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
;     BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
;     DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; ==================================================================================================

class AhkGui
{
	__New( typer, delayer, guiType, guiName, guiTitle ) {

		; Safely set type checker
		if ( typer.__Class == "TypeChecker" ) {
			this.typer := typer
		} else {
			throw Exception( A_ThisFunc . ": Type checker parameter was not correctly typed; member"
				. " '__Class' was set to: '" . typer.__Class . "'." )
		}

		; Safely set GUI Type identifier
		if ( typer.IsAlnum( guiType ) && guiType != "" ) {
			this.type := guiType
		} else {
			this.type := "Misc"
		}
		if ( typer.IsAlnum( guiName ) && guiName != "" ) {
			this.name := guiName
		} else {
			this.name := "Default"
		}
		if ( typer.IsAlnum( guiTitle ) && guiTitle != "" ) {
			this.title := guiTitle
		} else {
			this.title := A_ScriptName
		}
	}

	CloseGui() {
		guiType := this.type
		guiName := this.name
		Gui, guiGh%guiType%%guiName%: Destroy
	}
}
