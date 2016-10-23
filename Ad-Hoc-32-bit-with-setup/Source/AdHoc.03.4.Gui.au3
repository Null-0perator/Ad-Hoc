Func _Wind_4()
   If FileExists($Dir[0]) Then $Dir[0] = $Dir[5] & "Ad\"
   DirCreate($Dir[0])

   #include "AdHoc.02.3.FileInstall.au3"

   $Win[4] = GUICreate("", $WinWidth[2], $WinHeight[2], Default, Default, $WinSty[1], Default, $WinParnt[1])
   GUISetBkColor($WinColr, $Win[4])

   #Region  ¿–“»Õ »
   _GDIPlus_Startup()
   $Pic[19] = _GDIPlus_ImageLoadFromFile($Dir[0] & "Pic10.jpg")
   $ImRsz[11] = _GDIPlus_ImageResize($Pic[19], $PicWidth[5], $PicHeight[5], 6)
   $EncodID = _GDIPlus_EncodersGetCLSID("jpg")
   $PrmLst = _GDIPlus_ParamInit(1)
   $QualCreate = DllStructCreate("int Quality")
   DllStructSetData($QualCreate, "Quality", 100)
   $PntrStruc = DllStructGetPtr($QualCreate)
   _GDIPlus_ParamAdd($PrmLst, "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", 1, 4, $PntrStruc)
   _GDIPlus_ImageSaveToFileEx($ImRsz[11], $Dir[0] & "Pic21.jpg", $EncodID, DllStructGetPtr($PrmLst))
   _GDIPlus_ImageDispose($Pic[19])
   _GDIPlus_Shutdown()

   GUICtrlCreatePic($Dir[0] & "Pic21.jpg", $PicLeft[5], $PicTop[5], $PicWidth[5], $PicHeight[5])
   #EndRegion

   #Region ¡ÀŒ » “≈ —“¿
   $Blk[14] = GUICtrlCreateLabel($StrBlk[14], $BlkLeft[14], $BlkTop[14], $BlkWidth[14], $BlkHeight[14], $BlkSty[0])
   GUICtrlSetFont($Blk[14], $BlkTxtSz[1], 400, 0, $BlkTxt[1])
   #EndRegion

   #Region  ÕŒœ »
   For $i = 0 To 3
	  $MsgBtn[$i] = GUICtrlCreateButton($StrBtn[8+$i], $BtnLeft[6+$i], $BtnTop[6], $BtnWidth[6], $BtnHeight[6])
	  GUICtrlSetFont($MsgBtn[$i], $BtnTxtSz[0], 400, 0, $BtnTxt)
   Next
   #EndRegion

   GUISetState(@SW_SHOW, $Win[4])
   GUISetState(@SW_DISABLE, $Win[0])

   DirRemove($Dir[0], 1)

   While True
	  $MSG = GUIGetMsg(1)
	  Switch $MSG[0]
		 Case $GUI_EVENT_CLOSE
			If $MSG[1] = $Win[0] Or $MSG[1] = $Win[4] Then
			   _WinSwich()
			   ExitLoop
			ElseIf $MSG[1] = $Win[3] Then
			   GUIDelete($Win[3])
			EndIf
		 Case $MsgBtn[0]
			_WinSwich()
			$RunProc = Run($Dir[2] & $File[10], $Dir[2], @SW_HIDE)
			GUISetState(@SW_HIDE, $Win[0])
			ExitLoop
		 Case $MsgBtn[1]
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "StrMngr", "RunStrMngr", "Yes")
			_WinSwich()
			$RunProc = Run($Dir[2] & $File[10], $Dir[2], @SW_HIDE)
			GUISetState(@SW_HIDE, $Win[0])
			ExitLoop
		 Case $MsgBtn[2]
			_WinSwich()
			ExitLoop
		 Case $MsgBtn[3]
			If Not FileExists($File[1]) Then _SettingsSave()
			IniWrite($File[1], "StrMngr", "RunStrMngr", "No")
			_WinSwich()
			ExitLoop
	  EndSwitch
   WEnd
EndFunc

Func _WinSwich()
   GUIDelete($Win[4])
   GUISetState(@SW_ENABLE, $Win[0])
   WinActivate($Win[0], "")
EndFunc
