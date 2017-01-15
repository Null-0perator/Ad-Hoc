#NoTrayIcon

Local $File[8], $Var
Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)
Local $Envir[12] = ['AppData', 'LocalAppData', 'UserProfile', 'Public', 'AllUsersProfile', 'CommonProgramFiles', _
				'CommonProgramFiles(x86)', 'ProgramFiles', 'ProgramFiles(x86)', 'WinDir', 'Temp', 'HomeDrive']

$File[0] = $UpDir & '\Data\'
$File[1] = $File[0] & 'RegKeys'
$File[2] = $File[0] & 'RegInfoTmp.ini'
$File[3] = $File[0] & 'RegPathsTmp.ini'
$File[4] = $File[0] & 'RegPathsTmpSep.ini'
$File[5] = $File[0] & 'Sepr_Tmp.txt'
$File[6] = $File[0] & 'RegPaths.ini'
$File[7] = $File[0] & 'RegInfo.ini'

If $CmdLine[0] = 1 Then
   If StringInStr($CmdLine[1], ">>", 0, 1, 1, 2) Then
	  _Export()
   ElseIf StringInStr($CmdLine[1], "+>", 0, -1) Then
	  $Var = StringRegExpReplace($CmdLine[1], "[^0-9]+", "")
	  If $CmdLine[1] = "<+>" Then
		 _Merge()
	  ElseIf $Var = 0 Then
		 If FileExists($File[1] & '_' & $Var & '.txt') Then
			FileMove($File[1] & '_' & $Var & '.txt', $File[1] & '.txt', 1)
		 ElseIf FileExists($File[1] & '.txt') Then
			FileDelete($File[1] & '.txt')
		 EndIf
	  Else
		 If FileExists($File[1] & '_' & $Var & '.txt') Then
			_AddFile($Var)
		 EndIf
	  EndIf
   ElseIf StringInStr($CmdLine[1], "*", 0, 1, 1, 1) Then
	  _RegDel()
   EndIf
ElseIf $CmdLine[0] = 2 Then
   $Var = StringRegExpReplace($CmdLine[2], "[^0-9]+", "")
   If StringRegExp($CmdLine[2], "[<>]") Then
	  _Generate($CmdLine[1], $Var)
   Else
	  _Compare($CmdLine[1], $CmdLine[2])
   EndIf
EndIf

Func _AddFile($Prm_0)
   Local $FO[2] = [FileOpen($File[1] & '.txt', 1+32), FileOpen($File[1] & '_' & $Prm_0 & '.txt', 32)]

   FileWrite($FO[0], FileRead($FO[1]))
   FileClose($FO[0])
   FileClose($FO[1])
   FileDelete($File[1] & '_' & $Prm_0 & '.txt')
EndFunc

Func _Generate($Prm_0, $Prm_1)
   Local $Path = $File[0] & 'RegData_' & $Prm_1, $RunProc, $FO, $Msv, $Bnd

   FileDelete($Path & '.reg')
   Sleep(40)
   $RunProc = RunWait(@ComSpec & ' /U /C REG EXPORT ' & $Prm_0 & ' "' & $Path & '.reg"', '', @SW_HIDE)

   $FO = FileOpen($Path & '.reg', 32)
   $Msv = StringRegExp(FileRead($FO), "\n\[.+", 3)
   $Bnd = UBound($Msv)-1
   FileClose($FO)
   FileDelete($Path & '.reg')

   $FO = FileOpen($Path & '.txt', 2+32)
   For $i = 0 To $Bnd
      FileWriteLine($FO, StringTrimRight(StringTrimLeft($Msv[$i], 2), 1))
   Next
   FileClose($FO)
EndFunc

Func _Compare($Prm_0, $Prm_1)
   If FileGetSize($File[0] & 'RegData_' & $Prm_0 & '.txt') > 2 And _
   FileGetSize($File[0] & 'RegData_' & $Prm_1 & '.txt') > 2 Then
	  Local $FO[3], $ReadStr[2] = [".", "."], $NonEx[2]

	  $FO[0] = FileOpen($File[0] & 'RegData_' & $Prm_0 & '.txt', 32)
	  If $FO[0] = -1 Then Exit
	  $FO[1] = FileOpen($File[0] & 'RegData_' & $Prm_1 & '.txt', 32)
	  If $FO[1] = -1 Then
		 FileClose($FO[0])
		 Exit
	  EndIf
	  $FO[2] = FileOpen($File[1] & '_' & $Prm_0 & '.txt', 2+32)
	  While True
		 If $ReadStr[0] = $ReadStr[1] Then
			$ReadStr[0] = FileReadLine($FO[0])
			If @error = -1 Then
			   FileWrite($FO[2], FileRead($FO[1]))
			   ExitLoop
			EndIf
			$ReadStr[1] = FileReadLine($FO[1])
			If @error = -1 Then ExitLoop
		 Else
			RegRead($ReadStr[0], "")
			$NonEx[0] = @error
			RegRead($ReadStr[1], "")
			$NonEx[1] = @error
			If $NonEx[0] <> 1 And $NonEx[1] <> 1 Then
			   Do
				  FileWriteLine($FO[2], $ReadStr[1])
				  $ReadStr[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop 2
				  RegRead($ReadStr[1], "")
				  $NonEx[1] = @error
			   Until $ReadStr[0] = $ReadStr[1] Or $NonEx[1] = 1
			ElseIf $NonEx[0] = 1 And $NonEx[1] <> 1 Then
			   Do
				  $ReadStr[0] = FileReadLine($FO[0])
				  If @error = -1 Then
					 FileWriteLine($FO[2], $ReadStr[1])
					 FileWrite($FO[2], FileRead($FO[1]))
					 ExitLoop 2
				  EndIf
				  RegRead($ReadStr[0], "")
				  $NonEx[0] = @error
			   Until $ReadStr[0] = $ReadStr[1] Or $NonEx[0] <> 1
			ElseIf $NonEx[0] <> 1 And $NonEx[1] = 1 Then
			   Do
				  $ReadStr[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop 2
				  RegRead($ReadStr[1], "")
				  $NonEx[1] = @error
			   Until $ReadStr[0] = $ReadStr[1] Or $NonEx[1] <> 1
			Else
			   $ReadStr[0] = FileReadLine($FO[0])
			   If @error = -1 Then ExitLoop
			   $ReadStr[1] = FileReadLine($FO[1])
			   If @error = -1 Then ExitLoop
			EndIf
		 EndIf
	  WEnd
	  FileClose($FO[0])
	  FileClose($FO[1])
	  FileClose($FO[2])
   EndIf
EndFunc

Func _Export()
   Global $FO[5], $Msv, $Bnd, $RgPrm, $RgVal, $RgType, $Str[2], $WrP, $WrV, $ChkSect[3], $CheckLoop, $k, $Sepr, $T, $Q, $V
   Global $ScriptDir = $UpDir & '\App\PortApp', $StrTmp = "[::]", $Max = 0, $Chk[6], $ChkSepr[6]
   For $i = 0 To 5
	  $Chk[$i] = False
   Next

   $FO[0] = FileOpen($File[1] & '.txt', 32)
   If $FO[0] = -1 Then Exit
   $Msv = FileReadToArray($FO[0])
   _ArraySort($Msv)
   $Bnd = UBound($Msv)-1
   FileClose($FO[0])

   $FO[0] = FileOpen($File[1] & '.txt', 2+32)
   For $i = 1 To 4
	  $FO[$i] = FileOpen($File[$i+1], 2+32)
   Next
   For $i = 0 To $Bnd
	  FileWriteLine($FO[0], $Msv[$i])
	  For $j = 0 To 2
		 $ChkSect[$j] = True
	  Next
	  $k = 0
	  While True
		 $Sepr = "::::@"
		 For $j = 0 To 5
			$ChkSepr[$j] = False
		 Next
		 $T = 0
		 $Q = 0
		 $CheckLoop = False
		 $k = $k+1
		 $RgPrm = RegEnumVal($Msv[$i], $k)
		 If @error Then ExitLoop
		 $RgVal = RegRead($Msv[$i], $RgPrm)
		 $RgType = @extended
		 Switch $RgType
			Case 1
			   If StringInStr($RgVal, $Sepr) Then
				  $ChkSepr[0] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $Q = $Q+1
					 If $Q > $Max Then $Max = $Q
				  Until Not StringInStr($RgVal, $Sepr)
			   EndIf
			   $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[0] Then $RgVal = $WrV
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[0] Then $RgVal = $WrV
					 $CheckLoop = True
				  EndIf
			   Next
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[0] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[0] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[0] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[0] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[0] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)
					 EndIf
					 $Chk[0] = True
				  Else
					 If Not $ChkSepr[0] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_SZ=" & $RgVal)
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_SZ=" & $RgVal)
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_SZ=" & $RgVal)
				  EndIf
			   EndIf
			Case 2
			   If StringInStr($RgVal, $Sepr) Then
				  $ChkSepr[1] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $Q = $Q+1
					 If $Q > $Max Then $Max = $Q
				  Until Not StringInStr($RgVal, $Sepr)
			   EndIf
			   $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[1] Then $RgVal = $WrV
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[1] Then $RgVal = $WrV
					 $CheckLoop = True
				  EndIf
			   Next
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[1] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[1] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[1] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[1] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[1] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)
					 EndIf
					 $Chk[1] = True
				  Else
					 If Not $ChkSepr[1] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)
				  EndIf
			   EndIf
			Case 3
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[2] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[2] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[2] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[2] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[2] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)
					 EndIf
					 $Chk[2] = True
				  Else
					 If Not $ChkSepr[2] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_BINARY=" & $RgVal)
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_BINARY=" & $RgVal)
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_BINARY=" & $RgVal)
				  EndIf
			   EndIf
			Case 4
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[3] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[3] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[3] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[3] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[3] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)
					 EndIf
					 $Chk[3] = True
				  Else
					 If Not $ChkSepr[3] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_DWORD=" & $RgVal)
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_DWORD=" & $RgVal)
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_DWORD=" & $RgVal)
				  EndIf
			   EndIf
			Case 7
			   If StringInStr($RgVal, $Sepr) Then
				  $ChkSepr[4] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $Q = $Q+1
					 If $Q > $Max Then $Max = $Q
				  Until Not StringInStr($RgVal, $Sepr)
			   EndIf
			   $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[4] Then $RgVal = $WrV
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[4] Then $RgVal = $WrV
					 $CheckLoop = True
				  EndIf
			   Next
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[4] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[4] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[4] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[4] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[4] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
					 EndIf
					 $Chk[4] = True
				  Else
					 If Not $ChkSepr[4] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
				  EndIf
			   EndIf
			Case 11
			   If StringInStr($RgPrm, $Sepr) Then
				  $ChkSepr[5] = True
				  Do
					 $Sepr = $Sepr & "::::@"
					 $T = $T+1
					 If $T > $Max Then $Max = $T
				  Until Not StringInStr($RgPrm, $Sepr)
			   EndIf
			   $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
			   If @extended Then
				  If  Not $ChkSepr[5] Then $RgPrm = $WrP
				  $CheckLoop = True
			   EndIf
			   For $Var in $Envir
				  $WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
				  If @extended Then
					 If  Not $ChkSepr[5] Then $RgPrm = $WrP
					 $CheckLoop = True
				  EndIf
			   Next
			   If $CheckLoop Then
				  If $ChkSect[1] Then
					 FileWriteLine($FO[2], "[" & $Msv[$i] & "]")
					 $ChkSect[1] = False
				  EndIf
				  If $ChkSect[2] And $ChkSepr[5] Then
					 FileWriteLine($FO[3], "[" & $Msv[$i] & "]")
					 $ChkSect[2] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 If Not $ChkSepr[5] Then
						FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)
					 Else
						FileWriteLine($FO[3], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)
					 EndIf
					 $Chk[5] = True
				  Else
					 If Not $ChkSepr[5] Then
						FileWriteLine($FO[2], $RgPrm & "=REG_QWORD=" & $RgVal)
					 Else
						FileWriteLine($FO[3], $RgPrm & "=REG_QWORD=" & $RgVal)
					 EndIf
				  EndIf
			   Else
				  If $ChkSect[0] Then
					 FileWriteLine($FO[1], "[" & $Msv[$i] & "]")
					 $ChkSect[0] = False
				  EndIf
				  If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
					 FileWriteLine($FO[1], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)
				  Else
					 FileWriteLine($FO[1], $RgPrm & "=REG_QWORD=" & $RgVal)
				  EndIf
			   EndIf
		 EndSwitch
	  WEnd
	  If Not $ChkSect[0] Then FileWriteLine($FO[1], @CRLF)
	  If Not $ChkSect[1] Then FileWriteLine($FO[2], @CRLF)
	  If Not $ChkSect[2] Then FileWriteLine($FO[3], @CRLF)
   Next
   For $i = 0 To 3
	  FileClose($FO[$i])
   Next
   If $Max > 0 Then FileWriteLine($FO[4], "::::@=" & $Max)
   If $Chk[0] Then FileWriteLine($FO[4], "Reg_Sz")
   If $Chk[1] Then FileWriteLine($FO[4], "Reg_Expand_Sz")
   If $Chk[2] Then FileWriteLine($FO[4], "Reg_Binary")
   If $Chk[3] Then FileWriteLine($FO[4], "Reg_Dword")
   If $Chk[4] Then FileWriteLine($FO[4], "Reg_Multi_Sz")
   If $Chk[5] Then FileWriteLine($FO[4], "Reg_Qword")
   FileClose($FO[4])
   If FileGetSize($File[4]) <= 2 Then
	  FileMove($File[3], $File[6], 1)
	  FileDelete($File[4])
   Else
	  $Sepr = "::::@"
	  For $i = 1 To $Max
		 $Sepr = $Sepr & "::::@"
	  Next
	  $FO[0] = FileOpen($File[3], 32)
	  If $FO[0] = -1 Then Exit
	  $FO[1] = FileOpen($File[4], 32)
	  If $FO[1] = -1 Then
		 FileClose($FO[0])
		 Exit
	  EndIf
	  $FO[2] = FileOpen($File[6], 2+32)
	  $CheckLoop = 1
	  $V = False
	  While True
		 $Str[0] = FileReadLine($FO[0])
		 If @error = -1 Then
			If FileGetSize($File[3]) > 2 Then
			   While True
				  If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then
					 __Sel_1()
				  ElseIf $Str[1] Then
					 If $CheckLoop <> 2 Then
						If $V Then
						   FileWriteLine($FO[2], @CRLF & $Str[1])
						Else
						   FileWriteLine($FO[2], $Str[1])
						   $V = True
						EndIf
					 EndIf
				  EndIf
				  $Str[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop 2
				  $CheckLoop = 1
			   WEnd
			Else
			   While True
				  $Str[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop 2
				  If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then
					 __Sel_1()
				  Else
					 FileWriteLine($FO[2], $Str[1])
				  EndIf
			   WEnd
			EndIf
		 EndIf
		 If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then
			__Sel_0()
		 ElseIf $Str[0] Then
			While True
			   If $CheckLoop Then $Str[1] = FileReadLine($FO[1])
			   If @error = -1 Then
				  While True
					 If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then
						__Sel_0()
					 ElseIf $Str[0] Then
						If $CheckLoop <> 2 Then
						   If $V Then
							  FileWriteLine($FO[2], @CRLF & $Str[0])
						   Else
							  FileWriteLine($FO[2], $Str[0])
							  $V = True
						   EndIf
						EndIf
					 EndIf
					 $Str[0] = FileReadLine($FO[0])
					 $CheckLoop = 1
					 If @error = -1 Then ExitLoop 3
				  WEnd
			   EndIf
			   If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then
				  __Sel_1()
			   ElseIf $Str[1] Then
				  If StringTrimRight($Str[1], 1) < StringTrimRight($Str[0], 1) Then
					 If $CheckLoop <> 2 Then
						If $V Then
						   FileWriteLine($FO[2], @CRLF & $Str[1])
						Else
						   FileWriteLine($FO[2], $Str[1])
						   $V = True
						EndIf
					 EndIf
					 $CheckLoop = 1
				  ElseIf StringTrimRight($Str[1], 1) > StringTrimRight($Str[0], 1) Then
					 If $CheckLoop <> 2 Then
						If $V Then
						   FileWriteLine($FO[2], @CRLF & $Str[0])
						Else
						   FileWriteLine($FO[2], $Str[0])
						   $V = True
						EndIf
					 EndIf
					 $CheckLoop = 0
					 ExitLoop
				  Else
					 If $V Then
						FileWriteLine($FO[2], @CRLF & $Str[0])
					 Else
						FileWriteLine($FO[2], $Str[0])
						$V = True
					 EndIf
					 $CheckLoop = 2
				  EndIf
			   EndIf
			WEnd
		 EndIf
	  WEnd
	  For $i = 0 To 2
		 FileClose($FO[$i])
	  Next
	  FileDelete($File[3])
	  FileDelete($File[4])
   EndIf
EndFunc

Func __Sel_0()
   $RgPrm = StringLeft($Str[0], StringInStr($Str[0], "=", 0, 1)-1)
   $RgVal = StringTrimLeft($Str[0], StringInStr($Str[0], "=", 0, 2))
   $RgType = StringTrimRight(StringTrimLeft($Str[0], StringLen($RgPrm)+1), StringLen($RgVal)+1)
   Select
	  Case $RgType = "REG_SZ" Or $RgType = "BIN_REG_SZ"
		 If $RgType = "BIN_REG_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgVal = $WrV
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_SZ=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_EXPAND_SZ" Or $RgType = "BIN_REG_EXPAND_SZ"
		 If $RgType = "BIN_REG_EXPAND_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgVal = $WrV
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_BINARY" Or $RgType = "BIN_REG_BINARY"
		 If $RgType = "BIN_REG_BINARY" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_BINARY=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_DWORD" Or $RgType = "BIN_REG_DWORD"
		 If $RgType = "BIN_REG_DWORD" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_DWORD=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_MULTI_SZ" Or $RgType = "BIN_REG_MULTI_SZ"
		 If $RgType = "BIN_REG_MULTI_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $RgVal = BinaryToString($RgVal, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgVal = $WrV
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
		 EndIf
	  Case $RgType = "REG_QWORD" Or $RgType = "BIN_REG_QWORD"
		 If $RgType = "BIN_REG_QWORD" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, "::::@" & "ScriptDir", $ScriptDir)
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, "::::@" & $Var, EnvGet($Var))
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_QWORD=" & $RgVal)
		 EndIf
   EndSelect
EndFunc
Func __Sel_1()
   $RgPrm = StringLeft($Str[1], StringInStr($Str[1], "=", 0, 1)-1)
   $RgVal = StringTrimLeft($Str[1], StringInStr($Str[1], "=", 0, 2))
   $RgType = StringTrimRight(StringTrimLeft($Str[1], StringLen($RgPrm)+1), StringLen($RgVal)+1)
   Select
	  Case $RgType = "REG_SZ" Or $RgType = "BIN_REG_SZ"
		 If $RgType = "BIN_REG_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_SZ=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_SZ=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_EXPAND_SZ" Or $RgType = "BIN_REG_EXPAND_SZ"
		 If $RgType = "BIN_REG_EXPAND_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_EXPAND_SZ=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_EXPAND_SZ=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_BINARY" Or $RgType = "BIN_REG_BINARY"
		 If $RgType = "BIN_REG_BINARY" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_BINARY=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_BINARY=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_DWORD" Or $RgType = "BIN_REG_DWORD"
		 If $RgType = "BIN_REG_DWORD" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_DWORD=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_DWORD=" & $RgVal)
		 EndIf
	  Case $RgType = "REG_MULTI_SZ" Or $RgType = "BIN_REG_MULTI_SZ"
		 If $RgType = "BIN_REG_MULTI_SZ" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $RgVal = BinaryToString($RgVal, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 $WrV = StringReplace($RgVal, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgVal = $WrV
		 For $Var in $Envir
			$WrV = StringReplace($RgVal, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgVal = $WrV
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_MULTI_SZ=" & StringToBinary($RgVal, 2))
		 EndIf
	  Case $RgType = "REG_QWORD" Or $RgType = "BIN_REG_QWORD"
		 If $RgType = "BIN_REG_QWORD" Then $RgPrm = BinaryToString($RgPrm, 2)
		 $WrP = StringReplace($RgPrm, $ScriptDir, $Sepr & "ScriptDir")
		 If @extended Then $RgPrm = $WrP
		 For $Var in $Envir
			$WrP = StringReplace($RgPrm, EnvGet($Var), $Sepr & $Var)
			If @extended Then $RgPrm = $WrP
		 Next
		 If StringInStr($RgPrm, "[", 0, 1, 1, 1) Or StringInStr($RgPrm, "=") Then
			FileWriteLine($FO[2], StringToBinary($RgPrm, 2) & "=BIN_REG_QWORD=" & $RgVal)
		 Else
			FileWriteLine($FO[2], $RgPrm & "=REG_QWORD=" & $RgVal)
		 EndIf
   EndSelect
EndFunc

Func _RegDel()
   Local $FO = FileOpen($File[1] & '.txt', 32), $ReadStr, $StrTmp
   $StrTmp = "[::]"
   While $FO <> -1
      $ReadStr = FileReadLine($FO)
      If @error = -1 Then ExitLoop
      If Not StringInStr($ReadStr, $StrTmp & "\") Then
         $StrTmp = $ReadStr
         RegDelete($ReadStr)
      EndIf
   WEnd
   FileClose($FO)
EndFunc

Func _Merge()
   Local $FO[3], $Str[2], $CheckLoop, $V
   $FO[0] = FileOpen($File[2], 32)
   If $FO[0] = -1 Or FileGetSize($File[2]) <= 2 Then
	  FileMove($File[6], $File[7], 1)
	  FileDelete($File[2])
	  Exit
   EndIf
   $FO[1] = FileOpen($File[6], 32)
   If $FO[1] = -1 Or FileGetSize($File[6]) <= 2 Then
	  FileClose($FO[0])
	  FileMove($File[2], $File[7], 1)
	  FileDelete($File[6])
	  Exit
   EndIf
   $FO[2] = FileOpen($File[7], 2+32)
   $CheckLoop = 1
   $V = False
   While True
	  $Str[0] = FileReadLine($FO[0])
	  If @error = -1 Then
		 While True
			FileWriteLine($FO[2], $Str[1])
			$Str[1] = FileReadLine($FO[1])
			If @error = -1 Then ExitLoop 2
		 WEnd
	  EndIf
	  If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then
		 FileWriteLine($FO[2], $Str[0])
	  ElseIf $Str[0] Then
		 While True
			If $CheckLoop Then $Str[1] = FileReadLine($FO[1])
			If @error = -1 Then
			   While True
				  If $Str[0] And Not StringInStr($Str[0], "[", 0, 1, 1, 1) Then
					 FileWriteLine($FO[2], $Str[0])
				  ElseIf $Str[0] Then
					 If $CheckLoop <> 2 Then
						If $V Then
						   FileWriteLine($FO[2], @CRLF & $Str[0])
						Else
						   FileWriteLine($FO[2], $Str[0])
						   $V = True
						EndIf
					 EndIf
				  EndIf
				  $Str[0] = FileReadLine($FO[0])
				  $CheckLoop = 1
				  If @error = -1 Then ExitLoop 3
			   WEnd
			EndIf
			If $Str[1] And Not StringInStr($Str[1], "[", 0, 1, 1, 1) Then
			   FileWriteLine($FO[2], $Str[1])
			ElseIf $Str[1] Then
			   If StringTrimRight($Str[1], 1) < StringTrimRight($Str[0], 1) Then
				  If $CheckLoop <> 2 Then
					 If $V Then
						FileWriteLine($FO[2], @CRLF & $Str[1])
					 Else
						FileWriteLine($FO[2], $Str[1])
						$V = True
					 EndIf
				  EndIf
				  $CheckLoop = 1
			   ElseIf StringTrimRight($Str[1], 1) > StringTrimRight($Str[0], 1) Then
				  If $CheckLoop <> 2 Then
					 If $V Then
						FileWriteLine($FO[2], @CRLF & $Str[0])
					 Else
						FileWriteLine($FO[2], $Str[0])
						$V = True
					 EndIf
				  EndIf
				  $CheckLoop = 0
				  ExitLoop
			   Else
				  If $V Then
					 FileWriteLine($FO[2], @CRLF & $Str[0])
				  Else
					 FileWriteLine($FO[2], $Str[0])
					 $V = True
				  EndIf
				  $CheckLoop = 2
			   EndIf
			EndIf
		 WEnd
	  EndIf
   WEnd
   For $i = 0 To 2
	  FileClose($FO[$i])
   Next
   FileDelete($File[2])
   FileDelete($File[6])
EndFunc

;Функция __ArrayDualPivotSort() из Array.au3
Func _ArraySort(ByRef $aArray, $iStart = 0, $iEnd = UBound($aArray) - 1, $bLeftMost = True)
   If $iStart > $iEnd Then Return
   Local $iLength = $iEnd - $iStart + 1
   Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
   If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
	  If $bLeftMost Then
		 $i = $iStart
		 While $i < $iEnd
			$j = $i
			$iAi = $aArray[$i + 1]
			While $iAi < $aArray[$j]
			   $aArray[$j + 1] = $aArray[$j]
			   $j -= 1
			   If $j + 1 = $iStart Then ExitLoop
			WEnd
			$aArray[$j + 1] = $iAi
			$i += 1
		 WEnd
	  Else
		 While 1
			If $iStart >= $iEnd Then Return 1
			$iStart += 1
			If $aArray[$iStart] < $aArray[$iStart - 1] Then ExitLoop
		 WEnd
		 While 1
			$k = $iStart
			$iStart += 1
			If $iStart > $iEnd Then ExitLoop
			$iA1 = $aArray[$k]
			$iA2 = $aArray[$iStart]
			If $iA1 < $iA2 Then
			   $iA2 = $iA1
			   $iA1 = $aArray[$iStart]
			EndIf
			$k -= 1
			While $iA1 < $aArray[$k]
			   $aArray[$k + 2] = $aArray[$k]
			   $k -= 1
			WEnd
			$aArray[$k + 2] = $iA1
			While $iA2 < $aArray[$k]
			   $aArray[$k + 1] = $aArray[$k]
			   $k -= 1
			WEnd
			$aArray[$k + 1] = $iA2
			$iStart += 1
		 WEnd
		 $iLast = $aArray[$iEnd]
		 $iEnd -= 1
		 While $iLast < $aArray[$iEnd]
			$aArray[$iEnd + 1] = $aArray[$iEnd]
			$iEnd -= 1
		 WEnd
		 $aArray[$iEnd + 1] = $iLast
	  EndIf
	  Return 1
   EndIf
   Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
   Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
   $iE3 = Ceiling(($iStart + $iEnd) / 2)
   $iE2 = $iE3 - $iSeventh
   $iE1 = $iE2 - $iSeventh
   $iE4 = $iE3 + $iSeventh
   $iE5 = $iE4 + $iSeventh
   If $aArray[$iE2] < $aArray[$iE1] Then
	  $t = $aArray[$iE2]
	  $aArray[$iE2] = $aArray[$iE1]
	  $aArray[$iE1] = $t
   EndIf
   If $aArray[$iE3] < $aArray[$iE2] Then
	  $t = $aArray[$iE3]
	  $aArray[$iE3] = $aArray[$iE2]
	  $aArray[$iE2] = $t
	  If $t < $aArray[$iE1] Then
		 $aArray[$iE2] = $aArray[$iE1]
		 $aArray[$iE1] = $t
	  EndIf
   EndIf
   If $aArray[$iE4] < $aArray[$iE3] Then
	  $t = $aArray[$iE4]
	  $aArray[$iE4] = $aArray[$iE3]
	  $aArray[$iE3] = $t
	  If $t < $aArray[$iE2] Then
		 $aArray[$iE3] = $aArray[$iE2]
		 $aArray[$iE2] = $t
		 If $t < $aArray[$iE1] Then
			$aArray[$iE2] = $aArray[$iE1]
			$aArray[$iE1] = $t
		 EndIf
	  EndIf
   EndIf
   If $aArray[$iE5] < $aArray[$iE4] Then
	  $t = $aArray[$iE5]
	  $aArray[$iE5] = $aArray[$iE4]
	  $aArray[$iE4] = $t
	  If $t < $aArray[$iE3] Then
		 $aArray[$iE4] = $aArray[$iE3]
		 $aArray[$iE3] = $t
		 If $t < $aArray[$iE2] Then
			$aArray[$iE3] = $aArray[$iE2]
			$aArray[$iE2] = $t
			If $t < $aArray[$iE1] Then
			   $aArray[$iE2] = $aArray[$iE1]
			   $aArray[$iE1] = $t
			EndIf
		 EndIf
	  EndIf
   EndIf
   Local $iLess = $iStart
   Local $iGreater = $iEnd
   If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) _
   And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
	  Local $iPivot_1 = $aArray[$iE2]
	  Local $iPivot_2 = $aArray[$iE4]
	  $aArray[$iE2] = $aArray[$iStart]
	  $aArray[$iE4] = $aArray[$iEnd]
	  Do
		 $iLess += 1
	  Until $aArray[$iLess] >= $iPivot_1
	  Do
		 $iGreater -= 1
	  Until $aArray[$iGreater] <= $iPivot_2
	  $k = $iLess
	  While $k <= $iGreater
		 $iAk = $aArray[$k]
		 If $iAk < $iPivot_1 Then
			$aArray[$k] = $aArray[$iLess]
			$aArray[$iLess] = $iAk
			$iLess += 1
		 ElseIf $iAk > $iPivot_2 Then
			While $aArray[$iGreater] > $iPivot_2
			   $iGreater -= 1
			   If $iGreater + 1 = $k Then ExitLoop 2
			WEnd
			If $aArray[$iGreater] < $iPivot_1 Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $aArray[$iGreater]
			   $iLess += 1
			Else
			   $aArray[$k] = $aArray[$iGreater]
			EndIf
			$aArray[$iGreater] = $iAk
			$iGreater -= 1
		 EndIf
		 $k += 1
	  WEnd
	  $aArray[$iStart] = $aArray[$iLess - 1]
	  $aArray[$iLess - 1] = $iPivot_1
	  $aArray[$iEnd] = $aArray[$iGreater + 1]
	  $aArray[$iGreater + 1] = $iPivot_2
	  _ArraySort($aArray, $iStart, $iLess - 2, True)
	  _ArraySort($aArray, $iGreater + 2, $iEnd, False)
	  If ($iLess < $iE1) And ($iE5 < $iGreater) Then
		 While $aArray[$iLess] = $iPivot_1
			$iLess += 1
		 WEnd
		 While $aArray[$iGreater] = $iPivot_2
			$iGreater -= 1
		 WEnd
		 $k = $iLess
		 While $k <= $iGreater
			$iAk = $aArray[$k]
			If $iAk = $iPivot_1 Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $iAk
			   $iLess += 1
			ElseIf $iAk = $iPivot_2 Then
			   While $aArray[$iGreater] = $iPivot_2
				  $iGreater -= 1
				  If $iGreater + 1 = $k Then ExitLoop 2
			   WEnd
			   If $aArray[$iGreater] = $iPivot_1 Then
				  $aArray[$k] = $aArray[$iLess]
				  $aArray[$iLess] = $iPivot_1
				  $iLess += 1
			   Else
				  $aArray[$k] = $aArray[$iGreater]
			   EndIf
			   $aArray[$iGreater] = $iAk
			   $iGreater -= 1
			EndIf
			$k += 1
		 WEnd
	  EndIf
	  _ArraySort($aArray, $iLess, $iGreater, False)
   Else
	  Local $iPivot = $aArray[$iE3]
	  $k = $iLess
	  While $k <= $iGreater
		 If $aArray[$k] = $iPivot Then
			$k += 1
			ContinueLoop
		 EndIf
		 $iAk = $aArray[$k]
		 If $iAk < $iPivot Then
			$aArray[$k] = $aArray[$iLess]
			$aArray[$iLess] = $iAk
			$iLess += 1
		 Else
			While $aArray[$iGreater] > $iPivot
			   $iGreater -= 1
			WEnd
			If $aArray[$iGreater] < $iPivot Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $aArray[$iGreater]
			   $iLess += 1
			Else
			   $aArray[$k] = $iPivot
			EndIf
			$aArray[$iGreater] = $iAk
			$iGreater -= 1
		 EndIf
		 $k += 1
	  WEnd
	  _ArraySort($aArray, $iStart, $iLess - 1, True)
	  _ArraySort($aArray, $iGreater + 1, $iEnd, False)
   EndIf
EndFunc
