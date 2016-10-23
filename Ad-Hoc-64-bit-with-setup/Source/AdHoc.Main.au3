#NoTrayIcon

#include "AdHoc.01.0.Declare.au3"
;#include "AdHoc.02.1.FileInstall.au3"
#include "AdHoc.03.1.Gui.au3"
#include "AdHoc.04.Engine.au3"

_HotKey_Assign(BitOR($CK_CONTROL, $VK_ADD), 'TxtUp', 0, $Win[3])
_HotKey_Assign(BitOR($CK_CONTROL, $VK_SUBTRACT), 'TxtDwn', 0, $Win[3])

While True
   $MSG = GUIGetMsg(1)
   Switch $MSG[0]
	  Case $GUI_EVENT_CLOSE
		 If $MSG[1] = $Win[0] Then
			If $Chk[2] Then
			   _AddArchData()
			   GUIDelete($Win[3])
			   If IniRead($File[1], "Miscellaneous", "Start.vbs", "Make") <> "Skip" Then
				  _MakeVbs()
			   EndIf
			   _DataTmpDel()
			EndIf
			Exit
		 ElseIf $MSG[1] = $Win[3] Then
			GUIDelete($Win[3])
			GUISwitch($Win[0])
		 EndIf
	  Case $NextBtn[0]
		 GUICtrlSetState($Pic[0], $GUI_HIDE)
		 GUICtrlSetState($Sep[1], $GUI_HIDE)
		 GUICtrlSetState($Blk[1], $GUI_HIDE)
		 GUICtrlSetState($Blk[2], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[0], $GUI_HIDE)
		 _RadRead_0()
		 GUICtrlSetState($Blk[0], $GUI_SHOW)
		 GUICtrlSetState($Pic[1], $GUI_SHOW)
		 GUICtrlSetState($Pic[9], $GUI_SHOW)
		 GUICtrlSetState($Sep[0], $GUI_SHOW)
		 GUICtrlSetState($Grp[0], $GUI_SHOW)
		 GUICtrlSetState($Rad[0], $GUI_SHOW)
		 GUICtrlSetState($Rad[1], $GUI_SHOW)
		 GUICtrlSetState($BackBtn[0], $GUI_SHOW)
		 $NumPr = _NumOfProc()
	  Case $BackBtn[0]
		 GUICtrlSetState($Pic[1], $GUI_HIDE)
		 GUICtrlSetState($Pic[9], $GUI_HIDE)
		 GUICtrlSetState($Sep[0], $GUI_HIDE)
		 GUICtrlSetState($Grp[0], $GUI_HIDE)
		 GUICtrlSetState($Rad[1], $GUI_HIDE)
		 GUICtrlSetState($Rad[0], $GUI_HIDE)
		 GUICtrlSetState($Blk[0], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[0], $GUI_HIDE)
		 _RadRead_1()
		 GUICtrlSetState($Pic[0], $GUI_SHOW)
		 GUICtrlSetState($Sep[1], $GUI_SHOW)
		 GUICtrlSetState($Blk[1], $GUI_SHOW)
		 GUICtrlSetState($Blk[2], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[0], $GUI_SHOW)
	  Case $NextBtn[1]
		 GUICtrlSetState($Grp[0], $GUI_HIDE)
		 GUICtrlSetState($Rad[0], $GUI_HIDE)
		 GUICtrlSetState($Rad[1], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[1], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[0], $GUI_HIDE)
		 GUICtrlSetState($Grp[1], $GUI_SHOW)
		 GUICtrlSetState($BtnSc[0], $GUI_SHOW)
		 GUICtrlSetState($BtnSet[0], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[2], $GUI_SHOW+$GUI_DISABLE)
		 GUICtrlSetState($BackBtn[1], $GUI_SHOW)
	  Case $BackBtn[1]
		 GUICtrlSetState($Grp[1], $GUI_HIDE)
		 GUICtrlSetState($BtnSc[0], $GUI_HIDE)
		 GUICtrlSetState($BtnSet[0], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[1], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[2], $GUI_ENABLE+$GUI_HIDE)
		 GUICtrlSetState($Grp[0], $GUI_SHOW)
		 GUICtrlSetState($Rad[0], $GUI_SHOW)
		 GUICtrlSetState($Rad[1], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[1], $GUI_SHOW)
		 GUICtrlSetState($BackBtn[0], $GUI_SHOW)
 	  Case $Rad[0]
		 GUICtrlSetState($NextBtn[2], $GUI_HIDE)
 		 GUICtrlSetState($NextBtn[1], $GUI_SHOW)
 	  Case $Rad[1]
 		 GUICtrlSetState($NextBtn[1], $GUI_HIDE)
 		 GUICtrlSetState($NextBtn[2], $GUI_SHOW)
	  Case $BtnSc[0]
		 GUICtrlSetState($Grp[1], $GUI_HIDE)
		 GUICtrlSetState($BtnSc[0], $GUI_HIDE)
		 GUICtrlSetState($BtnSet[0], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[1], $GUI_HIDE)
		 GUICtrlSetState($Blk[3], $GUI_SHOW)
		 GUICtrlSetState($Bar[0], $GUI_SHOW)
		 GUICtrlSetState($AbrtBtn[0], $GUI_SHOW)
		 $IniVal = IniRead($File[1], "Miscellaneous", "CPU", "0")
		 If Abs(Int($IniVal)) >= 1 And Abs(Int($IniVal)) <= $NumPr Then
			$IniNumPr = Abs(Int($IniVal))
		 Else
			$IniNumPr = $NumPr
		 EndIf
		 _SysSc_0()
		 _SysScEnd_0()
	  Case $BtnSet[0]
		 _Wind_1()
	  Case $NextBtn[2]
		 _RadRead_2()
		 GUICtrlSetState($NextBtn[2], $GUI_HIDE)
		 GUICtrlSetState($Pic[3], $GUI_SHOW)
		 GUICtrlSetState($Pic[11], $GUI_SHOW)
		 GUICtrlSetState($Grp[2], $GUI_SHOW)
		 GUICtrlSetState($BtnSc[1], $GUI_SHOW)
		 GUICtrlSetState($BtnSet[1], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[3], $GUI_SHOW+$GUI_DISABLE)
		 GUICtrlSetState($BackBtn[3], $GUI_SHOW)
	  Case $BackBtn[2]
		 GUICtrlSetState($Pic[2], $GUI_HIDE)
		 GUICtrlSetState($Pic[10], $GUI_HIDE)
		 GUICtrlSetState($Blk[4], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[2], $GUI_HIDE)
 		 GUICtrlSetState($NextBtn[2], $GUI_HIDE)
		 GUICtrlSetState($Pic[1], $GUI_SHOW)
		 GUICtrlSetState($Pic[9], $GUI_SHOW)
		 GUICtrlSetState($Grp[1], $GUI_SHOW)
		 GUICtrlSetState($BtnSc[0], $GUI_SHOW)
		 GUICtrlSetState($BtnSet[0], $GUI_SHOW)
		 GUICtrlSetState($NextBtn[2], $GUI_SHOW+$GUI_DISABLE)
		 GUICtrlSetState($BackBtn[1], $GUI_SHOW)
	  Case $BtnSc[1]
		 GUICtrlSetState($Grp[2], $GUI_HIDE)
		 GUICtrlSetState($BtnSc[1], $GUI_HIDE)
		 GUICtrlSetState($BtnSet[1], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[3], $GUI_HIDE)
		 GUICtrlSetState($Blk[3], $GUI_SHOW)
		 GUICtrlSetState($Bar[1], $GUI_SHOW)
		 GUICtrlSetState($AbrtBtn[1], $GUI_SHOW)
		 $IniVal = IniRead($File[1], "Miscellaneous", "CPU", "0")
		 If Abs(Int($IniVal)) >= 1 And Abs(Int($IniVal)) <= $NumPr Then
			$IniNumPr = Abs(Int($IniVal))
		 Else
			$IniNumPr = $NumPr
		 EndIf
		 _SysSc_1()
		 _SysScEnd_1()
		 _Compare()
		 _CompareEnd()
		 _CopyMove()
		 _CopyMoveEnd()
		 _Vrf_Prep()
		 _Vrf_PrepEnd()
	  Case $BtnSet[1]
		 _Wind_2()
	  Case $BackBtn[3]
		 GUICtrlSetState($Pic[3], $GUI_HIDE)
		 GUICtrlSetState($Pic[11], $GUI_HIDE)
		 GUICtrlSetState($Grp[2], $GUI_HIDE)
		 GUICtrlSetState($BtnSc[1], $GUI_HIDE)
		 GUICtrlSetState($BtnSet[1], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[3], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[3], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[2], $GUI_SHOW)
		 _RadRead_3()
	  Case $NextBtn[4]
		 _AddArchData()
		 GUIDelete($Win[3])
		 _Compile()
		 _DataTmpDel()
		 _RunMakeInst()
		 Exit
	  Case $BackBtn[5]
		 GUICtrlSetState($Pic[8], $GUI_HIDE)
		 GUICtrlSetState($Pic[16], $GUI_HIDE)
		 GUICtrlSetState($Pic[17], $GUI_HIDE)
		 GUICtrlSetState($Pic[18], $GUI_HIDE)
		 GUICtrlSetState($Blk[11], $GUI_HIDE)
		 GUICtrlSetState($ChkBox[3], $GUI_HIDE)
		 GUICtrlSetState($BackBtn[5], $GUI_HIDE)
		 GUICtrlSetState($NextBtn[4], $GUI_HIDE)
		 GUICtrlSetState($CancBtn[1], $GUI_HIDE)
		 $Chk[2] = False
		 If FileGetSize($File[11]) > 2 Then
			GUICtrlSetState($Sep[2], $GUI_HIDE)
			GUICtrlSetState($Pic[7], $GUI_SHOW)
			GUICtrlSetState($Pic[15], $GUI_SHOW)
			GUICtrlSetState($Blk[9], $GUI_SHOW)
			GUICtrlSetState($BackBtn[4], $GUI_SHOW+$GUI_DISABLE)
			GUICtrlSetState($NextBtn[3], $GUI_SHOW+$GUI_DISABLE)
			GUICtrlSetState($CancBtn[0], $GUI_SHOW+$GUI_DISABLE)
			_LiVw()
		 Else
			GUICtrlSetState($BackBtn[3], $GUI_SHOW+$GUI_DISABLE)
			GUICtrlSetState($NextBtn[3], $GUI_SHOW+$GUI_DISABLE)
			GUICtrlSetState($CancBtn[0], $GUI_SHOW+$GUI_DISABLE)
			_DataDel()
			GUICtrlSetState($Pic[3], $GUI_SHOW)
			GUICtrlSetState($Pic[11], $GUI_SHOW)
			GUICtrlSetState($Grp[2], $GUI_SHOW)
			GUICtrlSetState($BtnSc[1], $GUI_SHOW)
			GUICtrlSetState($BtnSet[1], $GUI_SHOW)
			GUICtrlSetState($BackBtn[3], $GUI_ENABLE)
			GUICtrlSetState($CancBtn[0], $GUI_ENABLE)
		 EndIf
	  Case $CancBtn[0]
		 If MsgBox(4+32, "", $StrMsg[3], 0, $Win[0]) = 6 Then Exit
	  Case $CancBtn[1]
		 _AddArchData()
		 GUIDelete($Win[3])
		 If IniRead($File[1], "Miscellaneous", "Start.vbs", "Make") <> "Skip" Then
			_MakeVbs()
		 EndIf
		 _DataTmpDel()
		 Exit
   EndSwitch
WEnd
