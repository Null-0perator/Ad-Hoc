#NoTrayIcon

Local $File[4], $Var
Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)

$File[0] = $UpDir & '\Data'
$File[1] = $File[0] & '\SysFiles_'
$File[2] = $File[0] & '\FilesDiff'
$File[3] = $UpDir & '\App\PortApp'

If $CmdLine[0] = 1 Then
   If StringInStr($CmdLine[1], "+>", 0, -1) Then
	  $Var = Number(StringRegExpReplace($CmdLine[1], "[^0-9]+", ""))
	  If $Var = 0 Then
		 If FileExists($File[2] & '_' & $Var & '.txt') Then
			FileMove($File[2] & '_' & $Var & '.txt', $File[2] & '.txt', 1)
		 ElseIf FileExists($File[2] & '.txt') Then
			FileDelete($File[2] & '.txt')
		 EndIf
	  Else
		 If FileExists($File[2] & '_' & $Var & '.txt') Then
			_AddFile($Var)
		 EndIf
	  EndIf
   EndIf
ElseIf $CmdLine[0] = 3 Then
   _Compare($CmdLine[1], $CmdLine[2], $CmdLine[3])
EndIf

Func _AddFile($Prm_0)
   Local $FO[2] = [FileOpen($File[2] & '.txt', 1+32), FileOpen($File[2] & '_' & $Prm_0 & '.txt', 32)]

   FileWrite($FO[0], FileRead($FO[1]))
   FileClose($FO[0])
   FileClose($FO[1])
   FileDelete($File[2] & '_' & $Prm_0 & '.txt')
EndFunc

Func _Compare($Prm_0, $Prm_1, $Prm_2)
   If FileGetSize($File[1] & $Prm_0 & '.txt') > 2 And _
   FileGetSize($File[1] & $Prm_1 & '.txt') > 2 Then
	  Local $Path[3] = [$File[1] & $Prm_0 & '.txt', $File[1] & $Prm_1 & '.txt', $File[2] & '_' & $Prm_0 & '.txt'], _
		    $FO[3], $ReadStr[2] = [".", "."]

	  $FO[0] = FileOpen($Path[0], 32)
	  If $FO[0] = -1 Then Exit
	  $FO[1] = FileOpen($Path[1], 32)
	  If $FO[1] = -1 Then
		 FileClose($FO[0])
		 Exit
	  EndIf
	  $FO[2] = FileOpen($Path[2], 2+32)
	  If $Prm_2 = "False" Then
		 While True
			If $ReadStr[0] = $ReadStr[1] Then
			   $ReadStr[0] = FileReadLine($FO[0])
			   If @error = -1 Then
				  While True
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
					 If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) And _
					 Not StringInStr($ReadStr[1], @TempDir) Then
						FileWriteLine($FO[2], $ReadStr[1])
					 EndIf
				  WEnd
			   EndIf
			   $ReadStr[1] = FileReadLine($FO[1])
			   If @error = -1 Then ExitLoop
			Else
			   If FileExists($ReadStr[0]) And FileExists($ReadStr[1]) Then
				  Do
					 If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) And _
					 Not StringInStr($ReadStr[1], @TempDir) Then
						FileWriteLine($FO[2], $ReadStr[1])
					 EndIf
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
				  Until $ReadStr[0] = $ReadStr[1] Or Not FileExists($ReadStr[1])
			   ElseIf Not FileExists($ReadStr[0]) And FileExists($ReadStr[1]) Then
				  Do
					 $ReadStr[0] = FileReadLine($FO[0])
					 If @error = -1 Then
						While True
						   If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) And _
						   Not StringInStr($ReadStr[1], @TempDir) Then
							  FileWriteLine($FO[2], $ReadStr[1])
						   EndIf
						   $ReadStr[1] = FileReadLine($FO[1])
						   If @error = -1 Then ExitLoop 3
						WEnd
					 EndIf
				  Until $ReadStr[0] = $ReadStr[1] Or FileExists($ReadStr[0])
			   ElseIf FileExists($ReadStr[0]) And Not FileExists($ReadStr[1]) Then
				  Do
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
				  Until $ReadStr[0] = $ReadStr[1] Or FileExists($ReadStr[1])
			   Else
				  $ReadStr[0] = FileReadLine($FO[0])
				  If @error = -1 Then ExitLoop
				  $ReadStr[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop
			   EndIf
			EndIf
		 WEnd
	  Else
		 While True
			If $ReadStr[0] = $ReadStr[1] Then
			   $ReadStr[0] = FileReadLine($FO[0])
			   If @error = -1 Then
				  While True
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
					 If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) Then
						FileWriteLine($FO[2], $ReadStr[1])
					 EndIf
				  WEnd
			   EndIf
			   $ReadStr[1] = FileReadLine($FO[1])
			   If @error = -1 Then ExitLoop
			Else
			   If FileExists($ReadStr[0]) And FileExists($ReadStr[1]) Then
				  Do
					 If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) Then
						FileWriteLine($FO[2], $ReadStr[1])
					 EndIf
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
				  Until $ReadStr[0] = $ReadStr[1] Or Not FileExists($ReadStr[1])
			   ElseIf Not FileExists($ReadStr[0]) And FileExists($ReadStr[1]) Then
				  Do
					 $ReadStr[0] = FileReadLine($FO[0])
					 If @error = -1 Then
						While True
						   If Not StringInStr($ReadStr[1], $File[0]) And Not StringInStr($ReadStr[1], $File[3]) Then
							  FileWriteLine($FO[2], $ReadStr[1])
						   EndIf
						   $ReadStr[1] = FileReadLine($FO[1])
						   If @error = -1 Then ExitLoop 3
						WEnd
					 EndIf
				  Until $ReadStr[0] = $ReadStr[1] Or FileExists($ReadStr[0])
			   ElseIf FileExists($ReadStr[0]) And Not FileExists($ReadStr[1]) Then
				  Do
					 $ReadStr[1] = FileReadLine($FO[1])
					 If @error = -1 Then ExitLoop 2
				  Until $ReadStr[0] = $ReadStr[1] Or FileExists($ReadStr[1])
			   Else
				  $ReadStr[0] = FileReadLine($FO[0])
				  If @error = -1 Then ExitLoop
				  $ReadStr[1] = FileReadLine($FO[1])
				  If @error = -1 Then ExitLoop
			   EndIf
			EndIf
		 WEnd
	  EndIf
	  FileClose($FO[0])
	  FileClose($FO[1])
	  FileClose($FO[2])
   EndIf
EndFunc
