#NoTrayIcon

If $CmdLine[0] = 2 Then
   If $CmdLine[1] = "<+>" Then
	  _PortableAll($CmdLine[2])
   ElseIf $CmdLine[1] = "<->" Then
	  _UnPortableAll($CmdLine[2])
   ElseIf $CmdLine[2] = "<+>" Then
	  _PortableAll($CmdLine[1])
   ElseIf $CmdLine[2] = "<->" Then
	  _UnPortableAll($CmdLine[1])
   EndIf
EndIf

Func _Lang()
   Local $MsvStr[2]
   Switch @OSLang
	  Case "0419", "0819"
		 $MsvStr[0] = "¬нимание!"
		 $MsvStr[1] = "“олько одна копи€ портативного приложени€ должна быть запущена."
	  Case Else
		 $MsvStr[0] = "Attention!"
		 $MsvStr[1] = "Only one copy of portable application should be run."
   EndSwitch
   Return $MsvStr
EndFunc

Func _PortableAll($Path)
   Local $TmpList = "ListOfFiles.txt", $FO, $Str, $StrIni

   $Path = StringRegExpReplace($Path, "[\\/]+\z", "") & "\"
   RunWait(@ComSpec & ' /U /C DIR "' & $Path & 'SetLnch.ini" /A /B /S > ' & $TmpList, '', @SW_HIDE)
   Sleep(30)
   $FO = FileOpen($TmpList, 32)
   While $FO <> -1
	  $Str = FileReadLine($FO)
	  If @error = -1 Then ExitLoop
	  $StrIni = Number(IniRead($Str, "Internal", "Prog", "0"))
	  If $StrIni > 0 Then
		 IniWrite($Str, "Internal", "Prog", $StrIni+1)
	  EndIf
   WEnd
   FileClose($FO)
   FileDelete($TmpList)
EndFunc

Func _UnPortableAll($Path)
   Local $TmpList = "ListOfFiles.txt", $FO, $Str, $StrIni, $ArrOfStr

   $Path = StringRegExpReplace($Path, "[\\/]+\z", "") & "\"
   RunWait(@ComSpec & ' /U /C DIR "' & $Path & 'SetLnch.ini" /A /B /S > ' & $TmpList, '', @SW_HIDE)
   $ArrOfStr = _Lang()
   If MsgBox(1+48, $ArrOfStr[0], $ArrOfStr[1]) = 1 Then
	  $FO = FileOpen($TmpList, 32)
	  While $FO <> -1
		 $Str = FileReadLine($FO)
		 If @error = -1 Then ExitLoop
		 $StrIni = Number(IniRead($Str, "Internal", "Prog", "0"))
		 If $StrIni > 1 Then
			IniWrite($Str, "Internal", "Prog", 1)
		 EndIf
	  WEnd
	  FileClose($FO)
   EndIf
   FileDelete($TmpList)
EndFunc
