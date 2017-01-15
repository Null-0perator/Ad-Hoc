Func _NumOfProc()
   Local $DataOut = StringToBinary("", 2), $Msv

   $RunProc = Run(@ComSpec & " /U /C SET NUMBER_OF_PROCESSORS", "", @SW_HIDE, 2)
   While True
	  $DataOut = $DataOut & StdoutRead($RunProc, False, True)
	  If @error Then ExitLoop
   WEnd
   $Msv = StringRegExp(BinaryToString($DataOut, 2), "[^\r\n]+", 3)
   $NumPr = StringReplace($Msv[0], "NUMBER_OF_PROCESSORS=", "", 1)

   Return Number($NumPr)
EndFunc

Func _SettingsOpen()
   $RS_D = IniReadSection($File[1], "Disks")
   If @error Then
	  For $i = 1 To $DrLst[0]
		 If $DrLst[$i] = @HomeDrive Then
			GUICtrlSetState($i-1+$VarDr[0], $GUI_CHECKED)
		 EndIf
	  Next
   Else
	  For $i = 1 To $RS_D[0][0]
		 If $i > $DrLst[0] Then ExitLoop
		 If $RS_D[$i][1] = "True" Then
			GUICtrlSetState($i-1+$VarDr[0], $GUI_CHECKED)
		 ElseIf $RS_D[$i][1] = "False" Then
			GUICtrlSetState($i-1+$VarDr[0], $GUI_UNCHECKED)
		 Else
			If $DrLst[$i] = @HomeDrive Then
			   GUICtrlSetState($i-1+$VarDr[0], $GUI_CHECKED)
			EndIf
		 EndIf
	  Next
   EndIf

   For $i = 0 To 1
	  $IniVal = IniRead($File[1], "Registry", $IniPrm[$i], "")
	  If $IniVal = "1" Then
		 GUICtrlSetState($ChkBox[$i], $GUI_CHECKED)
	  ElseIf $IniVal = "4" Then
		 GUICtrlSetState($ChkBox[$i], $GUI_UNCHECKED)
	  Else
		 GUICtrlSetState($ChkBox[$i], $GUI_CHECKED)
	  EndIf
   Next
EndFunc
Func _SettingsSave()
   If Not FileExists($Dir[5]) Then DirCreate($Dir[5])

   For $i = 1 To $DrLst[0]
	  If $LiVw[1] <> 0 Then
		 IniWrite($File[1], "Disks", StringUpper($DrLst[$i]), GUICtrlRead($i-1+$VarDr[0], 1) = $GUI_CHECKED)
	  ElseIf $DrLst[$i] = @HomeDrive Then
		 IniWrite($File[1], "Disks", @HomeDrive, True)
	  Else
		 IniWrite($File[1], "Disks", StringUpper($DrLst[$i]), False)
	  EndIf
   Next
   For $i = 0 To 1
	  If GUICtrlRead($ChkBox[$i]) Then
		 IniWrite($File[1], "Registry", $IniPrm[$i], GUICtrlRead($ChkBox[$i]))
	  Else
		 IniWrite($File[1], "Registry", $IniPrm[$i], "1")
	  EndIf
   Next
   $IniVal = IniRead($File[1], "CopyMove", "IsMove", "")
   If Not $Win[1] Or Not WinExists($Win[1]) Or $IniVal = "" Then
	  IniWrite($File[1], "CopyMove", "IsMove", GUICtrlRead($ChkBox[2]))
   EndIf

   $IniVal = IniRead($File[1], "Vrf_Prep", "IsVerify", "True")
   If $IniVal <> "False" Then IniWrite($File[1], "Vrf_Prep", "IsVerify", "True")

   $IniVal = IniRead($File[1], "StrMngr", "RunStrMngr", "Ask")
   If $IniVal <> "Yes" And $IniVal <> "No" Then IniWrite($File[1], "StrMngr", "RunStrMngr", "Ask")

   $IniVal = IniRead($File[1], "DataArch", "Add", "Ask")
   If $IniVal <> "Yes" And $IniVal <> "No" Then IniWrite($File[1], "DataArch", "Add", "Ask")
   $IniVal = IniRead($File[1], "DataArch", "Compress", "2")
   If $IniVal <> "0" And $IniVal <> "1" And $IniVal <> "3" And $IniVal <> "4" Then
	  IniWrite($File[1], "DataArch", "Compress", "2")
   EndIf

   $IniVal = IniRead($File[1], "MakeInst", "RunMakeInst", "Ask")
   If $IniVal <> "Yes" And $IniVal <> "No" Then IniWrite($File[1], "MakeInst", "RunMakeInst", "Ask")

   $IniVal = IniRead($File[1], "Miscellaneous", "Search in %Temp%", "False")
   If $IniVal <> "True" Then IniWrite($File[1], "Miscellaneous", "Search in %Temp%", "False")
   $IniVal = IniRead($File[1], "Miscellaneous", "Start.vbs", "Make")
   If $IniVal <> "Skip" Then IniWrite($File[1], "Miscellaneous", "Start.vbs", "Make")

   FileSetAttrib($File[1], "+H")
EndFunc

Func _SysSc_0()
   Local $Msv[$DrLst[0]+2], $Run[$IniNumPr], $SumProc, $Bnd, $ArrTmp, $L, $T, $M, $MsvTmp, $Q = 0, $s = 0
   If Not FileExists($Dir[5]) Then DirCreate($Dir[5])

   $RunProc = Run(@ComSpec & " /U /C DEL " & $Dir[5] & " /A-H /Q /F", "", @SW_HIDE)

   While True
	  $s = $s+1
	  GUICtrlSetData($Bar[0], $s)
	  Sleep(25)
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[0], $CancBtn[0]
			ProcessClose($RunProc)
			$Chk[1] = True
			Return
		 Case Else
			If Not ProcessExists($RunProc) Then
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd

   For $i = 0 To 1
	  $IniVal = IniRead($File[1], "Registry", $IniPrm[$i], "")
	  If $IniVal = "1" Then
		 $Msv[$i] = $IniPrm[$i]
	  ElseIf $IniVal <> "4" Then
		 $Msv[$i] = $IniPrm[$i]
	  EndIf
   Next

   $RS_D = IniReadSection($File[1], "Disks")
   If @error Then
	  For $i = 1 To $DrLst[0]
		 If $DrLst[$i] = @HomeDrive Then
			$Msv[$i-1+2] = @HomeDrive
		 EndIf
	  Next
   Else
	  For $i = 1 To $RS_D[0][0]
		 If $i > $DrLst[0] Then ExitLoop
		 If $RS_D[$i][1] = "True" Then
			$Msv[$i-1+2] = $RS_D[$i][0]
		 ElseIf $RS_D[$i][1] <> "False" Then
			If $RS_D[$i][0] = @HomeDrive Then
			   $Msv[$i-1+2] = $RS_D[$i][0]
			EndIf
		 EndIf
	  Next
   EndIf

   $Bnd = UBound($Msv)-1
   If $Bnd > 0 Then
	  $ArrTmp = $Msv
	  $L = 0
	  For $i = 0 To $Bnd
		 $Msv[$i] = Null
		 If $ArrTmp[$i] Then
			$Msv[$L] = $ArrTmp[$i]
			$L = $L+1
		 EndIf
	  Next
	  ReDim $Msv[$L]
   EndIf

   $Bnd = UBound($Msv)
   If Not $Bnd Or Not $Msv[0] Then
	  $Chk[1] = False
	  Return
   EndIf
   $T = Int($Bnd/$IniNumPr)
   $M = Mod($Bnd, $IniNumPr)

   If $IniNumPr = 2 And $Bnd > 1 Then
	  If $Msv[0] = $IniPrm[1] Then
		 $MsvTmp = $Msv[0]
		 $Msv[0] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  ElseIf $Msv[1] = $IniPrm[1] Then
		 $MsvTmp = $Msv[1]
		 $Msv[1] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  EndIf
   EndIf
   For $i = 1 To $T
	  For $j = 1 To $IniNumPr
		 If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
			$Run[$j-1] = Run($File[14] & " " & $Msv[$Q] & " <" & 2*$Q & ">", $Dir[4], @SW_HIDE)
		 Else
			$Run[$j-1] = Run(@ComSpec & " /U /C DIR " & $Msv[$Q] & "\ /A /B /S > " & _
						  $File[2] & 2*$Q & ".txt", "", @SW_HIDE)
		 EndIf
		 $Q = $Q+1
	  Next

	  While True
		 $s = $s+1
		 GUICtrlSetData($Bar[0], $s)
		 Sleep(25)
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[0], $CancBtn[0]
			   For $j = 1 To $IniNumPr
				  Run(@ComSpec & " /C TASKKILL /PID " & $Run[$j-1] & " /T /F", "", @SW_HIDE)
			   Next
			   $Chk[1] = True
			   Return
			Case Else
			   $SumProc = 0
			   For $j = 1 To $IniNumPr
				  $SumProc = $SumProc+Number(ProcessExists($Run[$j-1]))
			   Next
			   If Not $SumProc Then
				  $Chk[1] = False
				  ExitLoop
			   EndIf
		 EndSwitch
	  WEnd
   Next
   For $i = 1 To $M
	  If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
		 $Run[$i-1] = Run($File[14] & " " & $Msv[$Q] & " <" & 2*$Q & ">", $Dir[4], @SW_HIDE)
	  Else
		 $Run[$i-1] = Run(@ComSpec & " /U /C DIR " & $Msv[$Q] & "\ /A /B /S > " & _
					   $File[2] & 2*$Q & ".txt", "", @SW_HIDE)
	  EndIf
	  $Q = $Q+1
   Next

   While True
	  $s = $s+1
	  GUICtrlSetData($Bar[0], $s)
	  Sleep(25)
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[0], $CancBtn[0]
			For $i = 1 To $M
			   Run(@ComSpec & " /C TASKKILL /PID " & $Run[$i-1] & " /T /F", "", @SW_HIDE)
			Next
			$Chk[1] = True
			Return
		 Case Else
			$SumProc = 0
			For $i = 1 To $M
			   $SumProc = $SumProc+Number(ProcessExists($Run[$i-1]))
			Next
			If Not $SumProc Then
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd
EndFunc
Func _SysScEnd_0()
   GUICtrlSetState($Blk[3], $GUI_HIDE)
   GUICtrlSetState($Bar[0], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[0], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[1], $GUI_HIDE)
	  GUICtrlSetState($Pic[9], $GUI_HIDE)
	  GUICtrlSetState($Pic[2], $GUI_SHOW)
	  GUICtrlSetState($Pic[10], $GUI_SHOW)
	  GUICtrlSetState($Blk[4], $GUI_SHOW)
	  GUICtrlSetState($NextBtn[2], $GUI_ENABLE)
	  GUICtrlSetState($BackBtn[2], $GUI_SHOW)
   Else
	  GUICtrlSetState($Grp[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[0], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[0], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[1], $GUI_SHOW)
   EndIf
EndFunc

Func _SysSc_1()
   Local $Msv[$DrLst[0]+2], $Run[$IniNumPr], $SumProc, $Bnd, $ArrTmp, $L, $T, $M, $MsvTmp, $Q = 0, $s = 0
   If Not FileExists($Dir[5]) Then DirCreate($Dir[5])
   $Chk[4] = False

   For $i = 0 To 1
	  $IniVal = IniRead($File[1], "Registry", $IniPrm[$i], "")
	  If $IniVal = "1" Then
		 $Msv[$i] = $IniPrm[$i]
	  ElseIf $IniVal <> "4" Then
		 $Msv[$i] = $IniPrm[$i]
	  EndIf
	  FileDelete($File[3] & 2*$i+1 & ".txt")
   Next
   If $IniNumPr = 2 Then
	  For $i = 1 To $DrLst[0]+2
		 FileDelete($File[3] & 2*($i-1)+1 & ".txt")
	  Next
   EndIf

   $RS_D = IniReadSection($File[1], "Disks")
   If @error Then
	  For $i = 1 To $DrLst[0]
		 If $DrLst[$i] = @HomeDrive Then
			$Msv[$i-1+2] = @HomeDrive
		 EndIf
	  Next
   Else
	  For $i = 1 To $RS_D[0][0]
		 If $i > $DrLst[0] Then ExitLoop
		 If $RS_D[$i][1] = "True" Then
			$Msv[$i-1+2] = $RS_D[$i][0]
		 ElseIf $RS_D[$i][1] <> "False" Then
			If $RS_D[$i][0] = @HomeDrive Then
			   $Msv[$i-1+2] = $RS_D[$i][0]
			EndIf
		 EndIf
	  Next
   EndIf
   For $i = 1 To $DrLst[0]+2
	  FileDelete($File[2] & 2*($i-1)+1 & ".txt")
   Next

   $Bnd = UBound($Msv)-1
   If $Bnd > 0 Then
	  $ArrTmp = $Msv
	  $L = 0
	  For $i = 0 To $Bnd
		 $Msv[$i] = Null
		 If $ArrTmp[$i] Then
			$Msv[$L] = $ArrTmp[$i]
			$L = $L+1
		 EndIf
	  Next
	  ReDim $Msv[$L]
   EndIf

   $Bnd = UBound($Msv)
   If Not $Bnd Or Not $Msv[0] Then
	  $Chk[1] = False
	  Return
   EndIf
   $T = Int($Bnd/$IniNumPr)
   $M = Mod($Bnd, $IniNumPr)

   If $IniNumPr = 2 And $Bnd > 1 Then
	  If $Msv[0] = $IniPrm[1] Then
		 $MsvTmp = $Msv[0]
		 $Msv[0] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  ElseIf $Msv[1] = $IniPrm[1] Then
		 $MsvTmp = $Msv[1]
		 $Msv[1] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  EndIf
   EndIf
   For $i = 1 To $T
	  For $j = 1 To $IniNumPr
		 If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
			$Run[$j-1] = Run($File[14] & " " & $Msv[$Q] & " <" & 2*$Q+1 & ">", $Dir[4], @SW_HIDE)
		 Else
			$Run[$j-1] = Run(@ComSpec & " /U /C DIR " & $Msv[$Q] & "\ /A /B /S > " & _
						  $File[2] & 2*$Q+1 & ".txt", "", @SW_HIDE)
		 EndIf
		 $Q = $Q+1
	  Next

	  While True
		 $s = $s+1
		 GUICtrlSetData($Bar[1], $s)
		 Sleep(25)
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[1], $CancBtn[0]
			   For $j = 1 To $IniNumPr
				  Run(@ComSpec & " /C TASKKILL /PID " & $Run[$j-1] & " /T /F", "", @SW_HIDE)
			   Next
			   $Chk[1] = True
			   Return
			Case Else
			   $SumProc = 0
			   For $j = 1 To $IniNumPr
				  $SumProc = $SumProc+Number(ProcessExists($Run[$j-1]))
			   Next
			   If Not $SumProc Then
				  $Chk[1] = False
				  ExitLoop
			   EndIf
		 EndSwitch
	  WEnd
   Next
   For $i = 1 To $M
	  If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
		 $Run[$i-1] = Run($File[14] & " " & $Msv[$Q] & " <" & 2*$Q+1 & ">", $Dir[4], @SW_HIDE)
	  Else
		 $Run[$i-1] = Run(@ComSpec & " /U /C DIR " & $Msv[$Q] & "\ /A /B /S > " & _
					   $File[2] & 2*$Q+1 & ".txt", "", @SW_HIDE)
	  EndIf
	  $Q = $Q+1
   Next

   While True
	  $s = $s+1
	  GUICtrlSetData($Bar[1], $s)
	  Sleep(25)
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[1], $CancBtn[0]
			For $i = 1 To $M
			   Run(@ComSpec & " /C TASKKILL /PID " & $Run[$i-1] & " /T /F", "", @SW_HIDE)
			Next
			$Chk[1] = True
			Return
		 Case Else
			$SumProc = 0
			For $i = 1 To $M
			   $SumProc = $SumProc+Number(ProcessExists($Run[$i-1]))
			Next
			If Not $SumProc Then
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd
EndFunc
Func _SysScEnd_1()
   GUICtrlSetState($Blk[3], $GUI_HIDE)
   GUICtrlSetState($Bar[1], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[1], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[3], $GUI_HIDE)
	  GUICtrlSetState($Pic[11], $GUI_HIDE)
	  GUICtrlSetState($Pic[4], $GUI_SHOW)
	  GUICtrlSetState($Pic[12], $GUI_SHOW)
	  GUICtrlSetState($Blk[5], $GUI_SHOW)
	  GUICtrlSetState($Bar[2], $GUI_SHOW)
	  GUICtrlSetState($AbrtBtn[2], $GUI_SHOW)
   Else
	  GUICtrlSetState($Grp[2], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[1], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[3], $GUI_SHOW)
   EndIf
EndFunc

Func _Compare()
   If $Chk[1] Then Return
   Local $Msv[$DrLst[0]+2], $Run[$IniNumPr], $SumProc, $Bnd, $ArrTmp, $L, $T, $M, $MsvTmp, $Q = 0, $s = 0

   FileDelete($File[4])
   FileDelete($File[8])

   $IniVal = IniRead($File[1], "Miscellaneous", "Search in %Temp%", "False")
   If $IniVal <> "True" Then
	  Local $TmpDir = "False"
   Else
	  Local $TmpDir = "True"
   EndIf

   For $i = 0 To 1
	  $IniVal = IniRead($File[1], "Registry", $IniPrm[$i], "")
	  If $IniVal = "1" Then
		 $Msv[$i] = $IniPrm[$i]
	  ElseIf $IniVal <> "4" Then
		 $Msv[$i] = $IniPrm[$i]
	  EndIf
	  If FileExists($File[3] & 2*$i & ".txt") <> FileExists($File[3] & 2*$i+1 & ".txt") Then
		 MsgBox(48, $StrWin[2], $StrMsg[0], 0, $Win[0])
		 $Chk[1] = True
		 Return
	  EndIf
   Next
   If $IniNumPr = 2 Then
	  For $i = 1 To $DrLst[0]+2
		 If FileExists($File[3] & 2*($i-1) & ".txt") <> FileExists($File[3] & 2*($i-1)+1 & ".txt") Then
			MsgBox(48, $StrWin[2], $StrMsg[0], 0, $Win[0])
			$Chk[1] = True
			Return
		 EndIf
	  Next
   EndIf

   $RS_D = IniReadSection($File[1], "Disks")
   If @error Then
	  For $i = 1 To $DrLst[0]
		 If $DrLst[$i] = @HomeDrive Then
			$Msv[$i-1+2] = @HomeDrive
		 EndIf
	  Next
   Else
	  For $i = 1 To $RS_D[0][0]
		 If $i > $DrLst[0] Then ExitLoop
		 If $RS_D[$i][1] = "True" Then
			$Msv[$i-1+2] = $RS_D[$i][0]
		 ElseIf $RS_D[$i][1] <> "False" Then
			If $RS_D[$i][0] = @HomeDrive Then
			   $Msv[$i-1+2] = $RS_D[$i][0]
			EndIf
		 EndIf
	  Next
   EndIf
   For $i = 1 To $DrLst[0]+2
	  If FileExists($File[2] & 2*($i-1) & ".txt") <> FileExists($File[2] & 2*($i-1)+1 & ".txt") Then
		 MsgBox(48, $StrWin[2], $StrMsg[0], 0, $Win[0])
		 $Chk[1] = True
		 Return
	  EndIf
   Next
   If $IniNumPr = 2 Then
	  For $i = 0 To 1
		 If FileExists($File[2] & 2*$i & ".txt") <> FileExists($File[2] & 2*$i+1 & ".txt") Then
			MsgBox(48, $StrWin[2], $StrMsg[0], 0, $Win[0])
			$Chk[1] = True
			Return
		 EndIf
	  Next
   EndIf

   $Bnd = UBound($Msv)-1
   If $Bnd > 0 Then
	  $ArrTmp = $Msv
	  $L = 0
	  For $i = 0 To $Bnd
		 $Msv[$i] = Null
		 If $ArrTmp[$i] Then
			$Msv[$L] = $ArrTmp[$i]
			$L = $L+1
		 EndIf
	  Next
	  ReDim $Msv[$L]
   EndIf

   $Bnd = UBound($Msv)
   If Not $Bnd Or Not $Msv[0] Then
	  $Chk[1] = False
	  Return
   EndIf
   $T = Int($Bnd/$IniNumPr)
   $M = Mod($Bnd, $IniNumPr)

   If $IniNumPr = 2 And $Bnd > 1 Then
	  If $Msv[0] = $IniPrm[1] Then
		 $MsvTmp = $Msv[0]
		 $Msv[0] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  ElseIf $Msv[1] = $IniPrm[1] Then
		 $MsvTmp = $Msv[1]
		 $Msv[1] = $Msv[$Bnd-1]
		 $Msv[$Bnd-1] = $MsvTmp
	  EndIf
   EndIf

   For $i = 1 To $T
	  For $j = 1 To $IniNumPr
		 If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
			$Run[$j-1] = Run($File[14] & " " & 2*$Q & " " & 2*$Q+1, $Dir[4], @SW_HIDE)
		 Else
			$Run[$j-1] = Run($File[13] & " " & 2*$Q & " " & 2*$Q+1 & " " & $TmpDir, $Dir[4], @SW_HIDE)
		 EndIf
		 $Q = $Q+1
	  Next

	  While True
		 $s = $s+1
		 GUICtrlSetData($Bar[2], $s)
		 Sleep(25)
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[2], $CancBtn[0]
			   For $j = 1 To $IniNumPr
				  ProcessClose($Run[$j-1])
			   Next
			   $Chk[1] = True
			   Return
			Case Else
			   $SumProc = 0
			   For $j = 1 To $IniNumPr
				  $SumProc = $SumProc+Number(ProcessExists($Run[$j-1]))
			   Next
			   If Not $SumProc Then
				  $Chk[1] = False
				  ExitLoop
			   EndIf
		 EndSwitch
	  WEnd
   Next
   For $i = 1 To $M
	  If $Msv[$Q] = $IniPrm[0] Or $Msv[$Q] = $IniPrm[1] Then
		 $Run[$i-1] = Run($File[14] & " " & 2*$Q & " " & 2*$Q+1, $Dir[4], @SW_HIDE)
	  Else
		 $Run[$i-1] = Run($File[13] & " " & 2*$Q & " " & 2*$Q+1 & " " & $TmpDir, $Dir[4], @SW_HIDE)
	  EndIf
	  $Q = $Q+1
   Next

   While True
	  $s = $s+1
	  GUICtrlSetData($Bar[2], $s)
	  Sleep(25)
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[2], $CancBtn[0]
			For $i = 1 To $M
			   ProcessClose($Run[$i-1])
			Next
			$Chk[1] = True
			Return
		 Case Else
			$SumProc = 0
			For $i = 1 To $M
			   $SumProc = $SumProc+Number(ProcessExists($Run[$i-1]))
			Next
			If Not $SumProc Then
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd

   GUICtrlSetState($Bar[2], $GUI_HIDE)

   For $i = 0 To $Q-1
	  If $Msv[$i] = $IniPrm[0] Or $Msv[$i] = $IniPrm[1] Then
		 $Run[0] = Run($File[14] & " <" & 2*$i & "+>", $Dir[4], @SW_HIDE)
	  Else
		 $Run[0] = Run($File[13] & " <" & 2*$i & "+>", $Dir[4], @SW_HIDE)
	  EndIf

	  While True
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[2], $CancBtn[0]
			   ProcessClose($Run[0])
			   $Chk[1] = True
			   Return
			Case Else
			   If Not ProcessExists($Run[0]) Then
				  $Chk[1] = False
				  ExitLoop
			   EndIf
		 EndSwitch
	  WEnd
   Next
EndFunc
Func _CompareEnd()
   GUICtrlSetState($Pic[4], $GUI_HIDE)
   GUICtrlSetState($Pic[12], $GUI_HIDE)
   GUICtrlSetState($Blk[5], $GUI_HIDE)
   GUICtrlSetState($Bar[2], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[2], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[5], $GUI_SHOW)
	  GUICtrlSetState($Pic[13], $GUI_SHOW)
	  GUICtrlSetState($Bar[3], $GUI_SHOW)
	  GUICtrlSetState($AbrtBtn[3], $GUI_SHOW)
	  $IniVal = IniRead($File[1], "CopyMove", "IsMove", "0")
	  If $IniVal = "1" Then
		 GUICtrlSetState($Blk[7], $GUI_SHOW)
	  Else
		 GUICtrlSetState($Blk[6], $GUI_SHOW)
	  EndIf
   Else
	  GUICtrlSetState($Pic[3], $GUI_SHOW)
	  GUICtrlSetState($Pic[11], $GUI_SHOW)
	  GUICtrlSetState($Grp[2], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[1], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[3], $GUI_SHOW)
   EndIf
EndFunc

Func _CopyMove()
   If $Chk[1] Then Return
   Local $Pos, $EndPos, $s, $Attr, $StrTmp, $CheckLoop

   If $IniNumPr > 1 Then
	  $RunProc = Run($File[14] & " >>", $Dir[4], @SW_HIDE)
   EndIf

   $FO[0] = FileOpen($File[4], 32)
   If $FO[0] <> -1 Then
	  $Pos = FileGetPos($FO[0])
	  FileSetPos($FO[0], 0, $FILE_END)
	  $EndPos = FileGetPos($FO[0])
	  FileSetPos($FO[0], $Pos, $FILE_BEGIN)
	  $FO[1] = FileOpen($File[5], 2+32)
	  $FO[2] = FileOpen($File[7], 2+32)
   EndIf

   $IniVal = IniRead($File[1], "CopyMove", "IsMove", "0")
   If $IniVal = "1" Then
	  While $FO[0] <> -1
		 $ReadStr = FileReadLine($FO[0])
		 If @error = -1 Then
			FileClose($FO[0])
			FileClose($FO[1])
			FileClose($FO[2])
			ExitLoop
		 EndIf
		 If FileExists($ReadStr) Then
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr($ReadStr, EnvGet($Var)) Then
				  FileWriteLine($FO[2], StringReplace($ReadStr, EnvGet($Var), "::@" & $Var, 1))
				  $CheckLoop = True
				  $Attr = FileGetAttrib($ReadStr)
				  If StringInStr($Attr, "D") Then
					 DirMove($ReadStr, $Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1))
					 If $Attr <> "D" Then
						FileSetAttrib($Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1), StringReplace($Attr, "D", "", 1))
					 EndIf
				  Else
					 FileSetAttrib($ReadStr, "-R")
					 FileMove($ReadStr, $Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1), 8)
					 FileSetAttrib($Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1), "+" & $Attr)
				  EndIf
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   $StrTmp = StringInStr($ReadStr, ":", 0, 1)
			   If $StrTmp Then
				  $StrTmp = StringTrimLeft($ReadStr, $StrTmp)
				  $StrTmp = StringUpper(StringTrimRight($ReadStr, StringLen($StrTmp)+1)) & $StrTmp
				  FileWriteLine($FO[2], "::Drive_" & $StrTmp)
				  $Attr = FileGetAttrib($ReadStr)
				  If StringInStr($Attr, "D") Then
					 DirMove($ReadStr, $Dir[2] & "Drive_" & $StrTmp)
					 If $Attr <> "D" Then
						FileSetAttrib($Dir[2] & "Drive_" & $StrTmp, StringReplace($Attr, "D", "", 1))
					 EndIf
				  Else
					 FileMove($ReadStr, $Dir[2] & "Drive_" & $StrTmp, 8)
					 FileSetAttrib($Dir[2] & "Drive_" & $StrTmp, "+" & $Attr)
				  EndIf
			   EndIf
			EndIf
		 Else
			For $Var in $Envir
			   $CheckLoop = False
			   If StringInStr($ReadStr, EnvGet($Var)) Then
				  FileWriteLine($FO[2], StringReplace($ReadStr, EnvGet($Var), "::@" & $Var, 1))
				  $CheckLoop = True
				  ExitLoop
			   EndIf
			Next
			If Not $CheckLoop Then
			   $StrTmp = StringInStr($ReadStr, ":", 0, 1)
			   If $StrTmp Then
				  $StrTmp = StringTrimLeft($ReadStr, $StrTmp)
				  $StrTmp = StringUpper(StringTrimRight($ReadStr, StringLen($StrTmp)+1)) & $StrTmp
				  FileWriteLine($FO[2], "::Drive_" & $StrTmp)
			   EndIf
			EndIf
		 EndIf

		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[3], $CancBtn[0]
			   FileClose($FO[0])
			   FileClose($FO[1])
			   FileClose($FO[2])
			   If ProcessExists($RunProc) Then ProcessClose($RunProc)
			   $Chk[1] = True
			   $Chk[4] = True
			   Return
			Case Else
			   $s = Int(100*FileGetPos($FO[0])/$EndPos)
			   GUICtrlSetData($Bar[3], $s)
			   $Chk[1] = False
		 EndSwitch
	  WEnd
   Else
	  While $FO[0] <> -1
		 $ReadStr = FileReadLine($FO[0])
		 If @error = -1 Then
			FileClose($FO[0])
			FileClose($FO[1])
			FileClose($FO[2])
			ExitLoop
		 EndIf
		 For $Var in $Envir
			$CheckLoop = False
			If StringInStr($ReadStr, EnvGet($Var)) Then
			   FileWriteLine($FO[1], $ScriptDir & $Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1))
			   FileWriteLine($FO[2], StringReplace($ReadStr, EnvGet($Var), "::@" & $Var, 1))
			   $CheckLoop = True
			   $Attr = FileGetAttrib($ReadStr)
			   If StringInStr($Attr, "D") Then
				  DirCreate($Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1))
				  If $Attr <> "D" Then
					 FileSetAttrib($Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1), StringReplace($Attr, "D", "", 1))
				  EndIf
			   Else
				  FileCopy($ReadStr, $Dir[2] & StringReplace($ReadStr, EnvGet($Var), "@" & $Var, 1), 8)
			   EndIf
			   ExitLoop
			EndIf
		 Next
		 If Not $CheckLoop Then
			$StrTmp = StringInStr($ReadStr, ":", 0, 1)
			If $StrTmp Then
			   $StrTmp = StringTrimLeft($ReadStr, $StrTmp)
			   $StrTmp = StringUpper(StringTrimRight($ReadStr, StringLen($StrTmp)+1)) & $StrTmp
			   FileWriteLine($FO[1], $ScriptDir & $Dir[2] & "Drive_" & $StrTmp)
			   FileWriteLine($FO[2], "::Drive_" & $StrTmp)
			   $Attr = FileGetAttrib($ReadStr)
			   If StringInStr($Attr, "D") Then
				  DirCreate($Dir[2] & "Drive_" & $StrTmp)
				  If $Attr <> "D" Then
					 FileSetAttrib($Dir[2] & "Drive_" & $StrTmp, StringReplace($Attr, "D", "", 1))
				  EndIf
			   Else
				  FileCopy($ReadStr, $Dir[2] & "Drive_" & $StrTmp, 8)
			   EndIf
			EndIf
		 EndIf

		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[3], $CancBtn[0]
			   FileClose($FO[0])
			   FileClose($FO[1])
			   FileClose($FO[2])
			   If ProcessExists($RunProc) Then ProcessClose($RunProc)
			   $Chk[1] = True
			   $Chk[4] = True
			   Return
			Case Else
			   $s = Int(100*FileGetPos($FO[0])/$EndPos)
			   GUICtrlSetData($Bar[3], $s)
			   $Chk[1] = False
		 EndSwitch
	  WEnd
   EndIf

   If $IniNumPr = 1 Then
	  $RunProc = Run($File[14] & " >>", $Dir[4], @SW_HIDE)
   EndIf

   If ProcessExists($RunProc) Then
	  $s = 0
	  GUICtrlSetData($Bar[3], $s)
	  GUICtrlSetState($Bar[3], $GUI_HIDE)
	  GUICtrlSetState($Bar[4], $GUI_SHOW)

	  While True
		 $s = $s+1
		 GUICtrlSetData($Bar[4], $s)
		 Sleep(25)
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $AbrtBtn[3], $CancBtn[0]
			   ProcessClose($RunProc)
			   $Chk[1] = True
			   Return
			Case Else
			   If Not ProcessExists($RunProc) Then
				  $Chk[1] = False
				  ExitLoop
			   EndIf
		 EndSwitch
	  WEnd

	  If $IniNumPr = 1 And IniRead($File[1], "CopyMove", "IsMove", "0") = "1" Then
		 $RunProc = Run($File[14] & " *", $Dir[4], @SW_HIDE)

		 While True
			$s = $s+1
			GUICtrlSetData($Bar[4], $s)
			Sleep(25)
			Switch GUIGetMsg()
			   Case $GUI_EVENT_CLOSE, $AbrtBtn[3], $CancBtn[0]
				  ProcessClose($RunProc)
				  $Chk[1] = True
				  ExitLoop
			   Case Else
				  If Not ProcessExists($RunProc) Then
					 $Chk[1] = False
					 ExitLoop
				  EndIf
			EndSwitch
		 WEnd
	  EndIf
   EndIf
EndFunc
Func _CopyMoveEnd()
   GUICtrlSetData($Bar[3], 0)
   GUICtrlSetState($Pic[5], $GUI_HIDE)
   GUICtrlSetState($Pic[13], $GUI_HIDE)
   GUICtrlSetState($Blk[6], $GUI_HIDE)
   GUICtrlSetState($Blk[7], $GUI_HIDE)
   GUICtrlSetState($Bar[3], $GUI_HIDE)
   GUICtrlSetState($Bar[4], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[3], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[6], $GUI_SHOW)
	  GUICtrlSetState($Pic[14], $GUI_SHOW)
	  GUICtrlSetState($Blk[8], $GUI_SHOW)
	  GUICtrlSetState($Bar[5], $GUI_SHOW)
	  GUICtrlSetState($AbrtBtn[4], $GUI_SHOW)
   Else
	  If $Chk[4] Then Return
	  GUICtrlSetState($Pic[3], $GUI_SHOW)
	  GUICtrlSetState($Pic[11], $GUI_SHOW)
	  GUICtrlSetState($Grp[2], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[1], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[3], $GUI_SHOW)
   EndIf
EndFunc

Func _Vrf_Prep()
   If $Chk[1] Then Return
   Local $Run[2], $s = 0

   If $IniNumPr > 1 And IniRead($File[1], "CopyMove", "IsMove", "0") = "1" Then
	  $Run[0] = Run($File[14] & " *", $Dir[4], @SW_HIDE)
   EndIf
   $Run[1] = Run($File[14] & " <+>", $Dir[4], @SW_HIDE)

   $RunProc = Run($File[15], $Dir[4], @SW_HIDE)
   While True
	  $s = $s+1
	  GUICtrlSetData($Bar[5], $s)
	  Sleep(25)
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[4], $CancBtn[0]
			ProcessClose($RunProc)
			ProcessClose($Run[0])
			ProcessClose($Run[1])
			$Chk[1] = True
			$Chk[4] = True
			ExitLoop
		 Case Else
			If Not ProcessExists($RunProc) And Not ProcessExists($Run[0])  And Not ProcessExists($Run[1]) Then
			   If FileGetSize($File[6]) <= 2 Then
				  $Win[3] = False
			   Else
				  $FO[0] = FileOpen($File[6], 32)
				  _Wind_3(FileRead($FO[0]))
				  FileClose($FO[0])
			   EndIf
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd
EndFunc
Func _Vrf_PrepEnd()
   GUICtrlSetState($Pic[6], $GUI_HIDE)
   GUICtrlSetState($Pic[14], $GUI_HIDE)
   GUICtrlSetState($Blk[8], $GUI_HIDE)
   GUICtrlSetState($Bar[5], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[4], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[7], $GUI_SHOW)
	  GUICtrlSetState($Pic[15], $GUI_SHOW)
	  For $i = 0 To 2
		 If $i <> 1 Then
			If FileGetSize($File[$i+7]) > 2 Then FileMove($File[$i+7], $Dir[2], 9)
		 Else
			If FileGetSize($File[$i+7]) > 82 Then FileMove($File[$i+7], $Dir[2], 9)
		 EndIf
	  Next
	  FileCopy($Dir[4] & $File[10], $Dir[2], 9)
	  If FileGetSize($File[11]) <= 2 Then
		 GUICtrlSetState($NextBtn[3], $GUI_HIDE)
		 GUICtrlSetState($Blk[10], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[4], $GUI_SHOW+$GUI_DISABLE)
		 GUICtrlSetState($AbrtBtn[5], $GUI_SHOW)
		 _SrcGen()
		 _SrcGenEnd()
	  Else
		 GUICtrlSetState($Sep[2], $GUI_HIDE)
		 GUICtrlSetState($Blk[9], $GUI_SHOW)
		 GUICtrlSetState($BackBtn[4], $GUI_SHOW+$GUI_DISABLE)
		 GUICtrlSetState($NextBtn[3], $GUI_DISABLE)
		 GUICtrlSetState($CancBtn[0], $GUI_DISABLE)
		 _LiVw()
	  EndIf
   Else
	  If $Chk[4] Then _DataDel()
	  GUICtrlSetState($Pic[3], $GUI_SHOW)
	  GUICtrlSetState($Pic[11], $GUI_SHOW)
	  GUICtrlSetState($Grp[2], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[1], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[3], $GUI_SHOW)
   EndIf
EndFunc

Func _SrcGen()
   Local $DataOut = ""

   $RunProc = Run($File[16], $Dir[4], @SW_HIDE, 2)
   While True
	  $DataOut = $DataOut & StdoutRead($RunProc, False, False)
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE, $AbrtBtn[5], $CancBtn[0]
			If $MSG[1] = $Win[0] Then
			   ProcessClose($RunProc)
			   $Chk[1] = True
			   ExitLoop
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			   GUISwitch($Win[0])
			EndIf
		 Case Else
			If Not ProcessExists($RunProc) And $DataOut = "Exit" Then
			   $Chk[1] = True
			   ExitLoop
			ElseIf Not ProcessExists($RunProc) And $DataOut <> "Exit" Then
			   $Chk[1] = False
			   ExitLoop
			EndIf
	  EndSwitch
	  Sleep(80)
   WEnd
EndFunc
Func _SrcGenEnd()
   GUICtrlSetState($Blk[10], $GUI_HIDE)
   GUICtrlSetState($AbrtBtn[5], $GUI_HIDE)
   If Not $Chk[1] Then
	  GUICtrlSetState($Pic[7], $GUI_HIDE)
	  GUICtrlSetState($Pic[15], $GUI_HIDE)
	  GUICtrlSetState($BackBtn[5], $GUI_SHOW+$GUI_DISABLE)
	  GUICtrlSetState($CancBtn[0], $GUI_HIDE)
	  GUICtrlSetState($CancBtn[1], $GUI_SHOW+$GUI_DISABLE)
	  _RunStrMngr()
	  GUICtrlSetState($Pic[8], $GUI_SHOW)
	  GUICtrlSetState($Pic[16], $GUI_SHOW)
	  GUICtrlSetState($Pic[17], $GUI_SHOW)
	  GUICtrlSetState($Pic[18], $GUI_SHOW)
	  GUICtrlSetState($Blk[11], $GUI_SHOW)
	  GUICtrlSetState($ChkBox[3], $GUI_SHOW)
	  GUICtrlSetState($NextBtn[4], $GUI_ENABLE)
	  GUICtrlSetState($BackBtn[5], $GUI_ENABLE)
	  GUICtrlSetState($CancBtn[1], $GUI_ENABLE)
	  $Chk[2] = True
   ElseIf FileGetSize($File[11]) > 2 Then
	  GUICtrlSetState($NextBtn[4], $GUI_HIDE)
	  GUICtrlSetState($Sep[2], $GUI_HIDE)
	  GUICtrlSetState($Blk[9], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[4], $GUI_SHOW+$GUI_DISABLE)
	  GUICtrlSetState($NextBtn[3], $GUI_SHOW+$GUI_DISABLE)
	  GUICtrlSetState($CancBtn[0], $GUI_DISABLE)
 	  _LiVw()
   Else
	  GUICtrlSetState($Pic[7], $GUI_HIDE)
	  GUICtrlSetState($Pic[15], $GUI_HIDE)
	  GUICtrlSetState($BackBtn[3], $GUI_SHOW+$GUI_DISABLE)
	  GUICtrlSetState($NextBtn[4], $GUI_HIDE)
	  GUICtrlSetState($NextBtn[3], $GUI_SHOW+$GUI_DISABLE)
	  GUICtrlSetState($CancBtn[0], $GUI_DISABLE)
	  _DataDel()
	  GUICtrlSetState($BackBtn[3], $GUI_ENABLE)
	  GUICtrlSetState($CancBtn[0], $GUI_ENABLE)
	  GUICtrlSetState($Pic[3], $GUI_SHOW)
	  GUICtrlSetState($Pic[11], $GUI_SHOW)
	  GUICtrlSetState($Grp[2], $GUI_SHOW)
	  GUICtrlSetState($BtnSc[1], $GUI_SHOW)
	  GUICtrlSetState($BtnSet[1], $GUI_SHOW)
   EndIf
EndFunc

Func _DataDel()
   If MsgBox(4+32, "", $StrMsg[1], 0, $Win[0]) = 6 Then
	  RunWait(@ComSpec & " /U /C RD " & $Dir[2] & " /S /Q", "", @SW_HIDE)
	  Sleep(50)
	  DirCreate($Dir[2])
   EndIf
EndFunc

Func _DataTmpDel()
   TraySetState(2)

   If GUICtrlRead($ChkBox[3]) = $GUI_CHECKED Then
	  Run(@ComSpec & " /U /C DEL " & $Dir[5] & " /A-H /Q /F", "", @SW_HIDE)
   EndIf
EndFunc

Func _ShowTray()
   TrayItemSetState($TrayItm[0], $TRAY_DISABLE)
   TrayItemSetState($TrayItm[1], $TRAY_DISABLE)
   TrayItemSetState($TrayItm[4], $TRAY_DISABLE)
   TraySetState(1)
   TraySetToolTip($StrTlTp[3])

   While ProcessExists($RunProc)
	  Switch TrayGetMsg()
		 Case $TrayItm[3]
			ProcessClose($RunProc)
			TrayItemSetState($TrayItm[0], $TRAY_ENABLE)
			TrayItemSetState($TrayItm[3], $TRAY_DISABLE)
			While True
			   Switch TrayGetMsg()
				  Case $TrayItm[0]
					 $RunProc = Run($File[17], $Dir[4], @SW_HIDE)
					 TrayItemSetState($TrayItm[0], $TRAY_DISABLE)
					 TrayItemSetState($TrayItm[3], $TRAY_ENABLE)
					 ExitLoop
				  Case $TrayItm[6]
					 ProcessClose($RunProc)
					 Exit
			   EndSwitch
			WEnd
		 Case $TrayItm[6]
			ProcessClose($RunProc)
			Exit
	  EndSwitch
   WEnd
EndFunc

Func _RunStrMngr()
   $IniVal = IniRead($File[1], "StrMngr", "RunStrMngr", "Ask")
   If $IniVal = "Yes" Then
	  GUISetState(@SW_HIDE, $Win[0])
	  $RunProc = Run($Dir[2] & $File[10], $Dir[2], @SW_HIDE)
   ElseIf $IniVal <> "No" Then
	  _Wind_4()
   EndIf

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			EndIf
		 Case Else
			If Not ProcessExists($RunProc) Then
			   GUISetState(@SW_SHOW, $Win[0])
			   ExitLoop
			EndIf
	  EndSwitch
   WEnd
EndFunc

Func _AddArchData()
   $IniVal = IniRead($File[1], "DataArch", "Add", "Ask")
   If $IniVal = "Yes" Then
	  GUISetState(@SW_HIDE, $Win[0])
	  $RunProc = Run($File[17], $Dir[4], @SW_HIDE)
	  _ShowTray()
   ElseIf $IniVal = "No" Then
	  GUISetState(@SW_HIDE, $Win[0])
   Else
	  _Wind_5()
   EndIf
EndFunc

Func _MakeVbs()
   Local $n = -1, $StrTmp
   RunWait(@ComSpec & " /U /C DEL " & $Dir[1] & "*.vbs" & " /A /Q /F", "", @SW_HIDE)

   If FileGetSize($File[12]) <= 2 And FileExists($Dir[3] & "PortApp.au3") Then
	  $FO[1] = FileOpen($Dir[1] & "PortApp.vbs", 2+32)
	  FileWriteLine($FO[1], 'Dim Path' & @CRLF & _
				  'Set WshShell = CreateObject("WScript.Shell")' & @CRLF & _
				  'Path = WScript.ScriptFullName' & @CRLF & _
				  'Path = """" & Left(Path, InStrRev(Path, "\")) & "Source\PortApp.au3" & """"' & @CRLF & _
				  'WshShell.Run "Data\StrMngr.exe /AutoIt3ExecuteScript " & Path & "", 0, false' & @CRLF)
	  FileClose($FO[1])
   EndIf

   $FO[0] = FileOpen($File[12], 32)
   If $FO[0] = -1 Then Return
   While True
	  $ReadStr = FileReadLine($FO[0])
	  If @error = -1 Then ExitLoop
	  $n = $n+1
	  $StrTmp = StringRegExpReplace($ReadStr, "^(?:.*\\)([^\\]*?)(?:\.[^.]+)?$", "\1") & ".portable"

	  If FileExists($Dir[3] & $StrTmp & "_" & $n & ".au3") Then
		 $FO[1] = FileOpen($Dir[1] & $StrTmp & "_" & $n & ".vbs", 2+32)
		 FileWriteLine($FO[1], 'Dim Path' & @CRLF & _
					 'Set WshShell = CreateObject("WScript.Shell")' & @CRLF & _
					 'Path = WScript.ScriptFullName' & @CRLF & _
					 'Path = """" & Left(Path, InStrRev(Path, "\")) & "Source\' & _
					 $StrTmp & '_' & $n & '.au3' & '" & """"' & @CRLF & _
					 'WshShell.Run "Data\StrMngr.exe /AutoIt3ExecuteScript " & Path & "", 0, false' & @CRLF)
		 FileClose($FO[1])
	  ElseIf FileExists($Dir[3] & $StrTmp & ".au3") Then
		 $FO[1] = FileOpen($Dir[1] & $StrTmp & ".vbs", 2+32)
		 FileWriteLine($FO[1], 'Dim Path' & @CRLF & _
					 'Set WshShell = CreateObject("WScript.Shell")' & @CRLF & _
					 'Path = WScript.ScriptFullName' & @CRLF & _
					 'Path = """" & Left(Path, InStrRev(Path, "\")) & "Source\' & _
					 $StrTmp & '.au3' & '" & """"' & @CRLF & _
					 'WshShell.Run "Data\StrMngr.exe /AutoIt3ExecuteScript " & Path & "", 0, false' & @CRLF)
		 FileClose($FO[1])
	  EndIf
   WEnd

   FileClose($FO[0])
EndFunc
Func _Compile()
   $RunProc = Run($File[18], $Dir[4], @SW_HIDE)

   TrayItemSetState($TrayItm[0], $TRAY_DISABLE)
   TrayItemSetState($TrayItm[1], $TRAY_DISABLE)
   TrayItemSetState($TrayItm[3], $TRAY_DISABLE)
   TrayItemSetState($TrayItm[4], $TRAY_ENABLE)
   TraySetState(1)
   TraySetToolTip($StrTlTp[4])

   While ProcessExists($RunProc)
	  Switch TrayGetMsg()
		 Case $TrayItm[4]
			ProcessClose($RunProc)
			TrayItemSetState($TrayItm[1], $TRAY_ENABLE)
			TrayItemSetState($TrayItm[4], $TRAY_DISABLE)
			While True
			   Switch TrayGetMsg()
				  Case $TrayItm[1]
					 $RunProc = Run($File[18], $Dir[4], @SW_HIDE)
					 TrayItemSetState($TrayItm[1], $TRAY_DISABLE)
					 TrayItemSetState($TrayItm[4], $TRAY_ENABLE)
					 ExitLoop
				  Case $TrayItm[6]
					 ProcessClose($RunProc)
					 Exit
			   EndSwitch
			WEnd
		 Case $TrayItm[6]
			ProcessClose($RunProc)
			Exit
	  EndSwitch
   WEnd

   TraySetState(2)
EndFunc

Func _RunMakeInst()
   $IniVal = IniRead($File[1], "MakeInst", "RunMakeInst", "Ask")
   If $IniVal <> "Yes" And $IniVal <> "No" Then
   	  Switch MsgBox(4+32, "", $StrMsg[2])
		 Case 6
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "MakeInst", "RunMakeInst", "Yes")
			Run($File[19], "", @SW_HIDE)
		 Case 7
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "MakeInst", "RunMakeInst", "No")
	  EndSwitch
   ElseIf $IniVal = "Yes" Then
	  Run($File[19], "", @SW_HIDE)
   EndIf
EndFunc
