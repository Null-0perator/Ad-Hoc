$Win[0] = GUICreate($Text[0], $WinWidth[0], $WinHeight[0], Default, Default, $WinSty[0], $WinSty[1])
GUISetBkColor($WinColr, $Win[0])

#Region ¡ÀŒ » “≈ —“¿
For $i = 0 To 3
   $Blk[$i] = GUICtrlCreateLabel($Text[$i+2], $BlkLeft[0], $BlkTop[0], $BlkWidth[0], $BlkHeight[0])
   GUICtrlSetFont($Blk[$i], $BlkTxtSz, 400, 0, $BlkTxt)
   GUICtrlSetResizing($Blk[$i], BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKMENUBAR))
Next
For $i = 1 To 3
   GUICtrlSetState($Blk[$i], $GUI_HIDE)
Next
#EndRegion

#Region œŒÀ≈ ¬¬Œƒ¿
For $i = 0 To 1
   $Edit[$i] = GUICtrlCreateEdit("", $EditLeft, $EditTop, $EditWidth, $EditHeight, $EditSty[0], $EditSty[1])
   GUICtrlSendMsg($Edit[$i], $EM_LIMITTEXT, -1, 0)
   GUICtrlSetFont($Edit[$i], $EditTxtSz, 400, 0, $EditTxt)
   GUICtrlSetResizing($Edit[$i], $GUI_DOCKBORDERS)
Next
GUICtrlSetState($Edit[0], $GUI_DROPACCEPTED)
#EndRegion

#Region ¬€¡Œ– ›À≈Ã≈Õ“Œ¬
For $i = 0 To 1
   $LiVw[$i] = GUICtrlCreateListView(" | ", $EditLeft, $EditTop, $EditWidth, $EditHeight, $LiVwSty[0], $LiVwSty[1])
   GUICtrlSetResizing($LiVw[$i], $GUI_DOCKBORDERS)
   GUICtrlSetFont($LiVw[$i], $LiVwTxtSz, 400, 0, $LiVwTxt)
   GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
   GUICtrlSendMsg($LiVw[$i], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
   _GUICtrlListView_JustifyColumn($LiVw[$i], 0, 2)
   GUICtrlSetState($LiVw[$i], $GUI_HIDE)
Next
#EndRegion

#Region  ÕŒœ »
For $i = 0 To 1
   $Btn[$i] = GUICtrlCreateButton($Text[$i+7], $BtnLeft[$i], $BtnTop[0], $BtnWidth[0], $BtnHeight[0])
Next
For $i = 2 To 4
   $Btn[$i] = GUICtrlCreateButton($Text[$i+7], $BtnLeft[$i], $BtnTop[0], $BtnWidth[1], $BtnHeight[0])
Next
$Btn[5] = GUICtrlCreateButton($Text[12], $BtnLeft[3], $BtnTop[0], $BtnWidth[1], $BtnHeight[0])
GUICtrlSetState($Btn[5], $GUI_HIDE)
For $i = 0 To 5
   GUICtrlSetFont($Btn[$i], $BtnTxtSz, 400, 0, $BtnTxt)
   GUICtrlSetResizing($Btn[$i], $GUI_DOCKSTATEBAR)
Next
GUICtrlSetState($Btn[0], $GUI_DISABLE)
#EndRegion

#Region  ŒÕ“≈ —“ÕŒ≈ Ã≈Õﬁ
$CntxtMen[0] = GUICtrlCreateContextMenu($Btn[4])
$Cntxt[0] = GUICtrlCreateMenuItem($StrCntxt[0], $CntxtMen[0])
$CntxtMen[1] = GUICtrlCreateContextMenu($LiVw[1])
$Cntxt[1] = GUICtrlCreateMenuItem($StrCntxt[2], $CntxtMen[1])
#EndRegion

GUICtrlSetState($Edit[1], $GUI_HIDE)
GUICtrlSetTip($Btn[0], $TlTp[0])
GUICtrlSetTip($Btn[1], $TlTp[1])

GUISetState(@SW_SHOW, $Win[0])

If (FileGetSize($File[0])+FileGetSize($File[1]))/1048576 > 10 Then
   GUICtrlSetState($Blk[0], $GUI_DISABLE)
   GUICtrlSetState($Edit[0], $GUI_DISABLE)
   GUICtrlSetState($Btn[1], $GUI_DISABLE)
   For $i = 2 To 4
	  GUICtrlSetState($Btn[$i], $GUI_DISABLE)
   Next
EndIf
For $i = 0 To 1
   $FO[$i] = FileOpen($File[$i], 32)
   If $FO[$i] <> -1 Then
	  $E[$i] = True
	  $Q = 0
	  While True
		 FileReadLine($FO[$i])
		 If @error = -1 Then ExitLoop
		 $Q = $Q+1
	  WEnd
	  FileClose($FO[$i])
	  $Bnd[$i+2] = $Q
   Else
	  $Bnd[$i+2] = Null
   EndIf
Next
If (FileGetSize($File[0])+FileGetSize($File[1]))/1048576 > 10 Then
   GUICtrlSetState($Blk[0], $GUI_ENABLE)
   GUICtrlSetState($Edit[0], $GUI_ENABLE)
   GUICtrlSetState($Btn[1], $GUI_ENABLE)
   For $i = 2 To 4
	  GUICtrlSetState($Btn[$i], $GUI_ENABLE)
   Next
EndIf

Func _DelNExGUI()
   $Win[1] = GUICreate($Text[1], $WinWidth[1], $WinHeight[1], Default, Default, $WinSty[2], $WinSty[3], $Win[0])
   GUISetBkColor($WinColr, $Win[1])

   #Region ¡ÀŒ » “≈ —“¿
   $Blk[4] = GUICtrlCreateLabel($Text[6], $BlkLeft[1], $BlkTop[1], $BlkWidth[1], $BlkHeight[1])
   GUICtrlSetFont($Blk[4], $BlkTxtSz, 400, 0, $BlkTxt)
   #EndRegion

   #Region –¿«ƒ≈À»“≈À»
   For $i = 0 To 1
	  $Sep[$i] = GUICtrlCreateLabel("", $SepLeft, $SepTop[$i], $SepWidth, $SepHeight, $SepSty)
	  GUICtrlSetBkColor($Sep[$i], $SepColr)
   Next
   #EndRegion

   #Region œ≈–≈ Àﬁ◊¿“≈À» — ÃÕŒ∆≈—“¬ŒÃ ¬€¡Œ–Œ¬
   For $i = 0 To 2
	  $ChkBox[$i] = GUICtrlCreateCheckbox($StrChk[$i], $ChkLeft[$i], $ChkTop[$i], $ChkWidth[0], $ChkHeight)
	  GUICtrlSetFont($ChkBox[$i], $ChkTxtSz, 400, 0, $ChkTxt)
   Next
   $ChkBox[3] = GUICtrlCreateCheckbox($StrChk[3], $ChkLeft[3], $ChkTop[3], $ChkWidth[1], $ChkHeight)
   GUICtrlSetFont($ChkBox[3], $ChkTxtSz, 400, 0, $ChkTxt)
   GUICtrlSetState($ChkBox[3], $GUI_CHECKED)
   #EndRegion

   #Region  ÕŒœ »
   For $i = 0 To 1
	  $Btn[$i+6] = GUICtrlCreateButton($Text[$i+13], $BtnLeft[5], $BtnTop[1], $BtnWidth[1], $BtnHeight[1])
	  GUICtrlSetFont($Btn[$i+6], $BtnTxtSz, 400, 0, $BtnTxt)
   Next
   GUICtrlSetState($Btn[7], $GUI_HIDE)
   #EndRegion

   GUISetState(@SW_SHOW, $Win[1])
   GUISetState(@SW_DISABLE, $Win[0])

   While True
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			GUISetState(@SW_ENABLE, $Win[0])
			GUIDelete($Win[1])
			WinActivate($Win[0])
			If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($Edit[0], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($LiVw[0], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($Edit[1], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($LiVw[1], $GUI_FOCUS)
			EndIf
			ExitLoop
		 Case $Btn[6]
			GUICtrlSetState($Btn[6], $GUI_DISABLE)
			_DelNonExst()
			GUICtrlSetState($Btn[6], $GUI_HIDE)
			GUICtrlSetState($Btn[7], $GUI_SHOW)
		 Case $Btn[7]
			GUISetState(@SW_ENABLE, $Win[0])
			GUIDelete($Win[1])
			WinActivate($Win[0])
			If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($Edit[0], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($LiVw[0], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($Edit[1], $GUI_FOCUS)
			ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			   GUICtrlSetState($LiVw[1], $GUI_FOCUS)
			EndIf
			ExitLoop
		 Case $ChkBox[0], $ChkBox[1], $ChkBox[2]
			GUICtrlSetState($ChkBox[3], $GUI_UNCHECKED)
		 Case $ChkBox[3]
			For $i = 0 To 2
			   GUICtrlSetState($ChkBox[$i], $GUI_UNCHECKED)
			Next
	  EndSwitch
   WEnd
EndFunc
