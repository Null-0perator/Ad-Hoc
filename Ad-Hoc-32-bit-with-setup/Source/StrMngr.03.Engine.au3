#Region ƒŒ¡¿¬À≈Õ»≈ —“–Œ 
Func _AddStr_10()
   $FO[0] = FileOpen($File[0], 32)
   If $FO[0] = -1 Then
	  _AddStr_11()
	  Return
   EndIf
   $FO[3] = FileOpen($File[3], 2+32)
   $Bnd[0] = UBound($Msv)
   $Bnd[2] = 0
   $V = True
   For $i = 0 To $Bnd[0]-1
	  While True
		 If $V Then $WrStr = FileReadLine($FO[0])
			If @error = -1 Then
			   For $k = $i To $Bnd[0]-1
				  FileWriteLine($FO[3], $Msv[$k])
				  $Bnd[2] = $Bnd[2]+1
			   Next
			   ExitLoop 2
			EndIf
		 If $WrStr < $Msv[$i] Then
			FileWriteLine($FO[3], $WrStr)
			$Bnd[2] = $Bnd[2]+1
			$V = True
		 ElseIf $WrStr > $Msv[$i] Then
			FileWriteLine($FO[3], $Msv[$i])
			$Bnd[2] = $Bnd[2]+1
			$V = False
			ExitLoop
		 Else
			$V = True
		 EndIf
	  WEnd
   Next
   If Not $V Then
	  While True
		 FileWriteLine($FO[3], $WrStr)
		 $Bnd[2] = $Bnd[2]+1
		 $WrStr = FileReadLine($FO[0])
		 If @error = -1 Then ExitLoop
	  WEnd
   EndIf
   FileClose($FO[0])
   FileClose($FO[3])
   FileMove($File[3], $File[0], 1)
   $L[0] = True
EndFunc
Func _AddStr_11()
   $FO[0] = FileOpen($File[0], 2+32)
   $Bnd[0] = UBound($Msv)
   $Bnd[2] = $Bnd[0]
   For $i = 0 To $Bnd[0]-1
	  FileWriteLine($FO[0], $Msv[$i])
   Next
   FileClose($FO[0])
   $E[0] = True
   $L[0] = True
EndFunc
Func _AddStr_20()
   $FO[1] = FileOpen($File[1], 32)
   If $FO[1] = -1 Then
	  _AddStr_21()
	  Return
   EndIf
   $FO[5] = FileOpen($File[5], 2+32)
   $Bnd[1] = UBound($Msv)
   $Bnd[3] = 0
   $V = True
   For $i = 0 To $Bnd[1]-1
	  While True
		 If $V Then $WrStr = FileReadLine($FO[1])
		 If @error = -1 Then
			For $k = $i To $Bnd[1]-1
			   FileWriteLine($FO[5], $Msv[$k])
			   $Bnd[3] = $Bnd[3]+1
			Next
			ExitLoop 2
		 EndIf
		 If $WrStr < $Msv[$i] Then
			FileWriteLine($FO[5], $WrStr)
			$Bnd[3] = $Bnd[3]+1
			$V = True
		 ElseIf $WrStr > $Msv[$i] Then
			FileWriteLine($FO[5], $Msv[$i])
			$Bnd[3] = $Bnd[3]+1
			$V = False
			ExitLoop
		 Else
			$V = True
		 EndIf
	  WEnd
   Next
   If Not $V Then
	  While True
		 FileWriteLine($FO[5], $WrStr)
		 $Bnd[3] = $Bnd[3]+1
		 $WrStr = FileReadLine($FO[1])
		 If @error = -1 Then ExitLoop
	  WEnd
   EndIf
   FileClose($FO[1])
   FileClose($FO[5])
   FileMove($File[5], $File[1], 1)
   $L[1] = True
EndFunc
Func _AddStr_21()
   $FO[1] = FileOpen($File[1], 2+32)
   $Bnd[1] = UBound($Msv)
   $Bnd[3] = $Bnd[1]
   For $i = 0 To $Bnd[1]-1
	  FileWriteLine($FO[1], $Msv[$i])
   Next
   FileClose($FO[1])
   $E[1] = True
   $L[1] = True
EndFunc

Func _ArPrep(ByRef $Arr)
   $Bnd[0] = UBound($Arr)
   For $i = 0 To $Bnd[0]-1
	  If $Arr[$i] Then
		 For $Var In $Envir
			$CheckLoop = False
			$StrTmp = StringReplace($Arr[$i], EnvGet($Var), "::@" & $Var, 1)
			If @extended Then
			   $Arr[$i] = $StrTmp
			   $CheckLoop = True
			   ExitLoop
			EndIf
		 Next
		 If Not $CheckLoop Then
			$StrTmp = StringInStr($Arr[$i], ":", 0, 1)
			If $StrTmp Then
			   $StrTmp = StringTrimLeft($Arr[$i], $StrTmp)
			   $Arr[$i] = "::Drive_" & StringUpper(StringTrimRight($Arr[$i], StringLen($StrTmp)+1)) & $StrTmp
			Else
			   $Arr[$i] = ""
			EndIf
		 EndIf
	  EndIf
   Next
EndFunc

Func _AddBtnDis()
   GUICtrlSetState($Btn[2], $GUI_DISABLE)
   GUICtrlSetState($Btn[3], $GUI_DISABLE)
   GUICtrlSetState($Btn[4], $GUI_DISABLE)
EndFunc
Func _AddBtnEn()
   GUICtrlSetState($Btn[2], $GUI_ENABLE)
   GUICtrlSetState($Btn[3], $GUI_ENABLE)
   GUICtrlSetState($Btn[4], $GUI_ENABLE)
EndFunc
Func _AddBtnEn2()
   _AddBtnEn()
   GUICtrlSetData($Btn[4], $Text[14])
   $Chk = 3
EndFunc
#EndRegion

#Region ”ƒ¿À≈Õ»≈ —“–Œ 
Func _DelStr_1()
   $FO[4] = FileOpen($File[4], 2+32)
   $Q = 0
   $T = 0
   $CheckLoop = True
   For $i = 0 To $Bnd[2]-1
	  If ControlListView($Win[0], "", $LiVw[0], "IsSelected", $i) Then
		 $ReadStr = StringTrimLeft(_GUICtrlListView_GetItemText($LiVw[0], $i, 1), 2)
		 If StringInStr(FileGetAttrib($ReadStr), "D") Then
			If StringInStr(FileGetAttrib($ReadStr), "R") Then FileSetAttrib($ReadStr, "-R")
			If DirRemove($ReadStr) Then
			   $Q = $Q-1
			Else
			   FileWriteLine($FO[4], $ReadStr)
			   If $CheckLoop Then
				  $T = $i
				  $CheckLoop = False
			   EndIf
			EndIf
		 Else
			FileSetAttrib($ReadStr, "-R")
			If FileDelete($ReadStr) Or Not FileExists($ReadStr) Then
			   $Q = $Q-1
			Else
			   _GUICtrlListView_SetItemSelected($LiVw[0], $i, False)
			EndIf
		 EndIf
	  EndIf
   Next
   FileClose($FO[4])
   $FO[4] = FileOpen($File[4], 32)
   While $FO[4] <> -1
	  $ReadStr = FileReadLine($FO[4])
	  If @error = -1 Then ExitLoop
	  If FileExists($ReadStr) Then
		 $MsvTmp = DirGetSize($ReadStr, 1)
		 If $MsvTmp[1] = 0 Then
			If DirRemove($ReadStr, 1) Then
			   $Q = $Q-($MsvTmp[2]+1)
			Else
			   For $i = $T To $Bnd[2]-1
				  If _GUICtrlListView_GetItemText($LiVw[0], $i, 1) = "::" & $ReadStr Then
					 _GUICtrlListView_SetItemSelected($LiVw[0], $i, False)
					 $T = $i
					 ExitLoop
				  EndIf
			   Next
			EndIf
		 Else
			For $i = $T To $Bnd[2]-1
			   If _GUICtrlListView_GetItemText($LiVw[0], $i, 1) = "::" & $ReadStr Then
				  _GUICtrlListView_SetItemSelected($LiVw[0], $i, False)
				  $T = $i
				  ExitLoop
			   EndIf
			Next
		 EndIf
	  EndIf
   WEnd
   FileClose($FO[4])
   $FO[3] = FileOpen($File[3], 2+32)
   For $i = 0 To $Bnd[2]-1
	  If Not ControlListView($Win[0], "", $LiVw[0], "IsSelected", $i) Then
		 FileWriteLine($FO[3], _GUICtrlListView_GetItemText($LiVw[0], $i, 1))
	  EndIf
   Next
   _GUICtrlListView_DeleteItemsSelected($LiVw[0])
   FileClose($FO[3])
   FileMove($File[3], $File[0], 1)
   FileDelete($File[4])
   $L[0] = True
   $Bnd[2] = $Bnd[2]+$Q
   If $Bnd[2] = 0 Then
	  FileDelete($File[0])
	  $E[0] = False
	  $Bnd[2] = Null
   EndIf
EndFunc
Func _DelStr_2()
   $FO[5] = FileOpen($File[5], 2+32)
   $Q = 0
   For $i = 0 To $Bnd[3]-1
	  If Not ControlListView($Win[0], "", $LiVw[1], "IsSelected", $i) Then
		 $ReadStr = _GUICtrlListView_GetItemText($LiVw[1], $i, 1)
		 FileWriteLine($FO[5], $ReadStr)
	  Else
		 $Q = $Q-1
	  EndIf
   Next
   _GUICtrlListView_DeleteItemsSelected($LiVw[1])
   FileClose($FO[5])
   FileMove($File[5], $File[1], 1)
   $L[1] = True
   $Bnd[3] = $Bnd[3]+$Q
   If $Bnd[3] = 0 Then
	  FileDelete($File[1])
	  $E[1] = False
	  $Bnd[3] = Null
   EndIf
EndFunc

Func _DelGUI_1()
   If $L[0] And $E[0] Then
	  GUICtrlSendMsg($LiVw[0], $LVM_DELETEALLITEMS, 0, 0)
	  GUICtrlSetState($LiVw[0], $GUI_DISABLE)
	  GUICtrlSetState($Btn[1], $GUI_DISABLE)
	  _DelBtnDis()
	  $Q = 0
	  $FO[0] = FileOpen($File[0], 32)
	  If $FO[0] = -1 Then Return
	  While True
		 $ReadStr = FileReadLine($FO[0])
		 If @error = -1 Then ExitLoop
		 $Q = $Q+1
		 _GUICtrlListView_InsertItem($LiVw[0], $Q, -1)
		 _GUICtrlListView_AddSubItem($LiVw[0], $Q-1, $ReadStr, 1)
		 If Int(Log($Q)/Log(10)) <> Int(Log($Q-1)/Log(10)) Then
			GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
			GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
		 EndIf
		 If Mod($Q, 151) = 0 Then GUICtrlSendMsg($LiVw[0], $LVM_SCROLL, 0, 3*151*$Sc)
	  WEnd
	  GUICtrlSendMsg($LiVw[0], $LVM_SCROLL, 0, -3*$Q*$Sc)
	  FileClose($FO[0])
	  $Bnd[2] = $Q
	  $L[0] = False
	  GUICtrlSetState($LiVw[0], $GUI_ENABLE+$GUI_FOCUS)
	  GUICtrlSetState($Btn[1], $GUI_ENABLE)
	  _DelBtnEn()
   ElseIf $L[0] And Not $E[0] Then
	  GUICtrlSendMsg($LiVw[0], $LVM_DELETEALLITEMS, 0, 0)
	  GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
	  GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
	  $Bnd[2] = Null
	  $L[0] = False
   EndIf
EndFunc
Func _DelGUI_2()
   If $L[1] And $E[1] Then
	  GUICtrlSendMsg($LiVw[1], $LVM_DELETEALLITEMS, 0, 0)
	  GUICtrlSetState($LiVw[1], $GUI_DISABLE)
	  GUICtrlSetState($Btn[0], $GUI_DISABLE)
	  _DelBtnDis()
	  $Q = 0
	  $FO[1] = FileOpen($File[1], 32)
	  If $FO[1] = -1 Then Return
	  While True
		 $ReadStr = FileReadLine($FO[1])
		 If @error = -1 Then ExitLoop
		 $Q = $Q+1
		 _GUICtrlListView_InsertItem($LiVw[1], $Q, -1)
		 _GUICtrlListView_AddSubItem($LiVw[1], $Q-1, $ReadStr, 1)
		 If Int(Log($Q)/Log(10)) <> Int(Log($Q-1)/Log(10)) Then
			GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
			GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
		 EndIf
		 If Mod($Q, 151) = 0 Then GUICtrlSendMsg($LiVw[1], $LVM_SCROLL, 0, 3*151*$Sc)
	  WEnd
	  GUICtrlSendMsg($LiVw[1], $LVM_SCROLL, 0, -3*$Q*$Sc)
	  FileClose($FO[1])
	  $Bnd[3] = $Q
	  $L[1] = False
	  GUICtrlSetState($LiVw[1], $GUI_ENABLE+$GUI_FOCUS)
	  GUICtrlSetState($Btn[0], $GUI_ENABLE)
	  _DelBtnEn()
   ElseIf $L[1] And Not $E[1] Then
	  GUICtrlSendMsg($LiVw[1], $LVM_DELETEALLITEMS, 0, 0)
	  GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
	  GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
	  $Bnd[3] = Null
	  $L[1] = False
   EndIf
EndFunc

Func _DelBtnDis()
   GUICtrlSetState($Btn[2], $GUI_DISABLE)
   GUICtrlSetState($Btn[4], $GUI_DISABLE)
   GUICtrlSetState($Btn[5], $GUI_DISABLE)
EndFunc
Func _DelBtnEn()
   GUICtrlSetState($Btn[2], $GUI_ENABLE)
   GUICtrlSetState($Btn[4], $GUI_ENABLE)
   GUICtrlSetState($Btn[5], $GUI_ENABLE)
EndFunc
Func _DelBtnEn2()
   _DelBtnEn()
   GUICtrlSetData($Btn[4], $Text[14])
   $Chk = 3
EndFunc
#EndRegion

#Region ”œ–¿¬À≈Õ»≈ —œ»— ¿Ã» ƒ¿ÕÕ€’ –≈≈—“–¿
Func _RegDel()
   $FO[1] = FileOpen($File[1], 32)
   If $FO[1] = -1 Then
	  FileDelete($File[2])
	  Return
   EndIf
   $FO[2] = FileOpen($File[2], 32)
   If $FO[2] = -1 Then
	  FileClose($FO[1])
	  Return
   Else
	  $V = False
   EndIf
   $FO[6] = FileOpen($File[6], 2+32)
   $CheckLoop = True
   While True
	  $ReadStr = FileReadLine($FO[1])
	  If @error = -1 Then ExitLoop
	  While True
		 If $CheckLoop Then $WrStr = FileReadLine($FO[2])
		 If @error = -1 Then ExitLoop 2
		 If Not StringInStr($WrStr, "[", 0, 1, 1, 1) Then
			If $V Then FileWriteLine($FO[6], $WrStr)
		 Else
			If StringTrimRight(StringTrimLeft($WrStr, 1), 1) < $ReadStr Then
			   $CheckLoop = True
			   $V = False
			ElseIf StringTrimRight(StringTrimLeft($WrStr, 1), 1) > $ReadStr Then
			   $CheckLoop = False
			   ExitLoop
			Else
			   FileWriteLine($FO[6], $WrStr)
			   $CheckLoop = True
			   $V = True
			EndIf
		 EndIf
	  WEnd
   WEnd
   For $i = 0 To 1
	  FileClose($FO[2])
	  FileClose($FO[6])
	  FileMove($File[6], $File[2], 1)
   Next
   If FileGetSize($File[3]) <= 2 Then FileDelete($File[3])
   FileClose($FO[1])
EndFunc
#EndRegion

#Region –¿¡Œ“¿ — œŒƒ—“–Œ ¿Ã»
Func _AddSbFldr()
   $StrTmp = "[::]"
   $Bnd[0] = UBound($Msv)
   For $i = 0 To $Bnd[0]-1
	  If Not StringInStr($Msv[$i], $StrTmp & "\") Then
		 $StrTmp = $Msv[$i]
		 _SbFldr($StrTmp)
	  EndIf
   Next
   $FO[3] = FileOpen($File[3], 32)
   GUICtrlSetData($Edit[0], FileRead($FO[3]), "")
   FileClose($FO[3])
   FileDelete($File[3])
EndFunc
Func _RegAddSbK()
   $StrTmp = "[::]"
   $FO[5] = FileOpen($File[5], 2+32)
   $Bnd[1] = UBound($Msv)
   For $i = 0 To $Bnd[1]-1
	  If Not StringInStr($Msv[$i], $StrTmp & "\") Then
		 $StrTmp = $Msv[$i]
		 _RegSbK($Msv[$i])
	  EndIf
   Next
   FileClose($FO[5])
   $FO[5] = FileOpen($File[5], 32)
   GUICtrlSetData($Edit[1], FileRead($FO[5]), "")
   FileClose($FO[5])
   FileDelete($File[5])
EndFunc

Func _DelSbStr($n)
   $StrTmp = "[::]"
   For $i = 0 To $Bnd[$n+2]-1
	  $ReadStr = _GUICtrlListView_GetItemText($LiVw[$n], $i, 1)
	  If ControlListView($Win[0], "", $LiVw[$n], "IsSelected", $i) Then
		 $StrTmp = _GUICtrlListView_GetItemText($LiVw[$n], $i, 1)
	  ElseIf StringInStr($ReadStr, $StrTmp & "\") Then
		 ControlListView($Win[0], "", $LiVw[$n], "Select", $i, $i)
	  EndIf
   Next
EndFunc

Func _SbFldr($ReadStr)
   If StringInStr(FileGetAttrib($ReadStr), "D") Then
	  $FO[3] = FileOpen($File[3], 1+32)
	  FileWriteLine($FO[3], $ReadStr)
	  FileClose($FO[3])
	  RunWait(@ComSpec & " /U /C DIR """ & $ReadStr & """ /A /B /S >> " & $File[3], "", @SW_HIDE)
   Else
	  $FO[3] = FileOpen($File[3], 1+32)
	  FileWriteLine($FO[3], $ReadStr)
	  FileClose($FO[3])
   EndIf
EndFunc
Func _RegSbK($ReadStr)
   $CheckLoop = True
   $T = "1"
   $s = 1
   FileWriteLine($FO[5], $ReadStr)
   While True
	  While $CheckLoop
		 $T = $T & "\1"
		 $StrDeep = RegEnumKey($ReadStr, 1)
		 If @error Then ExitLoop
		 $ReadStr = $ReadStr & "\" & $StrDeep
		 FileWriteLine($FO[5], $ReadStr)
	  WEnd
	  $T = StringLeft($T, StringInStr($T, "\", 0, -1)-1)
	  If $T = "1" Then ExitLoop
	  $ReadStr = StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)-1)
	  $s = StringTrimLeft($T, StringInStr($T, "\", 0, -1))+1
	  $T = StringLeft($T, StringInStr($T, "\", 0, -1)-1) & "\" & $s
	  $EnumStr = RegEnumKey($ReadStr, $s)
	  If Not @error Then
		 $ReadStr = $ReadStr & "\" & $EnumStr
		 $CheckLoop = True
		 FileWriteLine($FO[5], $ReadStr)
	  Else
		 $CheckLoop = False
	  EndIf
   WEnd
EndFunc
#EndRegion

#Region œ–Œ◊≈≈
Func _DelNonExst()
   If ControlCommand($Win[1], "", $ChkBox[0], "IsChecked", "") And FileGetSize($File[0]) > 2 Then
	  $FO[0] = FileOpen($File[0], 32)
	  $FO[3] = FileOpen($File[3], 2+32)
	  $Bnd[2] = 0
	  While True
		 $StrTmp = FileReadLine($FO[0])
		 If @error = -1 Then ExitLoop
		 For $Var In $Envir
			$CheckLoop = False
			$ReadStr = StringReplace($StrTmp, "::@" & $Var, EnvGet($Var), 1)
			If @extended Then
			   $CheckLoop = True
			   If FileExists($ReadStr) Then
				  FileWriteLine($FO[3], $StrTmp)
				  $Bnd[2] = $Bnd[2]+1
			   EndIf
			   ExitLoop
			EndIf
		 Next
		 If Not $CheckLoop Then
			$ReadStr = StringReplace(StringTrimLeft($StrTmp, 8), "\", ":\", 1)
			If FileExists($ReadStr) Then
			   FileWriteLine($FO[3], $StrTmp)
			   $Bnd[2] = $Bnd[2]+1
			EndIf
		 EndIf
	  WEnd
	  FileClose($FO[0])
	  FileClose($FO[3])
	  FileMove($File[3], $File[0], 1)
	  If FileGetSize($File[0]) > 2 Then
		 $E[0] = True
	  Else
		 $E[0] = False
		 FileDelete($File[0])
		 $Bnd[2] = Null
	  EndIf
	  $L[0] = True
   EndIf
   If ControlCommand($Win[1], "", $ChkBox[1], "IsChecked", "") And FileGetSize($File[1]) > 2 Then
	  $FO[1] = FileOpen($File[1], 32)
	  $FO[5] = FileOpen($File[5], 2+32)
	  $Bnd[3] = 0
	  While True
		 $ReadStr = FileReadLine($FO[1])
		 If @error = -1 Then ExitLoop
		 RegRead($ReadStr, "")
		 If @error <> 1 And @error <> 2 And @error <> 3 Then
			FileWriteLine($FO[5], $ReadStr)
			$Bnd[3] = $Bnd[3]+1
		 EndIf
	  WEnd
	  FileClose($FO[1])
	  FileClose($FO[5])
	  FileMove($File[5], $File[1], 1)
	  If FileGetSize($File[1]) > 2 Then
		 $E[1] = True
	  Else
		 FileDelete($File[1])
		 $E[1] = False
		 $Bnd[3] = Null
	  EndIf
	  $L[1] = True
   EndIf
   If ControlCommand($Win[1], "", $ChkBox[2], "IsChecked", "") And FileGetSize($File[2]) > 2 Then
	  $V = True
	  $FO[2] = FileOpen($File[2], 32)
	  $FO[6] = FileOpen($File[6], 2+32)
	  While True
		 $ReadStr = FileReadLine($FO[2])
		 If @error = -1 Then ExitLoop
		 If StringInStr($ReadStr, "[", 0, 1, 1, 1) Then
			$V = False
			RegRead(StringTrimRight(StringTrimLeft($ReadStr, 1), 1), "")
			If @error <> 1 And @error <> 2 And @error <> 3 Then $V = True
		 EndIf
		 If $V Then FileWriteLine($FO[6], $ReadStr)
	  WEnd
	  FileClose($FO[2])
	  FileClose($FO[6])
	  FileMove($File[6], $File[2], 1)
	  If FileGetSize($File[2]) <= 2 Then FileDelete($File[2])
   EndIf
   If ControlCommand($Win[1], "", $ChkBox[3], "IsChecked", "") Then
	  RunWait(@ComSpec & ' /U /C DIR "' & @ScriptDir & '" /A:D /B /S > ' & $File[4], "", @SW_HIDE)
	  Sleep(50)
	  $FO[4] = FileOpen($File[4], 32)
	  While True
		 $ReadStr = FileReadLine($FO[4])
		 If @error = -1 Then ExitLoop
		 $MsvTmp = DirGetSize($ReadStr, 1)
		 If FileExists($ReadStr) And IsArray($MsvTmp) And $MsvTmp[1] = 0 Then
			DirRemove($ReadStr, 1)
		 EndIf
	  WEnd
	  FileClose($FO[4])
	  FileDelete($File[4])
   EndIf
EndFunc

Func _ArDuplCut(ByRef $Arr)
   Local $Bnd = UBound($Arr)-1
   If $Bnd > 0 Then
	  Local $ArrTmp[$Bnd+1], $L = 0

	  $ArrTmp[0] = $Arr[0]
	  For $i = 0 To $Bnd-1
		 If $Arr[$i] <> $Arr[$i+1] Then
			$ArrTmp[$i+1] = $Arr[$i+1]
		 EndIf
		 $Arr[$i] = Null
	  Next
	  $Arr[$Bnd] = Null

	  For $i = 0 To $Bnd
		 If $ArrTmp[$i] Then
			$Arr[$L] = $ArrTmp[$i]
			$L = $L+1
		 EndIf
	  Next
	  ReDim $Arr[$L]
   EndIf
EndFunc

Func _OpnNtpd($Path, $Line)
   $Path = StringTrimRight($Path, 4)
   If Not ProcessExists($RunProc) Then
	  $RunProc = Run('notepad.exe "' & $ScriptDir & $Path & '.ini"', "", @SW_MAXIMIZE)
	  While True
		 $Proc = WinList()
		 $ProcChld = _WinAPI_EnumChildProcess($RunProc)
		 If Not IsArray($ProcChld) Then
			For $j = 0 To $Proc[0][0]
			   If IsHWnd($Proc[$j][1]) And WinGetProcess($Proc[$j][1]) = $RunProc Then
				  $ClassList = StringSplit(WinGetClassList($Proc[$j][1]), @CRLF)
				  For $k = 0 To $ClassList[0]
					 If StringInStr($ClassList[$k], "edit") Then
						$WindHwnd = $Proc[$j][1]
						ExitLoop 3
					 EndIf
				  Next
			   EndIf
			Next
		 Else
			For $i = 1 To $ProcChld[0][0]
			   For $j = 0 To $Proc[0][0]
				  If IsHWnd($Proc[$j][1]) And WinGetProcess($Proc[$j][1]) = $ProcChld[$i][0] Then
					 $ClassList = StringSplit(WinGetClassList($Proc[$j][1]), @CRLF)
					 For $k = 0 To $ClassList[0]
						If StringInStr($ClassList[$k], "edit") Then
						   $WindHwnd = $Proc[$j][1]
						   ExitLoop 4
						EndIf
					 Next
				  EndIf
			   Next
			Next
		 EndIf
		 Sleep(100)
	  WEnd
	  _SelTxt($WindHwnd, $ScriptDir & $Path & ".ini", $Line)
   Else
	  If $WindHwnd And StringInStr(WinGetTitle($WindHwnd), $Path) Then
		 _SelTxt($WindHwnd, $ScriptDir & $Path & ".ini", $Line)
	  EndIf
   EndIf
EndFunc

Func _SelTxt($WHwnd, $FPt, $PassStr)
   Local $FO = FileOpen($FPt, 32), $Control, $Pos, $TextStr, $Cntr = 0
   While $FO <> -1
	  $TextStr = FileReadLine($FO)
	  If @error = -1 Then
		 FileClose($FO)
		 Return
	  EndIf
	  If StringInStr($TextStr, $PassStr) Then ExitLoop
	  $Cntr = $Cntr+1
   WEnd
   WinActivate($WHwnd)
   If WinGetTitle("[CLASS:Notepad]") Then $Cntr = 0
   $Pos = FileGetPos($FO)/2-StringLen($TextStr)-$Cntr-2
   $Control = ControlGetFocus($WHwnd)
   $Control = ControlGetHandle($WHwnd, "", $Control)
   _GUICtrlEdit_SetSel($Control, $Pos, $Pos+StringLen($PassStr))
   _GUICtrlEdit_Scroll($Control, $SB_PAGEDOWN)
   _GUICtrlEdit_Scroll($Control, $SB_SCROLLCARET)
   For $i = 0 To 1
	  _GUICtrlEdit_Scroll($Control, $SB_LINEUP)
   Next
   _GUICtrlEdit_Scroll($Control, $SB_SCROLLCARET)
   FileClose($FO)
EndFunc

Func TxtUp()
   $Sc = $Sc+1
   For $i = 0 To 1
	  GUICtrlSetFont($Edit[$i], $Sc+0.5, 400, 0, $EditTxt)
	  GUICtrlSetFont($LiVw[$i], $Sc, 400, 0, $LiVwTxt)
	  GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
	  GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
   Next
EndFunc

Func TxtDwn()
   $Sc = $Sc-1
   For $i = 0 To 1
	  GUICtrlSetFont($Edit[$i], $Sc+0.5, 400, 0, $EditTxt)
	  GUICtrlSetFont($LiVw[$i], $Sc, 400, 0, $LiVwTxt)
	  GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
	  GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
   Next
EndFunc
#EndRegion
