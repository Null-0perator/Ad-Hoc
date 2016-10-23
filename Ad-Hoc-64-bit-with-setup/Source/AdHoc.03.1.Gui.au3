DirCreate($Dir[0])

#include "AdHoc.02.2.FileInstall.au3"

$Win[0] = GUICreate($StrWin[0], $WinWidth[0], $WinHeight[0], Default, Default, $WinSty[0], Default, $WinParnt[0])
GUISetBkColor($WinColr, $Win[0])

#include "AdHoc.03.2.Gui.au3"
#include "AdHoc.03.3.Gui.au3"
#include "AdHoc.03.4.Gui.au3"
#include "AdHoc.03.5.Gui.au3"

#Region –¿«ƒ≈À»“≈À»
For $i = 0 To 2
   $Sep[$i] = GUICtrlCreateLabel("", $SepLeft[$i], $SepTop[$i], $SepWidth[$i], $SepHeight[$i], $SepSty)
   GUICtrlSetBkColor($Sep[$i], $SepColr)
Next
GUICtrlSetState($Sep[0], $GUI_HIDE)
#EndRegion

#Region ¡ÀŒ » “≈ —“¿
$Blk[0] = GUICtrlCreateLabel($StrBlk[0], $BlkLeft[0], $BlkTop[0], $BlkWidth[0], $BlkHeight[0], $BlkSty[0])
GUICtrlSetBkColor($Blk[0], 0xf0f0f0)
GUICtrlSetState($Blk[0], $GUI_HIDE)
For $i = 1 To 11
   $Blk[$i] = GUICtrlCreateLabel($StrBlk[$i], $BlkLeft[$i], $BlkTop[$i], $BlkWidth[$i], $BlkHeight[$i], $BlkSty[0])
   GUICtrlSetFont($Blk[$i], $BlkTxtSz[1], 400, 0, $BlkTxt[1])
Next
For $i = 3 To 11
   GUICtrlSetState($Blk[$i], $GUI_HIDE)
Next
GUICtrlSetFont($Blk[1], $BlkTxtSz[0], 400, 0, $BlkTxt[0])
#EndRegion

#Region  ¿–“»Õ »
$Pic[0] = GUICtrlCreatePic($Dir[0] & "Pic" & 0 & ".jpg", $PicLeft[0], $PicTop[0], $PicWidth[0], $PicHeight[0])

_GDIPlus_Startup()
For $i = 1 To 8
   $Pic[$i] = _GDIPlus_ImageLoadFromFile($Dir[0] & "Pic" & $i & ".jpg")
   $ImRsz[$i] = _GDIPlus_ImageResize($Pic[$i], $PicWidth[1], $PicHeight[1], 6)
   $EncodID = _GDIPlus_EncodersGetCLSID("jpg")
   $PrmLst = _GDIPlus_ParamInit(1)
   $QualCreate = DllStructCreate("int Quality")
   DllStructSetData($QualCreate, "Quality", 100)
   $PntrStruc = DllStructGetPtr($QualCreate)
   _GDIPlus_ParamAdd($PrmLst, "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", 1, 4, $PntrStruc)
   _GDIPlus_ImageSaveToFileEx($ImRsz[$i], $Dir[0] & "Pic" & 10+$i & ".jpg", $EncodID, DllStructGetPtr($PrmLst))
   _GDIPlus_ImageDispose($Pic[$i])
Next
For $i = 0 To 1
   $Pic[17+$i] = _GDIPlus_ImageLoadFromFile($Dir[0] & "Pic" & 9 & ".jpg")
   $ImRsz[9+$i] = _GDIPlus_ImageResize($Pic[17+$i], $PicWidth[3+$i], $PicHeight[3+$i], 6)
   $EncodID = _GDIPlus_EncodersGetCLSID("jpg")
   $PrmLst = _GDIPlus_ParamInit(1)
   $QualCreate = DllStructCreate("int Quality")
   DllStructSetData($QualCreate, "Quality", 100)
   $PntrStruc = DllStructGetPtr($QualCreate)
   _GDIPlus_ParamAdd($PrmLst, "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", 1, 4, $PntrStruc)
   _GDIPlus_ImageSaveToFileEx($ImRsz[9+$i], $Dir[0] & "Pic" & 19+$i & ".jpg", $EncodID, DllStructGetPtr($PrmLst))
   _GDIPlus_ImageDispose($Pic[17+$i])
Next
_GDIPlus_Shutdown()

For $i = 1 To 8
   $Pic[$i] = GUICtrlCreatePic($Dir[0] & "Pic" & $i+10 & ".jpg", $PicLeft[1], $PicTop[1], $PicWidth[1], $PicHeight[1])
   $Pic[$i+8] = GUICtrlCreatePic($Dir[0] & "Pic" & $i+10 & ".jpg", $PicLeft[2], $PicTop[2], $PicWidth[2], $PicHeight[2])
   GUICtrlSetState($Pic[$i], $GUI_HIDE)
   GUICtrlSetState($Pic[$i+8], $GUI_HIDE)
Next
For $i = 0 To 1
   $Pic[17+$i] = GUICtrlCreatePic($Dir[0] & "Pic" & 19+$i & ".jpg", $PicLeft[3+$i], $PicTop[3+$i], $PicWidth[3+$i], $PicHeight[3+$i])
   GUICtrlSetState($Pic[17+$i], $GUI_HIDE)
Next
#EndRegion

#Region √–”œœ€ ›À≈Ã≈Õ“Œ¬
For $i = 0 To 2
   $Grp[$i] = GUICtrlCreateGroup($StrGrp[$i], $GrpLeft[$i], $GrpTop[$i], $GrpWidth[$i], $GrpHeight[$i], $GrpSty[$i])
   GUICtrlSetFont($Grp[$i], $GrpTxtSz, 400, 0, $GrpTxt)
   DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($Grp[$i]), "wstr", 0, "wstr", 0)
   GUICtrlSetColor($Grp[$i], 0x000000)
   GUICtrlSetState($Grp[$i], $GUI_HIDE)
Next
#EndRegion

#Region œ≈–≈ Àﬁ◊¿“≈À» — ŒƒÕ»Ã ¬€¡Œ–ŒÃ
For $i = 0 To 1
   $Rad[$i] = GUICtrlCreateRadio($StrRad[$i], $RadLeft[$i], $RadTop[$i], $RadWidth[$i], $RadHeight[$i])
   GUICtrlSetFont($Rad[$i], $RadTxtSz, 400, 0, $RadTxt)
   GUICtrlSetState($Rad[$i], $GUI_HIDE)
   GUICtrlSetTip($Rad[$i], $StrTlTp[$i])
Next
GUICtrlSetState($Rad[0], $GUI_CHECKED)

Func _RadRead_0()
   If GUICtrlRead($Rad[0]) = $GUI_CHECKED Then
	  GUICtrlSetState($NextBtn[2], $GUI_HIDE)
	  GUICtrlSetState($NextBtn[1], $GUI_SHOW)
   ElseIf GUICtrlRead($Rad[1]) = $GUI_CHECKED Then
	  GUICtrlSetState($NextBtn[1], $GUI_HIDE)
	  GUICtrlSetState($NextBtn[2], $GUI_SHOW)
   EndIf
EndFunc

Func _RadRead_1()
   If GUICtrlRead($Rad[0]) = $GUI_CHECKED Then
	  GUICtrlSetState($NextBtn[1], $GUI_HIDE)
   ElseIf GUICtrlRead($Rad[1]) = $GUI_CHECKED Then
	  GUICtrlSetState($NextBtn[2], $GUI_HIDE)
   EndIf
EndFunc

Func _RadRead_2()
   If GUICtrlRead($Rad[0]) = $GUI_CHECKED Then
	  GUICtrlSetState($Pic[2], $GUI_HIDE)
	  GUICtrlSetState($Pic[10], $GUI_HIDE)
	  GUICtrlSetState($Blk[4], $GUI_HIDE)
	  GUICtrlSetState($BackBtn[2], $GUI_HIDE)
   ElseIf GUICtrlRead($Rad[1]) = $GUI_CHECKED Then
	  GUICtrlSetState($Pic[1], $GUI_HIDE)
	  GUICtrlSetState($Pic[9], $GUI_HIDE)
	  GUICtrlSetState($Grp[0], $GUI_HIDE)
	  GUICtrlSetState($Rad[0], $GUI_HIDE)
	  GUICtrlSetState($Rad[1], $GUI_HIDE)
	  GUICtrlSetState($BackBtn[0], $GUI_HIDE)
   EndIf
EndFunc

Func _RadRead_3()
   If GUICtrlRead($Rad[0]) = $GUI_CHECKED Then
	  GUICtrlSetState($Pic[2], $GUI_SHOW)
	  GUICtrlSetState($Pic[10], $GUI_SHOW)
	  GUICtrlSetState($Blk[4], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[2], $GUI_SHOW)
   ElseIf GUICtrlRead($Rad[1]) = $GUI_CHECKED Then
	  GUICtrlSetState($Pic[1], $GUI_SHOW)
	  GUICtrlSetState($Pic[9], $GUI_SHOW)
	  GUICtrlSetState($Grp[0], $GUI_SHOW)
	  GUICtrlSetState($Rad[0], $GUI_SHOW)
	  GUICtrlSetState($Rad[1], $GUI_SHOW)
	  GUICtrlSetState($BackBtn[0], $GUI_SHOW)
   EndIf
EndFunc
#EndRegion

#Region œ≈–≈ Àﬁ◊¿“≈À» — ÃÕŒ∆≈—“¬ŒÃ ¬€¡Œ–Œ¬
$ChkBox[3] = GUICtrlCreateCheckbox($StrChk[3], $ChkLeft[3], $ChkTop[3], $ChkWidth[3], $ChkHeight[3])
GUICtrlSetFont($ChkBox[3], $ChkTxtSz, 400, 0, $ChkTxt)
GUICtrlSetTip($ChkBox[3], $StrTlTp[2])
GUICtrlSetState($ChkBox[3], $GUI_CHECKED)
GUICtrlSetState($ChkBox[3], $GUI_HIDE)
#EndRegion

#Region œŒÀŒ—€ œ–Œ√–≈——¿
For $i = 0 To 5
   $Bar[$i] = GUICtrlCreateProgress($BarLeft, $BarTop, $BarWidth, $BarHeight, $BarSty[$i])
   GUICtrlSetState($Bar[$i], $GUI_HIDE)
Next
#EndRegion

#Region  ÕŒœ »
For $i = 0 To 1
   $CancBtn[$i] = GUICtrlCreateButton($StrBtn[3], $BtnLeft[0], $BtnTop[0], $BtnWidth[0], $BtnHeight[0])
   GUICtrlSetFont($CancBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
Next
GUICtrlSetState($CancBtn[1], $GUI_HIDE)

For $i = 0 To 4
   $NextBtn[$i] = GUICtrlCreateButton($StrBtn[0], $BtnLeft[1], $BtnTop[1], $BtnWidth[1], $BtnHeight[1])
   GUICtrlSetFont($NextBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   GUICtrlSetState($NextBtn[$i], $GUI_HIDE)
Next
GUICtrlSetState($NextBtn[0], $GUI_SHOW)
ControlSetText($Win[0], "", $NextBtn[4], $StrBtn[5])

For $i = 0 To 5
   $BackBtn[$i] = GUICtrlCreateButton($StrBtn[1], $BtnLeft[2], $BtnTop[2], $BtnWidth[2], $BtnHeight[2])
   GUICtrlSetFont($BackBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   GUICtrlSetState($BackBtn[$i], $GUI_HIDE)
Next

For $i = 0 To 1
   $BtnSc[$i] = GUICtrlCreateButton($StrBtn[6], $BtnLeft[3], $BtnTop[3], $BtnWidth[3], $BtnHeight[3])
   GUICtrlSetFont($BtnSc[$i], $BtnTxtSz[1], 400, 0, $BtnTxt)
   GUICtrlSetState($BtnSc[$i], $GUI_HIDE)

   $BtnSet[$i] = GUICtrlCreateButton($StrBtn[7], $BtnLeft[4], $BtnTop[4], $BtnWidth[4], $BtnHeight[4])
   GUICtrlSetFont($BtnSet[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   GUICtrlSetState($BtnSet[$i], $GUI_HIDE)
Next

For $i = 0 To 5
   $AbrtBtn[$i] = GUICtrlCreateButton($StrBtn[2], $BtnLeft[2], $BtnTop[2], $BtnWidth[2], $BtnHeight[2])
   GUICtrlSetFont($AbrtBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   GUICtrlSetState($AbrtBtn[$i], $GUI_HIDE)
Next
#EndRegion

#Region “–≈…
Opt("TrayMenuMode", 1+2)

For $i = 0 To 6
   $TrayItm[$i] = TrayCreateItem($StrTray[$i])
Next
#EndRegion

GUISetState(@SW_SHOW, $Win[0])

DirRemove($Dir[0], 1)

Func _LiVw()
   Local $CntxtMen, $CntxtLv[5], $Q = 0, $ChkLp = False

   $FO[0] = FileOpen($File[11], 32)
   If $FO[0] = -1 Then Return

   GUICtrlSendMsg($LiVw[0], $LVM_DELETEALLITEMS, 0, 0)
   $LiVw[0] = GUICtrlCreateListView($StrLiVw[0], $LiVwLeft[0], $LiVwTop[0], $LiVwWidth[0], $LiVwHeight[0], $LiVwSty[0], $LiVwSty[1])
   For $i = 0 To 1
	  GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, $i, $LiVwColWd[$i])
   Next
   GUICtrlSetState($LiVw[0], $GUI_DISABLE)

   $LvImg = _GUIImageList_Create($LiVwImg[0], $LiVwImg[1], 5, 1)
   While True
	  $ReadStr = FileReadLine($FO[0])
	  If @error = -1 Then ExitLoop
	  $Q = $Q+1
	  Switch StringTrimLeft($ReadStr, StringInStr($ReadStr, ".", 0, -1)-1)
		 Case $FileMask[0]
			If $TxtSize < 16 Then
			   $AddIcn = _GUIImageList_AddIcon($LvImg, $ReadStr, 0)
			Else
			   $AddIcn = _GUIImageList_AddIconEx($LvImg, $ReadStr, 1, $LiVwImg[0], $LiVwImg[1])
			EndIf
			If $AddIcn = -1 Then
			   If $TxtSize < 16 Then
				  _GUIImageList_AddIcon($LvImg, $File[20], 0)
			   Else
				  _GUIImageList_AddIconEx($LvImg, $File[20], 1, $LiVwImg[0], $LiVwImg[1])
			   EndIf
			EndIf
			_GUICtrlListView_InsertItem($LiVw[0], StringTrimLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), -1, $Q-1)
			_GUICtrlListView_AddSubItem($LiVw[0], $Q-1, StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), 1)
		 Case $FileMask[1]
			If $TxtSize < 16 Then
			   _GUIImageList_AddIcon($LvImg, $File[20], 1)
			Else
			   _GUIImageList_AddIconEx($LvImg, $File[20], 2, $LiVwImg[0], $LiVwImg[1])
			EndIf
			_GUICtrlListView_InsertItem($LiVw[0], StringTrimLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), -1, $Q-1)
			_GUICtrlListView_AddSubItem($LiVw[0], $Q-1, StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), 1)
		 Case $FileMask[2] To $FileMask[11]
			If $TxtSize < 16 Then
			   _GUIImageList_AddIcon($LvImg, $File[20], 2)
			Else
			   _GUIImageList_AddIconEx($LvImg, $File[20], 3, $LiVwImg[0], $LiVwImg[1])
			EndIf
			_GUICtrlListView_InsertItem($LiVw[0], StringTrimLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), -1, $Q-1)
			_GUICtrlListView_AddSubItem($LiVw[0], $Q-1, StringLeft($ReadStr, StringInStr($ReadStr, "\", 0, -1)), 1)
	  EndSwitch
	  If Mod($Q, 150) = 0 Then GUICtrlSendMsg($LiVw[0], $LVM_SCROLL, 0, 150*$LiVwImg[0])
   WEnd
   _GUICtrlListView_SetImageList($LiVw[0], $LvImg, 1)
   GUICtrlSendMsg($LiVw[0], $LVM_SCROLL, 0, -2*$Q*$LiVwImg[0])

   FileClose($FO[0])
   $FO[0] = FileOpen($File[12], 2+32)

   If Not $Win[3] Then
	  GUICtrlSetState($LiVw[0], $GUI_ENABLE+$GUI_FOCUS)
   Else
	  GUICtrlSetState($LiVw[0], $GUI_ENABLE)
   EndIf
   GUICtrlSetState($BackBtn[4], $GUI_ENABLE)
   GUICtrlSetState($NextBtn[3], $GUI_ENABLE)
   GUICtrlSetState($CancBtn[0], $GUI_ENABLE)

   #Region  ŒÕ“≈ —“ÕŒ≈ Ã≈Õﬁ
   $CntxtMen = GUICtrlCreateContextMenu($LiVw[0])

   For $i = 0 To 4
	  $CntxtLv[$i] = GUICtrlCreateMenuItem($StrCntxt[$i], $CntxtMen)
   Next
   #EndRegion

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[0] Then
			   FileClose($FO[0])
			   Exit
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			   GUISwitch($Win[0])
			EndIf
		 Case $CancBtn[0]
			FileClose($FO[0])
			If MsgBox(4+32, "", $StrMsg[3], 0, $Win[0]) = 6 Then Exit
		 Case $NextBtn[3]
			If $Q > 2000 Then
			   GUICtrlSetState($LiVw[0], $GUI_DISABLE)
			   GUICtrlSetState($BackBtn[4], $GUI_DISABLE)
			   GUICtrlSetState($NextBtn[3], $GUI_DISABLE)
			   GUICtrlSetState($CancBtn[0], $GUI_DISABLE)
			EndIf
			For $i = 0 To $Q-1
			   If _GUICtrlListView_GetItemChecked($LiVw[0], $i) Then
				  FileWriteLine($FO[0], _GUICtrlListView_GetItemText($LiVw[0], $i, 1) & _
				  _GUICtrlListView_GetItemText($LiVw[0], $i))
				  $ChkLp = True
			   EndIf
			Next
			If $Q > 2000 Then
			   GUICtrlSetState($LiVw[0], $GUI_ENABLE)
			   GUICtrlSetState($BackBtn[4], $GUI_ENABLE)
			   GUICtrlSetState($NextBtn[3], $GUI_ENABLE)
			   GUICtrlSetState($CancBtn[0], $GUI_ENABLE)
			EndIf
			If $ChkLp Then
			   GUICtrlSetState($Blk[9], $GUI_HIDE)
			   GUICtrlSetState($LiVw[0], $GUI_HIDE)
			   GUICtrlSetState($NextBtn[3], $GUI_HIDE)
			   GUICtrlSetState($BackBtn[4], $GUI_HIDE)
			   GUICtrlSetState($Blk[10], $GUI_SHOW)
			   GUICtrlSetState($Sep[2], $GUI_SHOW)
			   GUICtrlSetState($NextBtn[4], $GUI_SHOW+$GUI_DISABLE)
			   GUICtrlSetState($AbrtBtn[5], $GUI_SHOW)
			   FileClose($FO[0])
			   _SrcGen()
			   _SrcGenEnd()
			   ExitLoop
			Else
			   GUICtrlSetState($LiVw[0], $GUI_FOCUS)
			EndIf
		 Case $BackBtn[4]
			GUICtrlSetState($Pic[7], $GUI_HIDE)
			GUICtrlSetState($Pic[15], $GUI_HIDE)
			GUICtrlSetState($Blk[9], $GUI_HIDE)
			GUICtrlSetState($LiVw[0], $GUI_HIDE)
			GUICtrlSetState($BackBtn[4], $GUI_HIDE)
			GUICtrlSetState($Sep[2], $GUI_SHOW)
			GUICtrlSetState($BackBtn[3], $GUI_SHOW+$GUI_DISABLE)
			GUICtrlSetState($NextBtn[3], $GUI_DISABLE)
			GUICtrlSetState($CancBtn[0], $GUI_DISABLE)
			FileClose($FO[0])
			_DataDel()
			GUICtrlSetState($BackBtn[3], $GUI_ENABLE)
			GUICtrlSetState($CancBtn[0], $GUI_ENABLE)
			GUICtrlSetState($Pic[3], $GUI_SHOW)
			GUICtrlSetState($Pic[11], $GUI_SHOW)
			GUICtrlSetState($Grp[2], $GUI_SHOW)
			GUICtrlSetState($BtnSc[1], $GUI_SHOW)
			GUICtrlSetState($BtnSet[1], $GUI_SHOW)
			ExitLoop
		 Case $CntxtLv[0]
			For $i = 0 To $Q-1
			   If ControlListView($Win[0], "", $LiVw[0], "IsSelected", $i) Then
				  _GUICtrlListView_SetItemChecked($LiVw[0], $i, True)
			   EndIf
			Next
		 Case $CntxtLv[1]
			For $i = 0 To $Q-1
			   If ControlListView($Win[0], "", $LiVw[0], "IsSelected", $i) Then
				  _GUICtrlListView_SetItemChecked($LiVw[0], $i, False)
			   EndIf
			Next
		 Case $CntxtLv[3]
			_GUICtrlListView_SetItemChecked($LiVw[0], -1, True)
		 Case $CntxtLv[4]
			_GUICtrlListView_SetItemChecked($LiVw[0], -1, False)
	  EndSwitch
   WEnd
EndFunc
