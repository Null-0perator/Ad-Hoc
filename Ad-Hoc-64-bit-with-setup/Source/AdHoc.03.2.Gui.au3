Func _Wind_1()
   Local $CntxtMen, $CntxtDr[5], $ChkLp = False, $CmbData = ""

   $Win[1] = GUICreate($StrWin[1], $WinWidth[1], $WinHeight[1], Default, Default, $WinSty[1], Default, $WinParnt[1])
   GUISetBkColor($WinColr, $Win[1])

   #Region акнйх рейярю
   For $i = 0 To 1
	  $Blk[$i+12] = GUICtrlCreateLabel($StrBlk[$i+12], $BlkLeft[$i+12], $BlkTop[$i+12], $BlkWidth[$i+12], $BlkHeight[$i+12], $BlkSty[$i])
	  GUICtrlSetFont($Blk[$i+12], $BlkTxtSz[1], 400, 0, $BlkTxt[1])
   Next
   #EndRegion

   #Region цпсоош щкелемрнб
   $Grp[3] = GUICtrlCreateGroup($StrGrp[3], $GrpLeft[3], $GrpTop[3], $GrpWidth[3], $GrpHeight[3], $GrpSty[3])
   GUICtrlSetFont($Grp[3], $GrpTxtSz, 400, 0, $GrpTxt)
   #EndRegion

   #Region бшанп щкелемрнб
   $LiVw[1] = GUICtrlCreateListView($StrLiVw[1], $LiVwLeft[1], $LiVwTop[1], $LiVwWidth[1], $LiVwHeight[1], $LiVwSty[0], $LiVwSty[1])
   For $i = 0 To 1
	  GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, $i, $LiVwColWd[$i])
   Next

   $VarDr[0] = GUICtrlCreateListViewItem($DrLst[1] & "\" & "|" & Round(DriveSpaceTotal($DrLst[1] & "\")/1024, 1) & $StrUnitInf, $LiVw[1])
   $VarDr[1] = $VarDr[0]
   For $i = 2 To $DrLst[0]
	  $VarDr[1] = GUICtrlCreateListViewItem($DrLst[$i] & "\" & "|" & Round(DriveSpaceTotal($DrLst[$i] & "\")/1024, 1) & $StrUnitInf, $LiVw[1])
   Next
   #EndRegion

   #Region йнмрейярмне лемч
   $CntxtMen = GUICtrlCreateContextMenu($LiVw[1])

   For $i = 0 To 4
	  $CntxtDr[$i] = GUICtrlCreateMenuItem($StrCntxt[$i], $CntxtMen)
   Next
   #EndRegion

   #Region оепейкчвюрекх я лмнфеярбнл бшанпнб
   For $i = 0 To 1
	  $ChkBox[$i] = GUICtrlCreateCheckbox($StrChk[$i], $ChkLeft[$i], $ChkTop[$i], $ChkWidth[$i], $ChkHeight[$i])
	  GUICtrlSetFont($ChkBox[$i], $ChkTxtSz, 400, 0, $ChkTxt)
   Next
   #EndRegion

   #Region яохянй щкелемрнб
   $Combo = GUICtrlCreateCombo("", $CmbLeft, $CmbTop, $CmbWidth, $CmbHeight, $CmbSty)
   For $i = 1 To $NumPr
	  $CmbData = $CmbData & " " & $i & "|"
   Next
   GUICtrlSetData($Combo, $CmbData, " " & $NumPr)
   #EndRegion

   #Region пюгдекхрекх
   $Sep[3] = GUICtrlCreateLabel("", $SepLeft[3], $SepTop[3], $SepWidth[3], $SepHeight[3], $SepSty)
   GUICtrlSetBkColor($Sep[3], $SepColr)
   #EndRegion

   #Region ймнойх
   $CancBtn[2] = GUICtrlCreateButton($StrBtn[4], $BtnLeft[5], $BtnTop[5], $BtnWidth[5], $BtnHeight[5])
   GUICtrlSetFont($CancBtn[2], $BtnTxtSz[0], 400, 0, $BtnTxt)
   #EndRegion

   If Not $Chk[3] Then
	  $CmbTmp = _GUICtrlComboBox_GetItemHeight($Combo)+2*3
	  $BtnTmp = $CmbTmp+2*Int(($BtnHeight[0]-$CmbTmp)/2)
	  If $BtnTmp < $BtnHeight[0] Then $BtnTmp = $BtnTmp+2

	  $SepTop[3] = $WinHeight[1]-2*Int($WinHeight[1]/12.6)-2*Int($BtnTmp/2)+$BtnTmp-$SepHeight[0]
	  $BlkTop[13] = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int($CmbTmp/2)
	  $BlkHeight[13] = $CmbTmp
	  $CmbTop = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int($CmbTmp/2)
	  $ChkTop[2] = $WinHeight[1]-Int($WinHeight[1]/12.6)-$ChkHeight[0]
	  $BtnTop[5] = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int($BtnTmp/2)
	  $BtnHeight[5] = $BtnTmp

	  GUICtrlSetPos($Sep[3], $SepLeft[3], $SepTop[3], $SepWidth[3], $SepHeight[3])
	  GUICtrlSetPos($Blk[13], $BlkLeft[13], $BlkTop[13], $BlkWidth[13], $BlkHeight[13])
	  GUICtrlSetPos($Combo, $CmbLeft, $CmbTop, $CmbWidth, $CmbHeight)
	  GUICtrlSetPos($CancBtn[2], $BtnLeft[5], $BtnTop[5], $BtnWidth[5], $BtnHeight[5])

	  $Chk[3] = True
   EndIf

   _SettingsOpen()
   $IniVal = IniRead($File[1], "Miscellaneous", "CPU", "0")
   If Abs(Int($IniVal)) >= 1 And Abs(Int($IniVal)) <= $NumPr Then
	  GUICtrlSetData($Combo, " " & Abs(Int($IniVal)), " " & Abs(Int($IniVal)))
   Else
	  GUICtrlSetData($Combo, " " & $NumPr, " " & $NumPr)
   EndIf

   GUISetState(@SW_SHOW, $Win[1])
   GUISetState(@SW_DISABLE, $Win[0])

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[1] Then
			   GUISetState(@SW_ENABLE, $Win[0])
			   GUIDelete($Win[1])
			   GUISwitch($Win[0])
			   ExitLoop
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			EndIf
		 Case $CancBtn[2]
			For $i = $VarDr[0] To $VarDr[1]
			   If BitAND(GUICtrlRead($i, 1), $GUI_CHECKED) Then
				  $ChkLp = True
				  ExitLoop
			   EndIf
			Next
			If $ChkLp Then
			   _SettingsSave()
			   IniWrite($File[1], "Miscellaneous", "CPU", StringTrimLeft(GUICtrlRead($Combo), 1))
			   GUISetState(@SW_ENABLE, $Win[0])
			   GUIDelete($Win[1])
			   GUISwitch($Win[0])
			   ExitLoop
			EndIf
		 Case $CntxtDr[0]
			For $i = $VarDr[0] To $VarDr[1]
			   If ControlListView($Win[1], "", $LiVw[1], "IsSelected", $i-$VarDr[0]) Then
				  GUICtrlSetState($i, $GUI_CHECKED)
			   EndIf
			Next
		 Case $CntxtDr[1]
			For $i = $VarDr[0] To $VarDr[1]
			   If ControlListView($Win[1], "", $LiVw[1], "IsSelected", $i-$VarDr[0]) Then
				  GUICtrlSetState($i, $GUI_UNCHECKED)
			   EndIf
			Next
		 Case $CntxtDr[3]
			For $i = $VarDr[0] To $VarDr[1]
			   GUICtrlSetState($i, $GUI_CHECKED)
			Next
		 Case $CntxtDr[4]
			For $i = $VarDr[0] To $VarDr[1]
			   GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
	  EndSwitch
   WEnd
EndFunc

Func _Wind_2()
   Local $CntxtMen, $CntxtDr[5], $ChkLp = False

   $Win[2] = GUICreate($StrWin[1], $WinWidth[1], $WinHeight[1], Default, Default, $WinSty[1], Default, $WinParnt[1])
   GUISetBkColor($WinColr, $Win[2])

   #Region акнйх рейярю
   $Blk[12] = GUICtrlCreateLabel($StrBlk[12], $BlkLeft[12], $BlkTop[12], $BlkWidth[12], $BlkHeight[12], $BlkSty[0])
   GUICtrlSetFont($Blk[12], $BlkTxtSz[1], 400, 0, $BlkTxt[1])
   #EndRegion

   #Region цпсоош щкелемрнб
   $Grp[3] = GUICtrlCreateGroup($StrGrp[3], $GrpLeft[3], $GrpTop[3], $GrpWidth[3], $GrpHeight[3], $GrpSty[3])
   GUICtrlSetFont($Grp[3], $GrpTxtSz, 400, 0, $GrpTxt)
   #EndRegion

   #Region бшанп щкелемрнб
   $LiVw[1] = GUICtrlCreateListView($StrLiVw[1], $LiVwLeft[1], $LiVwTop[1], $LiVwWidth[1], $LiVwHeight[1], $LiVwSty[0], $LiVwSty[1])
   For $i = 0 To 1
	  GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, $i, $LiVwColWd[$i])
   Next

   $VarDr[0] = GUICtrlCreateListViewItem($DrLst[1] & "\" & "|" & Round(DriveSpaceTotal($DrLst[1] & "\")/1024, 1) & $StrUnitInf, $LiVw[1])
   $VarDr[1] = $VarDr[0]
   For $i = 2 To $DrLst[0]
	  $VarDr[1] = GUICtrlCreateListViewItem($DrLst[$i] & "\" & "|" & Round(DriveSpaceTotal($DrLst[$i] & "\")/1024, 1) & $StrUnitInf, $LiVw[1])
   Next
   #EndRegion

   #Region йнмрейярмне лемч
   $CntxtMen = GUICtrlCreateContextMenu($LiVw[1])

   For $i = 0 To 4
	  $CntxtDr[$i] = GUICtrlCreateMenuItem($StrCntxt[$i], $CntxtMen)
   Next
   #EndRegion

   #Region оепейкчвюрекх я лмнфеярбнл бшанпнб
   For $i = 0 To 2
	  $ChkBox[$i] = GUICtrlCreateCheckbox($StrChk[$i], $ChkLeft[$i], $ChkTop[$i], $ChkWidth[$i], $ChkHeight[$i])
	  GUICtrlSetFont($ChkBox[$i], $ChkTxtSz, 400, 0, $ChkTxt)
   Next
   GUICtrlSetStyle($ChkBox[2], $ChkSty)
   #EndRegion

   #Region пюгдекхрекх
   $Sep[3] = GUICtrlCreateLabel("", $SepLeft[3], $SepTop[3], $SepWidth[3], $SepHeight[3], $SepSty)
   GUICtrlSetBkColor($Sep[3], $SepColr)
   #EndRegion

   #Region ймнойх
   $CancBtn[2] = GUICtrlCreateButton($StrBtn[4], $BtnLeft[5], $BtnTop[5], $BtnWidth[5], $BtnHeight[5])
   GUICtrlSetFont($CancBtn[2], $BtnTxtSz[0], 400, 0, $BtnTxt)
   #EndRegion

   _SettingsOpen()
   $IniVal = IniRead($File[1], "CopyMove", "IsMove", "0")
   If $IniVal = "1" Then
	  GUICtrlSetState($ChkBox[2], $GUI_CHECKED)
   Else
	  GUICtrlSetState($ChkBox[2], $GUI_UNCHECKED)
   EndIf

   GUISetState(@SW_SHOW, $Win[2])
   GUISetState(@SW_DISABLE, $Win[0])

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[2] Then
			   GUISetState(@SW_ENABLE, $Win[0])
			   GUIDelete($Win[2])
			   GUISwitch($Win[0])
			   ExitLoop
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			EndIf
		 Case $CancBtn[2]
			For $i = $VarDr[0] To $VarDr[1]
			   If BitAND(GUICtrlRead($i, 1), $GUI_CHECKED) Then
				  $ChkLp = True
				  ExitLoop
			   EndIf
			Next
			If $ChkLp Then
			   _SettingsSave()
			   GUISetState(@SW_ENABLE, $Win[0])
			   GUIDelete($Win[2])
			   GUISwitch($Win[0])
			   ExitLoop
			EndIf
		 Case $CntxtDr[0]
			For $i = $VarDr[0] To $VarDr[1]
			   If ControlListView($Win[2], "", $LiVw[1], "IsSelected", $i-$VarDr[0]) Then
				  GUICtrlSetState($i, $GUI_CHECKED)
			   EndIf
			Next
		 Case $CntxtDr[1]
			For $i = $VarDr[0] To $VarDr[1]
			   If ControlListView($Win[2], "", $LiVw[1], "IsSelected", $i-$VarDr[0]) Then
				  GUICtrlSetState($i, $GUI_UNCHECKED)
			   EndIf
			Next
		 Case $CntxtDr[3]
			For $i = $VarDr[0] To $VarDr[1]
			   GUICtrlSetState($i, $GUI_CHECKED)
			Next
		 Case $CntxtDr[4]
			For $i = $VarDr[0] To $VarDr[1]
			   GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
	  EndSwitch
   WEnd
EndFunc
