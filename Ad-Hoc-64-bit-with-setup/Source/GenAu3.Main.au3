#NoTrayIcon

Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPED = 0
Global Const $WS_SYSMENU = 0x00080000
Global Const $DS_SETFOREGROUND = 0x0200
Global Const $WS_EX_CLIENTEDGE = 0x00000200

Global Const $SS_LEFT = 0x0
Global Const $SS_CENTERIMAGE = 0x0200

Global Const $GUI_EVENT_CLOSE = -3

Local $Win, $Input, $Btn, $FO[3], $AppName, $UpDir, $ReadStr, $Num, $Var, $ChkFO = True, $CheckLoop, _
	  $StartExe, $InsStr[18], $RegGlob, $Sepr, $n = 0
Local $RegStr[2] = ["HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI"]
Local $FileMask[12] = ['.exe', '.msi', '.msc', '.bat', '.cmd', '.ps1', '.js', '.jse', '.vbe', '.vbs', '.wsf', '.wsh']
Local $Envir[12] = ['AppData', 'LocalAppData', 'UserProfile', 'Public', 'AllUsersProfile', 'CommonProgramFiles', _
				'CommonProgramFiles(x86)', 'ProgramFiles', 'ProgramFiles(x86)', 'WinDir', 'Temp', 'HomeDrive']

Local $DPI = RegRead($RegStr[0], $RegStr[1]), $TxtSize = Ceiling(8.5*25/2400*$DPI)
Local $WinHeight = Round(11.2*$TxtSize)
If Int(@DesktopWidth/@DesktopHeight*100) >= 170 Then
   Local $WinWidth = Round(3.3*$WinHeight)
Else
   Local $WinWidth = 3*$WinHeight
EndIf

If $DPI > 220 And $DPI < 481 Then
   $WinHeight = Round(1.05*$WinHeight)
   $WinWidth = Round(1.05*$WinWidth)
ElseIf $DPI > 480 Then
   $WinHeight = Round(1.1*$WinHeight)
   $WinWidth = Round(1.1*$WinWidth)
EndIf

Switch @OSLang
   Case "0419", "0819"
	  Local $Text = "Введите название глобального счетчика:"
   Case Else
	  Local $Text = "Enter the name of the global counter:"
EndSwitch

Local $WinSty = BitOR($WS_CAPTION, $WS_OVERLAPPED, $WS_SYSMENU, $DS_SETFOREGROUND)
Local $WinTxt = "Tahoma"
Local $WinColr = 0xfafafa

Local Const $BlkTxt = "Tahoma"
If $DPI > 103 And $DPI < 112 Or $DPI > 135 And $DPI < 144 Then
   Local Const $BlkTxtSz = 9
Else
   Local Const $BlkTxtSz = 8.5
EndIf
Local $BlkLeft = $TxtSize
Local $BlkTop = Round(1.2*$TxtSize)
Local $BlkWidth =$WinWidth-2*$BlkLeft
Local $BlkHeight = 2*$TxtSize
Local $BlkSty = BitOR($SS_LEFT, $SS_CENTERIMAGE)

Local $InputLeft = $BlkLeft
Local $InputTop = $BlkTop+3*$TxtSize
Local $InputWidth = $WinWidth-2*$BlkLeft
Local $InputHeight = Round(2.2*$TxtSize)
Local $InputSty = $WS_EX_CLIENTEDGE

Local Const $BtnTxt = "Tahoma", $BtnTxtSz = $BlkTxtSz
Local $BtnHeight = Round(2.7*$TxtSize)
Local $BtnWidth = 10*$TxtSize
Local $BtnLeft = $WinWidth-$BtnWidth-$BlkLeft
Local $BtnTop = $WinHeight-Round(3.0*$BlkTop)

Local $Strings[] = [ _
'#NoTrayIcon' & @CRLF & @CRLF & _ ;$Strings[0]
'If @Compiled Then' & @CRLF & _
'   Local $ScriptDir = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, "\", 0, -1)-1)' & @CRLF & _
'Else' & @CRLF & _
'   Local $ScriptDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)' & @CRLF & _
'EndIf' & @CRLF & @CRLF & _
'Local $File[9] = ["App\DefData\DefaultData.exe", "SetLnch.ini", "Data\DataFiles.txt", "Data\RegKeys.txt", "Data\RegInfo.ini", ' & _
'"ExFiles.txt", "FilePos.txt", "ExKeys.txt", "RegPos.txt"]' & @CRLF & _
'For $i = 0 To 4' & @CRLF & _
'   $File[$i] = $ScriptDir & "\" & $File[$i]' & @CRLF & _
'Next' & @CRLF & _
'Local $DataDir = $ScriptDir & ''\Data\''' & @CRLF & _
'For $i = 5 To 8' & @CRLF & _
'   $File[$i] = $DataDir & $File[$i]' & @CRLF & _
'Next' & @CRLF & @CRLF & _
'Global Const $tagPROCESSENTRY32 = "dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;' & _
'dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]"' & @CRLF & _
'Local $Envir[12] = ["AppData", "LocalAppData", "UserProfile", "Public", "AllUsersProfile", "CommonProgramFiles", ' & _
'"CommonProgramFiles(x86)", "ProgramFiles", "ProgramFiles(x86)", "WinDir", "Temp", "HomeDrive"]' & @CRLF & _
'Local $IniVal[2], $FO[4], $Proc = 0, $ReadStr, $StrTmp, $Attr, $CheckLoop, $Path[2], $ChkFO = True, $Pos, $OpenPr, ' & _
'$OpnGlob, $SomeVar = False' & @CRLF & _
'Local $RegStr[2] = ["HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI"]' & @CRLF & _
'Local $RegGlob = "HKEY_CURRENT_USER\Software\', _
' & "~⁄~", $Sepr = ', _ ;$Strings[1]
'If _WinAPI_GetProcessFileName(_WinAPI_GetParentProcess()) = @AutoItExe Then' & @CRLF & _ ;$Strings[2]
'   If $CmdLine[1] = "RegOpen" Then' & @CRLF & _
'      _RegOpen($CmdLine[2])' & @CRLF & _
'   ElseIf $CmdLine[1] = "RegClose" Then' & @CRLF & _
'      _RegClose($CmdLine[2])' & @CRLF & _
'   ElseIf $CmdLine[1] = "RegDelAft" Then' & @CRLF & _
'      _RegDelAft($CmdLine[2])' & @CRLF & _
'   ElseIf $CmdLine[1] = "RegDelBfr" Then' & @CRLF & _
'      _RegDelBfr()' & @CRLF & _
'   EndIf' & @CRLF & _
'Else' & @CRLF & _
'   Switch @OSLang' & @CRLF & _
'      Case "0419", "0819"' & @CRLF & _
'         Local $Text = " Пожалуйста, подождите..."' & @CRLF & _
'      Case Else' & @CRLF & _
'         Local $Text = " Please wait..."' & @CRLF & _
'   EndSwitch' & @CRLF & @CRLF & _
'   Local $TxtSize = 11' & @CRLF & _
'   Switch @OSLang' & @CRLF & _
'      Case "0419", "0819"' & @CRLF & _
'         Local $Height = Round(6.3*Ceiling(8.5*25/2400*RegRead($RegStr[0], $RegStr[1])))' & @CRLF & _
'         Local $Width = Round(4.1*$Height)' & @CRLF & _
'      Case Else' & @CRLF & _
'         Local $Height = Round(6*Ceiling(8.5*25/2400*RegRead($RegStr[0], $RegStr[1])))' & @CRLF & _
'         Local $Width = Round(3.3*$Height)' & @CRLF & _
'   EndSwitch' & @CRLF & @CRLF & _
'   Local $Win = GUICreate("", $Width, $Height, -1, -1, BitOR(0x80000000, 0x00400000), BitOR(0x00000200, 0x00000008, 0x00000080))' & @CRLF & _
'   GUISetBkColor(0xfafafa, $Win)' & @CRLF & _
'   GUICtrlCreateLabel($Text, -1, -1, $Width, $Height, BitOR(0x1, 0x0200))' & @CRLF & _
'   GUICtrlSetFont(-1, $TxtSize, 400, 0, "Lucida Sans Unicode")' & @CRLF & @CRLF & _
'   If Not FileExists($DataDir) Then' & @CRLF & _
'      RunWait($File[0], "", @SW_HIDE)' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   ResOpen()' & @CRLF & _
'   RunExe()' & @CRLF & _
'   ResClose()' & @CRLF & _
'EndIf' & @CRLF & @CRLF & _
'Func ResOpen()' & @CRLF & _
'   If IniRead($File[1], "Internal", "Prog", 0) <> 0 Then Return' & @CRLF & _
'   $OpnGlob = Number(RegRead($RegGlob, ""))' & @CRLF & _
'   If $OpnGlob < 0 Then RegWrite($RegGlob, "", "REG_SZ", 0)' & @CRLF & @CRLF & _
'   If IniRead($File[1], "Splash", "SplashShowBefore", "False") = "True" Then' & @CRLF & _
'      GUISetState(@SW_SHOW, $Win)' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   If IniRead($File[1], "Clean", "CleanUpBefore", "False") = "True" And $OpnGlob = 0 Then' & @CRLF & _
'      If @Compiled Then' & @CRLF & _
"         $Proc = Run('""' & @ScriptFullPath & '"" RegDelBfr', '', @SW_HIDE)" & @CRLF & _
'      Else' & @CRLF & _
"         $Proc = Run('""' & @AutoItExe & '"" /AutoIt3ExecuteScript ""' & @ScriptFullPath & '"" RegDelBfr', '', @SW_HIDE)" & @CRLF & _
'      EndIf' & @CRLF & _
'      If RegRead($RegGlob, "ExFiles") Then' & @CRLF & _
'         RegDelete($RegGlob, "ExFiles")' & @CRLF & _
'      EndIf' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      $StrTmp = "[::]"' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'            $StrTmp = $ReadStr' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $CheckLoop = False' & @CRLF & _
'               If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                  $CheckLoop = True' & @CRLF & _
'                  $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                  If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                     DirRemove($Path[1], 1)' & @CRLF & _
'                  Else' & @CRLF & _
'                     FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                     FileDelete($Path[1])' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  ExitLoop' & @CRLF & _
'               EndIf' & @CRLF & _
'            Next' & @CRLF & _
'            If Not $CheckLoop Then' & @CRLF & _
'               $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'               If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                  DirRemove($Path[1], 1)' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                  FileDelete($Path[1])' & @CRLF & _
'               EndIf' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      $ChkFO = True' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   While ProcessExists($Proc)' & @CRLF & _
'      Sleep(100)' & @CRLF & _
'   WEnd' & @CRLF & @CRLF & _
'   $IniVal[0] = IniRead($File[1], "CopyMove", "ActionBefore", "None")' & @CRLF & _
'   If $IniVal[0] = "Copy" Or $IniVal[0] = "Move" Then' & @CRLF & _
'      If @Compiled Then' & @CRLF & _
"         $Proc = Run('""' & @ScriptFullPath & '"" RegOpen ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      Else' & @CRLF & _
"         $Proc = Run('""' & @AutoItExe & '"" /AutoIt3ExecuteScript ""' & @ScriptFullPath & '"" RegOpen ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      EndIf' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   $IniVal[0] = IniRead($File[1], "CopyMove", "ActionBefore", "None")' & @CRLF & _
'   $IniVal[1] = IniRead($File[1], "Internal", "FilesOperations", "Success")' & @CRLF & _
'   If $IniVal[0] = "Move" And $IniVal[1] = "Success" And $OpnGlob = 0 Then' & @CRLF & _
'      IniWrite($File[1], "Internal", "FilesOperations", "Failure")' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 2+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 2+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If FileExists($Path[1]) Then' & @CRLF & _
'                  FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'                  FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If FileExists($Path[1]) Then' & @CRLF & _
'               FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'            EndIf' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'               FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'         FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'         FileSetPos($FO[2], 0, 0)' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal[0] = "Copy" And $IniVal[1] = "Success" And $OpnGlob = 0 Then' & @CRLF & _
'      IniWrite($File[1], "Internal", "FilesOperations", "Failure")' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 2+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 2+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If FileExists($Path[1]) Then' & @CRLF & _
'                  FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If FileExists($Path[1]) Then' & @CRLF & _
'               FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'            EndIf' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'         FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'         FileSetPos($FO[2], 0, 0)' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal[0] = "Move" And $IniVal[1] = "Failure" And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 1+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 512)' & @CRLF & _
'         $Pos = FileReadLine($FO[2])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 1+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         If FileGetPos($FO[0]) > $Pos Then $SomeVar = True' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If FileExists($Path[1]) And $SomeVar Then' & @CRLF & _
'                  FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'                  FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If FileExists($Path[1]) And $SomeVar Then' & @CRLF & _
'               FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'            EndIf' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'               FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'         If FileGetPos($FO[0]) > $Pos Then' & @CRLF & _
'            FileSetPos($FO[2], 0, 0)' & @CRLF & _
'            FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal[0] = "Copy" And $IniVal[1] = "Failure" And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 1+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 512)' & @CRLF & _
'         $Pos = FileReadLine($FO[2])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'         $FO[2] = FileOpen($File[6], 1+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         If FileGetPos($FO[0]) > $Pos Then $SomeVar = True' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If FileExists($Path[1]) And $SomeVar Then' & @CRLF & _
'                  FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If FileExists($Path[1]) And $SomeVar Then' & @CRLF & _
'               FileWriteLine($FO[1], $ReadStr)' & @CRLF & _
'            EndIf' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'         If FileGetPos($FO[0]) > $Pos Then' & @CRLF & _
'            FileSetPos($FO[2], 0, 0)' & @CRLF & _
'            FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal[0] = "Move" And $IniVal[1] = "Mostly" And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'                  FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileMove($Path[0], $Path[1], 8)' & @CRLF & _
'               FileSetAttrib($Path[1], "+" & $Attr)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'   ElseIf $IniVal[0] = "Copy" And $IniVal[1] = "Mostly" Or $OpnGlob <> 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         $Attr = FileGetAttrib($Path[0])' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[1])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[1])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[1], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileCopy($Path[0], $Path[1], 8)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'   EndIf' & @CRLF & _
'   FileDelete($File[6])' & @CRLF & _
'   IniWrite($File[1], "Internal", "FilesOperations", "Mostly")' & @CRLF & @CRLF & _
'   While ProcessExists($Proc)' & @CRLF & _
'      Sleep(100)' & @CRLF & _
'   WEnd' & @CRLF & @CRLF & _
';   __UserFunc()' & @CRLF & @CRLF & _
'   If IniRead($File[1], "Splash", "SplashShowBefore", "False") = "True" Then' & @CRLF & _
'      GUISetState(@SW_HIDE, $Win)' & @CRLF & _
'   EndIf' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func RunExe()' & @CRLF & _
'   $OpenPr = Number(IniRead($File[1], "Internal", "Prog", 0))' & @CRLF & _
'   If $OpenPr >= 0 Then' & @CRLF & _
'      $OpenPr = $OpenPr+1' & @CRLF & _
'   Else' & @CRLF & _
'      $OpenPr = 1' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   If Number(RegRead($RegGlob, "")) = 0 Then' & @CRLF & _
'      If FileGetSize($File[5]) > 2 Then RegWrite($RegGlob, "ExFiles", "REG_SZ", $File[5])' & @CRLF & _
'      If FileGetSize($File[7]) > 2 Then RegWrite($RegGlob, "ExKeys", "REG_SZ", $File[7])' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   IniWrite($File[1], "Internal", "Prog", $OpenPr)' & @CRLF & _
'   If $OpenPr = 1 Then RegWrite($RegGlob, "", "REG_SZ", Number(RegRead($RegGlob, ""))+1)' & @CRLF & @CRLF, _
'   $OpenPr = IniRead($File[1], "Internal", "Prog", 1)' & @CRLF & _ ;$Strings[3]
'   $OpenPr = Number($OpenPr)-1' & @CRLF & _
'   IniWrite($File[1], "Internal", "Prog", $OpenPr)' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func ResClose()' & @CRLF & _
'   If IniRead($File[1], "Internal", "Prog", 0) <> 0 Then Return' & @CRLF & _
'   $OpnGlob = Number(RegRead($RegGlob, ""))' & @CRLF & _
'   If $OpnGlob > 1 Then' & @CRLF & _
'      $OpnGlob = $OpnGlob-1' & @CRLF & _
'   Else' & @CRLF & _
'      $OpnGlob = 0' & @CRLF & _
'   EndIf' & @CRLF & _
'   RegWrite($RegGlob, "", "REG_SZ", $OpnGlob)' & @CRLF & _
'   If RegRead($RegGlob, "ExFiles") Then' & @CRLF & _
'      $File[5] = RegRead($RegGlob, "ExFiles")' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   Local $V = True, $ExStr, $ChkLp' & @CRLF & _
'   If IniRead($File[1], "Splash", "SplashShowAfter", "False") = "True" Then' & @CRLF & _
'      GUISetState(@SW_SHOW, $Win)' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   $IniVal[0] = IniRead($File[1], "CopyMove", "ActionAfter", "None")' & @CRLF & _
'   If $IniVal[0] = "Copy" Or $IniVal[0] = "Move" Then' & @CRLF & _
'      If @Compiled Then' & @CRLF & _
"         $Proc = Run('""' & @ScriptFullPath & '"" RegClose ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      Else' & @CRLF & _
"         $Proc = Run('""' & @AutoItExe & '"" /AutoIt3ExecuteScript ""' & @ScriptFullPath & '"" RegClose ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      EndIf' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   IniWrite($File[1], "Internal", "FilesOperations", "Mostly")' & @CRLF & _
'   $IniVal[0] = IniRead($File[1], "CopyMove", "ActionAfter", "None")' & @CRLF & _
'   If $OpnGlob = 0 And $IniVal[0] = "Move" And FileGetSize($File[5]) <= 2 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[0])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                  FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'                  FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[0])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileSetAttrib($Path[1], "-R")' & @CRLF & _
'               FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'               FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileSetPos($FO[0], 2, 0)' & @CRLF & _
'         $StrTmp = "[::]"' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'            $StrTmp = $ReadStr' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $CheckLoop = False' & @CRLF & _
'               If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                  $CheckLoop = True' & @CRLF & _
'                  $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                  If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                     DirRemove($Path[1], 1)' & @CRLF & _
'                  Else' & @CRLF & _
'                     FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                     FileDelete($Path[1])' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  ExitLoop' & @CRLF & _
'               EndIf' & @CRLF & _
'            Next' & @CRLF & _
'            If Not $CheckLoop Then' & @CRLF & _
'               $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'               If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                  DirRemove($Path[1], 1)' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                  FileDelete($Path[1])' & @CRLF & _
'               EndIf' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      $ChkFO = True' & @CRLF & _
'   ElseIf $OpnGlob = 0 And $IniVal[0] = "Copy" And FileGetSize($File[5]) <= 2 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[0])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileCopy($Path[1], $Path[0], 1+8)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[0])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileCopy($Path[1], $Path[0], 1+8)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      $ChkFO = True' & @CRLF & _
'   ElseIf $OpnGlob = 0 And $IniVal[0] = "Move" And FileGetSize($File[5]) > 2 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 32)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ExStr = FileReadLine($FO[1])' & @CRLF & _
'         If @error = -1 Then' & @CRLF & _
'            While True' & @CRLF & _
'               $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'               For $Var in $Envir' & @CRLF & _
'                  $CheckLoop = False' & @CRLF & _
'                  If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                     $CheckLoop = True' & @CRLF & _
'                     $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                     $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'                     If StringInStr($Attr, "D") Then' & @CRLF & _
'                        DirCreate($Path[0])' & @CRLF & _
'                        If $Attr <> "D" Then' & @CRLF & _
'                           FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     Else' & @CRLF & _
'                        FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                        FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                        FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'                        FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'                     EndIf' & @CRLF & _
'                     ExitLoop' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Next' & @CRLF & _
'               If Not $CheckLoop Then' & @CRLF & _
'                  $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                  $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'                  If StringInStr($Attr, "D") Then' & @CRLF & _
'                     DirCreate($Path[0])' & @CRLF & _
'                     If $Attr <> "D" Then' & @CRLF & _
'                        FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  Else' & @CRLF & _
'                     FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                     FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                     FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'                     FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'                  EndIf' & @CRLF & _
'               EndIf' & @CRLF & _
'               $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'               If @error = -1 Then	ExitLoop 2' & @CRLF & _
'            WEnd' & @CRLF & _
'         EndIf' & @CRLF & _
'         While True' & @CRLF & _
'            If $V Then $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'            If @error = -1 Then ExitLoop 2' & @CRLF & _
'            If $ReadStr < $ExStr Then' & @CRLF & _
'               $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'               For $Var in $Envir' & @CRLF & _
'                  $CheckLoop = False' & @CRLF & _
'                  If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                     $CheckLoop = True' & @CRLF & _
'                     $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                     $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'                     If StringInStr($Attr, "D") Then' & @CRLF & _
'                        DirCreate($Path[0])' & @CRLF & _
'                        If $Attr <> "D" Then' & @CRLF & _
'                           FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     Else' & @CRLF & _
'                        FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                        FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                        FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'                        FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'                     EndIf' & @CRLF & _
'                     ExitLoop' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Next' & @CRLF & _
'               If Not $CheckLoop Then' & @CRLF & _
'                  $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                  $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'                  If StringInStr($Attr, "D") Then' & @CRLF & _
'                     DirCreate($Path[0])' & @CRLF & _
'                     If $Attr <> "D" Then' & @CRLF & _
'                        FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  Else' & @CRLF & _
'                     FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                     FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                     FileMove($Path[1], $Path[0], 1+8)' & @CRLF & _
'                     FileSetAttrib($Path[0], "+" & $Attr)' & @CRLF & _
'                  EndIf' & @CRLF & _
'               EndIf' & @CRLF & _
'               $V = True' & @CRLF & _
'            ElseIf $ReadStr > $ExStr Then' & @CRLF & _
'               $V = False' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            Else' & @CRLF & _
'               $V = True' & @CRLF & _
'            EndIf' & @CRLF & _
'         WEnd' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileSetPos($FO[0], 2, 0)' & @CRLF & _
'         FileSetPos($FO[1], 2, 0)' & @CRLF & _
'         $StrTmp = "[::]"' & @CRLF & _
'         $V = True' & @CRLF & _
'         $ChkLp = True' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         While True' & @CRLF & _
'            If $ChkLp Then $ExStr = FileReadLine($FO[1])' & @CRLF & _
'            If @error = -1 Then' & @CRLF & _
'               While True' & @CRLF & _
'                  If Not $V Then' & @CRLF & _
'                     $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'                     If @error = -1 Then ExitLoop 3' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                     $StrTmp = $ReadStr' & @CRLF & _
'                     For $Var in $Envir' & @CRLF & _
'                        $CheckLoop = False' & @CRLF & _
'                        If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                           $CheckLoop = True' & @CRLF & _
'                           $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                           If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                              DirRemove($Path[1], 1)' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                              FileDelete($Path[1])' & @CRLF & _
'                           EndIf' & @CRLF & _
'                           ExitLoop' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     Next' & @CRLF & _
'                     If Not $CheckLoop Then' & @CRLF & _
'                        $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                        If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                           DirRemove($Path[1], 1)' & @CRLF & _
'                        Else' & @CRLF & _
'                           FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                           FileDelete($Path[1])' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  $V = False' & @CRLF & _
'               WEnd' & @CRLF & _
'            EndIf' & @CRLF & _
'            If $ExStr = $ReadStr Then' & @CRLF & _
'               $ChkLp = True' & @CRLF & _
'               $V = False' & @CRLF & _
'            Else' & @CRLF & _
'               If Not StringInStr($ExStr, $ReadStr & "\") And $V Then' & @CRLF & _
'                  If $ExStr > $ReadStr & "\" Then' & @CRLF & _
'                     If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                        $StrTmp = $ReadStr' & @CRLF & _
'                        For $Var in $Envir' & @CRLF & _
'                           $CheckLoop = False' & @CRLF & _
'                           If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                              $CheckLoop = True' & @CRLF & _
'                              $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                              If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                                 DirRemove($Path[1], 1)' & @CRLF & _
'                              Else' & @CRLF & _
'                                 FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                                 FileDelete($Path[1])' & @CRLF & _
'                              EndIf' & @CRLF & _
'                              ExitLoop' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        Next' & @CRLF & _
'                        If Not $CheckLoop Then' & @CRLF & _
'                           $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                           If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                              DirRemove($Path[1], 1)' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                              FileDelete($Path[1])' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'               EndIf' & @CRLF & _
'               $ChkLp = False' & @CRLF & _
'               $V = True' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         WEnd' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      FileClose($FO[1])' & @CRLF & _
'      $ChkFO = True' & @CRLF & _
'   ElseIf $OpnGlob = 0 And $IniVal[0] = "Copy" And FileGetSize($File[5]) > 2 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $Path[0] = $DataDir & StringTrimLeft($ReadStr, 2)' & @CRLF & _
'         For $Var in $Envir' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'            If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'               $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'               If StringInStr($Attr, "D") Then' & @CRLF & _
'                  DirCreate($Path[0])' & @CRLF & _
'                  If $Attr <> "D" Then' & @CRLF & _
'                     FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'                  EndIf' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[0], "-R")' & @CRLF & _
'                  FileCopy($Path[1], $Path[0], 1+8)' & @CRLF & _
'               EndIf' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         Next' & @CRLF & _
'         If Not $CheckLoop Then' & @CRLF & _
'            $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'            $Attr = FileGetAttrib($Path[1])' & @CRLF & _
'            If StringInStr($Attr, "D") Then' & @CRLF & _
'               DirCreate($Path[0])' & @CRLF & _
'               If $Attr <> "D" Then' & @CRLF & _
'                  FileSetAttrib($Path[0], StringReplace($Attr, "D", "", 1))' & @CRLF & _
'               EndIf' & @CRLF & _
'            Else' & @CRLF & _
'               FileSetAttrib($Path[0], "-R")' & @CRLF & _
'               FileCopy($Path[1], $Path[0], 1+8)' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      $ChkFO = True' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   While ProcessExists($Proc)' & @CRLF & _
'      Sleep(100)' & @CRLF & _
'   WEnd' & @CRLF & @CRLF & _
'   $IniVal[0] = IniRead($File[1], "Clean", "CleanUpAfter", "False")' & @CRLF & _
'   If $IniVal[0] = "True" And $OpnGlob = 0 And FileGetSize($File[5]) <= 2 Then' & @CRLF & _
'      If @Compiled Then' & @CRLF & _
"         $Proc = Run('""' & @ScriptFullPath & '"" RegDelAft ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      Else' & @CRLF & _
"         $Proc = Run('""' & @AutoItExe & '"" /AutoIt3ExecuteScript ""' & @ScriptFullPath & '"" RegDelAft ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      EndIf' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $ChkLp = True' & @CRLF & _
'         $StrTmp = "[::]"' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'            $StrTmp = $ReadStr' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $CheckLoop = False' & @CRLF & _
'               If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                  $CheckLoop = True' & @CRLF & _
'                  $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                  If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                     DirRemove($Path[1], 1)' & @CRLF & _
'                  Else' & @CRLF & _
'                     FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                     FileDelete($Path[1])' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  ExitLoop' & @CRLF & _
'               EndIf' & @CRLF & _
'            Next' & @CRLF & _
'            If Not $CheckLoop Then' & @CRLF & _
'               $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'               If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                  DirRemove($Path[1], 1)' & @CRLF & _
'               Else' & @CRLF & _
'                  FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                  FileDelete($Path[1])' & @CRLF & _
'               EndIf' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'   ElseIf $IniVal[0] = "True" And $OpnGlob = 0 And FileGetSize($File[5]) > 2 Then' & @CRLF & _
'      If @Compiled Then' & @CRLF & _
"         $Proc = Run('""' & @ScriptFullPath & '"" RegDelAft ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      Else' & @CRLF & _
"         $Proc = Run('""' & @AutoItExe & '"" /AutoIt3ExecuteScript ""' & @ScriptFullPath & '"" RegDelAft ' & $OpnGlob, '', @SW_HIDE)" & @CRLF & _
'      EndIf' & @CRLF & _
'      $FO[0] = FileOpen($File[2], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[5], 32)' & @CRLF & _
'         $StrTmp = "[::]"' & @CRLF & _
'         $V = True' & @CRLF & _
'         $ChkLp = True' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         While True' & @CRLF & _
'            If $ChkLp Then $ExStr = FileReadLine($FO[1])' & @CRLF & _
'            If @error = -1 Then' & @CRLF & _
'               While True' & @CRLF & _
'                  If Not $V Then' & @CRLF & _
'                     $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'                     If @error = -1 Then ExitLoop 3' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                     $StrTmp = $ReadStr' & @CRLF & _
'                     For $Var in $Envir' & @CRLF & _
'                        $CheckLoop = False' & @CRLF & _
'                        If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                           $CheckLoop = True' & @CRLF & _
'                           $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                           If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                              DirRemove($Path[1], 1)' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                              FileDelete($Path[1])' & @CRLF & _
'                           EndIf' & @CRLF & _
'                           ExitLoop' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     Next' & @CRLF & _
'                     If Not $CheckLoop Then' & @CRLF & _
'                        $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                        If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                           DirRemove($Path[1], 1)' & @CRLF & _
'                        Else' & @CRLF & _
'                           FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                           FileDelete($Path[1])' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  $V = False' & @CRLF & _
'               WEnd' & @CRLF & _
'            EndIf' & @CRLF & _
'            If $ExStr = $ReadStr Then' & @CRLF & _
'               $ChkLp = True' & @CRLF & _
'               $V = False' & @CRLF & _
'            Else' & @CRLF & _
'               If Not StringInStr($ExStr, $ReadStr & "\") And $V Then' & @CRLF & _
'                  If $ExStr > $ReadStr & "\" Then' & @CRLF & _
'                     If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                        $StrTmp = $ReadStr' & @CRLF & _
'                        For $Var in $Envir' & @CRLF & _
'                           $CheckLoop = False' & @CRLF & _
'                           If StringInStr($ReadStr, "::@" & $Var) Then' & @CRLF & _
'                              $CheckLoop = True' & @CRLF & _
'                              $Path[1] = StringReplace($ReadStr, "::@" & $Var, EnvGet($Var), 1)' & @CRLF & _
'                              If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                                 DirRemove($Path[1], 1)' & @CRLF & _
'                              Else' & @CRLF & _
'                                 FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                                 FileDelete($Path[1])' & @CRLF & _
'                              EndIf' & @CRLF & _
'                              ExitLoop' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        Next' & @CRLF & _
'                        If Not $CheckLoop Then' & @CRLF & _
'                           $Path[1] = StringReplace(StringTrimLeft($ReadStr, 8), "\", ":\", 1)' & @CRLF & _
'                           If StringInStr(FileGetAttrib($Path[1]), "D") Then' & @CRLF & _
'                              DirRemove($Path[1], 1)' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileSetAttrib($Path[1], "-R")' & @CRLF & _
'                              FileDelete($Path[1])' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        EndIf' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'               EndIf' & @CRLF & _
'               $ChkLp = False' & @CRLF & _
'               $V = True' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         WEnd' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      FileClose($FO[1])' & @CRLF & _
'   EndIf' & @CRLF & _
'   FileDelete($DataDir & "ExFiles.txt")' & @CRLF & _
'   If $OpnGlob = 0 Then FileDelete($File[5])' & @CRLF & _
'   IniWrite($File[1], "Internal", "FilesOperations", "Success")' & @CRLF & @CRLF & _
'   While ProcessExists($Proc)' & @CRLF & _
'      Sleep(100)' & @CRLF & _
'   WEnd' & @CRLF & @CRLF & _
'   FileDelete($File[7])' & @CRLF & _
'   If $OpnGlob = 0 Then FileDelete(RegRead($RegGlob, "ExKeys"))' & @CRLF & @CRLF & _
'   IniWrite($File[1], "Internal", "KeysOperations", "Success")' & @CRLF & _
'   If $OpnGlob = 0 Then RegDelete($RegGlob)' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _RegDelBfr()' & @CRLF & _
'   Local $FO, $ChkFO = True' & @CRLF & _
'   If RegRead($RegGlob, "ExKeys") Then' & @CRLF & _
'      RegDelete($RegGlob, "ExKeys")' & @CRLF & _
'   EndIf' & @CRLF & _
'   $FO = FileOpen($File[3], 32)' & @CRLF & _
'   If $FO = -1 Then $ChkFO = False' & @CRLF & _
'   $StrTmp = "[::]"' & @CRLF & _
'   While $ChkFO' & @CRLF & _
'      $ReadStr = FileReadLine($FO)' & @CRLF & _
'      If @error = -1 Then ExitLoop' & @CRLF & _
'      If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'         $StrTmp = $ReadStr' & @CRLF & _
'         RegDelete($ReadStr)' & @CRLF & _
'      EndIf' & @CRLF & _
'   WEnd' & @CRLF & _
'   FileClose($FO)' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _RegOpen($OpnGlob)' & @CRLF & _
'   Local $IniVal, $FO[4], $KeyName, $RgPrm, $RgVal, $RgType, $WrP, $WrV, $ChkLp, $ChkFO = True' & @CRLF & _
'   $IniVal = IniRead($File[1], "Internal", "KeysOperations", "Success")' & @CRLF & _
'   If $IniVal = "Success" And $OpnGlob = 0 Then' & @CRLF & _
'      IniWrite($File[1], "Internal", "KeysOperations", "Failure")' & @CRLF & _
'      $FO[0] = FileOpen($File[4], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[7], 2+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[8], 2+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $RgPrm = StringLeft($ReadStr, StringInStr($ReadStr, "=", 0, 1)-1)' & @CRLF & _
'         $RgVal = StringTrimLeft($ReadStr, StringInStr($ReadStr, "=", 0, 2))' & @CRLF & _
'         $RgType = StringTrimRight(StringTrimLeft($ReadStr, StringLen($RgPrm)+1), StringLen($RgVal)+1)' & @CRLF & _
'         If $ReadStr And Not StringInStr($ReadStr, "[", 0, 1, 1, 1) Then' & @CRLF & _
'            Select' & @CRLF & _
'               Case $RgType = "REG_SZ"' & @CRLF, _
'               Case $RgType = "REG_MULTI_SZ"' & @CRLF, _ ;$Strings[4]
'               Case $RgType = "REG_EXPAND_SZ"' & @CRLF, _ ;$Strings[5]
'               Case $RgType = "REG_DWORD" Or $RgType = "REG_QWORD"' & @CRLF, _ ;$Strings[6]
'               Case $RgType = "REG_BINARY"' & @CRLF, _ ;$Strings[7]
'            EndSelect' & @CRLF & _ ;$Strings[8]
'         ElseIf $ReadStr Then' & @CRLF & _
'            $KeyName = StringTrimRight(StringTrimLeft($ReadStr, 1), 1)' & @CRLF & _
'            RegRead($KeyName, "")' & @CRLF & _
'            If @error <= 0 Then' & @CRLF & _
'               FileWriteLine($FO[1], $KeyName)' & @CRLF & _
'               $ChkLp = True' & @CRLF & _
'            Else' & @CRLF & _
'               $ChkLp = False' & @CRLF & _
'            EndIf' & @CRLF & _
'            FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'            FileSetPos($FO[2], 0, 0)' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal = "Failure" And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[4], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[7], 1+32)' & @CRLF & _
'         $FO[2] = FileOpen($File[8], 512)' & @CRLF & _
'         $Pos = FileReadLine($FO[2])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'         $FO[2] = FileOpen($File[8], 1+512)' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $RgPrm = StringLeft($ReadStr, StringInStr($ReadStr, "=", 0, 1)-1)' & @CRLF & _
'         $RgVal = StringTrimLeft($ReadStr, StringInStr($ReadStr, "=", 0, 2))' & @CRLF & _
'         $RgType = StringTrimRight(StringTrimLeft($ReadStr, StringLen($RgPrm)+1), StringLen($RgVal)+1)' & @CRLF & _
'         If $ReadStr And Not StringInStr($ReadStr, "[", 0, 1, 1, 1) Then' & @CRLF & _
'            Select' & @CRLF & _
'               Case $RgType = "REG_SZ"' & @CRLF, _
'               Case $RgType = "REG_MULTI_SZ"' & @CRLF, _ ;$Strings[9]
'               Case $RgType = "REG_EXPAND_SZ"' & @CRLF, _ ;$Strings[10]
'               Case $RgType = "REG_DWORD" Or $RgType = "REG_QWORD"' & @CRLF, _ ;$Strings[11]
'               Case $RgType = "REG_BINARY"' & @CRLF, _ ;$Strings[12]
'            EndSelect' & @CRLF & _ ;$Strings[13]
'         ElseIf $ReadStr Then' & @CRLF & _
'            If FileGetPos($FO[0]) > $Pos Then $SomeVar = True' & @CRLF & _
'            $KeyName = StringTrimRight(StringTrimLeft($ReadStr, 1), 1)' & @CRLF & _
'            RegRead($KeyName, "")' & @CRLF & _
'            If @error <= 0 And $SomeVar Then' & @CRLF & _
'               FileWriteLine($FO[1], $KeyName)' & @CRLF & _
'               $ChkLp = True' & @CRLF & _
'            Else' & @CRLF & _
'               $ChkLp = False' & @CRLF & _
'            EndIf' & @CRLF & _
'            If FileGetPos($FO[0]) > $Pos Then' & @CRLF & _
'               FileSetPos($FO[2], 0, 0)' & @CRLF & _
'               FileWriteLine($FO[2], FileGetPos($FO[0]))' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[0])' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'      EndIf' & @CRLF & _
'   ElseIf $IniVal = "Mostly" Or $OpnGlob <> 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[4], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         $RgPrm = StringLeft($ReadStr, StringInStr($ReadStr, "=", 0, 1)-1)' & @CRLF & _
'         $RgVal = StringTrimLeft($ReadStr, StringInStr($ReadStr, "=", 0, 2))' & @CRLF & _
'         $RgType = StringTrimRight(StringTrimLeft($ReadStr, StringLen($RgPrm)+1), StringLen($RgVal)+1)' & @CRLF & _
'         If $ReadStr And Not StringInStr($ReadStr, "[", 0, 1, 1, 1) Then' & @CRLF & _
'            Select' & @CRLF & _
'               Case $RgType = "REG_SZ"' & @CRLF, _
'               Case $RgType = "REG_MULTI_SZ"' & @CRLF, _ ;$Strings[14]
'               Case $RgType = "REG_EXPAND_SZ"' & @CRLF, _ ;$Strings[15]
'               Case $RgType = "REG_DWORD" Or $RgType = "REG_QWORD"' & @CRLF, _ ;$Strings[16]
'               Case $RgType = "REG_BINARY"' & @CRLF, _ ;$Strings[17]
'            EndSelect' & @CRLF & _ ;$Strings[18]
'         ElseIf $ReadStr Then' & @CRLF & _
'            $KeyName = StringTrimRight(StringTrimLeft($ReadStr, 1), 1)' & @CRLF & _
'            RegRead($KeyName, "")' & @CRLF & _
'            If @error <= 0 Then' & @CRLF & _
'               $ChkLp = True' & @CRLF & _
'            Else' & @CRLF & _
'               $ChkLp = False' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'   EndIf' & @CRLF & _
'   FileDelete($File[8])' & @CRLF & _
'   IniWrite($File[1], "Internal", "KeysOperations", "Mostly")' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _RegClose($OpnGlob)' & @CRLF & _
'   Global $IniVal, $KeyName, $RgPrm, $RgVal, $RgType, $WrP, $WrV, $ChkFO = True, $ChkSect, $k, $ExStr, $CheckLoop = True, $V, $Str[2]' & @CRLF & _
'   IniWrite($File[1], "Internal", "KeysOperations", "Mostly")' & @CRLF & _
'   If RegRead($RegGlob, "ExKeys") Then' & @CRLF & _
'      $File[7] = RegRead($RegGlob, "ExKeys")' & @CRLF & _
'   EndIf' & @CRLF & _
'   $FO[0] = FileOpen($File[3], 32)' & @CRLF & _
'   If $OpnGlob = 0 And FileGetSize($File[7]) <= 2 And $FO[0] <> -1 Then' & @CRLF & _
'      $FO[1] = FileOpen($File[4], 2+32)' & @CRLF & _
'      While True' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         __RegExp($ReadStr)' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[1])' & @CRLF & _
'   ElseIf $OpnGlob = 0 And $FO[0] <> -1 Then' & @CRLF & _
'      $FO[1] = FileOpen($File[4] & "~", 2+32)' & @CRLF & _
'      $FO[2] = FileOpen($File[7], 32)' & @CRLF & _
'      If $FO[1] = -1 Or $FO[2] = -1 Then $ChkFO = False' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         If $CheckLoop Then' & @CRLF & _
'            $ExStr = FileReadLine($FO[2])' & @CRLF & _
'            If @error = -1 Then ExitLoop' & @CRLF & _
'         EndIf' & @CRLF & _
'         If $ExStr = $ReadStr Then' & @CRLF & _
'            $CheckLoop = True' & @CRLF & _
'         Else' & @CRLF & _
'            __RegExp($ReadStr)' & @CRLF & _
'            $CheckLoop = False' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      If $ChkFO Then' & @CRLF & _
'         FileClose($FO[1])' & @CRLF & _
'         FileClose($FO[2])' & @CRLF & _
'         $FO[1] = FileOpen($File[4], 32)' & @CRLF & _
'         If $FO[1] = -1 Or FileGetSize($File[4]) <= 2 Then' & @CRLF & _
'            FileMove($File[4] & "~", $File[4], 1)' & @CRLF & _
'            $ChkFO = False' & @CRLF & _
'         EndIf' & @CRLF & _
'         If $ChkFO Then' & @CRLF & _
'            $FO[2] = FileOpen($File[4] & "~", 32)' & @CRLF & _
'            If $FO[2] = -1 Or FileGetSize($File[4] & "~") <= 2 Then' & @CRLF & _
'               FileClose($FO[1])' & @CRLF & _
'               FileDelete($File[4] & "~")' & @CRLF & _
'               $ChkFO = False' & @CRLF & _
'            EndIf' & @CRLF & _
'         EndIf' & @CRLF & _
'         If $ChkFO Then' & @CRLF & _
'            $FO[3] = FileOpen($File[4] & "~~", 2+32)' & @CRLF & _
'            $CheckLoop = 1' & @CRLF & _
'            $V = False' & @CRLF & _
'         EndIf' & @CRLF & _
'         While $ChkFO' & @CRLF & _
'            $Str[0] = FileReadLine($FO[2])' & @CRLF & _
'            If @error = -1 Then' & @CRLF & _
'               While True' & @CRLF & _
'                  If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then' & @CRLF & _
'                     FileWriteLine($FO[3], $Str[1])' & @CRLF & _
'                  ElseIf $Str[1] Then' & @CRLF & _
'                     FileWriteLine($FO[3], @CRLF & $Str[1])' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  $Str[1] = FileReadLine($FO[1])' & @CRLF & _
'                  If @error = -1 Then ExitLoop 2' & @CRLF & _
'               WEnd' & @CRLF & _
'            EndIf' & @CRLF & _
'            If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then' & @CRLF & _
'               FileWriteLine($FO[3], $Str[0])' & @CRLF & _
'            ElseIf $Str[0] Then' & @CRLF & _
'               While True' & @CRLF & _
'                  If $CheckLoop <> 0 Then $Str[1] = FileReadLine($FO[1])' & @CRLF & _
'                  If @error = -1 Then' & @CRLF & _
'                     While True' & @CRLF & _
'                        If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then' & @CRLF & _
'                           FileWriteLine($FO[3], $Str[0])' & @CRLF & _
'                        ElseIf $Str[0] Then' & @CRLF & _
'                           If $CheckLoop <> 2 Then' & @CRLF & _
'                              If $V Then' & @CRLF & _
'                                 FileWriteLine($FO[3], @CRLF & $Str[0])' & @CRLF & _
'                              Else' & @CRLF & _
'                                 FileWriteLine($FO[3], $Str[0])' & @CRLF & _
'                                 $V = True' & @CRLF & _
'                              EndIf' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        EndIf' & @CRLF & _
'                        $Str[0] = FileReadLine($FO[2])' & @CRLF & _
'                        $CheckLoop = 1' & @CRLF & _
'                        If @error = -1 Then ExitLoop 3' & @CRLF & _
'                     WEnd' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then' & @CRLF & _
'                     If $CheckLoop = 1 Then FileWriteLine($FO[3], $Str[1])' & @CRLF & _
'                  ElseIf $Str[1] Then' & @CRLF & _
'                     If StringTrimRight($Str[1], 1) < StringTrimRight($Str[0], 1) Then' & @CRLF & _
'                        If $CheckLoop <> 2 Then' & @CRLF & _
'                           If $V Then' & @CRLF & _
'                              FileWriteLine($FO[3], @CRLF & $Str[1])' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileWriteLine($FO[3], $Str[1])' & @CRLF & _
'                              $V = True' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        EndIf' & @CRLF & _
'                        $CheckLoop = 1' & @CRLF & _
'                     ElseIf StringTrimRight($Str[1], 1) > StringTrimRight($Str[0], 1) Then' & @CRLF & _
'                        If $CheckLoop <> 2 Then' & @CRLF & _
'                           If $V Then' & @CRLF & _
'                              FileWriteLine($FO[3], @CRLF & $Str[0])' & @CRLF & _
'                           Else' & @CRLF & _
'                              FileWriteLine($FO[3], $Str[0])' & @CRLF & _
'                              $V = True' & @CRLF & _
'                           EndIf' & @CRLF & _
'                        EndIf' & @CRLF & _
'                        $CheckLoop = 0' & @CRLF & _
'                        ExitLoop' & @CRLF & _
'                     Else' & @CRLF & _
'                        If $V Then' & @CRLF & _
'                           FileWriteLine($FO[3], @CRLF & $Str[0])' & @CRLF & _
'                        Else' & @CRLF & _
'                           FileWriteLine($FO[3], $Str[0])' & @CRLF & _
'                           $V = True' & @CRLF & _
'                        EndIf' & @CRLF & _
'                        $CheckLoop = 2' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'               WEnd' & @CRLF & _
'            EndIf' & @CRLF & _
'         WEnd' & @CRLF & _
'         For $i = 1 To 3' & @CRLF & _
'            FileClose($FO[$i])' & @CRLF & _
'         Next' & @CRLF & _
'         FileMove($File[4] & "~~", $File[4], 1)' & @CRLF & _
'         FileDelete($File[4] & "~")' & @CRLF & _
'      EndIf' & @CRLF & _
'   EndIf' & @CRLF & _
'   FileClose($FO[0])' & @CRLF & _
'   If IniRead($File[1], "CopyMove", "ActionAfter", "None") = "Move" Then' & @CRLF & _
'      _RegDelAft($OpnGlob)' & @CRLF & _
'   EndIf' & @CRLF & _
'   If FileGetSize($File[3]) <= 2 Then' & @CRLF & _
'      FileDelete($File[3])' & @CRLF & _
'      FileDelete($File[4])' & @CRLF & _
'   EndIf' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _RegDelAft($OpnGlob)' & @CRLF & _
'   Local $ChkFO = True, $ExStr, $CheckLoop = True, $V' & @CRLF & _
'   If RegRead($RegGlob, "ExKeys") Then' & @CRLF & _
'      $File[7] = RegRead($RegGlob, "ExKeys")' & @CRLF & _
'   EndIf' & @CRLF & _
'   If FileGetSize($File[7]) <= 2 And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[3], 32)' & @CRLF & _
'      If $FO[0] = -1 Then $ChkFO = False' & @CRLF & _
'      $StrTmp = "[::]"' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'            $StrTmp = $ReadStr' & @CRLF & _
'            RegDelete($ReadStr)' & @CRLF & _
'         EndIf' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'   ElseIf FileGetSize($File[7]) > 2 And $OpnGlob = 0 Then' & @CRLF & _
'      $FO[0] = FileOpen($File[3], 32)' & @CRLF & _
'      If $FO[0] <> -1 Then' & @CRLF & _
'         $FO[1] = FileOpen($File[7], 32)' & @CRLF & _
'         $StrTmp = "[::]"' & @CRLF & _
'         $V = True' & @CRLF & _
'      Else' & @CRLF & _
'         $ChkFO = False' & @CRLF & _
'      EndIf' & @CRLF & _
'      While $ChkFO' & @CRLF & _
'         $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'         If @error = -1 Then ExitLoop' & @CRLF & _
'         While True' & @CRLF & _
'            If $CheckLoop Then $ExStr = FileReadLine($FO[1])' & @CRLF & _
'            If @error = -1 Then' & @CRLF & _
'               While True' & @CRLF & _
'                  If Not $V Then' & @CRLF & _
'                     $ReadStr = FileReadLine($FO[0])' & @CRLF & _
'                     If @error = -1 Then ExitLoop 3' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                     $StrTmp = $ReadStr' & @CRLF & _
'                     RegDelete($ReadStr)' & @CRLF & _
'                  EndIf' & @CRLF & _
'                  $V = False' & @CRLF & _
'               WEnd' & @CRLF & _
'            EndIf' & @CRLF & _
'            If $ExStr = $ReadStr Then' & @CRLF & _
'               $CheckLoop = True' & @CRLF & _
'               $V = False' & @CRLF & _
'            Else' & @CRLF & _
'               If Not StringInStr($ExStr, $ReadStr & "\") And $V Then' & @CRLF & _
'                  If $ExStr > $ReadStr & "\" Then' & @CRLF & _
'                     If Not StringInStr($ReadStr, $StrTmp & "\") Then' & @CRLF & _
'                        $StrTmp = $ReadStr' & @CRLF & _
'                        RegDelete($ReadStr)' & @CRLF & _
'                     EndIf' & @CRLF & _
'                  EndIf' & @CRLF & _
'               EndIf' & @CRLF & _
'               $CheckLoop = False' & @CRLF & _
'               $V = True' & @CRLF & _
'               ExitLoop' & @CRLF & _
'            EndIf' & @CRLF & _
'         WEnd' & @CRLF & _
'      WEnd' & @CRLF & _
'      FileClose($FO[0])' & @CRLF & _
'      FileClose($FO[1])' & @CRLF & _
'   EndIf' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func __RegExp($ReadStr)' & @CRLF & _
'   $ChkSect = True' & @CRLF & _
'   $k = 0' & @CRLF & _
'   While True' & @CRLF & _
'      $k = $k+1' & @CRLF & _
'      $RgPrm = RegEnumVal($ReadStr, $k)' & @CRLF & _
'      If @error Then ExitLoop' & @CRLF & _
'      $RgVal = RegRead($ReadStr, $RgPrm)' & @CRLF & _
'      $RgType = @extended' & @CRLF & _
'      Switch $RgType' & @CRLF & _
'         Case 1' & @CRLF & _
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgVal = $WrV' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgVal = $WrV' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'         Case 2' & @CRLF & _ ;$Strings[19]
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgVal = $WrV' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgVal = $WrV' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'         Case 3' & @CRLF & _ ;$Strings[20]
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'         Case 4' & @CRLF & _ ;$Strings[21]
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'         Case 7' & @CRLF & _ ;$Strings[22]
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgVal = $WrV' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgVal = $WrV' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'         Case 11' & @CRLF & _ ;$Strings[23]
'            $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")' & @CRLF & _
'            If @extended Then $RgPrm = $WrP' & @CRLF & _
'            For $Var in $Envir' & @CRLF & _
'               $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)' & @CRLF & _
'               If @extended Then $RgPrm = $WrP' & @CRLF & _
'            Next' & @CRLF & _
'            If $ChkSect Then' & @CRLF & _
'               FileWriteLine($FO[1], "[" & $ReadStr & "]")' & @CRLF & _
'               $ChkSect = False' & @CRLF & _
'            EndIf' & @CRLF, _
'      EndSwitch' & @CRLF & _ ;$Strings[24]
'   WEnd' & @CRLF & _
'   If Not $ChkSect Then FileWriteLine($FO[1], @CRLF)' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'#Region Функции из WinAPIProc.au3' & @CRLF & _
'Func _WinAPI_GetParentProcess($iPID = 0)' & @CRLF & _
'   If Not $iPID Then $iPID = @AutoItPID' & @CRLF & @CRLF & _
'   Local $hSnapshot = DllCall("kernel32.dll", "handle", "CreateToolhelp32Snapshot", "dword", 0x00000002, "dword", 0)' & @CRLF & _
'   If @error Or Not $hSnapshot[0] Then Return SetError(@error+10, @extended, 0)' & @CRLF & _
'   Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)' & @CRLF & _
'   Local $iResult = 0' & @CRLF & @CRLF & _
'   $hSnapshot = $hSnapshot[0]' & @CRLF & _
'   DllStructSetData($tPROCESSENTRY32, "Size", DllStructGetSize($tPROCESSENTRY32))' & @CRLF & _
'   Local $aRet = DllCall("kernel32.dll", "bool", "Process32FirstW", "handle", $hSnapshot, "struct*", $tPROCESSENTRY32)' & @CRLF & _
'   Local $iError = @error' & @CRLF & _
'   While (Not @error) And ($aRet[0])' & @CRLF & _
'      If DllStructGetData($tPROCESSENTRY32, "ProcessID") = $iPID Then' & @CRLF & _
'         $iResult = DllStructGetData($tPROCESSENTRY32, "ParentProcessID")' & @CRLF & _
'         ExitLoop' & @CRLF & _
'      EndIf' & @CRLF & _
'      $aRet = DllCall("kernel32.dll", "bool", "Process32NextW", "handle", $hSnapshot, "struct*", $tPROCESSENTRY32)' & @CRLF & _
'      $iError = @error' & @CRLF & _
'   WEnd' & @CRLF & _
'   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)' & @CRLF & _
'   If Not $iResult Then Return SetError($iError, 0, 0)' & @CRLF & @CRLF & _
'   Return $iResult' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _WinAPI_GetProcessFileName($iPID = 0)' & @CRLF & _
'   If Not $iPID Then $iPID = @AutoItPID' & @CRLF & _
'   If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_2000" Then' & @CRLF & _
'      Local $WINVER = 0x00000410' & @CRLF & _
'   Else' & @CRLF & _
'      Local $WINVER = 0x00001010' & @CRLF & _
'   EndIf' & @CRLF & @CRLF & _
'   Local $hProcess = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $WINVER, "bool", 0, "dword", $iPID)' & @CRLF & _
'   If @error Or Not $hProcess[0] Then Return SetError(@error+20, @extended, "")' & @CRLF & @CRLF & _
'   Local $sPath = _WinAPI_GetModuleFileNameEx($hProcess[0])' & @CRLF & _
'   Local $iError = @error' & @CRLF & @CRLF & _
'   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])' & @CRLF & _
'   If $iError Then Return SetError(@error, 0, "")' & @CRLF & @CRLF & _
'   Return $sPath' & @CRLF & _
'EndFunc' & @CRLF & @CRLF & _
'Func _WinAPI_GetModuleFileNameEx($hProcess, $hModule = 0)' & @CRLF & _
'   Local $aRet = DllCall(@SystemDir & "\psapi.dll", "dword", "GetModuleFileNameExW", "handle", $hProcess, "handle", ' & _
'$hModule, "wstr", "", "int", 4096)' & @CRLF & _
'   If @error Or Not $aRet[0] Then Return SetError(@error+10, @extended, "")' & @CRLF & @CRLF & _
'   Return $aRet[3]' & @CRLF & _
'EndFunc' & @CRLF & _
'#EndRegion' & @CRLF & @CRLF & _
'#Region Дополнительные функции' & @CRLF & _
';Используйте дополнительные фунции такие, как этот шаблон, например, для замены в конфигурационных ' & _
'файлах абсолютных путей на относительные' & @CRLF & _
'Func __UserFunc()' & @CRLF & _
'   Local $FileName[2] = [$ScriptDir & "\example.ini", $ScriptDir & "\example_1.ini"]' & @CRLF & _
'   Local $hFile[2] = [FileOpen($FileName[0], 512), FileOpen($FileName[1], 2+512)]' & @CRLF & _
'   Local $Line' & @CRLF & _
'   While $hFile[0] <> -1' & @CRLF & _
'      $Line = FileReadLine($hFile[0])' & @CRLF & _
'      If @error = -1 Then ExitLoop' & @CRLF & _
'      If Not StringInStr($Line, "abstract path=") Then' & @CRLF & _
'         FileWriteLine($hFile[1], $Line)' & @CRLF & _
'      Else' & @CRLF & _
'         FileWriteLine($hFile[1], ''abstract path="'' & @ScriptDir & ''"'')' & @CRLF & _
'      EndIf' & @CRLF & _
'   WEnd' & @CRLF & _
'   FileClose($hFile[0])' & @CRLF & _
'   FileClose($hFile[1])' & @CRLF & _
'   FileMove($FileName[1], $FileName[0], 1)' & @CRLF & _
'EndFunc' & @CRLF & _
'#EndRegion' & @CRLF]

$InsStr[0] = '::::@'
$InsStr[1] = _
'                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  Next' & @CRLF & _
'                  $WrV = StringReplace($RgVal, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgVal = $WrV' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrV = StringReplace($RgVal, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgVal = $WrV' & @CRLF & _
'                  Next' & @CRLF & _
'                  If $ChkLp Then' & @CRLF & _
'                     RegRead($KeyName, $RgPrm)' & @CRLF & _
'                     If @error Then RegWrite($KeyName, $RgPrm, "REG_SZ", $RgVal)' & @CRLF & _
'                  Else' & @CRLF & _
'                     RegWrite($KeyName, $RgPrm, "REG_SZ", $RgVal)' & @CRLF & _
'                  EndIf' & @CRLF
$InsStr[2] = _
'                  $RgVal = BinaryToString($RgVal, 2)' & @CRLF & _
'                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  Next' & @CRLF & _
'                  $WrV = StringReplace($RgVal, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgVal = $WrV' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrV = StringReplace($RgVal, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgVal = $WrV' & @CRLF & _
'                  Next' & @CRLF & _
'                  If $ChkLp Then' & @CRLF & _
'                     RegRead($KeyName, $RgPrm)' & @CRLF & _
'                     If @error Then RegWrite($KeyName, $RgPrm, "REG_MULTI_SZ", $RgVal)' & @CRLF & _
'                  Else' & @CRLF & _
'                     RegWrite($KeyName, $RgPrm, "REG_MULTI_SZ", $RgVal)' & @CRLF & _
'                  EndIf' & @CRLF
$InsStr[3] = _
'                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  Next' & @CRLF & _
'                  $WrV = StringReplace($RgVal, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _'                  If @extended Then $RgVal = $WrV' & @CRLF & _'                  For $Var in $Envir' & @CRLF & _'                     $WrV = StringReplace($RgVal, $Sepr & $Var, EnvGet($Var))' & @CRLF & _'                     If @extended Then $RgVal = $WrV' & @CRLF & _'                  Next' & @CRLF & _
'                  If $ChkLp Then' & @CRLF & _
'                     RegRead($KeyName, $RgPrm)' & @CRLF & _
'                     If @error Then RegWrite($KeyName, $RgPrm, "REG_EXPAND_SZ", $RgVal)' & @CRLF & _
'                  Else' & @CRLF & _
'                     RegWrite($KeyName, $RgPrm, "REG_EXPAND_SZ", $RgVal)' & @CRLF & _
'                  EndIf' & @CRLF
$InsStr[4] = _
'                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  Next' & @CRLF & _
'                  If $ChkLp Then' & @CRLF & _
'                     RegRead($KeyName, $RgPrm)' & @CRLF & _
'                     If @error Then RegWrite($KeyName, $RgPrm, $RgType, Number($RgVal))' & @CRLF & _
'                  Else' & @CRLF & _
'                     RegWrite($KeyName, $RgPrm, $RgType, Number($RgVal))' & @CRLF & _
'                  EndIf' & @CRLF
$InsStr[5] = _
'                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _
'                  If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  For $Var in $Envir' & @CRLF & _
'                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _
'                     If @extended Then $RgPrm = $WrP' & @CRLF & _
'                  Next' & @CRLF & _
'                  If $ChkLp Then' & @CRLF & _
'                     RegRead($KeyName, $RgPrm)' & @CRLF & _
'                     If @error Then RegWrite($KeyName, $RgPrm, "REG_BINARY", $RgVal)' & @CRLF & _
'                  Else' & @CRLF & _
'                     RegWrite($KeyName, $RgPrm, "REG_BINARY", $RgVal)' & @CRLF & _
'                  EndIf' & @CRLF
For $i = 6 To 17
   $InsStr[$i] = ''
Next

$UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1))
$FO[2] = FileOpen($UpDir & 'Data\Sepr_Tmp.txt', 32)
If $FO[2] = -1 Then $ChkFO = False
   While $ChkFO
	  $ReadStr = FileReadLine($FO[2])
	  If @error = -1 Then ExitLoop
	  If StringInStr($ReadStr, "::::@") Then
		 $Sepr = Number(StringTrimLeft($ReadStr, StringInStr($ReadStr, "=", 0, -1)))
		 For $i = 1 To $Sepr
			$InsStr[0] = $InsStr[0] & '::::@'
		 Next
	  ElseIf $ReadStr = "Reg_Sz" Then
		 $InsStr[6] = _
		 '               Case $RgType = "BIN_REG_SZ"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & $InsStr[1]
		 $InsStr[7] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_SZ=" & $RgVal)' & @CRLF & _
		 '            EndIf' & @CRLF
	  ElseIf $ReadStr = "Reg_Expand_Sz" Then
		 $InsStr[8] = _
		 '               Case $RgType = "BIN_REG_EXPAND_SZ"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & $InsStr[3]
		 $InsStr[9] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)' & @CRLF & _
		 '            EndIf' & @CRLF
	  ElseIf $ReadStr = "Reg_Binary" Then
		 $InsStr[10] = _
		 '               Case $RgType = "BIN_REG_BINARY"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & $InsStr[5]
		 $InsStr[11] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_BINARY=" & $RgVal)' & @CRLF & _
		 '            EndIf' & @CRLF
	  ElseIf $ReadStr = "Reg_Dword" Then
		 $InsStr[12] = _
		 '               Case $RgType = "BIN_REG_DWORD"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & _
		 '                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _		 '                  If @extended Then $RgPrm = $WrP' & @CRLF & _		 '                  For $Var in $Envir' & @CRLF & _		 '                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _		 '                     If @extended Then $RgPrm = $WrP' & @CRLF & _		 '                  Next' & @CRLF & _
		 '                  If $ChkLp Then' & @CRLF & _
		 '                     RegRead($KeyName, $RgPrm)' & @CRLF & _
		 '                     If @error Then RegWrite($KeyName, $RgPrm, "REG_DWORD", Number($RgVal))' & @CRLF & _
		 '                  Else' & @CRLF & _
		 '                     RegWrite($KeyName, $RgPrm, "REG_DWORD", Number($RgVal))' & @CRLF & _
		 '                  EndIf' & @CRLF
		 $InsStr[13] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_DWORD=" & $RgVal)' & @CRLF & _
		 '            EndIf' & @CRLF
	  ElseIf $ReadStr = "Reg_Multi_Sz" Then
		 $InsStr[14] = _
		 '               Case $RgType = "BIN_REG_MULTI_SZ"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & $InsStr[2]
		 $InsStr[15] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))' & @CRLF & _
		 '            EndIf' & @CRLF
	  ElseIf $ReadStr = "Reg_Qword" Then
		 $InsStr[16] = _
		 '               Case $RgType = "BIN_REG_QWORD"' & @CRLF & _
		 '                  $RgPrm = BinaryToString($RgPrm, 2)' & @CRLF & _
		 '                  $WrP = StringReplace($RgPrm, $Sepr & "ScriptDir", $ScriptDir)' & @CRLF & _		 '                  If @extended Then $RgPrm = $WrP' & @CRLF & _		 '                  For $Var in $Envir' & @CRLF & _		 '                     $WrP = StringReplace($RgPrm, $Sepr & $Var, EnvGet($Var))' & @CRLF & _		 '                     If @extended Then $RgPrm = $WrP' & @CRLF & _		 '                  Next' & @CRLF & _
		 '                  If $ChkLp Then' & @CRLF & _
		 '                     RegRead($KeyName, $RgPrm)' & @CRLF & _
		 '                     If @error Then RegWrite($KeyName, $RgPrm, "REG_QWORD", Number($RgVal))' & @CRLF & _
		 '                  Else' & @CRLF & _
		 '                     RegWrite($KeyName, $RgPrm, "REG_QWORD", Number($RgVal))' & @CRLF & _
		 '                  EndIf' & @CRLF
		 $InsStr[17] = _
		 '            If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then' & @CRLF & _
		 '               FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)' & @CRLF & _
		 '            Else' & @CRLF & _
		 '               FileWriteLine($FO[1], $RgPrm & "=REG_QWORD=" & $RgVal)' & @CRLF & _
		 '            EndIf' & @CRLF
	  EndIf
   WEnd
If $ChkFO Then FileClose($FO[2])

If $InsStr[7] = '' Then
   $InsStr[7] = '            FileWriteLine($FO[1], $RgPrm & "=REG_SZ=" & $RgVal)' & @CRLF
EndIf
If $InsStr[9] = '' Then
   $InsStr[9] = '            FileWriteLine($FO[1], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)' & @CRLF
EndIf
If $InsStr[11] = '' Then
   $InsStr[11] = '            FileWriteLine($FO[1], $RgPrm & "=REG_BINARY=" & $RgVal)' & @CRLF
EndIf
If $InsStr[13] = '' Then
   $InsStr[13] = '            FileWriteLine($FO[1], $RgPrm & "=REG_DWORD=" & $RgVal)' & @CRLF
EndIf
If $InsStr[15] = '' Then
   $InsStr[15] = '            FileWriteLine($FO[1], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))' & @CRLF
EndIf
If $InsStr[17] = '' Then
   $InsStr[17] = '            FileWriteLine($FO[1], $RgPrm & "=REG_QWORD=" & $RgVal)' & @CRLF
EndIf

$FO[0] = FileOpen($UpDir & 'Data\AppExeLnch.txt', 32)
$ReadStr = FileReadLine($FO[0], 1)
If @error = 1 Or @error = -1 Then
   $Num = 0
Else
   FileReadLine($FO[0], 2)
   If @error = -1 Then
	  $Num = 1
   Else
	  $Num = 2
   EndIf
EndIf

$Win = GUICreate("", $WinWidth, $WinHeight, Default, Default, $WinSty)
GUISetFont($BlkTxtSz, 400, 0, $WinTxt)
GUISetBkColor($WinColr, $Win)

GUICtrlCreateLabel($Text, $BlkLeft, $BlkTop, $BlkWidth, $BlkHeight, $BlkSty)
GUICtrlSetFont(-1, $BlkTxtSz, 400, 0, $BlkTxt)

$Input = GUICtrlCreateInput("", $InputLeft, $InputTop, $InputWidth, $InputHeight, -1, $InputSty)

$Btn = GUICtrlCreateButton("OK", $BtnLeft, $BtnTop, $BtnWidth, $BtnHeight)
GUICtrlSetFont($Btn, $BtnTxtSz, 400, 0, $BtnTxt)

GUISetState(@SW_SHOW, $Win)
If $Num <> 0 Then
   If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
	  GUICtrlSetData($Input, StringTrimLeft(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)-1), _
	  StringLen($UpDir & 'App\PortApp\App\')))
   ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
	  GUICtrlSetData($Input, StringTrimLeft(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)-1), _
	  StringLen($UpDir & 'App\PortApp\Data\')))
   EndIf
Else
   GUICtrlSetData($Input, 'AdHoc PortApp')
EndIf

While True
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 ConsoleWrite("Exit")
		 Exit
	  Case $Btn
		 $RegGlob = GUICtrlRead($Input)
		 ExitLoop
   EndSwitch
WEnd

If FileExists($UpDir & 'App\PortApp\Source') Then
   RunWait(@ComSpec & ' /U /C DEL "' & $UpDir & 'App\PortApp\Source\' & '" /A /Q /F', '', @SW_HIDE)
EndIf
If $Num = 1 Then
   $AppName = StringRegExpReplace($ReadStr, '^(?:.*\\)([^\\]*?)(?:\.[^.]+)?$', '\1')
   $FO[1] = FileOpen($UpDir & 'App\PortApp\Source\' & $AppName & '.portable.au3', 2+8+32)
   If $FO[1] = -1 Then Exit

   Switch StringTrimLeft($ReadStr, StringInStr($ReadStr, ".", 0, -1)-1)
	  Case $FileMask[0]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = '   RunWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & ' " & $CmdLineRaw, _' & _
			@CRLF & '		   $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & '", @SW_HIDE)' & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = '   RunWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
				  $Var, '', 1) & ' " & $CmdLineRaw, _' & @CRLF & '		   EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", @SW_HIDE)' & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = '   RunWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '', 1), 6), _
				  "\", ":\", 1) & ' " & $CmdLineRaw, _' & @CRLF & '		   "' & StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", @SW_HIDE)' & @CRLF
			   EndIf
			EndIf
		 EndIf
	  Case $FileMask[1]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			@CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
				  $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
				  'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
				  StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
			   EndIf
			EndIf
		 EndIf
	  Case $FileMask[2]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			@CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
				  $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
				  'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
				  StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
			   EndIf
			EndIf
		 EndIf
	  Case $FileMask[3] To $FileMask[4]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			@CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
				  $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
				  'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
				  StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
			   EndIf
			EndIf
		 EndIf
	  Case $FileMask[5]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & $ScriptDir & '" & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & _
			"' & '""', _" & @CRLF & "				 $ScriptDir & '" & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & "', '', @SW_HIDE)" & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & EnvGet('" & $Var & "') & '" & StringReplace($ReadStr, _
				  $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & "' & '""', _" & @CRLF & "				 EnvGet('" & $Var & "') & '" & _
				  StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & _
				  "', '', @SW_HIDE)" & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & '" & StringReplace(StringTrimLeft(StringReplace($ReadStr, _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & "' & '""', _" & @CRLF & "				 '" & _
				  StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & "', '', @SW_HIDE)" & @CRLF
			   EndIf
			EndIf
		 EndIf
	  Case $FileMask[6] To $FileMask[10]
		 If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			$StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			@CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			$UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
		 ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
				  $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
				  $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
				  StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
				  $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
				  'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
				  StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
				  $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
			   EndIf
			EndIf
		 EndIf
   EndSwitch

   FileWrite($FO[1], $Strings[0] & $RegGlob & '"' & $Strings[1] & '"' & $InsStr[0] & '"' & @CRLF & @CRLF & $Strings[2] & _
   $StartExe & @CRLF & $Strings[3] & $InsStr[1] & $Strings[4] & $InsStr[2] & $Strings[5] & $InsStr[3] & $Strings[6] & $InsStr[4] & _
   $Strings[7] & $InsStr[5] & $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[8] & _
   $InsStr[1] & $Strings[9] & $InsStr[2] & $Strings[10] & $InsStr[3] & $Strings[11] & $InsStr[4] & $Strings[12] & $InsStr[5] & _
   $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[13] & $InsStr[1] & $Strings[14] & _
   $InsStr[2] & $Strings[15] & $InsStr[3] & $Strings[16] & $InsStr[4] & $Strings[17] & $InsStr[5] & $InsStr[6] & $InsStr[8] & _
   $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[18] & $InsStr[7] & $Strings[19] & $InsStr[9] & $Strings[20] & _
   $InsStr[11] & $Strings[21] & $InsStr[13] & $Strings[22] & $InsStr[15] & $Strings[23] & $InsStr[17] & $Strings[24])

   FileClose($FO[1])
ElseIf $Num = 2 Then
   FileClose($FO[0])
   $FO[0] = FileOpen($UpDir & 'Data\AppExeLnch.txt', 32)
   While True
	  $ReadStr = FileReadLine($FO[0])
	  If @error = -1 Then ExitLoop
	  $AppName = StringRegExpReplace($ReadStr, '^(?:.*\\)([^\\]*?)(?:\.[^.]+)?$', '\1')
	  $n = $n+1
	  If FileExists($UpDir & 'App\PortApp\Source\' & $AppName & '.portable.au3') Then
		 $FO[1] = FileOpen($UpDir & 'App\PortApp\Source\' & $AppName & '.portable_' & $n-1 & '.au3', 2+8+32)
	  Else
		 $FO[1] = FileOpen($UpDir & 'App\PortApp\Source\' & $AppName & '.portable.au3', 2+8+32)
	  EndIf
	  If $FO[1] = -1 Then ContinueLoop

	  Switch StringTrimLeft($ReadStr, StringInStr($ReadStr, ".", 0, -1)-1)
		 Case $FileMask[0]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = '   RunWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & ' " & $CmdLineRaw, _' & _
			   @CRLF & '		   $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			   $UpDir & 'App\PortApp', '', 1) & '", @SW_HIDE)' & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = '   RunWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\@' & _
					 $Var, '', 1) & ' " & $CmdLineRaw, _' & @CRLF & '		   EnvGet("' & $Var & '") & "' & StringReplace(StringLeft($ReadStr, _
					 StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & '", @SW_HIDE)' & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = '   RunWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & ' " & $CmdLineRaw, _' & @CRLF & '		   "' & _
					 StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
					 $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", @SW_HIDE)' & @CRLF
				  EndIf
			   EndIf
			EndIf
		 Case $FileMask[1]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			   @CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			   $UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\@' & $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & _
					 StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & _
					 $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
					 StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
					 $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
				  EndIf
			   EndIf
			EndIf
		 Case $FileMask[2]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			   @CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			   $UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\@' & $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & _
					 StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & _
					 $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
					 StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
					 $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
				  EndIf
			   EndIf
			EndIf
		 Case $FileMask[3] To $FileMask[4]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			   @CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			   $UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\@' & $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & _
					 StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & _
					 $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
					 StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
					 $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
				  EndIf
			   EndIf
			EndIf
		 Case $FileMask[5]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & $ScriptDir & '" & StringReplace($ReadStr, $UpDir & _
			   'App\PortApp', '', 1) & "' & '""', _" & @CRLF & "				 $ScriptDir & '" & StringReplace(StringLeft($ReadStr, _
			   StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp', '', 1) & "', '', @SW_HIDE)" & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & EnvGet('" & $Var & "') & '" & StringReplace($ReadStr, _
					 $UpDir & 'App\PortApp\Data\@' & $Var, '', 1) & "' & '""', _" & @CRLF & "				 EnvGet('" & _
					 $Var & "') & '" & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)),  $UpDir & _
					 'App\PortApp\Data\@' & $Var, '', 1) & "', '', @SW_HIDE)" & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = "   ShellExecuteWait('powershell.exe', '-file ""' & '" & StringReplace(StringRegExpReplace($ReadStr, _
					 '(?:Drive_(.))', '\1\:', 1), $UpDir & 'App\PortApp\Data\', '', 1) & "' & '""', _" & @CRLF & "				 '" & _
					 StringReplace(StringRegExpReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), '(?:Drive_(.))', '\1\:', 1), _
					 $UpDir & 'App\PortApp\Data\', '', 1) & "', '', @SW_HIDE)" & @CRLF
				  EndIf
			   EndIf
			EndIf
		 Case $FileMask[6] To $FileMask[10]
			If StringInStr($ReadStr, $UpDir & 'App\PortApp\App\') Then
			   $StartExe = '   ShellExecuteWait($ScriptDir & "' & StringReplace($ReadStr, $UpDir & 'App\PortApp', '', 1) & '", "", _' & _
			   @CRLF & '				 $ScriptDir & "' & StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
			   $UpDir & 'App\PortApp', '', 1) & '", "", @SW_HIDE)' & @CRLF
			ElseIf StringInStr($ReadStr, $UpDir & 'App\PortApp\Data\') Then
			   For $Var in $Envir
				  $CheckLoop = False
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::@' & $Var & '\') Then
					 $StartExe = '   ShellExecuteWait(EnvGet("' & $Var & '") & "' & StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\@' & $Var, '', 1) & '", "", _' & @CRLF & '				 EnvGet("' & $Var & '") & "' & _
					 StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), $UpDir & 'App\PortApp\Data\@' & _
					 $Var, '', 1) & '", "", @SW_HIDE)' & @CRLF
					 $CheckLoop = True
					 ExitLoop
				  EndIf
			   Next
			   If Not $CheckLoop Then
				  If StringInStr(StringReplace($ReadStr, $UpDir & 'App\PortApp\Data\', '::', 1), '::Drive_') Then
					 $StartExe = '   ShellExecuteWait("' & StringReplace(StringTrimLeft(StringReplace($ReadStr, $UpDir & _
					 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", _' & @CRLF & '				 "' & _
					 StringReplace(StringTrimLeft(StringReplace(StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), _
					 $UpDir & 'App\PortApp\Data\', '', 1), 6), "\", ":\", 1) & '", "", @SW_HIDE)' & @CRLF
				  EndIf
			   EndIf
			EndIf
	  EndSwitch

	  FileWrite($FO[1], $Strings[0] & $RegGlob & '"' & $Strings[1] & '"' & $InsStr[0] & '"' & @CRLF & @CRLF & $Strings[2] & _
	  $StartExe & @CRLF & $Strings[3] & $InsStr[1] & $Strings[4] & $InsStr[2] & $Strings[5] & $InsStr[3] & $Strings[6] & $InsStr[4] & _
	  $Strings[7] & $InsStr[5] & $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[8] & _
	  $InsStr[1] & $Strings[9] & $InsStr[2] & $Strings[10] & $InsStr[3] & $Strings[11] & $InsStr[4] & $Strings[12] & $InsStr[5] & _
	  $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[13] & $InsStr[1] & $Strings[14] & _
	  $InsStr[2] & $Strings[15] & $InsStr[3] & $Strings[16] & $InsStr[4] & $Strings[17] & $InsStr[5] & $InsStr[6] & $InsStr[8] & _
	  $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[18] & $InsStr[7] & $Strings[19] & $InsStr[9] & $Strings[20] & _
	  $InsStr[11] & $Strings[21] & $InsStr[13] & $Strings[22] & $InsStr[15] & $Strings[23] & $InsStr[17] & $Strings[24])

	  FileClose($FO[1])
   WEnd
Else
   $FO[1] = FileOpen($UpDir & 'App\PortApp\Source\PortApp.au3', 2+8+32)
   If $FO[1] = -1 Then Exit

   $StartExe = '   ;место для кода' & @CRLF & '   MsgBox(0, "", "RunExe($CmdLineRaw: " & $CmdLineRaw & ")")' & @CRLF

   FileWrite($FO[1], $Strings[0] & $RegGlob & '"' & $Strings[1] & '"' & $InsStr[0] & '"' & @CRLF & @CRLF & $Strings[2] & _
   $StartExe & @CRLF & $Strings[3] & $InsStr[1] & $Strings[4] & $InsStr[2] & $Strings[5] & $InsStr[3] & $Strings[6] & $InsStr[4] & _
   $Strings[7] & $InsStr[5] & $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[8] & _
   $InsStr[1] & $Strings[9] & $InsStr[2] & $Strings[10] & $InsStr[3] & $Strings[11] & $InsStr[4] & $Strings[12] & $InsStr[5] & _
   $InsStr[6] & $InsStr[8] & $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[13] & $InsStr[1] & $Strings[14] & _
   $InsStr[2] & $Strings[15] & $InsStr[3] & $Strings[16] & $InsStr[4] & $Strings[17] & $InsStr[5] & $InsStr[6] & $InsStr[8] & _
   $InsStr[10] & $InsStr[12] & $InsStr[14] & $InsStr[16] & $Strings[18] & $InsStr[7] & $Strings[19] & $InsStr[9] & $Strings[20] & _
   $InsStr[11] & $Strings[21] & $InsStr[13] & $Strings[22] & $InsStr[15] & $Strings[23] & $InsStr[17] & $Strings[24])

   FileClose($FO[1])
EndIf

FileClose($FO[0])
