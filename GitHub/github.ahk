﻿; ==================================================================================================
; github.ahk
; --------------------------------------------------------------------------------------------------
; SUMMARY: Automate tasks for working with git in Windows 10 via PowerShell and posting code from
; git repositories to WordPress.
;
; AUTHOR: Daniel Rieck [daniel.rieck@wsu.edu] (https://github.com/invokeImmediately)
;
; REPOSITORY: https://github.com/invokeImmediately/WSU-AutoHotkey
;
; LICENSE: ISC - Copyright (c) 2019 Daniel C. Rieck.
;
;   Permission to use, copy, modify, and/or distribute this software for any purpose with or
;   without fee is hereby granted, provided that the above copyright notice and this permission
;   notice appear in all copies.
;
;   THE SOFTWARE IS PROVIDED "AS IS" AND DANIEL RIECK DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
;   SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
;   DANIEL RIECK BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
;   DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
;   CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;   PERFORMANCE OF THIS SOFTWARE.
; --------------------------------------------------------------------------------------------------
; TODOS:
; • Add LSAMP to CSS and JS build processing hotstrings.
; ==================================================================================================

; ==================================================================================================
; TABLE OF CONTENTS:
; -----------------
;   §1: SETTINGS accessed via functions for this imported file.................................237
;     >>> §1.1: GetCmdForMoveToCSSFolder.......................................................241
;     >>> §1.2: GetCurrentDirFrom..............................................................256
;     >>> §1.3: GetGitHubFolder................................................................268
;     >>> §1.4: UserFolderIsSet................................................................276
;   §2: FUNCTIONS for working with GitHub Desktop..............................................290
;     >>> §2.1: ActivateGitShell...............................................................294
;     >>> §2.2: CommitAfterBuild...............................................................313
;     >>> §2.3: EscapeCommitMessage............................................................347
;     >>> §2.4: Git commit GUI — Imports.......................................................357
;       →→→ §2.4.1: For committing CSS builds..................................................360
;       →→→ §2.4.2: For committing JS builds...................................................365
;       →→→ §2.4.3: For committing any type of file............................................370
;     >>> §2.5: CopySrcFileToClipboard.........................................................375
;     >>> §2.6: IsGitShellActive...............................................................396
;     >>> §2.7: PasteTextIntoGitShell..........................................................403
;     >>> §2.8: ToEscapedPath..................................................................429
;     >>> §2.9: VerifyCopiedCode...............................................................437
;   §3: FUNCTIONS for interacting with online WEB DESIGN INTERFACES............................450
;     >>> §3.1: LoadWordPressSiteInChrome......................................................454
;   §4: GUI FUNCTIONS for handling user interactions with scripts..............................490
;     >>> §4.1: @postMinCss....................................................................494
;       →→→ §4.1.1: HandlePostCssCheckAllSites.................................................534
;       →→→ §4.1.2: HandlePostCssUncheckAllSites...............................................555
;       →→→ §4.1.3: HandlePostMinCssCancel.....................................................576
;       →→→ §4.1.4: HandlePostMinCssOK.........................................................583
;       →→→ §4.1.5: PasteMinCssToWebsite.......................................................654
;     >>> §4.2: @postBackupCss.................................................................665
;       →→→ §4.2.1: HandlePostBackupCssCheckAllSites...........................................711
;       →→→ §4.2.2: HandlePostBackupCssUncheckAllSites.........................................732
;       →→→ §4.2.3: HandlePostBackupCssCancel..................................................753
;       →→→ §4.2.4: HandlePostBackupCssOK......................................................760
;     >>> §4.3: @postMinJs.....................................................................827
;       →→→ §4.3.1: HandlePostJsCheckAllSites..................................................878
;       →→→ §4.3.2: HandlePostJsUncheckAllSites................................................898
;       →→→ §4.3.3: HandlePostMinJsCancel......................................................918
;       →→→ §4.3.4: HandlePostMinJsOK..........................................................925
;       →→→ §4.3.5: PasteMinJsToWebsite.......................................................992
;   §5: UTILITY HOTSTRINGS for working with GitHub Desktop....................................1007
;     >>> §5.1: FILE COMMITTING...............................................................1011
;     >>> §5.2: STATUS CHECKING...............................................................1158
;       →→→ §5.2.1: @doGitStataus & @dogs.....................................................1161
;       →→→ §5.2.2: @doGitDiff & @dogd........................................................1181
;       →→→ §5.2.3: @doGitLog & @dogl.........................................................1201
;       →→→ §5.2.4: @doGitNoFollowLog & @donfgl...............................................1221
;     >>> §5.3: Automated PASTING OF CSS/JS into online web interfaces........................1241
;       →→→ §5.3.1: @initCssPaste.............................................................1244
;       →→→ §5.3.2: @doCssPaste...............................................................1272
;       →→→ §5.3.3: @pasteGitCommitMsg........................................................1333
;       →→→ §5.3.4: ExecuteCssPasteCmds.......................................................1349
;       →→→ §5.3.5: ExecuteJsPasteCmds........................................................1384
;   §6: COMMAND LINE INPUT GENERATION SHORTCUTS...............................................1424
;     >>> §6.1: GUIs for automating generation of command line input..........................1428
;     >>> §6.2: Shortucts for backing up custom CSS builds....................................1435
;       →→→ §6.2.1: @BackupCss................................................................1438
;       →→→ §6.2.2: @backupCssAscc............................................................1451
;       →→→ §6.2.3: @backupCssCr..............................................................1460
;       →→→ §6.2.4: @backupCssDsp.............................................................1469
;       →→→ §6.2.5: @backupCssFye.............................................................1478
;       →→→ §6.2.6: @backupCssFyf.............................................................1487
;       →→→ §6.2.7: @backupCssLsamp...........................................................1497
;       →→→ §6.2.8: @backupCssNse.............................................................1507
;       →→→ §6.2.9: @backupCssNsse............................................................1516
;       →→→ §6.2.10: @backupCssOue............................................................1525
;       →→→ §6.2.11: @backupCssPbk............................................................1534
;       →→→ §6.2.12: @backupCssSurca..........................................................1543
;       →→→ §6.2.13: @backupCssSumRes.........................................................1552
;       →→→ §6.2.14: @backupCssXfer...........................................................1561
;       →→→ §6.2.15: @backupCssUgr............................................................1570
;       →→→ §6.2.16: @backupCssXfer...........................................................1580
;       →→→ §6.2.17: @backupCssUcrAss.........................................................1589
;       →→→ §6.2.18: @backupCssAll............................................................1598
;       →→→ §6.2.19: CopyCssFromWebsite.......................................................1621
;       →→→ §6.2.20: ExecuteCssCopyCmds.......................................................1631
;     >>> §6.3: Shortcuts for rebuilding & committing custom CSS files........................1650
;       →→→ §6.3.1: @rebuildCssInRepo.........................................................1653
;       →→→ §6.3.2: @rebuildCssAll............................................................1662
;     >>> §6.4: Shortcuts for committing CSS builds...........................................1689
;       →→→ §6.4.1: @commitCssAscc............................................................1692
;       →→→ §6.4.2: @commitCssCr..............................................................1701
;       →→→ §6.4.3: @commitCssDsp.............................................................1710
;       →→→ §6.4.4: @commitCssFye.............................................................1719
;       →→→ §6.4.5: @commitCssFyf.............................................................1728
;       →→→ §6.4.6: @commitCssLsamp...........................................................1737
;       →→→ §6.4.7: @commitCssNse.............................................................1746
;       →→→ §6.4.8: @commitCssNsse............................................................1755
;       →→→ §6.4.9: @commitCssOue.............................................................1764
;       →→→ §6.4.10: @commitCssPbk............................................................1773
;       →→→ §6.4.11: @commitCssSurca..........................................................1782
;       →→→ §6.4.12: @commitCssSumRes.........................................................1791
;       →→→ §6.4.13: @commitCssXfer...........................................................1800
;       →→→ §6.4.14: @commitCssUgr............................................................1809
;       →→→ §6.4.15: @commitCssUcore..........................................................1818
;       →→→ §6.4.16: @commitCssUcrAss.........................................................1827
;     >>> §6.5: Shortcuts for updating CSS submodules.........................................1836
;       →→→ §6.5.1: @updateCssSubmoduleInRepo.................................................1839
;       →→→ §6.5.2: @updateCssSubmoduleAll....................................................1848
;     >>> §6.6: For copying minified, backup css files to clipboard...........................1876
;       →→→ §6.6.1: @copyMinCssAscc...........................................................1879
;       →→→ §6.6.2: @copyBackupCssAscc........................................................1889
;       →→→ §6.6.3: @copyMinCssCr.............................................................1899
;       →→→ §6.6.4: @copyBackupCssCr..........................................................1909
;       →→→ §6.6.5: @copyMinCssDsp............................................................1919
;       →→→ §6.6.6: @copyBackupCssDsp.........................................................1929
;       →→→ §6.6.7: @copyMinCssFye............................................................1939
;       →→→ §6.6.8: @copyBackupCssFye.........................................................1951
;       →→→ §6.6.9: @copyMinCssFyf............................................................1961
;       →→→ §6.6.10: @copyBackupCssFyf........................................................1971
;       →→→ §6.6.11: @copyBackupCssLsamp......................................................1981
;       →→→ §6.6.12: @copyMinCssLsamp.........................................................1991
;       →→→ §6.6.13: @copyMinCssNse...........................................................2001
;       →→→ §6.6.14: @copyBackupCssNse........................................................2011
;       →→→ §6.6.15: @copyMinCssNsse..........................................................2021
;       →→→ §6.6.16: @copyBackupCssNsse.......................................................2031
;       →→→ §6.6.17: @copyMinCssOue...........................................................2041
;       →→→ §6.6.18: @copyMinCssPbk...........................................................2051
;       →→→ §6.6.19: @copyBackupCssPbk........................................................2061
;       →→→ §6.6.20: @copyMinCssSurca.........................................................2071
;       →→→ §6.6.21: @copyBackupCssSurca......................................................2081
;       →→→ §6.6.22: @copyMinCssSumRes........................................................2091
;       →→→ §6.6.23: @copyBackupCssSumRes.....................................................2101
;       →→→ §6.6.24: @copyMinCssXfer..........................................................2111
;       →→→ §6.6.25: @copyBackupCssXfer.......................................................2121
;       →→→ §6.6.26: @copyMinCssUgr...........................................................2131
;       →→→ §6.6.27: @copyBackupCssUgr........................................................2142
;       →→→ §6.6.28: @copyMinCssUcore.........................................................2152
;       →→→ §6.6.29: @copyBackupCssUcore......................................................2162
;       →→→ §6.6.30: @copyMinCssUcrAss........................................................2172
;       →→→ §6.6.31: @copyBackupCssUcrAss.....................................................2182
;     >>> §6.7: FOR BACKING UP CUSTOM JS BUILDS...............................................2192
;       →→→ §6.7.1: BackupJs..................................................................2195
;       →→→ §6.7.2: @backupJsRepo.............................................................2212
;       →→→ §6.7.3: @backupJsAll..............................................................2221
;       →→→ §6.7.4: CopyJsFromWebsite.........................................................2248
;       →→→ §6.7.5: ExecuteJsCopyCmds.........................................................2259
;     >>> §6.8: FOR REBUILDING JS SOURCE FILES................................................2275
;       →→→ §6.8.1: RebuildJs.................................................................2278
;       →→→ §6.8.2: @rebuildJsAscc............................................................2289
;       →→→ §6.8.3: @rebuildJsCr..............................................................2296
;       →→→ §6.8.4: @rebuildJsDsp.............................................................2303
;       →→→ §6.8.5: @rebuildJsFye.............................................................2310
;       →→→ §6.8.6: @rebuildJsFyf.............................................................2329
;       →→→ §6.8.7: @rebuildJsNse.............................................................2348
;       →→→ §6.8.8: @rebuildJsOue.............................................................2367
;       →→→ §6.8.9: @rebuildJsPbk.............................................................2374
;       →→→ §6.8.10: @rebuildJsSurca..........................................................2393
;       →→→ §6.8.11: @rebuildJsSumRes.........................................................2400
;       →→→ §6.8.12: @rebuildJsXfer...........................................................2412
;       →→→ §6.8.13: @rebuildJsUgr............................................................2419
;       →→→ §6.8.14: @rebuildJsUcore..........................................................2431
;       →→→ §6.8.15: @rebuildJsUcrAss.........................................................2444
;     >>> §6.9: FOR UPDATING JS SUBMODULES....................................................2463
;       →→→ §6.9.1: @commitJsAscc.............................................................2466
;       →→→ §6.9.2: @commitJsCr...............................................................2475
;       →→→ §6.9.3: @commitJsDsp..............................................................2484
;       →→→ §6.9.4: @commitJsOue..............................................................2493
;       →→→ §6.9.5: @commitJsSurca............................................................2501
;       →→→ §6.9.6: @commitJsSumRes...........................................................2510
;       →→→ §6.9.7: @commitJsXfer.............................................................2519
;       →→→ §6.9.8: @commitJsUgr..............................................................2528
;       →→→ §6.9.9: @commitJsUcore............................................................2537
;       →→→ §6.9.10: @commitJsXfer............................................................2546
;     >>> §6.10: FOR UPDATING JS SUBMODULES...................................................2554
;       →→→ §6.10.1: UpdateJsSubmodule........................................................2557
;       →→→ §6.10.2: @updateJsSubmoduleAscc...................................................2576
;       →→→ §6.10.3: @updateJsSubmoduleCr.....................................................2583
;       →→→ §6.10.4: @updateJsSubmoduleDsp....................................................2591
;       →→→ §6.10.5: @updateJsSubmoduleFye....................................................2599
;       →→→ §6.10.6: @updateJsSubmoduleFyf....................................................2606
;       →→→ §6.10.7: @updateJsSubmoduleNse....................................................2614
;       →→→ §6.10.8: @updateJsSubmoduleOue....................................................2621
;       →→→ §6.10.9: @updateJsSubmodulePbk....................................................2628
;       →→→ §6.10.10: @updateJsSubmoduleSurca.................................................2635
;       →→→ §6.10.11: @updateJsSubmoduleSumRes................................................2642
;       →→→ §6.10.12: @updateJsSubmoduleXfer..................................................2650
;       →→→ §6.10.13: @updateJsSubmoduleUgr...................................................2658
;       →→→ §6.10.14: @updateJsSubmoduleUcore.................................................2665
;       →→→ §6.10.15: @updateJsSubmoduleUcrAss................................................2672
;       →→→ §6.10.16: @updateJsSubmoduleAll...................................................2680
;     >>> §6.11: Shortcuts for copying minified JS to clipboard...............................2707
;       →→→ §6.11.1: @copyMinJsAscc...........................................................2712
;       →→→ §6.11.2: @copyMinJsCr.............................................................2723
;       →→→ §6.11.3: @copyMinJsDsp............................................................2733
;       →→→ §6.11.4: @copyMinJsFye............................................................2744
;       →→→ §6.11.5: @copyMinJsFyf............................................................2755
;       →→→ §6.11.6: @copyMinJsNse............................................................2766
;       →→→ §6.11.7: @copyMinJsOue............................................................2777
;       →→→ §6.11.8: @copyBackupJsOue.........................................................2788
;       →→→ §6.11.9: @copyMinJsPbk............................................................2799
;       →→→ §6.11.10: @copyMinJsSurca.........................................................2810
;       →→→ §6.11.11: @copyMinJsSumRes........................................................2820
;       →→→ §6.11.12: @copyMinJsXfer..........................................................2831
;       →→→ §6.11.13: @copyMinJsUgr...........................................................2841
;       →→→ §6.11.14: @copyMinJsUcore.........................................................2851
;       →→→ §6.11.15: @copyBackupJsUcore......................................................2862
;       →→→ §6.11.16: @copyMinJsUcrAss........................................................2873
;     >>> §6.12: FOR CHECKING GIT STATUS ON ALL PROJECTS......................................2884
;   §7: KEYBOARD SHORTCUTS FOR POWERSHELL.....................................................2975
;     >>> §7.1: SHORTCUTS.....................................................................2979
;     >>> §7.2: SUPPORTING FUNCTIONS..........................................................3006
; ==================================================================================================

sgIsPostingMinCss := false
sgIsPostingMinJs := false

; --------------------------------------------------------------------------------------------------
;   §1: SETTINGS accessed via functions for this imported file
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §1.1: GetCmdForMoveToCSSFolder

GetCmdForMoveToCSSFolder(curDir) {
	cmd := ""
	needleStr := "^" . ToEscapedPath(GetGitHubFolder()) . "(.+)"
	posFound := RegExMatch(curDir, needleStr, matches)
	if(posFound > 0) {
		if( doesVarExist( matches1 ) && !doesVarExist( matches2 ) ) {
			cmd := "cd CSS"
		}
	}
	Return cmd
}

;   ································································································
;     >>> §1.2: GetCurrentDirFrom

GetCurrentDirFromPS() {
	copyDirCmd := "(get-location).ToString() | clip`r`n"
	PasteTextIntoGitShell("", copyDirCmd)
	while(Clipboard = copyDirCmd) {
		Sleep 100
	}
	Return Clipboard
}

;   ································································································
;     >>> §1.3: GetGitHubFolder

GetGitHubFolder() {
	global userAccountFolderSSD
	Return userAccountFolderSSD . "\GitHub"
}

;   ································································································
;     >>> §1.4: UserFolderIsSet

UserFolderIsSet() {
	global userAccountFolderSSD
	varDeclared := userAccountFolderSSD != thisIsUndeclared
	if (!varDeclared) {
		MsgBox, % (0x0 + 0x10), % "ERROR: Upstream dependency missing in github.ahk"
			, % "The global variable specifying the user's account folder has not been declared and"
. " set upstream."
	}
	Return varDeclared
}

; --------------------------------------------------------------------------------------------------
;   §2: FUNCTIONS for working with GitHub Desktop
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §2.1: ActivateGitShell

ActivateGitShell() {
	WinGet, thisProcess, ProcessName, A
	shellActivated := false
	if (thisProcess != "PowerShell.exe") {
		IfWinExist, % "ahk_exe PowerShell.exe"
		{
			WinActivate, % "ahk_exe PowerShell.exe"
			shellActivated := true
		}
	}
	else {
		shellActivated := true
	}
	Return shellActivated
}

;   ································································································
;     >>> §2.2: CommitAfterBuild

CommitAfterBuild(ahkBuildCmd, ahkCommitCmd) {
	ahkFuncName := "github.ahk: CommitAfterBuild"
	errorMsg := ""
	qcAhkBuildCmd := IsLabel(ahkBuildCmd)
	qcAhkCommitCmd := IsLabel(ahkCommitCmd)
	if (qcAhkBuildCmd && qcAhkCommitCmd) {
		MsgBox, % (0x4 + 0x20)
			, % ahkBuildCmd . ": Proceed with commit?"
			, % "Would you like to proceed with the commit command " . ahkCommitCmd . "?"
		IfMsgBox Yes
			Gosub, %ahkCommitCmd%
	} else {
		if (!qcAhkBuildCmd) {
			errorMsg .= "Function was called with an invalid argument for the calling build command"
. ": " . ahkBuildCmd . "."
			if (!qcAhkCommitCmd) {
				errorMsg .= "The argument for the commit command to call next was also invalid: "
. ahkCommitCmd . "."
			}		
		} else {
			errorMsg .= "Function was called from the build command " . ahkBuildCmd . ", but an inv"
. "alid argument for the commit command was found: " . ahkCommitCmd . "."
		}
	}
	if (errorMsg != "") {
		MsgBox, % (0x0 + 0x10)
			, % "Error in " . ahkFuncName
			, % errorMsg
	}
}

;   ································································································
;     >>> §2.3: EscapeCommitMessage
;       Escape commit message strings for use in PowerShell. Assumes that double quotes are used to
;       enclose the string.

EscapeCommitMessage(msgToEscape) {
	escapedMsg := RegExReplace(msgToEscape, "m)("")", "`$1")
	return escapedMsg
}

;   ································································································
;     >>> §2.4: Git commit GUI — Imports

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §2.4.1: For committing CSS builds

#Include %A_ScriptDir%\GitHub\CommitCssBuild.ahk

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §2.4.2: For committing JS builds

#Include %A_ScriptDir%\GitHub\CommitJsBuild.ahk

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §2.4.3: For committing any type of file

#Include %A_ScriptDir%\GitHub\CommitAnyFile.ahk

;   ································································································
;     >>> §2.5: CopySrcFileToClipboard

CopySrcFileToClipboard(ahkCmdName, srcFileToCopy, strToPrepend, errorMsg) {
	if (UserFolderIsSet()) {
		srcFile := FileOpen(srcFileToCopy, "r")
		if (srcFile != 0) {
			contents := srcFile.Read()
			srcFile.Close()
			clipboard := strToPrepend . contents
		}
		else {
			MsgBox, % (0x0 + 0x10), % "ERROR (" . ahkCmdName . ")", % errorMsg . "`rCAUSE = Failed "
. "to open file: " . srcFile
		}
	} else {
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ahkCmdName . ")", % errorMsg . "`rCAUSE = User folder"
. " is not set."
	}
}

;   ································································································
;     >>> §2.6: IsGitShellActive

IsGitShellActive() {
	Return IsPowerShellActive()
}

;   ································································································
;     >>> §2.7: PasteTextIntoGitShell

PasteTextIntoGitShell(ahkCmdName, shellText) {
	errorMsg := ""
	if (UserFolderIsSet()) {
		proceedWithPaste := ActivateGitShell()
		if (proceedWithPaste) {
			SendInput, {Esc}
			Sleep, 20
			GetCursorCoordsToCenterInActiveWindow(newPosX, newPosY)
			clipboard = %shellText%
			Click right %newPosX%, %newPosY%
		} else {
			errorMsg := "Was unable to activate GitHub Powershell; aborting hotstring."
		}
	} else {
		errorMsg := "Because user folder is not set, location of GitHub is unknown."
	}
	if (errorMsg != "") {
		MsgBox, % (0x0 + 0x10)
			, % ahkCmdName . ": Error in Call to PasteTextIntoGitShell"
			, % errorMsg
	}
}

;   ································································································
;     >>> §2.8: ToEscapedPath

ToEscapedPath(path) {
	escapedPath := StrReplace(path, "\", "\\")
	Return escapedPath
}

;   ································································································
;     >>> §2.9: VerifyCopiedCode

VerifyCopiedCode(callerStr, copiedCss) {
	proceed := False
	title := "VerifyCopiedCode(...)"
	msg := "Here's what I copied:`n" . SubStr(copiedCss, 1, 320) . "...`n`nProceed with git commit?"
	MsgBox, 33, % title, % msg
	IfMsgBox, OK
		proceed := True
	Return proceed
}

; --------------------------------------------------------------------------------------------------
;   §3: FUNCTIONS for interacting with online WEB DESIGN INTERFACES
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §3.1: LoadWordPressSiteInChrome

LoadWordPressSiteInChrome(websiteUrl) {
	WinGet, thisProcess, ProcessName, A
	if (thisProcess != "chrome.exe") {
		WinActivate, % "ahk_exe chrome.exe"
		WinGet, thisProcess, ProcessName, A
	}
	if (thisProcess = "chrome.exe") {
		WinRestore, A
		WinGetPos, thisX, thisY, thisW, thisH, A
		if (thisX != -1830 or thisY != 0 or thisW != 1700 or thisH != 1040) {
			WinMove, A, , -1830, 0, 1700, 1040
		}
		Sleep, 330
		SendInput, ^t
		Sleep, 1000
		SendInput, !d
		Sleep, 200
		SendInput, % websiteUrl . "{Enter}"
		Sleep, 500
		proceed := false
		WinGetTitle, thisTitle, A
		IfNotInString, thisTitle, % "New Tab"
			proceed := true
		while (!proceed) {
			Sleep 500
			WinGetTitle, thisTitle, A
			IfNotInString, thisTitle, % "New Tab"
				proceed := true
		}
		Sleep, 500
	}
}

; --------------------------------------------------------------------------------------------------
;   §4: GUI FUNCTIONS for handling user interactions with scripts
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §4.1: @postMinCss

:*:@postMinCss::
	AppendAhkCmd(A_ThisLabel)
	if(!sgIsPostingMinCss) {
		Gui, guiPostMinCss: New,, % "Post Minified CSS to OUE Websites"
		Gui, guiPostMinCss: Add, Text, , % "Post minified CSS in:"
		Gui, guiPostMinCss: Add, Radio, Checked Y+0 vRadioGroupPostMinCssAutoMode
			, % "Automatic mode (&1)`n"
		Gui, guiPostMinCss: Add, Radio, Y+0, % "Manual mode (&2)"
		Gui, guiPostMinCss: Add, Text,, % "Which OUE Websites would you like to update?"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToAscc, % "https://&ascc.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToCr, % "https://commonread&ing.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToDsp Checked
			, % "https://&distinguishedscholarships.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToFye Checked, % "https://&firstyear.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToFyf Checked
			, % "https://&learningcommunities.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToNse Checked, % "https://&nse.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToNsse Checked, % "https://nsse.wsu.edu (&b)"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToPbk Checked
			, % "https://&phibetakappa.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToSurca Checked, % "https://&surca.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToSumRes Checked
			, % "https://su&mmerresearch.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToXfer, % "https://&transfercredit.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToUgr Checked
			, % "https://&undergraduateresearch.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToUcore Checked, % "https://uco&re.wsu.edu"
		Gui, guiPostMinCss: Add, CheckBox, vPostMinCssToUcrAss Checked
			, % "https://ucor&e.wsu.edu/assessment"
		Gui, guiPostMinCss: Add, Button, Default gHandlePostMinCssOK, &OK
		Gui, guiPostMinCss: Add, Button, gHandlePostMinCssCancel X+5, &Cancel
		Gui, guiPostMinCss: Add, Button, gHandlePostCssCheckAllSites X+15, C&heck All
		Gui, guiPostMinCss: Add, Button, gHandlePostCssUncheckAllSites X+5, Unchec&k All
		Gui, guiPostMinCss: Show
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.1: HandlePostCssCheckAllSites

HandlePostCssCheckAllSites() {
	global
	GuiControl, guiPostMinCss:, PostMinCssToAscc, 1
	GuiControl, guiPostMinCss:, PostMinCssToCr, 1
	GuiControl, guiPostMinCss:, PostMinCssToDsp, 1
	GuiControl, guiPostMinCss:, PostMinCssToFye, 1
	GuiControl, guiPostMinCss:, PostMinCssToFyf, 1
	GuiControl, guiPostMinCss:, PostMinCssToNse, 1
	GuiControl, guiPostMinCss:, PostMinCssToNsse, 1
	GuiControl, guiPostMinCss:, PostMinCssToPbk, 1
	GuiControl, guiPostMinCss:, PostMinCssToSurca, 1
	GuiControl, guiPostMinCss:, PostMinCssToSumRes, 1
	GuiControl, guiPostMinCss:, PostMinCssToXfer, 1
	GuiControl, guiPostMinCss:, PostMinCssToUgr, 1
	GuiControl, guiPostMinCss:, PostMinCssToUcore, 1
	GuiControl, guiPostMinCss:, PostMinCssToUcrAss, 1
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.2: HandlePostCssUncheckAllSites

HandlePostCssUncheckAllSites() {
	global
	GuiControl, guiPostMinCss:, PostMinCssToAscc, 0
	GuiControl, guiPostMinCss:, PostMinCssToCr, 0
	GuiControl, guiPostMinCss:, PostMinCssToDsp, 0
	GuiControl, guiPostMinCss:, PostMinCssToFye, 0
	GuiControl, guiPostMinCss:, PostMinCssToFyf, 0
	GuiControl, guiPostMinCss:, PostMinCssToNse, 0
	GuiControl, guiPostMinCss:, PostMinCssToNsse, 0
	GuiControl, guiPostMinCss:, PostMinCssToPbk, 0
	GuiControl, guiPostMinCss:, PostMinCssToSurca, 0
	GuiControl, guiPostMinCss:, PostMinCssToSumRes, 0
	GuiControl, guiPostMinCss:, PostMinCssToXfer, 0
	GuiControl, guiPostMinCss:, PostMinCssToUgr, 0
	GuiControl, guiPostMinCss:, PostMinCssToUcore, 0
	GuiControl, guiPostMinCss:, PostMinCssToUcrAss, 0
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.3: HandlePostMinCssCancel

HandlePostMinCssCancel() {
	Gui, guiPostMinCss: Destroy
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.4: HandlePostMinCssOK

HandlePostMinCssOK() {
	global
	Gui, guiPostMinCss: Submit
	Gui, guiPostMinCss: Destroy
	sgIsPostingMinCss := true
	local postMinCssAutoMode := false
	if (RadioGroupPostMinCssAutoMode == 2) {
		postMinCssAutoMode := true
	}
	if (PostMinCssToAscc) {
		PasteMinCssToWebsite("https://ascc.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssAscc", postMinCssAutoMode)
	}
	if (PostMinCssToCr) {
		PasteMinCssToWebsite("https://commonreading.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssCr", postMinCssAutoMode)
	}
	if (PostMinCssToDsp) {
		PasteMinCssToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?page=ed"
. "itcss", ":*:@copyMinCssDsp", postMinCssAutoMode)
	}
	if (PostMinCssToFye) {
		PasteMinCssToWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssFye", postMinCssAutoMode)
	}
	if (PostMinCssToFyf) {
		PasteMinCssToWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssFyf", postMinCssAutoMode)
	}
	if (PostMinCssToNse) {
		PasteMinCssToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssNse", postMinCssAutoMode)
	}
	if (PostMinCssToNsse) {
		PasteMinCssToWebsite("https://stage.web.wsu.edu/wsu-nsse/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssNsse", postMinCssAutoMode)
	}
	if (PostMinCssToPbk) {
		PasteMinCssToWebsite("https://phibetakappa.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssPbk", postMinCssAutoMode)
	}
	if (PostMinCssToSurca) {
		PasteMinCssToWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssSurca", postMinCssAutoMode)
	}
	if (PostMinCssToSumRes) {
		PasteMinCssToWebsite("https://summerresearch.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssSumRes", postMinCssAutoMode)
	}
	if (PostMinCssToXfer) {
		PasteMinCssToWebsite("https://transfercredit.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssXfer", postMinCssAutoMode)
	}
	if (PostMinCssToUgr) {
		PasteMinCssToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page=editcs"
. "s", ":*:@copyMinCssUgr", postMinCssAutoMode)
	}
	if (PostMinCssToUcore) {
		PasteMinCssToWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssUcore", postMinCssAutoMode)
	}
	if (PostMinCssToUcrAss) {
		PasteMinCssToWebsite("https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=editcss"
			, ":*:@copyMinCssUcrAss", postMinCssAutoMode)
	}
	sgIsPostingMinCss := false
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.1.5: PasteMinCssToWebsite

PasteMinCssToWebsite(websiteUrl, cssCopyCmd, manualProcession := false) {
	delay := 1000
	LoadWordPressSiteInChrome(websiteUrl)
	Gosub, %cssCopyCmd%
	Sleep, % delay
	ExecuteCssPasteCmds(manualProcession)
}

;   ································································································
;     >>> §4.2: @postBackupCss

:*:@postBackupCss::
	AppendAhkCmd(A_ThisLabel)
	if(!sgIsPostingBackupCss) {
		Gui, guiPostBackupCss: New,
			, % "Post Minified CSS to OUE Websites"
		Gui, guiPostBackupCss: Add, Text,
			, % "Which OUE Websites would you like to update?"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToAscc
			, % "https://&ascc.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToCr
			, % "https://commonread&ing.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToDsp Checked
			, % "https://&distinguishedscholarships.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToFye Checked
			, % "https://&firstyear.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToFyf Checked
			, % "https://&learningcommunities.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToNse Checked
			, % "https://&nse.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToNsse Checked
			, % "https://nsse.wsu.edu (&b)"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToPbk Checked
			, % "https://&phibetakappa.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToSurca Checked
			, % "https://&surca.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToSumRes Checked
			, % "https://su&mmerresearch.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToXfer
			, % "https://&transfercredit.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToUgr Checked
			, % "https://&undergraduateresearch.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToUcore Checked
			, % "https://uco&re.wsu.edu"
		Gui, guiPostBackupCss: Add, CheckBox, vPostBackupCssToUcrAss Checked
			, % "https://ucor&e.wsu.edu/assessment"
		Gui, guiPostBackupCss: Add, Button, Default gHandlePostBackupCssOK, &OK
		Gui, guiPostBackupCss: Add, Button, gHandlePostBackupCssCancel X+5, &Cancel
		Gui, guiPostBackupCss: Add, Button, gHandlePostBackupCssCheckAllSites X+15, C&heck All
		Gui, guiPostBackupCss: Add, Button, gHandlePostBackupCssUncheckAllSites X+5, Unchec&k All
		Gui, guiPostBackupCss: Show
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.1: HandlePostBackupCssCheckAllSites

HandlePostBackupCssCheckAllSites() {
	global
	GuiControl, guiPostBackupCss:, PostBackupCssToAscc, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToCr, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToDsp, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToFye, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToFyf, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToNse, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToNsse, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToPbk, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToSurca, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToSumRes, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToXfer, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToUgr, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToUcore, 1
	GuiControl, guiPostBackupCss:, PostBackupCssToUcrAss, 1
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.2: HandlePostBackupCssUncheckAllSites

HandlePostBackupCssUncheckAllSites() {
	global
	GuiControl, guiPostBackupCss:, PostBackupCssToAscc, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToCr, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToDsp, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToFye, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToFyf, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToNse, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToNsse, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToPbk, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToSurca, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToSumRes, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToXfer, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToUgr, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToUcore, 0
	GuiControl, guiPostBackupCss:, PostBackupCssToUcrAss, 0
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.3: HandlePostBackupCssCancel

HandlePostBackupCssCancel() {
	Gui, guiPostBackupCss: Destroy
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.2.4: HandlePostBackupCssOK

HandlePostBackupCssOK() {
	global
	Gui, guiPostBackupCss: Submit
	Gui, guiPostBackupCss: Destroy
	sgIsPostingBackupCss := true
	if (PostMinCssToAscc) {
		PasteMinCssToWebsite("https://ascc.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssAscc")
	}
	if (PostMinCssToCr) {
		PasteMinCssToWebsite("https://commonreading.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssCr")
	}
	if (PostBackupCssToDsp) {
		PasteMinCssToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?page=ed"
. "itcss", ":*:@copyBackupCssDsp")
	}
	if (PostBackupCssToFye) {
		PasteMinCssToWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssFye")
	}
	if (PostBackupCssToFyf) {
		PasteMinCssToWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssFyf")
	}
	if (PostBackupCssToNse) {
		PasteMinCssToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssNse")
	}
	if (PostBackupCssToNsse) {
		PasteMinCssToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssNsse")
	}
	if (PostBackupCssToPbk) {
		PasteMinCssToWebsite("https://phibetakappa.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssPbk")
	}
	if (PostBackupCssToSurca) {
		PasteMinCssToWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssSurca")
	}
	if (PostBackupCssToSumRes) {
		PasteMinCssToWebsite("https://summerresearch.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssSumRes")
	}
	if (PostBackupCssToXfer,) {
		PasteMinCssToWebsite("https://transfercredit.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssXfer")
	}
	if (PostBackupCssToUgr) {
		PasteMinCssToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page=editcs"
. "s", ":*:@copyBackupCssUgr")
	}
	if (PostBackupCssToUcore) {
		PasteMinCssToWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssUcore")
	}
	if (PostBackupCssToUcrAss) {
		PasteMinCssToWebsite("https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssUcrAss")
	}
	sgIsPostingBackupCss := false
}

;   ································································································
;     >>> §4.3: @postMinJs

:*:@postMinJs::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	if(!sgIsPostingMinJs) {
		Gui, guiPostMinJs: New,
			, % "Post Minified JS to OUE Websites"
		Gui, guiPostMinJs: Add, Text,
			, % "Post minified JS in:"
		Gui, guiPostMinJs: Add, Radio, Checked Y+0 vRadioGroupPostMinJsAutoMode
			, % "Automatic mode (&1)`n"
		Gui, guiPostMinJs: Add, Radio, Y+0
			, % "Manual mode (&2)"
		Gui, guiPostMinJs: Add, Text, Y+16
			, % "Which OUE Websites would you like to update?"
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToAscc
			, % "https://&ascc.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToCr
			, % "https://commonread&ing.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToDsp Checked
			, % "https://&distinguishedscholarships.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToFye Checked
			, % "https://&firstyear.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToFyf Checked
			, % "https://&learningcommunities.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToNse Checked
			, % "https://&nse.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToPbk Checked
			, % "https://&phibetakappa.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToSurca Checked
			, % "https://&surca.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToSumRes Checked
			, % "https://su&mmerresearch.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToXfer
			, % "https://&transfercredit.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToUgr Checked
			, % "https://&undergraduateresearch.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToUcore Checked
			, % "https://uco&re.wsu.edu"		
		Gui, guiPostMinJs: Add, CheckBox, vPostMinJsToUcrAss Checked
			, % "https://ucore.wsu.edu/&assessment"
		Gui, guiPostMinJs: Add, Button, Default Y+16 gHandlePostMinJsOK, &OK
		Gui, guiPostMinJs: Add, Button, gHandlePostMinJsCancel X+5, &Cancel
		Gui, guiPostMinJs: Add, Button, gHandlePostJsCheckAllSites X+15, C&heck All
		Gui, guiPostMinJs: Add, Button, gHandlePostJsUncheckAllSites X+5, Unchec&k All
		Gui, guiPostMinJs: Show
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.1: HandlePostJsCheckAllSites

HandlePostJsCheckAllSites() {
	global
	GuiControl, guiPostMinJs:, PostMinJsToAscc, 1
	GuiControl, guiPostMinJs:, PostMinJsToCr, 1
	GuiControl, guiPostMinJs:, PostMinJsToDsp, 1
	GuiControl, guiPostMinJs:, PostMinJsToFye, 1
	GuiControl, guiPostMinJs:, PostMinJsToFyf, 1
	GuiControl, guiPostMinJs:, PostMinJsToNse, 1
	GuiControl, guiPostMinJs:, PostMinJsToPbk, 1
	GuiControl, guiPostMinJs:, PostMinJsToSurca, 1
	GuiControl, guiPostMinJs:, PostMinJsToSumRes, 1
	GuiControl, guiPostMinJs:, PostMinJsToXfer, 1
	GuiControl, guiPostMinJs:, PostMinJsToUgr, 1
	GuiControl, guiPostMinJs:, PostMinJsToUcore, 1
	GuiControl, guiPostMinJs:, PostMinJsToUcrAss, 1
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.2: HandlePostJsUncheckAllSites

HandlePostJsUncheckAllSites() {
	global
	GuiControl, guiPostMinJs:, PostMinJsToAscc, 0
	GuiControl, guiPostMinJs:, PostMinJsToCr, 0
	GuiControl, guiPostMinJs:, PostMinJsToDsp, 0
	GuiControl, guiPostMinJs:, PostMinJsToFye, 0
	GuiControl, guiPostMinJs:, PostMinJsToFyf, 0
	GuiControl, guiPostMinJs:, PostMinJsToNse, 0
	GuiControl, guiPostMinJs:, PostMinJsToPbk, 0
	GuiControl, guiPostMinJs:, PostMinJsToSurca, 0
	GuiControl, guiPostMinJs:, PostMinJsToSumRes, 0
	GuiControl, guiPostMinJs:, PostMinJsToXfer, 0
	GuiControl, guiPostMinJs:, PostMinJsToUgr, 0
	GuiControl, guiPostMinJs:, PostMinJsToUcore, 0
	GuiControl, guiPostMinJs:, PostMinJsToUcrAss, 0
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.3: HandlePostMinJsCancel

HandlePostMinJsCancel() {
	Gui, Destroy
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.4: HandlePostMinJsOK

HandlePostMinJsOK() {
	global
	Gui, Submit
	Gui, Destroy
	sgIsPostingMinJs := true
	local postMinJsAutoMode := false
	if (RadioGroupPostMinJsAutoMode == 2) {
		postMinJsAutoMode := true
	}
	if (PostMinJsToAscc) {
		PasteMinJsToWebsite("https://ascc.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsAscc", postMinJsAutoMode)
	}
	if (PostMinJsToCr) {
		PasteMinJsToWebsite("https://commonreading.wsu.edu/wp-admin/themes.php?page=custom-javascri"
. "pt", ":*:@copyMinJsCr", postMinJsAutoMode)
	}
	if (PostMinJsToDsp) {
		PasteMinJsToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?page=cus"
. "tom-javascript", ":*:@copyMinJsDsp", postMinJsAutoMode)
	}
	if (PostMinJsToFye) {
		PasteMinJsToWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsFye", postMinJsAutoMode)
	}
	if (PostMinJsToFyf) {
		PasteMinJsToWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=custom-ja"
. "vascript", ":*:@copyMinJsFyf", postMinJsAutoMode)
	}
	if (PostMinJsToNse) {
		PasteMinJsToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsNse", postMinJsAutoMode)
	}
	if (PostMinJsToPbk) {
		PasteMinJsToWebsite("https://phibetakappa.wsu.edu/wp-admin/themes.php?page=custom-javascrip"
. "t", ":*:@copyMinJsPbk", postMinJsAutoMode)
	}
	if (PostMinJsToSurca) {
		PasteMinJsToWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsSurca", postMinJsAutoMode)
	}
	if (PostMinJsToSumRes) {
		PasteMinJsToWebsite("https://summerresearch.wsu.edu/wp-admin/themes.php?page=custom-javascr"
. "ipt", ":*:@copyMinJsSumRes", postMinJsAutoMode)
	}
	if (PostMinJsToXfer) {
		PasteMinJsToWebsite("https://transfercredit.wsu.edu/wp-admin/themes.php?page=custom-javascr"
. "ipt", ":*:@copyMinJsXfer", postMinJsAutoMode)
	}
	if (PostMinJsToUgr) {
		PasteMinJsToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page=custom-"
. "javascript", ":*:@copyMinJsUgr", postMinJsAutoMode)
	}
	if (PostMinJsToUcore) {
		PasteMinJsToWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsUcore", postMinJsAutoMode)
	}
	if (PostMinJsToUcrAss) {
		PasteMinJsToWebsite("https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=custom-javas"
. "cript", ":*:@copyMinJsUcrAss", postMinJsAutoMode)
	}
	sgIsPostingMinJs := false
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §4.3.5: PasteMinJsToWebsite

PasteMinJsToWebsite(websiteUrl, jsCopyCmd, manualProcession := false) {
	LoadWordPressSiteInChrome(websiteUrl)
	if (manualProcession) {
		MsgBox, 48, % "ExecuteJsPasteCmds", % "Press OK to proceed with " . jsCopyCmd . " command."
	} else {
		Sleep, 1000
	}
	Gosub, %jsCopyCmd%
	Sleep, 120
	ExecuteJsPasteCmds(manualProcession)
}

; --------------------------------------------------------------------------------------------------
;   §5: UTILITY HOTSTRINGS for working with GitHub Desktop
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §5.1: FILE COMMITTING
; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@getGitCommitLog::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel, "git log -p --since='last month' --pretty=format:'%h|%an|%ar|"
. "%s|%b' > git-log.txt`r")
Return

:*:@getNoDiffGitCommitLog::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel, "git log --since='last month' --pretty=format:'%h|%an|%ar|%s|"
. "%b' > git-log.txt`r")
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@findGitChangesRegEx::
	targetProcesses := ["notepad++.exe", "sublime_text.exe"]
	notActiveErrMsg := "Please ensure Notepad++ or Sublime Text are active before activating this h"
. "otstring."

	AppendAhkCmd(A_ThisLabel)
	activeProcessName := areTargetProcessesActive(targetProcesses, A_ThisLabel, notActiveErrMsg)
	if (activeProcessName == targetProcess[1]) {
		FindGitChangesRegExNotepadPp()
	} else {
		FindGitChangesRegExSublimeText()		
	}
Return

FindGitChangesRegExNotepadPp() {
	SendInput, % "^h"
	Sleep, 200
	SendInput, % "{^}(?:[{^} -].*| (?{!} {{}7{}}).*|-(?{!}-{{}7{}}).*)?$(?:\r\n)?"
	Sleep, 20
	SendInput, % "{Tab}"
	Sleep, 20
	SendInput, % "{Del}"
}

FindGitChangesRegExSublimeText() {
	delay := 60
	SendInput, % "{Esc}"
	Sleep, % delay
	SendInput, % "^h"
	Sleep, % delay * 4
	SendInput, % "{^}(?:[{^}\n \-].*| (?{!} {{}7{}}).*|-(?{!}-{{}7{}}).*)?$(?:\n?)"
	Sleep, % delay
	SendInput, % "{Tab}"
	Sleep, % delay
	SendInput, % "^a"
	Sleep, % delay
	SendInput, % "{Del}"
}

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@gitAddThis::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	WinGet, thisProcess, ProcessName, A
	if (thisProcess = "notepad++.exe") {
		SendInput !e
		Sleep 100
		SendInput {Down 8}
		Sleep 100
		SendInput {Right}
		Sleep 100
		SendInput {Down}
		Sleep 100
		SendInput {Enter}
		Sleep 100
		commitText := RegExReplace(clipboard, "^(.*)", "git add $1")
		clipboard = %commitText%
	} else {
		MsgBox, % (0x0 + 0x10), % "ERROR: Notepad++ Not Active"
			, % "Please activate Notepad++ and ensure the correct file is selected before attemptin"
. "g to utilize this hotstring, which is designed to create a 'git add' command for pasting into Po"
. "werShell based on Notepad++'s Edit > Copy to Clipboard > Current Full File Path to Clipboard men"
. "u command."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@doGitCommit::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput git commit -m '' -m ''{Left 7}
	}
	else {
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ":*:@doGitCommit" . "): Could Not Locate Git PowerShe"
. "ll"
		, % "The Git PowerShell process could not be located and activated."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@dogc::
	Gosub, :*:@doGitCommit
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@doSnglGitCommit::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput git commit -m ''{Left 1}
	}
	else {
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ":*:@doSnglGitCommit" . "): Could Not Locate Git Powe"
. "rShell"
		, % "The Git PowerShell process could not be located and activated."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@dosgc::
	Gosub, :*:@doSnglGitCommit
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

; For reversing forward slashes within a copied file name reported by 'git status' in PowerShell 
; and then pasting the result into PowerShell.
:*:@swapSlashes::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	WinGet, thisProcess, ProcessName, A
	if (thisProcess = "PowerShell.exe") {
		newText := RegExReplace(clipboard, "/", "\")
		clipboard := newText

		;TODO: Check to see if the mouse cursor is already within the PowerShell bounding rectangle 
		Click right 44, 55

	}    
Return

;   ································································································
;     >>> §5.2: STATUS CHECKING

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.1: @doGitStataus & @dogs
;
;	Shortcut for "git status" command in PowerShell.

:*:@doGitStatus::
	AppendAhkCmd(A_ThisLabel)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput % "git status{enter}"
	} else {
		MsgBox % (0x0 + 0x10), % "ERROR (" . A_ThisLabel . "): Could Not Locate Git PowerShell"
			, % "The Git PowerShell process could not be located and activated."
	}
Return

:*:@dogs::
	Gosub :*:@doGitStatus
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.2: @doGitDiff & @dogd
;
;	Shortcut for "git diff" command in PowerShell.

:*:@doGitDiff::
	AppendAhkCmd(A_ThisLabel)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput % "git --no-pager diff "
	} else {
		MsgBox % (0x0 + 0x10), % "ERROR (" . A_ThisLabel . "): Could Not Locate Git PowerShell"
			, % "The Git PowerShell process could not be located and activated."
	}
Return

:*:@dogd::
	Gosub :*:@doGitDiff
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.3: @doGitLog & @dogl
;
;	Shortcut for "git log" command in PowerShell.

:*:@doGitLog::
	AppendAhkCmd(A_ThisLabel)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput % "git --no-pager log --follow --pretty=""format:%h | %cn | %cd | %s | %b"" -20 "
	} else {
		MsgBox % (0x0 + 0x10), % "ERROR (" . A_ThisLabel . "): Could Not Locate Git PowerShell"
			, % "The Git PowerShell process could not be located and activated."
	}
Return

:*:@dogl::
	Gosub :*:@doGitLog
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.2.5: @doNoFollowGitLog & @donfgl
;
;	Shortcut for "git log" command in PowerShell, but without the follow directive.

:*:@doNoFollowGitLog::
	AppendAhkCmd(A_ThisLabel)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput % "git --no-pager log --pretty=""format:%h | %cn | %cd | %s | %b"" -20"
	} else {
		MsgBox % (0x0 + 0x10), % "ERROR (" . A_ThisLabel . "): Could Not Locate Git PowerShell"
			, % "The Git PowerShell process could not be located and activated."
	}
Return

:*:@donfgl::
	Gosub :*:@doNoFollowGitLog
Return

;   ································································································
;     >>> §5.3: Automated PASTING OF CSS/JS into online web interfaces

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.3.1: @initCssPaste
;
;	Initialize a tab in Chrome for automated repeated CSS pasting.

:*:@initCssPaste::
;	prevTitleMatchMode := A_TitleMatchMode
;	SetTitleMatchMode, RegEx
;	SetTitleMatchMode, prevTitleMatchMode
	global hwndCssPasteWindow
	global titleCssPasteWindowTab
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	WinGetTitle, thisTitle, A
	posFound := RegExMatch(thisTitle, "i)^CSS[^" . Chr(0x2014) . "]+" . Chr(0x2014) . " WordPress -"
. " Google Chrome$")
	if(posFound) {
		WinGet, hwndCssPasteWindow, ID, A
		titleCssPasteWindowTab := thisTitle
		MsgBox, % "HWND for window containing CSS stylsheet editor set to " . hwndCssPasteWindow
	}
	else {
		MsgBox, % (0x0 + 0x10), % "ERROR (:*:@setCssPasteWindow): CSS Stylesheet Editor Not Active"
			, % "Please select your CSS stylesheet editor tab in Chrome as the currently active win"
. "dow."
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.3.2: @doCssPaste
;
;	Paste CSS into a tab in Chrome previously initialized by the @initCssPaste command.

:*:@doCssPaste::		;Paste copied CSS into WordPress window
	global hwndCssPasteWindow
	global titleCssPasteWindowTab
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	if(isVarDeclared(hwndCssPasteWindow)) {
		; Attempt to switch to chrome
		WinActivate, % "ahk_id " . hwndCssPasteWindow
		WinWaitActive, % "ahk_id " . hwndCssPasteWindow, , 1
		if (ErrorLevel) {
			MsgBox, % (0x0 + 0x10), % "ERROR (:*:@doCssPaste): Could Not Find Process"
				, % "The HWND set for the chrome window containing the tab in which the CSS stylesh"
. "eet editor was loaded can no longer be found."
		}
		else {
			WinGetTitle, thisTitle, A
			if(thisTitle != titleCssPasteWindowTab) {
				startingTitle := thistTitle
				SendInput, ^{Tab}
				Sleep 100
				WinGetTitle, currentTitle, A
				while (currentTitle != startingTitle and currentTitle != titleCssPasteWindowTab) {
					SendInput, ^{Tab}
					Sleep 100
					WinGetTitle, currentTitle, A
				}
				if(currentTitle != titleCssPasteWindowTab) {
					MsgBox, % (0x0 + 0x10), % "ERROR (:*:@doCssPaste): Couldn't Find Tab"
						, % "Could not locate the tab containing the CSS stylesheet editor."
				}
				else {
					proceedWithPaste := true
				}
			}
			else {
				proceedWithPaste := true
			}
			if (proceedWithPaste) {
				; Add check for expected client coordinates; if not correct, then reset window 
				; position
				WinRestore, A
				WinGetPos, thisX, thisY, thisW, thisH, A
				if (thisX != -1830 or thisY != 0 or thisW != 1700 or thisH != 1040) {
					WinMove, A, , -1830, 0, 1700, 1040
				}
				ExecuteCssPasteCmds()
			}
		}
	}
	else {
		MsgBox, % (0x0 + 0x10), % "ERROR (:*:@doCssPaste): HWND Not Set Yet"
			, % "You haven't yet used the @setCssPasteWindow hotstring to set the HWND for the Chro"
. "me window containing a tab with the CSS stylsheet editor."
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.3.3: @pasteGitCommitMsg
;
;	Paste commit messages copied from GitHub.com into PowerShell with proper formatting.

:*:@pasteGitCommitMsg::
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	WinGet, thisProcess, ProcessName, A
	if (thisProcess = "PowerShell.exe") {
		commitText := RegExReplace(clipboard, Chr(0x2026) "\R" Chr(0x2026), "")
		clipboard = %commitText%
		Click right 44, 55
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.3.4: ExecuteCssPasteCmds
;
;	Perform the steps necessary to paste built CSS into a Chrome tab loaded with a WSUWP CSS
;	Stylesheet Editor page and apply it to the according website.

ExecuteCssPasteCmds(manualProcession := false) {
	; Add check for correct CSS in clipboard — the first line is a font import.
	posFound := RegExMatch(clipboard
		, "i)/\*! .*built with the Less CSS preprocessor.*github\.com/invokeImmediately")
	if (posFound != 0) {
		Click, 768, 570
		Sleep, 100
		SendInput, ^a
		Sleep 330
		if (manualProcession) {
			MsgBox, 48, % A_ThisFunc, % "Press OK to proceed with paste command."
		}
		SendInput, ^v
		Sleep 330
		if (manualProcession) {
			MsgBox, 48, % A_ThisFunc, % "Press OK to proceed with update button selection."
		}
		Click, 1565, 370
		Sleep, 60
		Click, 1565, 405
		Sleep, 60
	} else {
		MsgBox, % (0x0 + 0x10)
			, % "ERROR (" . A_ThisFunc .  "): Clipboard Has Unexpected Contents"
			, % "The clipboard does not begin with the expected inline documentation and thus may n"
. "ot contain minified CSS."
	}			
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §5.3.5: ExecuteJsPasteCmds
;
;	Perform the steps necessary to paste built JS into a Chrome tab loaded with a WSUWP Custom
;	Javascript Editor page and apply it to the according website.

ExecuteJsPasteCmds(manualProcession := false) {
	; Add check for correct CSS in clipboard — the first line is a font import.
	posFound := RegExMatch(clipboard, "^(?:// Built with Node.js)|(?:/\*!\*+`n \* jQuery.oue-custom"
. ".js)")
	if (posFound != 0) {
		Click, 461, 371
		Sleep, 330
		SendInput, ^a
		if (manualProcession) {
			MsgBox, 48, % A_ThisFunc, % "Press OK to proceed with paste command."
			Sleep 330
		} else {
			Sleep, 2500
		}
		SendInput, ^v
		if (manualProcession) {
			MsgBox, 48, % A_ThisFunc, % "Press OK to proceed with update button selection."
			Sleep 330
		} else {
			Sleep, 10000
		}
		Click, 214, 565
		Sleep, 60
		Click, 214, 615
		Sleep 1000
	}
	else {
		MsgBox, % (0x0 + 0x10)
			, % "ERROR (" . A_ThisFunc . "): Clipboard Has Unexpected Contents"
			, % "The clipboard does not begin with the expected '// Built with Node.js ...,' and th"
. "us may not contain minified JS."
	}			
}

; --------------------------------------------------------------------------------------------------
;   §6: COMMAND LINE INPUT GENERATION SHORTCUTS
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §6.1: GUIs for automating generation of command line input

#Include %A_ScriptDir%\GUIs\GhGui.ahk

#Include %A_ScriptDir%\GUIs\CssBldPsOps.ahk

;   ································································································
;     >>> §6.2: Shortucts for backing up custom CSS builds

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.1: @BackupCss

BackupCss(caller, website, repository, backupFile) {
	AppendAhkCmd(caller)
	copiedCss := CopyCssFromWebsite(website)
	if (VerifyCopiedCode(caller, copiedCss)) {
		WriteCodeToFile(caller, copiedCss, repository . backupFile)
		PasteTextIntoGitShell(caller, "cd '" . repository . "'`rgit add " . backupFile . "`rgit com"
. "mit -m 'Updating backup of latest verified custom CSS build'`rgit push`r")
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.2: @backupCssAscc

:*:@backupCssAscc::
	BackupCss(A_ThisLabel
		, "https://ascc.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\ascc.wsu.edu\", "CSS\ascc-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.3: @backupCssCr

:*:@backupCssCr::
	BackupCss(A_ThisLabel
		, "https://commonreading.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\commonreading.wsu.edu\", "CSS\cr-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.4: @backupCssDsp

:*:@backupCssDsp::
	BackupCss(A_ThisLabel
		, "https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\", "CSS\dsp-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.5: @backupCssFye

:*:@backupCssFye::
	BackupCss(A_ThisLabel
		, "https://firstyear.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\firstyear.wsu.edu\", "CSS\fye-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.6: @backupCssFyf

:*:@backupCssFyf::
	BackupCss(A_ThisLabel
		, "https://learningcommunities.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\", "CSS\learningcommunities-custom.prev"
. ".css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.7: @backupCssLsamp

:*:@backupCssLsamp::
	BackupCss(A_ThisLabel
		, "https://stage.web.wsu.edu/lsamp/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\lsamp.wsu.edu\", "CSS\lsamp-custom.prev"
. ".css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.8: @backupCssNse

:*:@backupCssNse::
	BackupCss(A_ThisLabel
		, "https://nse.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\nse.wsu.edu\", "CSS\nse-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.9: @backupCssNsse

:*:@backupCssNsse::
	BackupCss(A_ThisLabel
		, "https://stage.web.wsu.edu/wsu-nsse/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\nsse.wsu.edu\", "CSS\nsse-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.10: @backupCssOue

:*:@backupCssOue::
	BackupCss(A_ThisLabel
		, "https://stage.web.wsu.edu/oue/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\oue.wsu.edu\", "CSS\oue-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.11: @backupCssPbk

:*:@backupCssPbk::
	BackupCss(A_ThisLabel
		, "https://phibetakappa.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\", "CSS\pbk-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.12: @backupCssSurca

:*:@backupCssSurca::
	BackupCss(A_ThisLabel
		, "https://surca.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\surca.wsu.edu\", "CSS\surca-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.13: @backupCssSumRes

:*:@backupCssSumRes::
	BackupCss(A_ThisLabel
		, "https://summerresearch.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\summerresearch.wsu.edu\", "CSS\summerresearch-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.14: @backupCssXfer

:*:@backupCssXfer::
	BackupCss(A_ThisLabel
		, "https://transfercredit.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\transfercredit.wsu.edu\", "CSS\transfercredit-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.15: @backupCssUgr

:*:@backupCssUgr::
	BackupCss(A_ThisLabel
		, "https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\"
		, "CSS\ugr-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.16: @backupCssXfer

:*:@backupCssUcore::
	BackupCss(A_ThisLabel
		, "https://ucore.wsu.edu/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\ucore.wsu.edu\", "CSS\ucore-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.17: @backupCssUcrAss

:*:@backupCssUcrAss::
	BackupCss(A_ThisLabel
		, "https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=editcss"
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\", "CSS\ucore-assessment-custom.prev.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.18: @backupCssAll

:*:@backupCssAll::
	AppendAhkCmd(A_ThisLabel)
	Gosub, :*:@backupCssAscc
	Gosub, :*:@backupCssCr
	Gosub, :*:@backupCssDsp
	Gosub, :*:@backupCssFye
	Gosub, :*:@backupCssFyf
	Gosub, :*:@backupCssNse
	Gosub, :*:@backupCssPbk
	Gosub, :*:@backupCssSurca
	Gosub, :*:@backupCssSumRes
	Gosub, :*:@backupCssXfer
	Gosub, :*:@backupCssUgr
	Gosub, :*:@backupCssUcore
	Gosub, :*:@backupCssUcrAss
	PasteTextIntoGitShell(A_ThisLabel
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,300)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.19: CopyCssFromWebsite

CopyCssFromWebsite(websiteUrl)
{
	LoadWordPressSiteInChrome(websiteUrl)
	copiedCss := ExecuteCssCopyCmds()
	return copiedCss
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.20: ExecuteCssCopyCmds

ExecuteCssCopyCmds() {
	delay := 200
	Sleep, % delay * 10
	CoordMode, Mouse, Client
	Click, 768, 570
	Sleep, % delay
	SendInput, ^a
	Sleep, % delay
	SendInput, ^c
	Sleep, % delay * 3
	copiedCss := SubStr(clipboard, 1)
	SendInput, ^w
	Sleep, % delay * 10
	return copiedCss
}

;   ································································································
;     >>> §6.3: Shortcuts for rebuilding & committing custom CSS files

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.1: @rebuildCssInRepo

:*:@rebuildCssInRepo::
	AppendAhkCmd( A_ThisLabel )
	cssBldGui := new CssBldPsOps( scriptCfg.cssBuilds, checkType, execDelayer )
	cssBldGui.ShowGui( "rebuild" )
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.2: @rebuildCssAll

:*:@rebuildCssAll::
	AppendAhkCmd(A_ThisLabel)

	; TODO: Refactor command to rely on configuration settings
	; Gosub, :*:@rebuildCssCr
	; Gosub, :*:@rebuildCssDsp
	; Gosub, :*:@rebuildCssFye
	; Gosub, :*:@rebuildCssFyf
	; Gosub, :*:@rebuildCssNse
	; Gosub, :*:@rebuildCssOue
	; Gosub, :*:@rebuildCssPbk
	; Gosub, :*:@rebuildCssSurca
	; Gosub, :*:@rebuildCssSumRes
	; Gosub, :*:@rebuildCssXfer
	; Gosub, :*:@rebuildCssUgr
	; Gosub, :*:@rebuildCssUcore
	; Gosub, :*:@rebuildCssUcrAss
	; PasteTextIntoGitShell(A_ThisLabel
	; 	, "[console]::beep(750,600)`r"
	; 	. "[console]::beep(375,150)`r"
	; 	. "[console]::beep(375,150)`r"
	; 	. "[console]::beep(375,150)`r")
Return

;   ································································································
;     >>> §6.4: Shortcuts for committing CSS builds

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.1: @commitCssAscc

:*:@commitCssAscc::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "ascc.wsu.edu", "ascc-custom_new.less", "ascc-custom.css"
		, "ascc-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.2: @commitCssCr

:*:@commitCssCr::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "commonreading.wsu.edu", "src_cr-new.less", "cr-custom.css"
		, "cr-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.3: @commitCssDsp

:*:@commitCssDsp::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "distinguishedscholarships.wsu.edu", "dsp-custom.less"
		, "dsp-custom.css", "dsp-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.4: @commitCssFye

:*:@commitCssFye::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "firstyear.wsu.edu", "fye-custom.less", "fye-custom.css"
		, "fye-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.5: @commitCssFyf

:*:@commitCssFyf::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "learningcommunities.wsu.edu", "learningcommunities-custom.less"
		, "learningcommunities-custom.css", "learningcommunities-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.6: @commitCssLsamp

:*:@commitCssLsamp::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "lsamp.wsu.edu", "lsamp-custom.less", "lsamp-custom.css"
		, "lsamp-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.7: @commitCssNse

:*:@commitCssNse::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "nse.wsu.edu", "nse-custom.less", "nse-custom.css"
		, "nse-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.8: @commitCssNsse

:*:@commitCssNsse::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "nsse.wsu.edu", "nsse-custom.less", "nsse-custom.css"
		, "nsse-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.9: @commitCssOue

:*:@commitCssOue::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "oue.wsu.edu", "oue-custom.less", "oue-custom.css"
		, "oue-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.10: @commitCssPbk

:*:@commitCssPbk::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "phibetakappa.wsu.edu", "pbk-custom.less", "pbk-custom.css"
		, "pbk-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.11: @commitCssSurca

:*:@commitCssSurca::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "surca.wsu.edu", "surca-custom.less", "surca-custom.css"
		, "surca-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.12: @commitCssSumRes

:*:@commitCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "summerresearch.wsu.edu", "summerresearch-custom.less"
		, "summerresearch-custom.css", "summerresearch-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.13: @commitCssXfer

:*:@commitCssXfer::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "transfercredit.wsu.edu", "xfercredit-custom.less"
		, "xfercredit-custom.css", "xfercredit-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.14: @commitCssUgr

:*:@commitCssUgr::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "undergraduateresearch.wsu.edu", "ugr-custom.less"
		, "ugr-custom.css", "ugr-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.15: @commitCssUcore

:*:@commitCssUcore::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "ucore.wsu.edu", "ucore-custom.less", "ucore-custom.css"
		, "ucore-custom.min.css")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.16: @commitCssUcrAss

:*:@commitCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, "ucore.wsu.edu-assessment", "ucore-assessment-custom.less"
		, "ucore-assessment-custom.css", "ucore-assessment-custom.min.css")
Return

;   ································································································
;     >>> §6.5: Shortcuts for updating CSS submodules

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.1: @updateCssSubmoduleInRepo

:*:@updateCssSubmoduleInRepo::
	AppendAhkCmd( A_ThisLabel )
	cssBldGui := new CssBldPsOps( scriptCfg.cssBuilds, checkType, execDelayer )
	cssBldGui.ShowGui()
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.2: @updateCssSubmoduleAll

; TODO: Modify to rely on configuration settings
:*:@updateCssSubmoduleAll::
	AppendAhkCmd(A_ThisLabel)
	MsgBox % "Currently, this hotstring is being modified and does not do anything yet."
	; Gosub, :*:@updateCssSubmoduleAscc
	; Gosub, :*:@updateCssSubmoduleCr
	; Gosub, :*:@updateCssSubmoduleDsp
	; Gosub, :*:@updateCssSubmoduleFye
	; Gosub, :*:@updateCssSubmoduleFyf
	; Gosub, :*:@updateCssSubmoduleNse
	; Gosub, :*:@updateCssSubmoduleOue
	; Gosub, :*:@updateCssSubmodulePbk
	; Gosub, :*:@updateCssSubmoduleSurca
	; Gosub, :*:@updateCssSubmoduleSumRes
	; Gosub, :*:@updateCssSubmoduleXfer
	; Gosub, :*:@updateCssSubmoduleUgr
	; Gosub, :*:@updateCssSubmoduleUcore
	; Gosub, :*:@updateCssSubmoduleUcrAss
	PasteTextIntoGitShell(A_ThisLabel
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r")
Return

;   ································································································
;     >>> §6.6: For copying minified, backup css files to clipboard

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.1: @copyMinCssAscc

:*:@copyMinCssAscc::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ascc.wsu.edu\CSS\ascc-custom.min.css"
		, "", "Couldn't copy minified CSS for ASCC website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.2: @copyBackupCssAscc

:*:@copyBackupCssAscc::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ascc.wsu.edu\CSS\ascc-custom.min.prev.css"
		, "", "Couldn't copy backup CSS for ASCC Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.3: @copyMinCssCr

:*:@copyMinCssCr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\commonreading.wsu.edu\CSS\cr-custom.min.css"
		, "", "Couldn't copy minified CSS for Common Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.4: @copyBackupCssCr

:*:@copyBackupCssCr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\commonreading.wsu.edu\CSS\cr-custom.min.prev.css"
		, "", "Couldn't copy backup CSS for Common Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.5: @copyMinCssDsp

:*:@copyMinCssDsp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\CSS\dsp-custom.min.css"
		, "", "Couldn't copy minified CSS for DSP Website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.6: @copyBackupCssDsp

:*:@copyBackupCssDsp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\CSS\dsp-custom.prev.css"
		, "", "Couldn't copy backup CSS for DSP Website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.7: @copyMinCssFye

:*:@copyMinCssFye::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\firstyear.wsu.edu\CSS\fye-custom.min.css"
		, "/*! Built with the LESS CSS preprocessor [http://lesscss.org/]. Please see "
		. "[https://github.com/invokeImmediately/firstyear.wsu.edu] for a repository of source "
		. "code. */`r`n`r`n", "Couldn't copy minified CSS for FYE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.8: @copyBackupCssFye

:*:@copyBackupCssFye::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\firstyear.wsu.edu\CSS\fye-custom.prev.css"
		, "", "Couldn't copy backup CSS for FYE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.9: @copyMinCssFyf

:*:@copyMinCssFyf::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\CSS\learningcommunities-custom.min.css"
		, "", "Couldn't copy minified CSS for First-Year Focus website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.10: @copyBackupCssFyf

:*:@copyBackupCssFyf::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\CSS\learningcommunities-custom.prev.css"
		, "", "Couldn't copy backup CSS for First-Year Focus website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.11: @copyMinCssLsamp

:*:@copyMinCssLsamp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\lsamp.wsu.edu\CSS\lsamp-custom.min.css"
		, "", "Couldn't copy minified CSS for LSAMP program website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.12: @copyBackupCssFyf

:*:@copyBackupCssLsamp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\lsamp.wsu.edu\CSS\lsamp-custom.prev.css"
		, "", "Couldn't copy backup CSS for LSAMP program website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.13: @copyMinCssNse

:*:@copyMinCssNse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nse.wsu.edu\CSS\nse-custom.min.css"
		, "", "Couldn't copy minified CSS for NSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.14: @copyBackupCssNse

:*:@copyBackupCssNse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nse.wsu.edu\CSS\nse-custom.prev.css"
		, "", "Couldn't copy backup CSS for NSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.15: @copyMinCssNsse

:*:@copyMinCssNsse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nsse.wsu.edu\CSS\nsse-custom.min.css"
		, "", "Couldn't copy minified CSS for NSSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.16: @copyBackupCssNsse

:*:@copyBackupCssNsse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nsse.wsu.edu\CSS\nsse-custom.prev.css"
		, "", "Couldn't copy backup CSS for NSSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.17: @copyMinCssOue

:*:@copyMinCssOue::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\oue.wsu.edu\CSS\oue-custom.min.css"
		, "", "Couldn't copy minified CSS for OUE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.18: @copyMinCssPbk

:*:@copyMinCssPbk::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\CSS\pbk-custom.min.css"
		, "", "Couldn't copy minified CSS for Phi Beta Kappa website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.19: @copyBackupCssPbk

:*:@copyBackupCssPbk::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\CSS\pbk-custom.prev.css"
		, "", "Couldn't copy backup CSS for Phi Beta Kappa website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.20: @copyMinCssSurca

:*:@copyMinCssSurca::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\surca.wsu.edu\CSS\surca-custom.min.css"
		, "", "Couldn't copy minified CSS for SURCA website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.21: @copyBackupCssSurca

:*:@copyBackupCssSurca::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\surca.wsu.edu\CSS\surca-custom.prev.css"
		, "", "Couldn't copy backup CSS for SURCA website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.22: @copyMinCssSumRes

:*:@copyMinCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\summerresearch.wsu.edu\CSS\summerresearch-custom.min.css", ""
		, "Couldn't copy minified CSS for Summer Research website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.23: @copyBackupCssSumRes

:*:@copyBackupCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\summerresearch.wsu.edu\CSS\summerresearch-custom.prev.css"
		, "", "Couldn't copy backup CSS for Summer Research website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.24: @copyMinCssXfer

:*:@copyMinCssXfer::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\transfercredit.wsu.edu\CSS\xfercredit-custom.min.css"
		, "", "Couldn't copy minified CSS for Transfer Credit website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.25: @copyBackupCssXfer

:*:@copyBackupCssXfer::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\transfercredit.wsu.edu\CSS\xfercredit-custom.prev.css"
		, "", "Couldn't copy backup CSS for Transfer Credit website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.26: @copyMinCssUgr

:*:@copyMinCssUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\CSS\"
		. "ugr-custom.min.css", ""
		, "Couldn't copy minified CSS for UGR website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.27: @copyBackupCssUgr

:*:@copyBackupCssUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\CSS\ugr-custom.prev.css", ""
		, "Couldn't copy backup CSS for UGR website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.28: @copyMinCssUcore

:*:@copyMinCssUcore::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu\CSS\ucore-custom.min.css"
		, "", "Couldn't copy minified CSS for UCORE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.29: @copyBackupCssUcore

:*:@copyBackupCssUcore::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu\CSS\ucore-custom.prev.css"
		, "", "Couldn't copy backup CSS for UCORE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.30: @copyMinCssUcrAss

:*:@copyMinCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\CSS\ucore-assessment-custom.min.css"
		, "", "Couldn't copy minified CSS for UCORE Assessment website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.31: @copyBackupCssUcrAss

:*:@copyBackupCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\CSS\ucore-assessment-custom.min.css"
		, "", "Couldn't copy backup CSS for UCORE Assessment website.")
Return

;   ································································································
;     >>> §6.7: FOR BACKING UP CUSTOM JS BUILDS

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.1: BackupJs

#Include %A_ScriptDir%\GUIs\BackupJsGui.ahk

BackupJs(caller, website, repository, backupFile) {
	if ( caller != "" ) {
		AppendAhkCmd(caller)
	}
	CopyJsFromWebsite(website, copiedJs)
	if (VerifyCopiedCode(caller, copiedJs)) {
		WriteCodeToFile(caller, copiedJs, repository . backupFile)
		PasteTextIntoGitShell(caller, "cd '" . repository . "'`rgit add " . backupFile
			. "`rgit commit -m 'Updating backup of latest verified custom JS build'`rgit push`r")
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.2: @backupJsInRepo

:*:@backupJsRepo::
	AppendAhkCmd( A_ThisLabel )
	backupGui := new BackupJsGui( scriptCfg.backupJs, checkType )
	backupGui.ShowGui()
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.3: @backupJsAll

:*:@backupJsAll::
	AppendAhkCmd(A_ThisLabel)
	; TODO: Revise hotstring to rely on BackupJs function and configuration file settings.
	; Gosub, :*:@backupJsAscc
	; Gosub, :*:@backupJsCr
	; Gosub, :*:@backupJsDsp
	; Gosub, :*:@backupJsFye
	; Gosub, :*:@backupJsFyf
	; Gosub, :*:@backupJsNse
	; Gosub, :*:@backupJsOue
	; Gosub, :*:@backupJsPbk
	; Gosub, :*:@backupJsSurca
	; Gosub, :*:@backupJsSumRes
	; Gosub, :*:@backupJsXfer
	; Gosub, :*:@backupJsUgr
	; Gosub, :*:@backupJsUcore
	; Gosub, :*:@backupJsUcrAss
	; PasteTextIntoGitShell(A_ThisLabel
	; 	, "[console]::beep(750,600)`r"
	; 	. "[console]::beep(375,150)`r"
	; 	. "[console]::beep(375,150)`r"
	; 	. "[console]::beep(375,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.4: CopyJsFromWebsite

CopyJsFromWebsite(websiteUrl, ByRef copiedJs)
{
	delay := GetDelay("long", 3)
	LoadWordPressSiteInChrome(websiteUrl)
	Sleep % delay
	ExecuteJsCopyCmds(copiedJs)
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.5: ExecuteJsCopyCmds

ExecuteJsCopyCmds(ByRef copiedJs) {
	CoordMode, Mouse, Client
	Click, 461, 371
	Sleep, 330
	SendInput, ^a
	Sleep, 2500
	SendInput, ^c
	Sleep, 2500
	SendInput, ^w
	copiedJs := SubStr(clipboard, 1)
	Sleep, 2000
}

;   ································································································
;     >>> §6.8: FOR REBUILDING JS SOURCE FILES

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.1: RebuildJs

RebuildJs(caller, repository, commitCommand) {
	AppendAhkCmd(caller)
	PasteTextIntoGitShell(caller
		, "cd '" . GetGitHubFolder() . "\" . repository . "\'`rgulp buildMinJs`rStart-Sleep -s 1`r["
		. "console]::beep(1500,300)`r")
	CommitAfterBuild(caller, commitCommand)
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.2: @rebuildJsAscc

:*:@rebuildJsAscc::
	RebuildJs(A_ThisLabel, "ascc.wsu.edu", ":*:@commitJsAscc")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.3: @rebuildJsCr

:*:@rebuildJsCr::
	RebuildJs(A_ThisLabel, "commonreading.wsu.edu", ":*:@commitJsCr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.4: @rebuildJsDsp

:*:@rebuildJsDsp::
	RebuildJs(A_ThisLabel, "distinguishedscholarships.wsu.edu", ":*:@commitJsDsp")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.5: @rebuildJsFye

:*:@rebuildJsFye::
	ahkCmdName := ":*:@rebuildJsFye"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.6: @rebuildJsFyf

:*:@rebuildJsFyf::
	ahkCmdName := ":*:@rebuildJsFyf"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.7: @rebuildJsNse

:*:@rebuildJsNse::
	ahkCmdName := ":*:@rebuildJsNse"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\nse.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs nse-custom.js --output nse-custom.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\nse.wsu.edu\'`r"
		. "git add JS\nse-custom.js`r"
		. "git add JS\nse-custom.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.8: @rebuildJsOue

:*:@rebuildJsOue::
	RebuildJs(A_ThisLabel, "oue.wsu.edu", ":*:@commitJsOue")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.9: @rebuildJsPbk

:*:@rebuildJsPbk::
	ahkCmdName := ":*:@rebuildJsPbk"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs pbk-custom.js --output pbk-custom.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\'`r"
		. "git add JS\pbk-custom.js`r"
		. "git add JS\pbk-custom.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.10: @rebuildJsSurca

:*:@rebuildJsSurca::
	RebuildJs(A_ThisLabel, "surca.wsu.edu", ":*:@commitJsSurca")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.11: @rebuildJsSumRes

:*:@rebuildJsSumRes::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsSumRes")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.12: @rebuildJsXfer

:*:@rebuildJsXfer::
	RebuildJs(A_ThisLabel, "transfercredit.wsu.edu", ":*:@commitJsXfer")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.13: @rebuildJsUgr

:*:@rebuildJsUgr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsUgr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.14: @rebuildJsUcore

:*:@rebuildJsUcore::
	ahkCmdName := ":*:@rebuildJsUcore"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsUcore")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.15: @rebuildJsUcrAss

:*:@rebuildJsUcrAss::
	ahkCmdName := ":*:@rebuildJsUcrAss"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;   ································································································
;     >>> §6.9: FOR UPDATING JS SUBMODULES

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.1: @commitJsAscc

:*:@commitJsAscc::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "ascc.wsu.edu", "ascc-specific.js", "ascc-custom.js"
		, "ascc-custom.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.2: @commitJsCr

:*:@commitJsCr::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "commonreading.wsu.edu", "cr-custom.js", "cr-build.js"
		, "cr-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.3: @commitJsDsp

:*:@commitJsDsp::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "distinguishedscholarships.wsu.edu", "dsp-custom.js"
		, "dsp-custom-build.js", "dsp-custom-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.4: @commitJsOue

:*:@commitJsOue::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "oue.wsu.edu", "oue-custom.js", "oue-build.js", "oue-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.5: @commitJsSurca

:*:@commitJsSurca::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "surca.wsu.edu", "surca-custom.js", "surca-build.js"
		, "surca-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.6: @commitJsSumRes

:*:@commitJsSumRes::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "summerresearch.wsu.edu", "sumres-custom.js", "sumres-build.js"
		, "sumres-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.7: @commitJsXfer

:*:@commitJsXfer::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "transfercredit.wsu.edu", "xfercredit-custom.js"
		, "xfercredit-build.js", "xfercredit-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.8: @commitJsUgr

:*:@commitJsUgr::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "undergraduateresearch.wsu.edu", "ugr-custom.js", "ugr-build.js"
		, "ugr-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.9: @commitJsUcore

:*:@commitJsUcore::
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, "ucore.wsu.edu", "ucore-custom.js", "ucore-build.js"
		, "ucore-build.min.js")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.9.10: @commitJsXfer

:*:@commitJsXfer::
	CommitJsBuild(A_ThisLabel, "transfercredit.wsu.edu", "xfercredit-custom.js"
		, "xfercredit-build.js", "xfercredit-build.min.js")
Return

;   ································································································
;     >>> §6.10: FOR UPDATING JS SUBMODULES

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.1: UpdateJsSubmodule

UpdateJsSubmodule(caller, repository, rebuildCommand) {
	AppendAhkCmd(caller)
	PasteTextIntoGitShell(caller, "cd '" . GetGitHubFolder() . "\" . repository . "\WSU-UE---JS'`rg"
		. "it fetch`rgit merge origin/master`rcd ..`rgit add WSU-UE---JS`rgit commit -m 'Updating c"
		. "ustom JS master submodule for OUE websites' -m 'Obtaining recent changes in OUE-wide JS "
		.  "source code used in builds.'`rgit push`r")
	MsgBox, % (0x4 + 0x20)
		, % caller . ": Proceed with rebuild?"
		, % "After updating the JS submodule, would you like to proceed with the rebuild command "
			. rebuildCommand . "?"
	IfMsgBox Yes
	{
		Gosub % rebuildCommand
	}
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.2: @updateJsSubmoduleAscc

:*:@updateJsSubmoduleAscc::
	UpdateJsSubmodule(A_ThisLabel, "ascc.wsu.edu", ":*:@rebuildJsAscc")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.3: @updateJsSubmoduleCr

:*:@updateJsSubmoduleCr::
	UpdateJsSubmodule(A_ThisLabel, "commonreading.wsu.edu"
		, ":*:@rebuildJsCr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.4: @updateJsSubmoduleDsp

:*:@updateJsSubmoduleDsp::
	UpdateJsSubmodule(A_ThisLabel, "distinguishedscholarships.wsu.edu"
		, ":*:@rebuildJsDsp")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.5: @updateJsSubmoduleFye

:*:@updateJsSubmoduleFye::
	UpdateJsSubmodule(A_ThisLabel, "firstyear.wsu.edu", ":*:@rebuildJsFye")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.6: @updateJsSubmoduleFyf

:*:@updateJsSubmoduleFyf::
	UpdateJsSubmodule(A_ThisLabel, "learningcommunities.wsu.edu"
		, ":*:@rebuildJsFyf")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.7: @updateJsSubmoduleNse

:*:@updateJsSubmoduleNse::
	UpdateJsSubmodule(A_ThisLabel, "nse.wsu.edu", ":*:@rebuildJsNse")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.8: @updateJsSubmoduleOue

:*:@updateJsSubmoduleOue::
	UpdateJsSubmodule(A_ThisLabel, "oue.wsu.edu", ":*:@rebuildJsOue")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.9: @updateJsSubmodulePbk

:*:@updateJsSubmodulePbk::
	UpdateJsSubmodule(A_ThisLabel, "phibetakappa.wsu.edu", ":*:@rebuildJsPbk")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.10: @updateJsSubmoduleSurca

:*:@updateJsSubmoduleSurca::
	UpdateJsSubmodule(A_ThisLabel, "surca.wsu.edu", ":*:@rebuildJsSurca")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.11: @updateJsSubmoduleSumRes

:*:@updateJsSubmoduleSumRes::
	UpdateJsSubmodule(A_ThisLabel, "summerresearch.wsu.edu"
		, ":*:@rebuildJsSumRes")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.12: @updateJsSubmoduleXfer

:*:@updateJsSubmoduleXfer::
	UpdateJsSubmodule(A_ThisLabel, "transfercredit.wsu.edu"
		, ":*:@rebuildJsXfer")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.13: @updateJsSubmoduleUgr

:*:@updateJsSubmoduleUgr::
	UpdateJsSubmodule(A_ThisLabel, "undergraduateresearch.wsu.edu", ":*:@rebuildJsUgr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.14: @updateJsSubmoduleUcore

:*:@updateJsSubmoduleUcore::
	UpdateJsSubmodule(A_ThisLabel, "ucore.wsu.edu", ":*:@rebuildJsUcore")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.15: @updateJsSubmoduleUcrAss

:*:@updateJsSubmoduleUcrAss::
	UpdateJsSubmodule(A_ThisLabel, "ucore.wsu.edu-assessment"
		, ":*:@rebuildJsUcrAss")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.10.16: @updateJsSubmoduleAll

:*:@updateJsSubmoduleAll::
	ahkCmdName := ":*:@updateJsSubmoduleAll"
	AppendAhkCmd(ahkCmdName)
	Gosub, :*:@updateJsSubmoduleAscc
	Gosub, :*:@updateJsSubmoduleCr
	Gosub, :*:@updateJsSubmoduleDsp
	Gosub, :*:@updateJsSubmoduleFye
	Gosub, :*:@updateJsSubmoduleFyf
	Gosub, :*:@updateJsSubmoduleNse
	Gosub, :*:@updateJsSubmoduleOue
	Gosub, :*:@updateJsSubmodulePbk
	Gosub, :*:@updateJsSubmoduleSurca
	Gosub, :*:@updateJsSubmoduleSumRes
	Gosub, :*:@updateJsSubmoduleXfer
	Gosub, :*:@updateJsSubmoduleUgr
	Gosub, :*:@updateJsSubmoduleUcore
	Gosub, :*:@updateJsSubmoduleUcrAss
	PasteTextIntoGitShell(ahkCmdName
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r")
Return

;   ································································································
;     >>> §6.11: Shortcuts for copying minified JS to clipboard

;TODO: Add scripts for copying JS backups to clipboard (see CSS backup-copying scripts above)

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.1: @copyMinJsAscc

:*:@copyMinJsAscc::
	ahkCmdName := ":*:@copyMinJsAscc"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ascc.wsu.edu\JS\ascc-custom.min.js"
		, "", "Couldn't Copy Minified JS for ASCC Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.2: @copyMinJsCr

:*:@copyMinJsCr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\commonreading.wsu.edu\JS\cr-build.min.js"
		, "", "Couldn't Copy Minified JS for CR Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.3: @copyMinJsDsp

:*:@copyMinJsDsp::
	ahkCmdName := ":*:@copyMinJsDsp"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\JS\dsp-custom-build.min.js"
		, "", "Couldn't Copy Minified JS for DSP Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.4: @copyMinJsFye

:*:@copyMinJsFye::
	ahkCmdName := ":*:@copyMinJsFye"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\firstyear.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for FYE Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.5: @copyMinJsFyf

:*:@copyMinJsFyf::
	ahkCmdName := ":*:@copyMinJsFyf"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for FYF Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.6: @copyMinJsNse

:*:@copyMinJsNse::
	ahkCmdName := ":*:@copyMinJsNse"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\nse.wsu.edu\JS\nse-custom.min.js"
		, "", "Couldn't Copy Minified JS for Nse Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.7: @copyMinJsOue

:*:@copyMinJsOue::
	ahkCmdName := ":*:@copyMinJsOue"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\oue.wsu.edu\JS\oue-build.min.js"
		, "", "Couldn't Copy Minified JS for WSU OUE Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.8: @copyBackupJsOue

:*:@copyBackupJsOue::
	ahkCmdName := ":*:@copyBackupJsOue"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\oue.wsu.edu\JS\oue-custom.min.prev.js"
		, "", "Couldn't copy backup copy of minified JS for WSU OUE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.9: @copyMinJsPbk

:*:@copyMinJsPbk::
	ahkCmdName := ":*:@copyMinJsPbk"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for WSU Phi Beta Kappa Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.10: @copyMinJsSurca

:*:@copyMinJsSurca::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\surca.wsu.edu\JS\surca-build.min.js"
		, "", "Couldn't Copy Minified JS for SURCA Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.11: @copyMinJsSumRes

:*:@copyMinJsSumRes::
	ahkCmdName := ":*:@copyMinJsSumRes"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\summerresearch.wsu.edu\JS\sumres-build.min.js"
		, "", "Couldn't Copy Minified JS for WSU Summer Research Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.12: @copyMinJsXfer

:*:@copyMinJsXfer::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\transfercredit.wsu.edu\JS\xfercredit-build.min.js"
		, "", "Couldn't Copy Minified JS for WSU Transfer Credit Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.13: @copyMinJsUgr

:*:@copyMinJsUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\JS\ugr-build.min.js"
		, "", "Couldn't Copy Minified JS for UGR Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.14: @copyMinJsUcore

:*:@copyMinJsUcore::
	ahkCmdName := ":*:@copyMinJsUcore"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu\JS\ucore-build.min.js"
		, "", "Couldn't copy minified JS for UCORE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.15: @copyBackupJsUcore

:*:@copyBackupJsUcore::
	ahkCmdName := ":*:@copyBackupJsUcore"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu\JS\wp-custom-js-source.min.prev.js"
		, ""		, "Couldn't copy backup copy of minified JS for UCORE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.11.16: @copyMinJsUcrAss

:*:@copyMinJsUcrAss::
	ahkCmdName := ":*:@copyMinJsUcrAss"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for WSU Summer Research Website")
Return

;   ································································································
;     >>> §6.12: FOR CHECKING GIT STATUS ON ALL PROJECTS

; TODO: Update hotstring for improved efficiency
:*:@checkGitStatus::
	ahkCmdName := ":*:@checkGitStatus"
	AppendAhkCmd(ahkCmdName)
	gitHubFolder := GetGitHubFolder()
	PasteTextIntoGitShell(ahkCmdName
		, "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n----------------------------------------------WSU-OUE-AutoHotkey--------"
		. "---------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\WSU-OUE-AutoHotkey\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n------------------------------------------------WSU-OUE---CSS-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\WSU-UE---CSS\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n-------------------------------------------------WSU-OUE---JS-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\WSU-UE---JS\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n-------------------------------------------------ascc.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\ascc.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n--------------------------------------------commonreading.wsu.edu-------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\commonreading.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n--------------------------------------distinguishedscholarships.wsu.edu-"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\distinguishedscholarships.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n----------------------------------------------firstyear.wsu.edu---------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\firstyear.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n-----------------------------------------learningcommunities.wsu.edu----"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\learningcommunities.wsu.edu\""`r`n"
		. "git status`r`n"
		. "Write-Host ""``n------------------------------------------------lsamp.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\lsamp.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n-------------------------------------------------oue.wsu.edu------------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\oue.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n------------------------------------------------surca.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\surca.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n----------------------------------------undergraduateresearch.wsu.edu---"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\undergraduateresearch.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n--------------------------------------------transfercredit.wsu.edu------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\transfercredit.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n--------------------------------------------summerresearch.wsu.edu------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\summerresearch.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n------------------------------------------------ucore.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\ucore.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n"
		. "Write-Host ""``n-------------------------------------------ucore.wsu.edu/assessment-----"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd """ . gitHubFolder . "\ucore.wsu.edu-assessment\""`r`n"
		. "git status`r`n"
		. "cd """ . gitHubFolder . "\""`r`n")
Return

; --------------------------------------------------------------------------------------------------
;   §7: KEYBOARD SHORTCUTS FOR POWERSHELL
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §7.1: SHORTCUTS

^+v::	
	if (IsGitShellActive()) {
		PasteTextIntoGitShell("", clipboard)
	} else {
		Gosub, PerformBypassingCtrlShftV
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

~^+Backspace::
	if (IsGitShellActive()) {
		SendInput {Backspace 120}
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

~^+Delete::
	if (IsGitShellActive()) {
		SendInput {Delete 120}
	}
Return

;   ································································································
;     >>> §7.2: SUPPORTING FUNCTIONS

PerformBypassingCtrlShftV:
	Suspend
	Sleep 10
	SendInput ^+v
	Sleep 10
	Suspend, Off
Return
