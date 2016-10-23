Func _Wind_3($InsTxt = "")
   Global $Sc = $EditTxtSz

   If $Win[3] Then GUIDelete($Win[3])
   $Win[3] = GUICreate($StrWin[3], $EditWidth, $EditHeight, Default, Default, $WinSty[2], Default, $WinParnt[1])
   GUISetBkColor($WinColr, $Win[3])

   #Region онке ббндю
   $Edit = GUICtrlCreateEdit($InsTxt, $EditLeft, $EditTop, $EditWidth, $EditHeight, $EditSty[0], $EditSty[1])
   GUICtrlSendMsg($Edit, $EM_LIMITTEXT, -1, 0)
   GUICtrlSetFont($Edit, $EditTxtSz, 400, 0, $EditTxt)
   #EndRegion

   GUISetState(@SW_MAXIMIZE, $Win[3])
   GUICtrlSendMsg($Edit, $EM_SETSEL, -1, 0)
   GUISwitch($Win[0])
   WinActivate($Win[0], "")
EndFunc

Func TxtUp()
   If GUICtrlGetState($Edit) = $GUI_SHOW+$GUI_ENABLE Then
	  $Sc = $Sc+1
	  GUICtrlSetFont($Edit, $Sc, 400, 0, $EditTxt)
   EndIf
EndFunc

Func TxtDwn()
   If GUICtrlGetState($Edit) = $GUI_SHOW+$GUI_ENABLE Then
	  $Sc = $Sc-1
	  GUICtrlSetFont($Edit, $Sc, 400, 0, $EditTxt)
   EndIf
EndFunc
