Func _Wind_5()
   If FileExists($Dir[0]) Then $Dir[0] = $Dir[5] & "Ad\"
   DirCreate($Dir[0])

   #include "AdHoc.02.3.FileInstall.au3"

   $Win[5] = GUICreate("", $WinWidth[3], $WinHeight[3], Default, Default, $WinSty[1], Default, $WinParnt[1])
   GUISetBkColor($WinColr, $Win[5])

   #Region ÊÀÐÒÈÍÊÈ
   _GDIPlus_Startup()
   $Pic[19] = _GDIPlus_ImageLoadFromFile($Dir[0] & "Pic10.jpg")
   $ImRsz[11] = _GDIPlus_ImageResize($Pic[19], $PicWidth[6], $PicHeight[6], 6)
   $EncodID = _GDIPlus_EncodersGetCLSID("jpg")
   $PrmLst = _GDIPlus_ParamInit(1)
   $QualCreate = DllStructCreate("int Quality")
   DllStructSetData($QualCreate, "Quality", 100)
   $PntrStruc = DllStructGetPtr($QualCreate)
   _GDIPlus_ParamAdd($PrmLst, "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", 1, 4, $PntrStruc)
   _GDIPlus_ImageSaveToFileEx($ImRsz[11], $Dir[0] & "Pic21.jpg", $EncodID, DllStructGetPtr($PrmLst))
   _GDIPlus_ImageDispose($Pic[19])
   _GDIPlus_Shutdown()

   GUICtrlCreatePic($Dir[0] & "Pic21.jpg", $PicLeft[6], $PicTop[6], $PicWidth[6], $PicHeight[6])
   #EndRegion

   #Region ÁËÎÊÈ ÒÅÊÑÒÀ
   $Blk[15] = GUICtrlCreateLabel($StrBlk[15], $BlkLeft[15], $BlkTop[15], $BlkWidth[15], $BlkHeight[15], $BlkSty[0])
   GUICtrlSetFont($Blk[15], $BlkTxtSz[1], 400, 0, $BlkTxt[1])
   #EndRegion

   #Region ÊÍÎÏÊÈ
   For $i = 0 To 3
	  $MsgBtn[$i] = GUICtrlCreateButton($StrBtn[8+$i], $BtnLeft[10+$i], $BtnTop[7], $BtnWidth[7], $BtnHeight[7])
	  GUICtrlSetFont($MsgBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   Next
   If UBound($StrBtn) > 12 Then
	  GUICtrlSetData($MsgBtn[1], $StrBtn[12])
	  GUICtrlSetData($MsgBtn[3], $StrBtn[13])
   EndIf
   #EndRegion

   GUISetState(@SW_SHOW, $Win[5])
   GUISetState(@SW_DISABLE, $Win[0])

   DirRemove($Dir[0], 1)

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[0] Or $MSG[1] = $Win[5] Then
			   GUISetState(@SW_HIDE, $Win[0])
			   GUIDelete($Win[5])
			   ExitLoop
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			EndIf
		 Case $MsgBtn[0]
			GUISetState(@SW_HIDE, $Win[0])
			GUIDelete($Win[5])
			$RunProc = Run($File[17], $Dir[4], @SW_HIDE)
			_ShowTray()
			ExitLoop
		 Case $MsgBtn[1]
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "DataArch", "Add", "Yes")
			GUISetState(@SW_HIDE, $Win[0])
			GUIDelete($Win[5])
			$RunProc = Run($File[17], $Dir[4], @SW_HIDE)
			_ShowTray()
			ExitLoop
		 Case $MsgBtn[2]
			GUISetState(@SW_HIDE, $Win[0])
			GUIDelete($Win[5])
			ExitLoop
		 Case $MsgBtn[3]
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "DataArch", "Add", "No")
			GUISetState(@SW_HIDE, $Win[0])
			GUIDelete($Win[5])
			ExitLoop
	  EndSwitch
   WEnd
EndFunc
