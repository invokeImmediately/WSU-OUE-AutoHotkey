; ==================================================================================================
; AUTOHOTKEY SCRIPT IMPORT for Working with Github Desktop for Windows
; ==================================================================================================
; IMPORT DEPENDENCIES
;   Global Variable Name    Purpose
;   -·-·-·-·-·-·-·-·-·-     -·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·
;   userAccountFolder       Contains the path to the Windows user folder for the script runner
; --------------------------------------------------------------------------------------------------
; IMPORT ASSUMPTIONS
;   Environmental Property           State
;   ----------------------------     ---------------------------------------------------------------
;   Location of GitHub               …userAccountFolder (see above dependency)…\Documents\GitHub
;   Repositories locally present     All those from https://github.com/invokeImmediately 
; ==================================================================================================
; AUTOHOTKEY SEND LEGEND
; ! = ALT     + = SHIFT     ^ = CONTROL     # = WIN
; (see https://autohotkey.com/docs/commands/Send.htm for more info)
; ==================================================================================================
; Table of Contents
; -----------------
;   §1: SETTINGS accessed via functions for this imported file.................................238
;     >>> §1.1: GetCmdForMoveToCSSFolder.......................................................242
;     >>> §1.2: GetCurrentDirFrom..............................................................257
;     >>> §1.3: GetGitHubFolder................................................................269
;     >>> §1.4: UserFolderIsSet................................................................277
;   §2: FUNCTIONS for working with GitHub Desktop..............................................291
;     >>> §2.1: ActivateGitShell...............................................................295
;     >>> §2.2: CommitAfterBuild...............................................................314
;     >>> §2.3: EscapeCommitMessage............................................................349
;     >>> §2.4: Git commit GUI — Imports.......................................................359
;       →→→ §2.4.1: For committing CSS builds..................................................362
;       →→→ §2.4.2: For committing JS builds...................................................367
;       →→→ §2.4.3: For committing any type of file............................................372
;     >>> §2.5: CopySrcFileToClipboard.........................................................377
;     >>> §2.6: IsGitShellActive...............................................................398
;     >>> §2.7: PasteTextIntoGitShell..........................................................407
;     >>> §2.8: ToEscapedPath..................................................................433
;     >>> §2.9: VerifyCopiedCode...............................................................441
;   §3: FUNCTIONS for interacting with online WEB DESIGN INTERFACES............................455
;     >>> §3.1: LoadWordPressSiteInChrome......................................................459
;   §4: GUI FUNCTIONS for handling user interactions with scripts..............................495
;     >>> §4.1: @postMinCss....................................................................499
;       →→→ §4.1.1: HandlePostCssCheckAllSites.................................................539
;       →→→ §4.1.2: HandlePostCssUncheckAllSites...............................................559
;       →→→ §4.1.3: HandlePostMinCssCancel.....................................................579
;       →→→ §4.1.4: HandlePostMinCssOK.........................................................586
;       →→→ §4.1.5: PasteMinCssToWebsite.......................................................653
;     >>> §4.2: @postBackupCss.................................................................664
;       →→→ §4.2.1: HandlePostBackupCssCheckAllSites...........................................709
;       →→→ §4.2.2: HandlePostBackupCssUncheckAllSites.........................................729
;       →→→ §4.2.3: HandlePostBackupCssCancel..................................................749
;       →→→ §4.2.4: HandlePostBackupCssOK......................................................756
;     >>> §4.3: @postMinJs.....................................................................819
;       →→→ §4.3.1: HandlePostJsCheckAllSites..................................................870
;       →→→ §4.3.2: HandlePostJsUncheckAllSites................................................890
;       →→→ §4.3.3: HandlePostMinJsCancel......................................................910
;       →→→ §4.3.4: HandlePostMinJsOK..........................................................917
;       →→→ §4.3.5: PasteMinJsToWebsite........................................................984
;   §5: UTILITY HOTSTRINGS for working with GitHub Desktop.....................................999
;     >>> §5.1: FILE COMMITTING...............................................................1003
;     >>> §5.2: STATUS CHECKING...............................................................1153
;     >>> §5.3: Automated PASTING OF CSS into online web interfaces...........................1175
;   §6: COMMAND LINE INPUT GENERATION SHORTCUTS...............................................1341
;     >>> §6.1: Shortucts for backing up custom CSS builds....................................1345
;       →→→ §6.1.1: @backupCssAscc............................................................1348
;       →→→ §6.1.2: @backupCssCr..............................................................1363
;       →→→ §6.1.3: @backupCssDsp.............................................................1381
;       →→→ §6.1.4: @backupCssFye.............................................................1399
;       →→→ §6.1.5: @backupCssFyf.............................................................1416
;       →→→ §6.1.6: @backupCssNse.............................................................1434
;       →→→ §6.1.7: @backupCssOue.............................................................1451
;       →→→ §6.1.8: @backupCssPbk.............................................................1468
;       →→→ §6.1.9: @backupCssSurca...........................................................1485
;       →→→ §6.1.10: @backupCssSumRes.........................................................1502
;       →→→ §6.1.11: @backupCssXfer...........................................................1520
;       →→→ §6.1.12: @backupCssUgr............................................................1538
;       →→→ §6.1.13: @backupCssXfer...........................................................1556
;       →→→ §6.1.14: @backupCssUcrAss.........................................................1573
;       →→→ §6.1.15: @backupCssAll............................................................1591
;       →→→ §6.1.16: CopyCssFromWebsite.......................................................1614
;       →→→ §6.1.16: CopyCssFromWebsite.......................................................1624
;     >>> §6.2: Shortcuts for rebuilding & committing custom CSS files........................1643
;       →→→ §6.2.1: @rebuildCssHere...........................................................1646
;       →→→ §6.2.2: @rebuildCssAscc...........................................................1656
;       →→→ §6.2.3: @commitCssAscc............................................................1668
;       →→→ §6.2.4: @rebuildCssCr.............................................................1683
;       →→→ §6.2.5: @commitCssCr..............................................................1695
;       →→→ §6.2.6: @rebuildCssDsp............................................................1710
;       →→→ §6.2.7: @commitCssDsp.............................................................1722
;       →→→ §6.2.8: @rebuildCssFye............................................................1737
;       →→→ §6.2.9: @commitCssFye.............................................................1749
;       →→→ §6.2.10: @rebuildCssFyf...........................................................1765
;       →→→ §6.2.11: @commitCssFyf............................................................1777
;       →→→ §6.2.12: @rebuildCssNse...........................................................1790
;       →→→ §6.2.13: @commitCssNse............................................................1802
;       →→→ §6.2.14: @rebuildCssOue...........................................................1817
;       →→→ §6.2.15: @commitCssOue............................................................1829
;       →→→ §6.2.16: @rebuildCssPbk...........................................................1845
;       →→→ §6.2.17: @commitCssPbk............................................................1857
;       →→→ §6.2.18: @rebuildCssSurca.........................................................1873
;       →→→ §6.2.19: @commitCssSurca..........................................................1885
;       →→→ §6.2.20: @rebuildCssSumRes........................................................1900
;       →→→ §6.2.21: @commitCssSumRes.........................................................1912
;       →→→ §6.2.22: @rebuildCssXfer..........................................................1927
;       →→→ §6.2.23: @commitCssXfer...........................................................1939
;       →→→ §6.2.24: @rebuildCssUgr...........................................................1955
;       →→→ §6.2.25: @commitCssUgr............................................................1967
;       →→→ §6.2.26: @commitCssSumRes.........................................................1982
;       →→→ §6.2.27: @commitCssUcore..........................................................1994
;       →→→ §6.2.28: @rebuildCssUcrAss........................................................2009
;       →→→ §6.2.29: @commitCssUcrAss.........................................................2021
;       →→→ §6.2.30: @rebuildCssAll...........................................................2036
;     >>> §6.3: Shortcuts for updating CSS submodules.........................................2061
;       →→→ §6.3.1: @updateCssSubmoduleAscc...................................................2064
;       →→→ §6.3.2: @updateCssSubmoduleCr.....................................................2081
;       →→→ §6.3.3: @updateCssSubmoduleDsp....................................................2098
;       →→→ §6.3.4: @updateCssSubmoduleFye....................................................2115
;       →→→ §6.3.5: @updateCssSubmoduleFyf....................................................2132
;       →→→ §6.3.6: @updateCssSubmoduleNse....................................................2149
;       →→→ §6.3.7: @updateCssSubmoduleOue....................................................2166
;       →→→ §6.3.8: @updateCssSubmodulePbk....................................................2183
;       →→→ §6.3.9: @updateCssSubmoduleSurca..................................................2200
;       →→→ §6.3.10: @updateCssSubmoduleSumRes................................................2217
;       →→→ §6.3.11: @updateCssSubmoduleXfer..................................................2234
;       →→→ §6.3.12: @updateCssSubmoduleUgr...................................................2251
;       →→→ §6.3.13: @updateCssSubmoduleUcore.................................................2268
;       →→→ §6.3.14: @updateCssSubmoduleUcrAss................................................2285
;       →→→ §6.3.15: @updateCssSubmoduleAll...................................................2302
;     >>> §6.4: For copying minified, backup css files to clipboard...........................2328
;       →→→ §6.4.1: @copyMinCssAscc...........................................................2331
;       →→→ §6.4.2: @copyBackupCssAscc........................................................2341
;       →→→ §6.4.3: @copyMinCssCr.............................................................2351
;       →→→ §6.4.4: @copyBackupCssCr..........................................................2363
;       →→→ §6.4.5: @copyMinCssDsp............................................................2373
;       →→→ §6.4.6: @copyBackupCssDsp.........................................................2383
;       →→→ §6.4.7: @copyMinCssFye............................................................2393
;       →→→ §6.4.8: @copyBackupCssFye.........................................................2405
;       →→→ §6.4.9: @copyMinCssFyf............................................................2415
;       →→→ §6.4.10: @copyBackupCssFyf........................................................2425
;       →→→ §6.4.11: @copyMinCssNse...........................................................2435
;       →→→ §6.4.12: @copyBackupCssNse........................................................2445
;       →→→ §6.4.13: @copyMinCssOue...........................................................2455
;       →→→ §6.4.14: @copyMinCssPbk...........................................................2465
;       →→→ §6.4.15: @copyBackupCssPbk........................................................2475
;       →→→ §6.4.16: @copyMinCssSurca.........................................................2485
;       →→→ §6.4.17: @copyBackupCssSurca......................................................2497
;       →→→ §6.4.18: @copyMinCssSumRes........................................................2507
;       →→→ §6.4.19: @copyBackupCssSumRes.....................................................2517
;       →→→ §6.4.20: @copyMinCssXfer..........................................................2527
;       →→→ §6.4.21: @copyBackupCssXfer.......................................................2537
;       →→→ §6.4.22: @copyMinCssUgr...........................................................2547
;       →→→ §6.4.23: @copyBackupCssUgr........................................................2558
;       →→→ §6.4.24: @copyMinCssUcore.........................................................2568
;       →→→ §6.4.25: @copyBackupCssUcore......................................................2578
;       →→→ §6.4.26: @copyMinCssUcrAss........................................................2588
;       →→→ §6.4.27: @copyBackupCssUcrAss.....................................................2598
;     >>> §6.5: FOR BACKING UP CUSTOM JS BUILDS...............................................2608
;       →→→ §6.5.1: @backupJsAscc.............................................................2611
;       →→→ §6.5.2: @backupJsCr...............................................................2626
;       →→→ §6.5.3: @backupJsDsp..............................................................2642
;       →→→ §6.5.4: @backupJsFye..............................................................2658
;       →→→ §6.5.5: @backupJsFyf..............................................................2674
;       →→→ §6.5.6: @backupJsNse..............................................................2690
;       →→→ §6.5.7: @backupJsOue..............................................................2704
;       →→→ §6.5.8: @backupJsPbk..............................................................2718
;       →→→ §6.5.9: @backupJsSurca............................................................2734
;       →→→ §6.5.10: @backupJsSumRes..........................................................2749
;       →→→ §6.5.11: @commitBackupJsSumRes....................................................2761
;       →→→ §6.5.12: @backupJsXfer............................................................2773
;       →→→ §6.5.13: @backupJsUgr.............................................................2789
;       →→→ §6.5.14: @backupJsUcore...........................................................2805
;       →→→ §6.5.15: @backupJsUcrAss..........................................................2820
;       →→→ §6.5.16: @backupJsAll.............................................................2836
;       →→→ §6.5.17: CopyJsFromWebsite........................................................2862
;       →→→ §6.5.18: ExecuteJsCopyCmds........................................................2871
;     >>> §6.6: FOR REBUILDING JS SOURCE FILES................................................2887
;       →→→ §6.6.1: @rebuildJsAscc............................................................2890
;       →→→ §6.6.2: @rebuildJsCr..............................................................2909
;       →→→ §6.6.3: @rebuildJsDsp.............................................................2928
;       →→→ §6.6.4: @commitJsDsp..............................................................2943
;       →→→ §6.6.5: @rebuildJsFye.............................................................2955
;       →→→ §6.6.6: @rebuildJsFyf.............................................................2974
;       →→→ §6.6.7: @rebuildJsNse.............................................................2993
;       →→→ §6.6.8: @rebuildJsOue.............................................................3012
;       →→→ §6.6.9: @rebuildJsPbk.............................................................3031
;       →→→ §6.6.10: @rebuildJsSurca..........................................................3050
;       →→→ §6.6.11: @rebuildJsSumRes.........................................................3069
;       →→→ §6.6.12: @commitJsSumRes..........................................................3081
;       →→→ §6.6.13: @rebuildJsXfer...........................................................3093
;       →→→ §6.6.14: @commitJsXfer............................................................3105
;       →→→ §6.6.15: @rebuildJsUgr............................................................3117
;       →→→ §6.6.16: @commitJsUgr.............................................................3129
;       →→→ §6.6.17: @rebuildJsUcore..........................................................3141
;       →→→ §6.6.18: @rebuildJsUcrAss.........................................................3160
;     >>> §6.7: FOR UPDATING JS SUBMODULES....................................................3179
;       →→→ §6.7.1: @updateJsSubmoduleAscc....................................................3182
;       →→→ §6.7.2: @updateJsSubmoduleCr......................................................3200
;       →→→ §6.7.3: @updateJsSubmoduleDsp.....................................................3218
;       →→→ §6.7.4: @updateJsSubmoduleFye.....................................................3236
;       →→→ §6.7.5: @updateJsSubmoduleFyf.....................................................3254
;       →→→ §6.7.6: @updateJsSubmoduleNse.....................................................3272
;       →→→ §6.7.7: @updateJsSubmoduleOue.....................................................3290
;       →→→ §6.7.8: @updateJsSubmodulePbk.....................................................3308
;       →→→ §6.7.9: @updateJsSubmoduleSurca...................................................3326
;       →→→ §6.7.10: @updateJsSubmoduleSumRes.................................................3344
;       →→→ §6.7.11: @updateJsSubmoduleXfer...................................................3362
;       →→→ §6.7.12: @updateJsSubmoduleUgr....................................................3380
;       →→→ §6.7.13: @updateJsSubmoduleUcore..................................................3398
;       →→→ §6.7.14: @updateJsSubmoduleUcrAss.................................................3416
;       →→→ §6.7.15: @updateJsSubmoduleAll....................................................3434
;     >>> §6.8: Shortcuts for copying minified JS to clipboard................................3461
;       →→→ §6.8.1: @copyMinJsAscc............................................................3466
;       →→→ §6.8.2: @copyMinJsCr..............................................................3477
;       →→→ §6.8.3: @copyMinJsDsp.............................................................3488
;       →→→ §6.8.4: @copyMinJsFye.............................................................3499
;       →→→ §6.8.5: @copyMinJsFyf.............................................................3510
;       →→→ §6.8.6: @copyMinJsNse.............................................................3521
;       →→→ §6.8.7: @copyMinJsOue.............................................................3532
;       →→→ §6.8.8: @copyBackupJsOue..........................................................3543
;       →→→ §6.8.9: @copyMinJsPbk.............................................................3554
;       →→→ §6.8.10: @copyMinJsSurca..........................................................3565
;       →→→ §6.8.11: @copyMinJsSumRes.........................................................3576
;       →→→ §6.8.12: @copyMinJsXfer...........................................................3587
;       →→→ §6.8.13: @copyMinJsUgr............................................................3598
;       →→→ §6.8.14: @copyMinJsUcore..........................................................3609
;       →→→ §6.8.15: @copyBackupJsUcore.......................................................3620
;       →→→ §6.8.16: @copyMinJsUcrAss.........................................................3631
;     >>> §6.9: FOR CHECKING GIT STATUS ON ALL PROJECTS ......................................3642
;   §7: KEYBOARD SHORTCUTS FOR POWERSHELL.....................................................3727
;     >>> §7.1: SHORTCUTS.....................................................................3731
;     >>> §7.2: SUPPORTING FUNCTIONS..........................................................3757
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
		if(doesVarExist(matches1) && !doesVarExist(matches2)) {
			cmd := "awesome!"
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
	Return userAccountFolderSSD . "\Documents\GitHub"
}

;   ································································································
;     >>> §1.4: UserFolderIsSet

UserFolderIsSet() {
	global userAccountFolderSSD
	varDeclared := userAccountFolderSSD != thisIsUndeclared
	if (!varDeclared) {
		MsgBox, % (0x0 + 0x10), % "ERROR: Upstream dependency missing in github.ahk"
			, % "The global variable specifying the user's account folder has not been declared "
			. "and set upstream."
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
			errorMsg .= "Function was called with an invalid argument for the calling build "
				. "command: " . ahkBuildCmd . "."
			if (!qcAhkCommitCmd) {
				errorMsg .= "The argument for the commit command to call next was also invalid: "
					. ahkCommitCmd . "."
			}		
		} else {
			errorMsg .= "Function was called from the build command " . ahkBuildCmd
				. ", but an invalid argument for the commit command was found: " . ahkCommitCmd
				. "."
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

#Include %A_ScriptDir%\GitHub\WSU-OUE-AutoHotkey\CommitCssBuild.ahk

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §2.4.2: For committing JS builds

#Include %A_ScriptDir%\GitHub\WSU-OUE-AutoHotkey\CommitJsBuild.ahk

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §2.4.3: For committing any type of file

#Include %A_ScriptDir%\GitHub\WSU-OUE-AutoHotkey\CommitAnyFile.ahk

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
			MsgBox, % (0x0 + 0x10), % "ERROR (" . ahkCmdName . ")", % errorMsg
				. "`rCAUSE = Failed to open file: " . srcFile
		}
	} else {
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ahkCmdName . ")", % errorMsg
			. "`rCAUSE = User folder is not set."
	}
}

;   ································································································
;     >>> §2.6: IsGitShellActive

IsGitShellActive() {
	WinGet, thisProcess, ProcessName, A
	shellIsActive := thisProcess = "PowerShell.exe"
	Return shellIsActive
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
	msg := "Here's what I copied:`n" . SubStr(copiedCss, 1, 320) . "..."
		. "`n`nProceed with git commit?"
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
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
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
		PasteMinCssToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/"
			. "themes.php?page=editcss", ":*:@copyMinCssDsp", postMinCssAutoMode)
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
		PasteMinCssToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/"
			. "themes.php?page=editcss", ":*:@copyMinCssUgr", postMinCssAutoMode)
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
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
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
		PasteMinCssToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/"
		. "themes.php?page=editcss", ":*:@copyBackupCssDsp")
	}
	if (PostBackupCssToFye) {
		PasteMinCssToWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssFye")
	}
	if (PostBackupCssToFyf) {
		PasteMinCssToWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssFyf")
	}
	if (PostBackupCssToFyf) {
		PasteMinCssToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=editcss"
			, ":*:@copyBackupCssNse")
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
		PasteMinCssToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/"
			. "themes.php?page=editcss", ":*:@copyBackupCssUgr")
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
		PasteMinJsToWebsite("https://commonreading.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsCr", postMinJsAutoMode)
	}
	if (PostMinJsToDsp) {
		PasteMinJsToWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsDsp", postMinJsAutoMode)
	}
	if (PostMinJsToFye) {
		PasteMinJsToWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsFye", postMinJsAutoMode)
	}
	if (PostMinJsToFyf) {
		PasteMinJsToWebsite("https://learningcommunities.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsFyf", postMinJsAutoMode)
	}
	if (PostMinJsToNse) {
		PasteMinJsToWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsNse", postMinJsAutoMode)
	}
	if (PostMinJsToPbk) {
		PasteMinJsToWebsite("https://phibetakappa.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsPbk", postMinJsAutoMode)
	}
	if (PostMinJsToSurca) {
		PasteMinJsToWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsSurca", postMinJsAutoMode)
	}
	if (PostMinJsToSumRes) {
		PasteMinJsToWebsite("https://summerresearch.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsSumRes", postMinJsAutoMode)
	}
	if (PostMinJsToXfer) {
		PasteMinJsToWebsite("https://transfercredit.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsXfer", postMinJsAutoMode)
	}
	if (PostMinJsToUgr) {
		PasteMinJsToWebsite("https://undergraduateresearch.wsu.edu/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsUgr", postMinJsAutoMode)
	}
	if (PostMinJsToUcore) {
		PasteMinJsToWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=custom-javascript"
			, ":*:@copyMinJsUcore", postMinJsAutoMode)
	}
	if (PostMinJsToUcrAss) {
		PasteMinJsToWebsite("https://ucore.wsu.edu/assessment/wp-admin/"
			. "themes.php?page=custom-javascript", ":*:@copyMinJsUcrAss", postMinJsAutoMode)
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
	thisAhkCmd := A_ThisLabel

	AppendAhkCmd(thisAhkCmd)
	PasteTextIntoGitShell(thisAhkCmd, "git log -p --since='last month' "
		. "--pretty=format:'%h|%an|%ar|%s|%b' > git-log.txt`r")
Return

:*:@getNoDiffGitCommitLog::
	thisAhkCmd := A_ThisLabel

	AppendAhkCmd(thisAhkCmd)
	PasteTextIntoGitShell(thisAhkCmd, "git log --since='last month' "
		. "--pretty=format:'%h|%an|%ar|%s|%b' > git-log.txt`r")
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@findGitChangesRegEx::
	thisAhkCmd := A_ThisLabel
	targetProcesses := ["notepad++.exe", "sublime_text.exe"]
	notActiveErrMsg := "Please ensure Notepad++ or Sublime Text are active before activating this "
		. "hotstring."

	AppendAhkCmd(thisAhkCmd)
	activeProcessName := areTargetProcessesActive(targetProcesses, thisAhkCmd, notActiveErrMsg)
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
	SendInput, % "{^}(?:[{^}\n \-].*| (?{!} {{}7{}}).*|-(?{!}-{{}7{}}).*)?$(?:\n)"
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
			, % "Please activate Notepad++ and ensure the correct file is selected before "
			. "attempting to utilize this hotstring, which is designed to create a 'git add' "
			. "command for pasting into PowerShell based on Notepad++'s Edit > Copy to Clipboard "
			. "> Current Full File Path to Clipboard menu command."
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
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ":*:@doGitCommit" . "): Could Not Locate Git "
			. "PowerShell", % "The Git PowerShell process could not be located and activated."
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
		MsgBox, % (0x0 + 0x10), % "ERROR (" . ":*:@doSnglGitCommit" . "): Could Not Locate Git "
			. "PowerShell", % "The Git PowerShell process could not be located and activated."
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
; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@doGitStatus::
	hsName := ":*:@doGitStatus"
	AppendAhkCmd(hsName)
	proceedWithCmd := ActivateGitShell()
	if(proceedWithCmd) {
		SendInput % "git status{enter}"
	} else {
		MsgBox, % (0x0 + 0x10), % "ERROR (" . hsName . "): Could Not Locate Git PowerShell"
			, % "The Git PowerShell process could not be located and activated."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@dogs::
	Gosub, :*:@doGitStatus
Return

;   ································································································
;     >>> §5.3: Automated PASTING OF CSS into online web interfaces
; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

:*:@initCssPaste::
;	prevTitleMatchMode := A_TitleMatchMode
;	SetTitleMatchMode, RegEx
;	SetTitleMatchMode, prevTitleMatchMode
	global hwndCssPasteWindow
	global titleCssPasteWindowTab
	thisAhkCmd := A_ThisLabel
	AppendAhkCmd(thisAhkCmd)
	WinGetTitle, thisTitle, A
	posFound := RegExMatch(thisTitle, "i)^CSS[^" . Chr(0x2014) . "]+" . Chr(0x2014)
		. " WordPress - Google Chrome$")
	if(posFound) {
		WinGet, hwndCssPasteWindow, ID, A
		titleCssPasteWindowTab := thisTitle
		MsgBox, % "HWND for window containing CSS stylsheet editor set to " . hwndCssPasteWindow
	}
	else {
		MsgBox, % (0x0 + 0x10), % "ERROR (:*:@setCssPasteWindow): CSS Stylesheet Editor Not Active"
			, % "Please select your CSS stylesheet editor tab in Chrome as the currently active "
			. "window."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

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
				, % "The HWND set for the chrome window containing the tab in which the CSS "
				. "stylesheet editor was loaded can no longer be found."
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
			, % "You haven't yet used the @setCssPasteWindow hotstring to set the HWND for the "
			. "Chrome window containing a tab with the CSS stylsheet editor."
	}
Return

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

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

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

ExecuteCssPasteCmds(manualProcession := false) {
	; Add check for correct CSS in clipboard — the first line is a font import.
	posFound := RegExMatch(clipboard, "^/\*! Built with the Less CSS preprocessor")
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
		Click, 1565, 401
		Sleep, 60
		Click, 1565, 421
		Sleep, 60
		Click, 1565, 441
		Sleep, 1000
	} else {
		MsgBox, % (0x0 + 0x10)
			, % "ERROR (" . A_ThisFunc .  "): Clipboard Has Unexpected Contents"
			, % "The clipboard does not begin with the expected '@import ...,' and thus may not "
			. "contain minified CSS."
	}			
}

; · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 

ExecuteJsPasteCmds(manualProcession := false) {
	; Add check for correct CSS in clipboard — the first line is a font import.
	posFound := RegExMatch(clipboard, "^// Built with Node.js")
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
			MsgBox, 48, % A_ThisFunc, % "Press OK to proceed with update button "
				. "selection."
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
			, % "The clipboard does not begin with the expected '// Built with Node.js ...,' and "
			. "thus may not contain minified JS."
	}			
}

; --------------------------------------------------------------------------------------------------
;   §6: COMMAND LINE INPUT GENERATION SHORTCUTS
; --------------------------------------------------------------------------------------------------

;   ································································································
;     >>> §6.1: Shortucts for backing up custom CSS builds

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.1: @backupCssAscc

:*:@backupCssAscc::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://ascc.wsu.edu/wp-admin/themes.php?page=editcss")
	WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
		. "\ascc.wsu.edu\CSS\ascc-custom.prev.css")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\'`r"
		. "git add CSS\ascc-custom.prev.css`r"
		. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.2: @backupCssCr

:*:@backupCssCr::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://commonreading.wsu.edu/wp-admin/themes.php?"
		. "page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\commonreading.wsu.edu\CSS\cr-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\'`r"
			. "git add CSS\cr-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.3: @backupCssDsp

:*:@backupCssDsp::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?"
		. "page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\distinguishedscholarships.wsu.edu\CSS\dsp-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\'`r"
			. "git add CSS\dsp-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.4: @backupCssFye

:*:@backupCssFye::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\firstyear.wsu.edu\CSS\fye-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\'`r"
			. "git add CSS\fye-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.5: @backupCssFyf

:*:@backupCssFyf::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=e"
		. "ditcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\learningcommunities.wsu.edu\CSS\learningcommunities-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\'`r"
			. "git add CSS\learningcommunities-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.6: @backupCssNse

:*:@backupCssNse::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder() . "\nse.wsu.edu\CSS\nse-custom.pr"
			. "ev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\nse.wsu.edu\'`r"
			. "git add CSS\nse-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.7: @backupCssOue

:*:@backupCssOue::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://oue.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder() . "\oue.wsu.edu\CSS\oue-custom.pr"
			. "ev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\oue.wsu.edu\'`r"
			. "git add CSS\oue-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.8: @backupCssPbk

:*:@backupCssPbk::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://phibetakappa.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\phibetakappa.wsu.edu\CSS\pbk-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\'`r"
			. "git add CSS\pbk-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.9: @backupCssSurca

:*:@backupCssSurca::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\surca.wsu.edu\CSS\surca-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\surca.wsu.edu\'`r"
			. "git add CSS\surca-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.10: @backupCssSumRes

:*:@backupCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://summerresearch.wsu.edu/wp-admin/themes.php?page=editcs"
		. "s")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\summerresearch.wsu.edu\CSS\summerresearch-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\'`r"
			. "git add CSS\summerresearch-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.11: @backupCssXfer

:*:@backupCssXfer::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://transfercredit.wsu.edu/wp-admin/themes.php?page=editcs"
		. "s")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\transfercredit.wsu.edu\CSS\xfercredit-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu\'`r"
			. "git add CSS\xfercredit-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.12: @backupCssUgr

:*:@backupCssUgr::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page"
		. "=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\undergraduateresearch.wsu.edu\CSS\undergraduate-research-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\'`r"
			. "git add CSS\undergraduate-research-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.13: @backupCssXfer

:*:@backupCssUcore::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=editcss")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\ucore.wsu.edu\CSS\ucore-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\'`r"
			. "git add CSS\ucore-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.14: @backupCssUcrAss

:*:@backupCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	copiedCss := CopyCssFromWebsite("https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=edit"
		. "css")
	if (VerifyCopiedCode(A_ThisLabel, copiedCss)) {
		WriteCodeToFile(A_ThisLabel, copiedCss, GetGitHubFolder()
			. "\ucore.wsu.edu-assessment\CSS\ucore-assessment-custom.prev.css")
		PasteTextIntoGitShell(A_ThisLabel
			, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\'`r"
			. "git add CSS\ucore-assessment-custom.prev.css`r"
			. "git commit -m 'Updating backup of latest verified custom CSS build'`r"
			. "git push`r")
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.15: @backupCssAll

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
;       →→→ §6.1.16: CopyCssFromWebsite

CopyCssFromWebsite(websiteUrl)
{
	LoadWordPressSiteInChrome(websiteUrl)
	copiedCss := ExecuteCssCopyCmds()
	return copiedCss
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.1.16: CopyCssFromWebsite

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
;     >>> §6.2: Shortcuts for rebuilding & committing custom CSS files

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.1: @rebuildCssHere

:*:@rebuildCssHere::
	currentDir := GetCurrentDirFromPS()
	if (GetCmdForMoveToCSSFolder(currentDir) = "awesome!") {
		MsgBox % "Current location: " . currentDir
	}
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.2: @rebuildCssAscc

:*:@rebuildCssAscc::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssAscc")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.3: @commitCssAscc

:*:@commitCssAscc::
	gitFolder := "ascc.wsu.edu" ; fp = file path
	lessSrcFile := "ascc-custom_new.less" ; fn = file name
	cssBuildFile := "ascc-custom.css"
	minCssBuildFile := "ascc-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the 
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.4: @rebuildCssCr

:*:@rebuildCssCr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssCr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.5: @commitCssCr

:*:@commitCssCr::
	gitFolder := "commonreading.wsu.edu" ; fp = file path
	lessSrcFile := "src_cr-new.less" ; fn = file name
	cssBuildFile := "cr-custom.css"
	minCssBuildFile := "cr-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the 
	;CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.6: @rebuildCssDsp

:*:@rebuildCssDsp::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssDsp")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.7: @commitCssDsp

:*:@commitCssDsp::
	gitFolder := "distinguishedscholarships.wsu.edu" ; fp = file path
	lessSrcFile := "dsp-custom.less" ; fn = file name
	cssBuildFile := "dsp-custom.css"
	minCssBuildFile := "dsp-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.8: @rebuildCssFye

:*:@rebuildCssFye::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssFye")	
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.9: @commitCssFye

:*:@commitCssFye::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu'`r"
		. "git add CSS\fye-custom.css`r"
		. "git add CSS\fye-custom.min.css`r"
		. "git commit -m 'Updating custom CSS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies.' `r"
		. "git push`r"
		. "[console]::beep(2000,150)`r"
		. "[console]::beep(2000,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.10: @rebuildCssFyf

:*:@rebuildCssFyf::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssFyf")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.11: @commitCssFyf

:*:@commitCssFyf::
	gitFolder := "learningcommunities.wsu.edu"
	lessSrcFile := "learningcommunities-custom.less"
	cssBuildFile := "learningcommunities-custom.css"
	minCssBuildFile := "learningcommunities-custom.min.css"

	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.12: @rebuildCssNse

:*:@rebuildCssNse::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\nse.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssNse")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.13: @commitCssNse

:*:@commitCssNse::
	gitFolder := "nse.wsu.edu" ; fp = file path
	lessSrcFile := "nse-custom.less" ; fn = file name
	cssBuildFile := "nse-custom.css"
	minCssBuildFile := "nse-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.14: @rebuildCssOue

:*:@rebuildCssOue::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssOue")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.15: @commitCssOue

:*:@commitCssOue::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu'`r"
		. "git add CSS\oue-custom.css`r"
		. "git add CSS\oue-custom.min.css`r"
		. "git commit -m 'Updating custom CSS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies.' `r"
		. "git push`r"
		. "[console]::beep(2000,150)`r"
		. "[console]::beep(2000,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.16: @rebuildCssPbk

:*:@rebuildCssPbk::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssPbk")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.17: @commitCssPbk

:*:@commitCssPbk::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu'`r"
		. "git add CSS\pbk-custom.css`r"
		. "git add CSS\pbk-custom.min.css`r"
		. "git commit -m 'Updating custom CSS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies.' `r"
		. "git push`r"
		. "[console]::beep(2000,150)`r"
		. "[console]::beep(2000,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.18: @rebuildCssSurca

:*:@rebuildCssSurca::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\surca.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssSurca")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.19: @commitCssSurca

:*:@commitCssSurca::
	gitFolder := "surca.wsu.edu" ; fp = file path
	lessSrcFile := "surca-custom.less" ; fn = file name
	cssBuildFile := "surca-custom.css"
	minCssBuildFile := "surca-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.20: @rebuildCssSumRes

:*:@rebuildCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssSumRes")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.21: @commitCssSumRes

:*:@commitCssSumRes::
	gitFolder := "summerresearch.wsu.edu" ; fp = file path
	lessSrcFile := "summerresearch-custom.less" ; fn = file name
	cssBuildFile := "summerresearch-custom.css"
	minCssBuildFile := "summerresearch-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.22: @rebuildCssXfer

:*:@rebuildCssXfer::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssXfer")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.23: @commitCssXfer

:*:@commitCssXfer::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu'`r"
		. "git add CSS\xfercredit-custom.css`r"
		. "git add CSS\xfercredit-custom.min.css`r"
		. "git commit -m 'Updating custom CSS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies.' `r"
		. "git push`r"
		. "[console]::beep(2000,150)`r"
		. "[console]::beep(2000,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.24: @rebuildCssUgr

:*:@rebuildCssUgr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssUgr")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.25: @commitCssUgr

:*:@commitCssUgr::
	gitFolder := "undergraduateresearch.wsu.edu" ; fp = file path
	lessSrcFile := "undergraduate-research-custom.less" ; fn = file name
	cssBuildFile := "undergraduate-research-custom.css"
	minCssBuildFile := "undergraduate-research-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.26: @commitCssSumRes

:*:@rebuildCssUcore::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssUcore")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.27: @commitCssUcore

:*:@commitCssUcore::
	gitFolder := "ucore.wsu.edu" ; fp = file path
	lessSrcFile := "ucore-custom.less" ; fn = file name
	cssBuildFile := "ucore-custom.css"
	minCssBuildFile := "ucore-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.28: @rebuildCssUcrAss

:*:@rebuildCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment'`r"
		. "gulp buildMinCss`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitCssUcrAss")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.29: @commitCssUcrAss

:*:@commitCssUcrAss::
	gitFolder := "ucore.wsu.edu-assessment" ; fp = file path
	lessSrcFile := "ucore-assessment-custom.less" ; fn = file name
	cssBuildFile := "ucore-assessment-custom.css"
	minCssBuildFile := "ucore-assessment-custom.min.css"

	; Register this hotkey with command history interface & process instructions for committing the
	; CSS build
	AppendAhkCmd(A_ThisLabel)
	CommitCssBuild(A_ThisLabel, gitFolder, lessSrcFile, cssBuildFile, minCssBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.2.30: @rebuildCssAll

:*:@rebuildCssAll::
	AppendAhkCmd(A_ThisLabel)
	Gosub, :*:@rebuildCssCr
	Gosub, :*:@rebuildCssDsp
	Gosub, :*:@rebuildCssFye
	Gosub, :*:@rebuildCssFyf
	Gosub, :*:@rebuildCssNse
	Gosub, :*:@rebuildCssOue
	Gosub, :*:@rebuildCssPbk
	Gosub, :*:@rebuildCssSurca
	Gosub, :*:@rebuildCssSumRes
	Gosub, :*:@rebuildCssXfer
	Gosub, :*:@rebuildCssUgr
	Gosub, :*:@rebuildCssUcore
	Gosub, :*:@rebuildCssUcrAss
	PasteTextIntoGitShell(A_ThisLabel
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r")
Return

;   ································································································
;     >>> §6.3: Shortcuts for updating CSS submodules

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.1: @updateCssSubmoduleAscc

:*:@updateCssSubmoduleAscc::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssAscc
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.2: @updateCssSubmoduleCr

:*:@updateCssSubmoduleCr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssCr
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.3: @updateCssSubmoduleDsp

:*:@updateCssSubmoduleDsp::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating"
		. " recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssDsp
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.4: @updateCssSubmoduleFye

:*:@updateCssSubmoduleFye::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssFye
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.5: @updateCssSubmoduleFyf

:*:@updateCssSubmoduleFyf::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssFyf
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.6: @updateCssSubmoduleNse

:*:@updateCssSubmoduleNse::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\nse.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssNse
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.7: @updateCssSubmoduleOue

:*:@updateCssSubmoduleOue::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssOue
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.8: @updateCssSubmodulePbk

:*:@updateCssSubmodulePbk::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssPbk
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.9: @updateCssSubmoduleSurca

:*:@updateCssSubmoduleSurca::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\surca.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssSurca
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.10: @updateCssSubmoduleSumRes

:*:@updateCssSubmoduleSumRes::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssSumRes
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.11: @updateCssSubmoduleXfer

:*:@updateCssSubmoduleXfer::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssXfer
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.12: @updateCssSubmoduleUgr

:*:@updateCssSubmoduleUgr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssUgr
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.13: @updateCssSubmoduleUcore

:*:@updateCssSubmoduleUcore::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssUcore
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.14: @updateCssSubmoduleUcrAss

:*:@updateCssSubmoduleUcrAss::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\WSU-UE---CSS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---CSS`r"
		. "git commit -m 'Updating custom CSS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildCssUcrAss
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.3.15: @updateCssSubmoduleAll

:*:@updateCssSubmoduleAll::
	AppendAhkCmd(A_ThisLabel)
	Gosub, :*:@updateCssSubmoduleAscc
	Gosub, :*:@updateCssSubmoduleCr
	Gosub, :*:@updateCssSubmoduleDsp
	Gosub, :*:@updateCssSubmoduleFye
	Gosub, :*:@updateCssSubmoduleFyf
	Gosub, :*:@updateCssSubmoduleNse
	Gosub, :*:@updateCssSubmoduleOue
	Gosub, :*:@updateCssSubmodulePbk
	Gosub, :*:@updateCssSubmoduleSurca
	Gosub, :*:@updateCssSubmoduleSumRes
	Gosub, :*:@updateCssSubmoduleXfer
	Gosub, :*:@updateCssSubmoduleUgr
	Gosub, :*:@updateCssSubmoduleUcore
	Gosub, :*:@updateCssSubmoduleUcrAss
	PasteTextIntoGitShell(A_ThisLabel
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r")
Return

;   ································································································
;     >>> §6.4: For copying minified, backup css files to clipboard

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.1: @copyMinCssAscc

:*:@copyMinCssAscc::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ascc.wsu.edu\CSS\ascc-custom.min.css"
		, "", "Couldn't copy minified CSS for ASCC website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.2: @copyBackupCssAscc

:*:@copyBackupCssAscc::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ascc.wsu.edu\CSS\ascc-custom.min.prev.css"
		, "", "Couldn't copy backup CSS for ASCC Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.3: @copyMinCssCr

:*:@copyMinCssCr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\commonreading.wsu.edu\CSS\cr-custom.min.css"
		, "/*! Built with the LESS CSS preprocessor [http://lesscss.org/]. Please see "
		. "[https://github.com/invokeImmediately/commonreading.wsu.edu] for a repository of source "
		. "code. */`r`n`r`n", "Couldn't copy minified CSS for Common Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.4: @copyBackupCssCr

:*:@copyBackupCssCr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\commonreading.wsu.edu\CSS\cr-custom.min.prev.css"
		, "", "Couldn't copy backup CSS for Common Reading website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.5: @copyMinCssDsp

:*:@copyMinCssDsp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\CSS\dsp-custom.min.css"
		, "", "Couldn't copy minified CSS for DSP Website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.6: @copyBackupCssDsp

:*:@copyBackupCssDsp::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\CSS\dsp-custom.prev.css"
		, "", "Couldn't copy backup CSS for DSP Website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.7: @copyMinCssFye

:*:@copyMinCssFye::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\firstyear.wsu.edu\CSS\fye-custom.min.css"
		, "/*! Built with the LESS CSS preprocessor [http://lesscss.org/]. Please see "
		. "[https://github.com/invokeImmediately/firstyear.wsu.edu] for a repository of source "
		. "code. */`r`n`r`n", "Couldn't copy minified CSS for FYE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.8: @copyBackupCssFye

:*:@copyBackupCssFye::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\firstyear.wsu.edu\CSS\fye-custom.prev.css"
		, "", "Couldn't copy backup CSS for FYE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.9: @copyMinCssFyf

:*:@copyMinCssFyf::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\CSS\learningcommunities-custom.min.css"
		, "", "Couldn't copy minified CSS for First-Year Focus website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.10: @copyBackupCssFyf

:*:@copyBackupCssFyf::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\CSS\learningcommunities-custom.prev.css"
		, "", "Couldn't copy backup CSS for First-Year Focus website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.11: @copyMinCssNse

:*:@copyMinCssNse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nse.wsu.edu\CSS\nse-custom.min.css"
		, "", "Couldn't copy minified CSS for NSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.12: @copyBackupCssNse

:*:@copyBackupCssNse::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\nse.wsu.edu\CSS\nse-custom.prev.css"
		, "", "Couldn't copy backup CSS for NSE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.13: @copyMinCssOue

:*:@copyMinCssOue::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\oue.wsu.edu\CSS\oue-custom.min.css"
		, "", "Couldn't copy minified CSS for OUE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.14: @copyMinCssPbk

:*:@copyMinCssPbk::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\CSS\pbk-custom.min.css"
		, "", "Couldn't copy minified CSS for Phi Beta Kappa website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.15: @copyBackupCssPbk

:*:@copyBackupCssPbk::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\CSS\pbk-custom.prev.css"
		, "", "Couldn't copy backup CSS for Phi Beta Kappa website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.16: @copyMinCssSurca

:*:@copyMinCssSurca::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\surca.wsu.edu\CSS\surca-custom.min.css"
		, "/*! Built with the LESS CSS preprocessor [http://lesscss.org/]. Please see "
		. "[https://github.com/invokeImmediately/surca.wsu.edu] for a repository of source code. "
		. "*/`r`n`r`n", "Couldn't copy minified CSS for SURCA website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.17: @copyBackupCssSurca

:*:@copyBackupCssSurca::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\surca.wsu.edu\CSS\surca-custom.prev.css"
		, "", "Couldn't copy backup CSS for SURCA website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.18: @copyMinCssSumRes

:*:@copyMinCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\summerresearch.wsu.edu\CSS\summerresearch-custom.min.css", ""
		, "Couldn't copy minified CSS for Summer Research website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.19: @copyBackupCssSumRes

:*:@copyBackupCssSumRes::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\summerresearch.wsu.edu\CSS\summerresearch-custom.prev.css"
		, "", "Couldn't copy backup CSS for Summer Research website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.20: @copyMinCssXfer

:*:@copyMinCssXfer::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\transfercredit.wsu.edu\CSS\xfercredit-custom.min.css"
		, "", "Couldn't copy minified CSS for Transfer Credit website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.21: @copyBackupCssXfer

:*:@copyBackupCssXfer::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\transfercredit.wsu.edu\CSS\xfercredit-custom.prev.css"
		, "", "Couldn't copy backup CSS for Transfer Credit website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.22: @copyMinCssUgr

:*:@copyMinCssUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\CSS\"
		. "undergraduate-research-custom.min.css", ""
		, "Couldn't copy minified CSS for UGR website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.23: @copyBackupCssUgr

:*:@copyBackupCssUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\CSS\undergraduate-research-custom.pre"
		. "v.css", "", "Couldn't copy backup CSS for UGR website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.24: @copyMinCssUcore

:*:@copyMinCssUcore::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu\CSS\ucore-custom.min.css"
		, "", "Couldn't copy minified CSS for UCORE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.25: @copyBackupCssUcore

:*:@copyBackupCssUcore::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu\CSS\ucore-custom.prev.css"
		, "", "Couldn't copy backup CSS for UCORE website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.26: @copyMinCssUcrAss

:*:@copyMinCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\CSS\ucore-assessment-custom.min.css"
		, "", "Couldn't copy minified CSS for UCORE Assessment website.")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.4.27: @copyBackupCssUcrAss

:*:@copyBackupCssUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\CSS\ucore-assessment-custom.min.css"
		, "", "Couldn't copy backup CSS for UCORE Assessment website.")
Return

;   ································································································
;     >>> §6.5: FOR BACKING UP CUSTOM JS BUILDS

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.1: @backupJsAscc

:*:@backupJsAscc::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://ascc.wsu.edu/wp-admin/themes.php?page=custom-javascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\ascc.wsu.edu\JS\ascc-custom.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\'`r"
		. "git add JS\ascc-custom.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.2: @backupJsCr

:*:@backupJsCr::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://commonreading.wsu.edu/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\commonreading.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.3: @backupJsDsp

:*:@backupJsDsp::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://distinguishedscholarships.wsu.edu/wp-admin/themes.php?page=custom-ja"
		. "vascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\distinguishedscholarships.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.4: @backupJsFye

:*:@backupJsFye::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://firstyear.wsu.edu/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\firstyear.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.5: @backupJsFyf

:*:@backupJsFyf::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://learningcommunities.wsu.edu/wp-admin/themes.php?page=custom-javascri"
		. "pt", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\learningcommunities.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.6: @backupJsNse

:*:@backupJsNse::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://nse.wsu.edu/wp-admin/themes.php?page=custom-javascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder() . "\nse.wsu.edu\JS\nse-custom.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\nse.wsu.edu\'`r"
		. "git add JS\nse-custom.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.7: @backupJsOue

:*:@backupJsOue::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://oue.wsu.edu/wp-admin/themes.php?page=custom-javascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder() . "\oue.wsu.edu\JS\oue-custom.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu\'`r"
		. "git add JS\oue-custom.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.8: @backupJsPbk

:*:@backupJsPbk::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://phibetakappa.wsu.edu/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\phibetakappa.wsu.edu\JS\pbk-custom.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\'`r"
		. "git add JS\pbk-custom.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.9: @backupJsSurca

:*:@backupJsSurca::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://surca.wsu.edu/wp-admin/themes.php?page=custom-javascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\surca.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\surca.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.10: @backupJsSumRes

:*:@backupJsSumRes::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://summerresearch.wsu.edu/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\summerresearch.wsu.edu\JS\sumres-build.min.prev.js")
	GoSub, :*:@commitBackupJsSumRes
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.11: @commitBackupJsSumRes

:*:@commitBackupJsSumRes::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\'`r"
		. "git add JS\sumres-build.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.12: @backupJsXfer

:*:@backupJsXfer::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://transfercredit.wsu.edu/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\transfercredit.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.13: @backupJsUgr

:*:@backupJsUgr::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://undergraduateresearch.wsu.edu/wp-admin/themes.php?page=custom-javasc"
		. "ript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\undergraduateresearch.wsu.edu\JS\wp-custom-js-source.min.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.14: @backupJsUcore

:*:@backupJsUcore::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://ucore.wsu.edu/wp-admin/themes.php?page=custom-javascript", copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder() . "\ucore.wsu.edu\JS\wp-custom-js-source.mi"
		. "n.prev.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.min.prev.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.15: @backupJsUcrAss

:*:@backupJsUcrAss::
	AppendAhkCmd(A_ThisLabel)
	CopyJsFromWebsite("https://ucore.wsu.edu/assessment/wp-admin/themes.php?page=custom-javascript"
		, copiedJs)
	WriteCodeToFile(A_ThisLabel, copiedJs, GetGitHubFolder()
		. "\ucore.wsu.edu-assessment\JS\wp-custom-js-source.min.js")
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\'`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating backup of latest verified custom JS build'`r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.16: @backupJsAll

:*:@backupJsAll::
	AppendAhkCmd(A_ThisLabel)
	Gosub, :*:@backupJsAscc
	Gosub, :*:@backupJsCr
	Gosub, :*:@backupJsDsp
	Gosub, :*:@backupJsFye
	Gosub, :*:@backupJsFyf
	Gosub, :*:@backupJsNse
	Gosub, :*:@backupJsOue
	Gosub, :*:@backupJsPbk
	Gosub, :*:@backupJsSurca
	Gosub, :*:@backupJsSumRes
	Gosub, :*:@backupJsXfer
	Gosub, :*:@backupJsUgr
	Gosub, :*:@backupJsUcore
	Gosub, :*:@backupJsUcrAss
	PasteTextIntoGitShell(A_ThisLabel
		, "[console]::beep(750,600)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r"
		. "[console]::beep(375,150)`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.17: CopyJsFromWebsite

CopyJsFromWebsite(websiteUrl, ByRef copiedJs)
{
	LoadWordPressSiteInChrome(websiteUrl)
	ExecuteJsCopyCmds(copiedJs)
}

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.5.18: ExecuteJsCopyCmds

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
;     >>> §6.6: FOR REBUILDING JS SOURCE FILES

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.1: @rebuildJsAscc

:*:@rebuildJsAscc::
	ahkCmdName := ":*:@rebuildJsAscc"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs ascc-custom.js --output ascc-custom.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\'`r"
		. "git add JS\ascc-custom.js`r"
		. "git add JS\ascc-custom.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.2: @rebuildJsCr

:*:@rebuildJsCr::
	ahkCmdName := ":*:@rebuildJsCr"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.3: @rebuildJsDsp

:*:@rebuildJsDsp::
	ahkCmdName := ":*:@rebuildJsDsp"
	AppendAhkCmd(ahkCmdName)
	; TODO: Add AHK function for creating a JS build string
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\'`r"
		. "gulp buildMinJs`r"
		. "Start-Sleep -s 1`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(ahkCmdName, ":*:@commitJsDsp")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.4: @commitJsDsp

:*:@commitJsDsp::
	gitFolder := "distinguishedscholarships.wsu.edu" ; fp = file path
	jsSrcFile := "dsp-custom.js" ; fn = file name
	jsBuildFile := "dsp-custom-build.js"
	minJsBuildFile := "dsp-custom-build.min.js"
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, gitFolder, jsSrcFile, jsBuildFile, minJsBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.5: @rebuildJsFye

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
;       →→→ §6.6.6: @rebuildJsFyf

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
;       →→→ §6.6.7: @rebuildJsNse

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
;       →→→ §6.6.8: @rebuildJsOue

:*:@rebuildJsOue::
	ahkCmdName := ":*:@rebuildJsOue"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs oue-custom.js --output oue-custom.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\oue.wsu.edu\'`r"
		. "git add JS\oue-custom.js`r"
		. "git add JS\oue-custom.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.9: @rebuildJsPbk

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
;       →→→ §6.6.10: @rebuildJsSurca

:*:@rebuildJsSurca::
	ahkCmdName := ":*:@rebuildJsSurca"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\surca.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\surca.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.11: @rebuildJsSumRes

:*:@rebuildJsSumRes::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\JS'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsSumRes")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.12: @commitJsSumRes

:*:@commitJsSumRes::
	gitFolder := "summerresearch.wsu.edu"
	jsSrcFile := "sumres-custom.js"
	jsBuildFile := "sumres-build.js"
	minJsBuildFile := "sumres-build.min.js"
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, gitFolder, jsSrcFile, jsBuildFile, minJsBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.13: @rebuildJsXfer

:*:@rebuildJsXfer::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu\'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsXfer")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.14: @commitJsXfer

:*:@commitJsXfer::
	gitFolder := "transfercredit.wsu.edu" ; fp = file path
	jsSrcFile := "transfer-central-custom.js" ; fn = file name
	jsBuildFile := "transfer-central-custom-build.js"
	minJsBuildFile := "transfer-central-custom-build.min.js"
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, gitFolder, jsSrcFile, jsBuildFile, minJsBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.15: @rebuildJsUgr

:*:@rebuildJsUgr::
	AppendAhkCmd(A_ThisLabel)
	PasteTextIntoGitShell(A_ThisLabel
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\JS'`r"
		. "gulp buildMinJs`r"
		. "[console]::beep(1500,300)`r")
	CommitAfterBuild(A_ThisLabel, ":*:@commitJsSumRes")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.16: @commitJsUgr

:*:@commitJsUgr::
	gitFolder := "undergraduateresearch.wsu.edu"
	jsSrcFile := "ugr-custom.js"
	jsBuildFile := "ugr-build.js"
	minJsBuildFile := "ugr-build.min.js"
	AppendAhkCmd(A_ThisLabel)
	CommitJsBuild(A_ThisLabel, gitFolder, jsSrcFile, jsBuildFile, minJsBuildFile)
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.17: @rebuildJsUcore

:*:@rebuildJsUcore::
	ahkCmdName := ":*:@rebuildJsUcore"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\JS'`r"
		. "node build-production-file.js`r"
		. "uglifyjs wp-custom-js-source.js --output wp-custom-js-source.min.js -mt`r"
		. "[console]::beep(1500,300)`r"
		. "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\'`r"
		. "git add JS\wp-custom-js-source.js`r"
		. "git add JS\wp-custom-js-source.min.js`r"
		. "git commit -m 'Updating custom JS build' -m 'Rebuilt production files to incorporate "
		. "recent changes to source code and/or dependencies' `r"
		. "git push`r")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.6.18: @rebuildJsUcrAss

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
;     >>> §6.7: FOR UPDATING JS SUBMODULES

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.1: @updateJsSubmoduleAscc

:*:@updateJsSubmoduleAscc::
	ahkCmdName := ":*:@updateJsSubmoduleAscc"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ascc.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsAscc
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.2: @updateJsSubmoduleCr

:*:@updateJsSubmoduleCr::
	ahkCmdName := ":*:@updateJsSubmoduleCr"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\commonreading.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsCr
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.3: @updateJsSubmoduleDsp

:*:@updateJsSubmoduleDsp::
	ahkCmdName := ":*:@updateJsSubmoduleDsp"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsDsp
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.4: @updateJsSubmoduleFye

:*:@updateJsSubmoduleFye::
	ahkCmdName := ":*:@updateJsSubmoduleFye"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\firstyear.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsFye
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.5: @updateJsSubmoduleFyf

:*:@updateJsSubmoduleFyf::
	ahkCmdName := ":*:@updateJsSubmoduleFyf"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\learningcommunities.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsFyf
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.6: @updateJsSubmoduleNse

:*:@updateJsSubmoduleNse::
	ahkCmdName := ":*:@updateJsSubmoduleNse"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\nse.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsFyf
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.7: @updateJsSubmoduleOue

:*:@updateJsSubmoduleOue::
	ahkCmdName := ":*:@updateJsSubmoduleOue"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\oue.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsOue
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.8: @updateJsSubmodulePbk

:*:@updateJsSubmodulePbk::
	ahkCmdName := ":*:@updateJsSubmodulePbk"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\phibetakappa.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsPbk
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.9: @updateJsSubmoduleSurca

:*:@updateJsSubmoduleSurca::
	ahkCmdName := ":*:@updateJsSubmoduleSurca"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\surca.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsSurca
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.10: @updateJsSubmoduleSumRes

:*:@updateJsSubmoduleSumRes::
	ahkCmdName := ":*:@updateJsSubmoduleSumRes"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\summerresearch.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsSumRes
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.11: @updateJsSubmoduleXfer

:*:@updateJsSubmoduleXfer::
	ahkCmdName := ":*:@updateJsSubmoduleXfer"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\transfercredit.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsXfer
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.12: @updateJsSubmoduleUgr

:*:@updateJsSubmoduleUgr::
	ahkCmdName := ":*:@updateJsSubmoduleUgr"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\undergraduateresearch.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsUgr
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.13: @updateJsSubmoduleUcore

:*:@updateJsSubmoduleUcore::
	ahkCmdName := ":*:@updateJsSubmoduleUcore"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsUcore
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.14: @updateJsSubmoduleUcrAss

:*:@updateJsSubmoduleUcrAss::
	ahkCmdName := ":*:@updateJsSubmoduleUcrAss"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd '" . GetGitHubFolder() . "\ucore.wsu.edu-assessment\WSU-UE---JS'`r"
		. "git fetch`r"
		. "git merge origin/master`r"
		. "cd ..`r"
		. "git add WSU-UE---JS`r"
		. "git commit -m 'Updating custom JS master submodule for OUE websites' -m 'Incorporating "
		. "recent changes in project source code'`r"
		. "git push`r")
	Gosub, :*:@rebuildJsUcrAss
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.7.15: @updateJsSubmoduleAll

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
;     >>> §6.8: Shortcuts for copying minified JS to clipboard

;TODO: Add scripts for copying JS backups to clipboard (see CSS backup-copying scripts above)

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.1: @copyMinJsAscc

:*:@copyMinJsAscc::
	ahkCmdName := ":*:@copyMinJsAscc"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ascc.wsu.edu\JS\ascc-custom.min.js"
		, "", "Couldn't Copy Minified JS for ASCC Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.2: @copyMinJsCr

:*:@copyMinJsCr::
	ahkCmdName := ":*:@copyMinJsCr"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\commonreading.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for CR Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.3: @copyMinJsDsp

:*:@copyMinJsDsp::
	ahkCmdName := ":*:@copyMinJsDsp"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\distinguishedscholarships.wsu.edu\JS\wp-custom-js-source.min.dsp.js"
		, "", "Couldn't Copy Minified JS for DSP Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.4: @copyMinJsFye

:*:@copyMinJsFye::
	ahkCmdName := ":*:@copyMinJsFye"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\firstyear.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for FYE Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.5: @copyMinJsFyf

:*:@copyMinJsFyf::
	ahkCmdName := ":*:@copyMinJsFyf"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\learningcommunities.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for FYF Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.6: @copyMinJsNse

:*:@copyMinJsNse::
	ahkCmdName := ":*:@copyMinJsNse"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\nse.wsu.edu\JS\nse-custom.min.js"
		, "", "Couldn't Copy Minified JS for Nse Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.7: @copyMinJsOue

:*:@copyMinJsOue::
	ahkCmdName := ":*:@copyMinJsOue"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\JS\oue-custom.min.js"
		, "", "Couldn't Copy Minified JS for WSU OUE Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.8: @copyBackupJsOue

:*:@copyBackupJsOue::
	ahkCmdName := ":*:@copyBackupJsOue"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\oue.wsu.edu\JS\oue-custom.min.prev.js"
		, "", "Couldn't copy backup copy of minified JS for WSU OUE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.9: @copyMinJsPbk

:*:@copyMinJsPbk::
	ahkCmdName := ":*:@copyMinJsPbk"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\phibetakappa.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for WSU Phi Beta Kappa Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.10: @copyMinJsSurca

:*:@copyMinJsSurca::
	ahkCmdName := ":*:@copyMinJsSurca"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\surca.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for SURCA Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.11: @copyMinJsSumRes

:*:@copyMinJsSumRes::
	ahkCmdName := ":*:@copyMinJsSumRes"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\summerresearch.wsu.edu\JS\sumres-build.min.js"
		, "", "Couldn't Copy Minified JS for WSU Summer Research Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.12: @copyMinJsXfer

:*:@copyMinJsXfer::
	ahkCmdName := ":*:@copyMinJsXfer"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\transfercredit.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for WSU Transfer Credit Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.13: @copyMinJsUgr

:*:@copyMinJsUgr::
	AppendAhkCmd(A_ThisLabel)
	CopySrcFileToClipboard(A_ThisLabel
		, GetGitHubFolder() . "\undergraduateresearch.wsu.edu\JS\ugr-build.min.js"
		, "", "Couldn't Copy Minified JS for UGR Website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.14: @copyMinJsUcore

:*:@copyMinJsUcore::
	ahkCmdName := ":*:@copyMinJsUcore"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu\JS\wp-custom-js-source.min.js"
		, "", "Couldn't copy minified JS for UCORE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.15: @copyBackupJsUcore

:*:@copyBackupJsUcore::
	ahkCmdName := ":*:@copyBackupJsUcore"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu\JS\wp-custom-js-source.min.prev.js"
		, ""		, "Couldn't copy backup copy of minified JS for UCORE website")
Return

;      · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
;       →→→ §6.8.16: @copyMinJsUcrAss

:*:@copyMinJsUcrAss::
	ahkCmdName := ":*:@copyMinJsUcrAss"
	AppendAhkCmd(ahkCmdName)
	CopySrcFileToClipboard(ahkCmdName
		, GetGitHubFolder() . "\ucore.wsu.edu-assessment\JS\wp-custom-js-source.min.js"
		, "", "Couldn't Copy Minified JS for WSU Summer Research Website")
Return

;   ································································································
;     >>> §6.9: FOR CHECKING GIT STATUS ON ALL PROJECTS 

:*:@checkGitStatus::
	ahkCmdName := ":*:@checkGitStatus"
	AppendAhkCmd(ahkCmdName)
	PasteTextIntoGitShell(ahkCmdName
		, "cd 'C:\Users\CamilleandDaniel\Documents\GitHub\'`r`n"
		. "Write-Host ""``n----------------------------------------------WSU-OUE-AutoHotkey--------"
		. "---------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\WSU-OUE-AutoHotkey\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n------------------------------------------------WSU-OUE---CSS-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\WSU-UE---CSS\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n-------------------------------------------------WSU-OUE---JS-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\WSU-UE---JS\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n-------------------------------------------------ascc.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\ascc.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n--------------------------------------------commonreading.wsu.edu-------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\commonreading.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n--------------------------------------distinguishedscholarships.wsu.edu-"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\distinguishedscholarships.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n----------------------------------------------firstyear.wsu.edu---------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\firstyear.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n-----------------------------------------learningcommunities.wsu.edu----"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\learningcommunities.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n-------------------------------------------------oue.wsu.edu------------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\oue.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n------------------------------------------------surca.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\surca.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n----------------------------------------undergraduateresearch.wsu.edu---"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\undergraduateresearch.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n--------------------------------------------transfercredit.wsu.edu------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\transfercredit.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n--------------------------------------------summerresearch.wsu.edu------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\summerresearch.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n------------------------------------------------ucore.wsu.edu-----------"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\ucore.wsu.edu\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n"
		. "Write-Host ""``n-------------------------------------------ucore.wsu.edu/assessment-----"
		. "--------------------------------------"" -ForegroundColor ""green""`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\ucore.wsu.edu-assessment\""`r`n"
		. "git status`r`n"
		. "cd ""C:\Users\CamilleandDaniel\Documents\GitHub\""`r`n")
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
