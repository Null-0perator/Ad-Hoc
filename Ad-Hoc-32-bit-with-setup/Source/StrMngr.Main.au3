#NoTrayIcon
#pragma compile(AutoItExecuteAllowed, True)

#include "StrMngr.01.Declare.au3"
#include "StrMngr.02.Gui.au3"
#include "StrMngr.03.Engine.au3"

_HotKey_Assign(BitOR($CK_CONTROL, $VK_ADD), 'TxtUp', 0, $Win[0])
_HotKey_Assign(BitOR($CK_CONTROL, $VK_SUBTRACT), 'TxtDwn', 0, $Win[0])

While True
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $Btn[0]
		 GUICtrlSetState($Btn[0], $GUI_DISABLE)
		 GUICtrlSetState($Btn[1], $GUI_ENABLE)
		 If GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[1], $GUI_HIDE)
			GUICtrlSetState($Edit[1], $GUI_HIDE)
			If $Chk = 3 Then
			   GUICtrlSetData($Btn[4], $Text[11])
			   $Chk = 1
			EndIf
			GUICtrlSetState($Blk[0], $GUI_SHOW)
			GUICtrlSetState($Edit[0], $GUI_SHOW+$GUI_FOCUS)
			GUICtrlSendMsg($Edit[0], $EM_SETSEL, -1, 0)
			GUICtrlSetData($Cntxt[0], $StrCntxt[0])
		 ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[3], $GUI_HIDE)
			GUICtrlSetState($LiVw[1], $GUI_HIDE)
			If $Chk = 3 Then
			   GUICtrlSetData($Btn[4], $Text[13])
			   $Chk = 2
			EndIf
			GUICtrlSetState($Blk[2], $GUI_SHOW)
			GUICtrlSetState($LiVw[0], $GUI_SHOW+$GUI_FOCUS)
			_DelGUI_1()
			GUICtrlSetData($Cntxt[0], $StrCntxt[0])
		 EndIf
	  Case $Btn[1]
		 GUICtrlSetState($Btn[1], $GUI_DISABLE)
		 GUICtrlSetState($Btn[0], $GUI_ENABLE)
		 If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[0], $GUI_HIDE)
			GUICtrlSetState($Edit[0], $GUI_HIDE)
			If $Chk = 3 Then
			   GUICtrlSetData($Btn[4], $Text[11])
			   $Chk = 1
			EndIf
			GUICtrlSetState($Blk[1], $GUI_SHOW)
			GUICtrlSetState($Edit[1], $GUI_SHOW+$GUI_FOCUS)
			GUICtrlSendMsg($Edit[1], $EM_SETSEL, -1, 0)
			GUICtrlSetData($Cntxt[0], $StrCntxt[1])
		 ElseIf GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[2], $GUI_HIDE)
			GUICtrlSetState($LiVw[0], $GUI_HIDE)
			If $Chk = 3 Then
			   GUICtrlSetData($Btn[4], $Text[13])
			   $Chk = 2
			EndIf
			GUICtrlSetState($Blk[3], $GUI_SHOW)
			GUICtrlSetState($LiVw[1], $GUI_SHOW+$GUI_FOCUS)
			_DelGUI_2()
			GUICtrlSetData($Cntxt[0], $StrCntxt[1])
		 EndIf
	  Case $Btn[2]
		 _DelNExGUI()
	  Case $Btn[3]
		 GUICtrlSetState($Btn[3], $GUI_HIDE)
		 GUICtrlSetState($Btn[5], $GUI_SHOW)
		 GUICtrlSetData($Btn[4], $Text[13])
		 $Chk = 2
		 If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[0], $GUI_HIDE)
			GUICtrlSetState($Edit[0], $GUI_HIDE)
			GUICtrlSetState($Blk[2], $GUI_SHOW)
			GUICtrlSetState($LiVw[0], $GUI_SHOW+$GUI_FOCUS)
			_DelGUI_1()
		 ElseIf GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[1], $GUI_HIDE)
			GUICtrlSetState($Edit[1], $GUI_HIDE)
			GUICtrlSetState($Blk[3], $GUI_SHOW)
			GUICtrlSetState($LiVw[1], $GUI_SHOW+$GUI_FOCUS)
			_DelGUI_2()
		 EndIf
	  Case $Btn[4]
		 If $Chk = 1 Then
			If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			   $Msv = StringRegExp(GUICtrlRead($Edit[0]), "[^\r\n]+", 3)
			   If UBound($Msv) Then
				  GUICtrlSetState($Edit[0], $GUI_DISABLE)
				  GUICtrlSetState($Btn[1], $GUI_DISABLE)
				  _AddBtnDis()
				  _ArPrep($Msv)
				  _ArraySort($Msv)
				  _ArDuplCut($Msv)
				  _AddStr_10()
				  GUICtrlSetState($Edit[0], $GUI_ENABLE+$GUI_FOCUS)
				  GUICtrlSendMsg($Edit[0], $EM_SETSEL, -1, 0)
				  GUICtrlSetState($Btn[1], $GUI_ENABLE)
				  _AddBtnEn2()
			   EndIf
			ElseIf GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			   $Msv = StringRegExp(GUICtrlRead($Edit[1]), "[^\r\n]+", 3)
			   If UBound($Msv) Then
				  GUICtrlSetState($Edit[1], $GUI_DISABLE)
				  GUICtrlSetState($Btn[0], $GUI_DISABLE)
				  _AddBtnDis()
				  _ArraySort($Msv)
				  _ArDuplCut($Msv)
				  _AddStr_20()
				  GUICtrlSetState($Edit[1], $GUI_ENABLE+$GUI_FOCUS)
				  GUICtrlSendMsg($Edit[1], $EM_SETSEL, -1, 0)
				  GUICtrlSetState($Btn[0], $GUI_ENABLE)
				  _AddBtnEn2()
			   EndIf
			EndIf
		 ElseIf $Chk = 2 Then
			If GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			   If ControlListView($Win[0], "", $LiVw[0], "GetSelectedCount") Then
				  GUICtrlSetState($LiVw[0], $GUI_DISABLE)
				  GUICtrlSetState($Btn[1], $GUI_DISABLE)
				  _DelBtnDis()
				  _DelStr_1()
				  GUICtrlSetState($LiVw[0], $GUI_ENABLE+$GUI_FOCUS)
				  GUICtrlSetState($Btn[1], $GUI_ENABLE)
				  _DelBtnEn2()
			   EndIf
			ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			   If ControlListView($Win[0], "", $LiVw[1], "GetSelectedCount") Then
				  GUICtrlSetState($LiVw[1], $GUI_DISABLE)
				  GUICtrlSetState($Btn[0], $GUI_DISABLE)
				  _DelBtnDis()
				  _DelStr_2()
				  _RegDel()
				  GUICtrlSetState($LiVw[1], $GUI_ENABLE+$GUI_FOCUS)
				  GUICtrlSetState($Btn[0], $GUI_ENABLE)
				  _DelBtnEn2()
			   EndIf
			EndIf
		 ElseIf $Chk = 3 Then
			Exit
		 EndIf
	  Case $Btn[5]
		 GUICtrlSetState($Btn[5], $GUI_HIDE)
		 GUICtrlSetState($Btn[3], $GUI_SHOW)
		 GUICtrlSetData($Btn[4], $Text[11])
		 $Chk = 1
		 If GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[2], $GUI_HIDE)
			GUICtrlSetState($LiVw[0], $GUI_HIDE)
			GUICtrlSetState($Blk[0], $GUI_SHOW)
			GUICtrlSetState($Edit[0], $GUI_SHOW+$GUI_FOCUS)
			GUICtrlSendMsg($Edit[0], $EM_SETSEL, -1, 0)
		 ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSetState($Blk[3], $GUI_HIDE)
			GUICtrlSetState($LiVw[1], $GUI_HIDE)
			GUICtrlSetState($Blk[1], $GUI_SHOW)
			GUICtrlSetState($Edit[1], $GUI_SHOW+$GUI_FOCUS)
			GUICtrlSendMsg($Edit[1], $EM_SETSEL, -1, 0)
		 EndIf
	  Case $Cntxt[0]
		 If GUICtrlGetState($Blk[0]) = $GUI_SHOW+$GUI_ENABLE Then
			$Msv = StringRegExp(GUICtrlRead($Edit[0]), "[^\r\n]+", 3)
			If UBound($Msv) Then
			   GUICtrlSetState($Edit[0], $GUI_DISABLE)
			   GUICtrlSetState($Btn[1], $GUI_DISABLE)
			   _AddBtnDis()
			   _ArraySort($Msv)
			   _ArDuplCut($Msv)
			   _AddSbFldr()
			   GUICtrlSetState($Edit[0], $GUI_ENABLE+$GUI_FOCUS)
			   GUICtrlSendMsg($Edit[0], $EM_SETSEL, -1, 0)
			   GUICtrlSetState($Btn[1], $GUI_ENABLE)
			   _AddBtnEn()
			EndIf
		 ElseIf GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			If ControlListView($Win[0], "", $LiVw[0], "GetSelectedCount") Then
			   GUICtrlSetState($LiVw[0], $GUI_DISABLE)
			   GUICtrlSetState($Btn[1], $GUI_DISABLE)
			   _DelBtnDis()
			   _DelSbStr(0)
			   GUICtrlSetState($LiVw[0], $GUI_ENABLE+$GUI_FOCUS)
			   GUICtrlSetState($Btn[1], $GUI_ENABLE)
			   _DelBtnEn()
			EndIf
		 ElseIf GUICtrlGetState($Blk[1]) = $GUI_SHOW+$GUI_ENABLE Then
			$Msv = StringRegExp(GUICtrlRead($Edit[1]), "[^\r\n]+", 3)
			If UBound($Msv) Then
			   GUICtrlSetState($Edit[1], $GUI_DISABLE)
			   GUICtrlSetState($Btn[0], $GUI_DISABLE)
			   _AddBtnDis()
			   _ArraySort($Msv)
			   _ArDuplCut($Msv)
			   _RegAddSbK()
			   GUICtrlSetState($Edit[1], $GUI_ENABLE+$GUI_FOCUS)
			   GUICtrlSendMsg($Edit[1], $EM_SETSEL, -1, 0)
			   GUICtrlSetState($Btn[0], $GUI_ENABLE)
			   _AddBtnEn()
			EndIf
		 ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			If ControlListView($Win[0], "", $LiVw[1], "GetSelectedCount") Then
			   GUICtrlSetState($LiVw[1], $GUI_DISABLE)
			   GUICtrlSetState($Btn[0], $GUI_DISABLE)
			   _DelBtnDis()
			   _DelSbStr(1)
			   GUICtrlSetState($LiVw[1], $GUI_ENABLE+$GUI_FOCUS)
			   GUICtrlSetState($Btn[0], $GUI_ENABLE)
			   _DelBtnEn()
			EndIf
		 EndIf
	  Case $Cntxt[1]
		 If $Bnd[3] > 2000 Then
			GUICtrlSetState($LiVw[1], $GUI_DISABLE)
			GUICtrlSetState($Btn[0], $GUI_DISABLE)
			_DelBtnDis()
		 EndIf
		 For $i = 0 To $Bnd[3]-1
			If ControlListView($Win[0], "", $LiVw[1], "IsSelected", $i) And _
			_GUICtrlListView_GetItemFocused($LiVw[1], $i) Then
			   $ReadStr = _GUICtrlListView_GetItemText($LiVw[1], $i, 1)
			   _OpnNtpd($File[2], $ReadStr)
			   ExitLoop
			EndIf
		 Next
		 If $Bnd[3] > 2000 Then
			GUICtrlSetState($LiVw[1], $GUI_ENABLE+$GUI_FOCUS)
			GUICtrlSetState($Btn[0], $GUI_ENABLE)
			_DelBtnEn()
		 EndIf
	  Case $GUI_EVENT_RESIZED Or $GUI_EVENT_MAXIMIZE
		 If GUICtrlGetState($Blk[2]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSendMsg($LiVw[0], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
		 ElseIf GUICtrlGetState($Blk[3]) = $GUI_SHOW+$GUI_ENABLE Then
			GUICtrlSendMsg($LiVw[1], $LVM_SETCOLUMNWIDTH, 1, $LVSCW_AUTOSIZE_USEHEADER)
		 EndIf
   EndSwitch
WEnd
