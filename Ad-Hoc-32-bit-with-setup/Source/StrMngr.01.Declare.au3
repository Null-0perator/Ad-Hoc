#Region КОНСТАНТЫ
Global Const $HK_RID = True
Global Const $HK_WM_HOTKEY = _WinAPI_RegisterWindowMessage('{509ADA08-BDC8-45BC-8082-1FFA4CB8D1C8}')

Global Const $tagKBDLLHOOKSTRUCT = "dword vkCode;dword scanCode;dword flags;dword time;" & _
			"ulong_ptr dwExtraInfo"

Global Const $tagPROCESSENTRY32 = "dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;" & _
			"dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]"

Global Const $tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;" & _
			"int TextMax;int Image;lparam Param;int Indent;int GroupID;uint Columns;ptr pColumns;" & _
			"ptr piColFmt;int iGroup;endstruct"
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Global Const $tagLVCOLUMN = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;" & _
			"int Order;int cxMin;int cxDefault;int cxIdeal"

Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_THICKFRAME = 0x00040000
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_STATICEDGE = 0x00020000
Global Const $WS_OVERLAPPEDWINDOW = BitOR($WS_CAPTION, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, _
			   $WS_OVERLAPPED, $WS_SYSMENU, $WS_THICKFRAME)
Global Const $WS_POPUP = 0x80000000
Global Const $DS_SETFOREGROUND = 0x0200

Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $ES_MULTILINE = 4
Global Const $ES_AUTOVSCROLL = 64
Global Const $ES_AUTOHSCROLL = 128
Global Const $ES_WANTRETURN = 4096
Global Const $ES_NOHIDESEL = 256
Global Const $EM_LIMITTEXT = 0xC5
Global Const $EM_SETSEL = 0xB1
Global Const $EM_SCROLL = 0xB5
Global Const $EM_SCROLLCARET = 0x00B7

Global Const $SB_LINEUP = 0
Global Const $SB_PAGEDOWN = 3
Global Const $SB_SCROLLCARET = 4

Global Const $LVS_REPORT = 0x0001
Global Const $LVS_SHOWSELALWAYS = 0x0008
Global Const $LVS_EX_FULLROWSELECT = 0x00000020
Global Const $LVS_EX_GRIDLINES = 0x00000001
Global Const $LVS_EX_INFOTIP = 0x00000400
Global Const $LVM_FIRST = 0x1000
Global Const $LVM_SETCOLUMNWIDTH = ($LVM_FIRST + 30)
Global Const $LVM_DELETEALLITEMS = ($LVM_FIRST + 9)
Global Const $LVM_SCROLL = ($LVM_FIRST + 20)
Global Const $LVSCW_AUTOSIZE_USEHEADER = -2

Global Const $GUI_DOCKLEFT = 0x0002
Global Const $GUI_DOCKRIGHT = 0x0004
Global Const $GUI_DOCKMENUBAR = 0x0220
Global Const $GUI_DOCKBORDERS = 0x0066
Global Const $GUI_DOCKSTATEBAR = 0x0240

Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_DROPACCEPTED = 8
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MAXIMIZE = -6
Global Const $GUI_EVENT_RESIZED = -12

Global Const $CK_CONTROL = 0x0200
Global Const $VK_ADD = 0x6B
Global Const $VK_SUBTRACT = 0x6D
#EndRegion

#Region ПЕРЕМЕННЫЕ
Global $hkTb[1][12] = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, GUICreate('')]], $hkRt[256]
Global $__g_hLVLastWnd, $__g_aInProcess_WinAPI[64][2] = [[0, 0]]

Local $FO[7], $Win[2], $Blk[5], $Edit[2], $LiVw[2], $ChkBox[4], $Btn[8], $CntxtMen[2], $Cntxt[2], _
	  $Sep[2], $T, $V, $Q, $Bnd[4], $E[2] = [False, False], $L[2] = [True, True], $Chk = 1, $Msv, _
	  $MsvTmp, $ReadStr, $WrStr, $StrTmp, $CheckLoop, $StrDeep, $EnumStr, $s, $RgPrm, _
	  $RgType, $RgVal, $StSpl, $SRv, $RunProc, $ProcChld, $ClassList, $WindHwnd, $Control

Local $ScriptDir = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, "\", 0, -1))
Local $Envir[12] = ["AppData", "LocalAppData", "UserProfile", "Public", "AllUsersProfile", "CommonProgramFiles", _
				"CommonProgramFiles(x86)", "ProgramFiles", "ProgramFiles(x86)", "WinDir", "Temp", "HomeDrive"]
Local $File[7] = ["DataFiles.txt", "RegKeys.txt", "RegInfo.ini", "DataFilesTmp.txt", "DirList.txt", "RegKeysTmp.txt", _
			    "RegInfoTmp.ini"]
Local $StrChk[4] = [$File[0], $File[1], $File[2]]

Switch @OSLang
   Case "0419", "0819"
	  Local $Text[15] = ["Управление строками", "", _
					"Введите новые пути для " & $File[0] & ":", _
					"Введите новые ключи для " & $File[1] & ":", _
					"Выберите пути, которые будут удалены из " & $File[0] & ":", _
					"Выберите ключи, которые будут удалены из " & $File[1] & ":", _
					"Удаление несуществующих путей в файлах:", _
					"<<<", ">>>", "Расшир. удал.", "Удаление...", "Добавить", "Добавление...", _
					"Удалить", "Закрыть"]
	  Local $TlTp[2] = ["Перейти к " & $File[0], "Перейти к " & $File[1]]
	  Local $StrCntxt[3] = ["Вместе с подкаталогами", "Вместе с подключами", _
					   "Найти в " & $File[2]]
	  $StrChk[3] = "Удалить пустые каталоги из ...\Data"

	  Local $Proc = ProcessList(@ScriptName)
	  For $i = 1 To $Proc[0][0]
		 If _WinAPI_GetProcessFileName($Proc[$i][1]) = @ScriptFullPath Then
			If $Chk = 0 Then
			   MsgBox(48, "", "Приложение уже запущено")
			   Exit
			EndIf
			$Chk = 0
		 EndIf
	  Next
   Case Else
	  Local $Text[15] = ["Strings management", "", _
					"Enter new paths for " & $File[0] & ":", _
					"Enter new keys for " & $File[1] & ":", _
					"Select paths to be deleted from " & $File[0] & ":", _
					"Select keys to be deleted from " & $File[1] & ":", _
					"Removing non-existent paths from files:", _
					"<<<", ">>>", "More", "Removing...", "Add", "Adding...", _
					"Delete", "Close"]
	  Local $TlTp[2] = ["Go to " & $File[0], "Go to " & $File[1]]
	  Local $StrCntxt[3] = ["Include subfolders", "Include subkeys", _
					   "Search in " & $File[2]]
	  $StrChk[3] = "Remove empty directories from ...\Data"

	  Local $Proc = ProcessList(@ScriptName)
	  For $i = 1 To $Proc[0][0]
		 If _WinAPI_GetProcessFileName($Proc[$i][1]) = @ScriptFullPath Then
			If $Chk = 0 Then
			   MsgBox(48, "", "The application is already running")
			   Exit
			EndIf
			$Chk = 0
		 EndIf
	  Next
EndSwitch
$Chk = 1

Local $RegStr[2] = ["HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI"]
Local $DPI = RegRead($RegStr[0], $RegStr[1]), $TxtSize = Ceiling(8.5*25/2400*$DPI)
If Int(@DesktopWidth/@DesktopHeight*100) >= 170 Then
   Local $WinHeight[2] = [Round(40*$TxtSize), Round(16*$TxtSize)]
   Local $WinWidth[2] = [Round(1.7*$WinHeight[0]), Round(2.6*$WinHeight[1])]
Else
   Local $WinHeight[2] = [Round(40*$TxtSize), Round(15*$TxtSize)]
   Local $WinWidth[2] = [Round(1.62*$WinHeight[0]), Round(2.68*$WinHeight[1])]
EndIf

If $DPI > 220 And $DPI < 481 Then
   For $i = 0 To 1
	  $WinHeight[$i] = Round(1.05*$WinHeight[$i])
	  $WinWidth[$i] = Round(1.05*$WinWidth[$i])
   Next
ElseIf $DPI > 480 Then
   For $i = 0 To 1
	  $WinHeight[$i] = Round(1.1*$WinHeight[$i])
	  $WinWidth[$i] = Round(1.1*$WinWidth[$i])
   Next
EndIf

Local $WinSty[4] = [BitOR($WS_OVERLAPPEDWINDOW, $WS_POPUP), $WS_EX_ACCEPTFILES, _
				  BitOR($WS_CAPTION, $WS_OVERLAPPED, $WS_SYSMENU, $DS_SETFOREGROUND), Default]
Local $WinTxt = "Tahoma"
Local $WinColr = 0xfafafa

Local Const $BlkTxt = "Tahoma"
If $DPI > 103 And $DPI < 112 Or $DPI > 135 And $DPI < 144 Then
   Local Const $BlkTxtSz = 9
   Local $Sc = 9
Else
   Local Const $BlkTxtSz = 8.5
   Local $Sc = 8.5
EndIf

Local $BlkLeft[2] = [$TxtSize, Round(1.1*$TxtSize)]
Local $BlkTop[2] = [Int(1.23*$TxtSize), Round(0.045*$WinHeight[1])]
Local $BlkWidth[2] = [$WinWidth[0]-2*$BlkLeft[0], $WinWidth[1]-2*$BlkLeft[1]]
Local $BlkHeight[2] = [2*$TxtSize, 2*$TxtSize]

Local Const $EditTxt = "Segoe UI", $EditTxtSz = $BlkTxtSz+1
Local $EditWidth = $WinWidth[0]-2*$TxtSize
Local $EditHeight = Int($WinHeight[0]/1.26)
Local $EditLeft = $TxtSize
Local $EditTop = 4*$TxtSize
Local $EditSty = [BitOR($ES_MULTILINE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, _
					$WS_VSCROLL, $WS_HSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN), _
			    BitOR($WS_EX_STATICEDGE, $WS_EX_CLIENTEDGE)]

Local Const $LiVwTxt = "Tahoma", $LiVwTxtSz = $BlkTxtSz
Local $LiVwSty[2] = [BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), _
				   BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE)]

Local $SepWidth = $WinWidth[1]
Local $SepHeight = 1
Local $SepLeft = 0
Local $SepTop[2] = [2*Round(0.2*$WinHeight[1]/2), Round(0.75*$WinHeight[1])]
Local $SepSty = 0x0
Local $SepColr = 0x878787

Local Const $ChkTxt = "Tahoma", $ChkTxtSz = $BlkTxtSz
Local $ChkWidth[2] = [Round(9.6*$TxtSize), 25*$TxtSize]
Local $ChkHeight = 2*$TxtSize
Local $ChkLeft[4] = [Round(0.11*$WinWidth[1]), Round(0.395*$WinWidth[1]), _
					 Round(0.67*$WinWidth[1]), Round(1.3*$TxtSize)]
Local $ChkTop[4] = [Round(0.465*$WinHeight[1])-$TxtSize, Round(0.465*$WinHeight[1])-$TxtSize, _
					Round(0.465*$WinHeight[1])-$TxtSize, _
					$SepTop[1]+($WinHeight[1]-$SepTop[1]-$ChkHeight)/2]

Local Const $BtnTxt = "Tahoma", $BtnTxtSz = $BlkTxtSz
Local $BtnHeight[2] = [Int($WinHeight[0]/14.5), 0.65*($WinHeight[1]-$SepTop[1])+1]
Local $BtnWidth[2] = [Int(2.2*$BtnHeight[0]), Int(3.8*$BtnHeight[0])]
Local $BtnLeft[6] = [Int(0.025*$WinWidth[0]), Int(0.025*$WinWidth[0])+Int($TxtSize/2)+$BtnWidth[0], _
				  Int(0.975*$WinWidth[0])-2*Int($TxtSize/9)-3*$BtnWidth[1], _
				  Int(0.975*$WinWidth[0])-Int($TxtSize/9)-2*$BtnWidth[1], _
				  Int(0.975*$WinWidth[0])-$BtnWidth[1], Int(0.975*$WinWidth[1])-$BtnWidth[1]]
Local $BtnTop[2] = [Int(0.98*$WinHeight[0])-$BtnHeight[0], $SepTop[1]+($WinHeight[1]-$SepTop[1]-$BtnHeight[1])/2+1]
#EndRegion

#Region Функции из HotKey.au3
GUIRegisterMsg(0x0006, 'HK_WM_ACTIVATE')
GUIRegisterMsg($HK_WM_HOTKEY, 'HK_WM_HOTKEY')
If $HK_RID Then
   GUIRegisterMsg(0x00FF, 'HK_WM_INPUT')
   __HK_Raw()
EndIf

OnAutoItExitRegister('__HK_AutoItExit')

Func HK_WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
   #forceref $hWnd, $iMsg, $lParam

   If $HK_RID Then
	  Switch $wParam
		 Case 0
			__HK_Raw(0)
		 Case 1, 2
			__HK_Raw(1)
	  EndSwitch
   EndIf
   Return 'GUI_RUNDEFMSG'
EndFunc

Func HK_WM_HOTKEY($hWnd, $iMsg, $wParam, $lParam)
   #forceref $iMsg

   Switch $hWnd
	  Case $hkTb[0][10]
		 Switch $lParam
			Case 0xAFAF
			   $hkTb[0][6] += 1
			   $hkTb[$wParam][8] += 1
			   If $hkTb[$wParam][6] = 1 Then
				  Call($hkTb[$wParam][1], $hkTb[$wParam][0])
			   Else
				  Call($hkTb[$wParam][1])
			   EndIf
			   $hkTb[$wParam][8] -= 1
			   $hkTb[0][6] -= 1
;~ 			   If (@error = 0xDEAD) And (@extended = 0xBEEF) Then
;~ 				  __HK_Error($hkTb[$wParam][1] & '(): Function does not exist or invalid number of parameters.')
;~ 			   EndIf
		 EndSwitch
   EndSwitch
EndFunc

Func HK_WM_INPUT($hWnd, $iMsg, $wParam, $lParam)
   #forceref $iMsg, $wParam

   If Not $HK_RID Then
	  Return 'GUI_RUNDEFMSG'
   EndIf

   Switch $hWnd
	  Case $hkTb[0][10]
		 If ($hkTb[0][1] = 0) And ($hkTb[0][3] = 0) And ($hkTb[0][5]) Then
			Local $tRIKB = DllStructCreate('dword Type;dword Size;ptr hDevice;wparam wParam;ushort MakeCode;ushort Flags;ushort Reserved;ushort VKey;ushort;uint Message;ulong ExtraInformation')
			Local $ID, $Ret, $Length

			If @AutoItX64 Then
			   $Length = 24
			Else
			   $Length = 16
			EndIf
			$Ret = DllCall('user32.dll', 'uint', 'GetRawInputData', 'ptr', $lParam, 'uint', 0x10000003, 'ptr', DllStructGetPtr($tRIKB), 'uint*', DllStructGetSize($tRIKB), 'uint', $Length)
			If (@error) Or ($Ret[0] = 0) Or ($Ret[0] = 4294967295) Then
			   ;
			Else
			   If BitAND(DllStructGetData($tRIKB, 'Flags'), 0x01) Then
				  $ID = DllStructGetData($tRIKB, 'VKey')
				  Switch $ID
					 Case 0x10, 0x11, 0x12, 0x5B, 0x5C
						;
					 Case Else
						$hkRt[$ID] -= 1
						If $hkRt[$ID] < 0 Then
						   _HotKey_Disable(0x00010000)
						   _HotKey_Enable()
						EndIf
				  EndSwitch
			   EndIf
			EndIf
		 EndIf
   EndSwitch
   Return 'GUI_RUNDEFMSG'
EndFunc

Func _HotKey_Disable($iFlags = -1)
	If $iFlags < 0 Then
		$iFlags = 0
	EndIf
	If (BitAND($iFlags, 0x0010) = 0) And ($hkTb[0][6] > 0) Then
		Return SetError(1,-1, 0)
	EndIf
	If (BitAND($iFlags, 0x0002) = 0) And ($hkTb[0][5]) Then
		If Not _WinAPI_UnhookWindowsHookEx($hkTb[0][5]) Then
			If Not BitAND($iFlags, 0x00010000) Then
				Return SetError(1, 0, 0)
			EndIf
		EndIf
		DllCallbackFree($hkTb[0][4])
		$hkTb[0][5] = 0
	EndIf
	$hkTb[0][3] = 1
	__HK_Reset()
	Return 1
EndFunc

Func _HotKey_Enable()
	If $hkTb[0][6] > 0 Then
		Return SetError(1,-1, 0)
	EndIf
	If ($hkTb[0][5] = 0) And ($hkTb[0][0] > 0) Then
		For $i = 0 To 0xFF
			$hkRt[$i] = 0
		Next
		$hkTb[0][4] = DllCallbackRegister('__HK_Hook', 'long', 'int;wparam;lparam')
		$hkTb[0][5] =_WinAPI_SetWindowsHookEx(13, DllCallbackGetPtr($hkTb[0][4]), _WinAPI_GetModuleHandle(0), 0)
		If (@error) Or ($hkTb[0][5] = 0) Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	$hkTb[0][3] = 0
	Return 1
EndFunc

Func _HotKey_Assign($iKey, $sFunction = 0, $iFlags = -1, $sTitle = 0)
   Local $Index = 0, $Redim = False

   If $iFlags < 0 Then
	  $iFlags = BitOR(0x0004, 0x0008)
   EndIf
   If (BitAND($iFlags, 0x0010) = 0) And ($hkTb[0][6] > 0) Then
	  Return SetError(1,-1, 0)
   EndIf
   If (Not IsString($sFunction)) And ($sFunction = 0) Then
	  $sFunction = ''
   EndIf
   $sFunction = StringStripWS($sFunction, 3)
   $iKey = BitAND($iKey, 0x0FFF)
   If BitAND($iKey, 0x00FF) = 0 Then
	  Return SetError(1, 0, 0)
   EndIf
   For $i = 1 To $hkTb[0][0]
	  If $hkTb[$i][0] = $iKey Then
		 $Index = $i
		 ExitLoop
	  EndIf
   Next
   If Not $sFunction Then
	  If $Index = 0 Then
		 Return SetError(0, 0, 1)
	  EndIf
	  If (BitAND($iFlags, 0x0002) = 0) And ($hkTb[0][5]) And ($hkTb[0][0] = 1) Then
		 If Not _WinAPI_UnhookWindowsHookEx($hkTb[0][5]) Then
			Return SetError(1, 0, 0)
		 EndIf
		 DllCallbackFree($hkTb[0][4])
		 $hkTb[0][5] = 0
		 __HK_Reset()
	  EndIf
	  $hkTb[0][8] = 1
	  For $i = $Index To $hkTb[0][0] - 1
		 For $j = 0 To UBound($hkTb, 2) - 1
			$hkTb[$i][$j] = $hkTb[$i + 1][$j]
		 Next
	  Next
	  ReDim $hkTb[$hkTb[0][0]][UBound($hkTb, 2)]
	  $hkTb[0][0] -= 1
	  If $iKey = $hkTb[0][2] Then
		 __HK_Reset()
	  EndIf
	  $hkTb[0][8] = 0
   Else
	  If $Index = 0 Then
		 If ($hkTb[0][5] = 0) And ($hkTb[0][3] = 0) Then
			For $i = 0 To 0xFF
			   $hkRt[$i] = 0
			Next
			$hkTb[0][4] = DllCallbackRegister('__HK_Hook', 'long', 'int;wparam;lparam')
			$hkTb[0][5] =_WinAPI_SetWindowsHookEx(13, DllCallbackGetPtr($hkTb[0][4]), _WinAPI_GetModuleHandle(0), 0)
			If (@error) Or ($hkTb[0][5] = 0) Then
			   Return SetError(1, 0, 0)
			EndIf
		 EndIf
		 $Index = $hkTb[0][0] + 1
		 ReDim $hkTb[$Index + 1][UBound($hkTb, 2)]
		 $Redim = 1
	  EndIf
	  $hkTb[$Index][0] = $iKey
	  $hkTb[$Index][1] = $sFunction
	  $hkTb[$Index][2] = $sTitle
	  $hkTb[$Index][3] = (BitAND($iFlags, 0x0001) = 0x0001)
	  $hkTb[$Index][4] = (BitAND($iFlags, 0x0004) = 0x0004)
	  $hkTb[$Index][5] = (BitAND($iFlags, 0x0008) = 0x0008)
	  $hkTb[$Index][6] = (BitAND($iFlags, 0x0040) = 0x0040)
	  $hkTb[$Index][7] = (BitAND($iFlags, 0x0080) = 0x0080)
	  $hkTb[$Index][8] = 0
	  For $i = 9 To 11
		 $hkTb[$Index][$i] = 0
	  Next
	  If $Redim Then
		 $hkTb[0][0] += 1
	  EndIf
   EndIf
   Return 1
EndFunc

Func __HK_Hook($iCode, $wParam, $lParam)
   If ($iCode > -1) And ($hkTb[0][1] = 0) And ($hkTb[0][3] = 0) Then
	  Local $vkCode = BitAND(DllStructGetData(DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam), 'vkCode'), 0xFF)
	  Local $Return = False

	  Switch $wParam
		 Case 0x0100, 0x0104
			If $hkTb[0][8] = 1 Then
			   Return -1
			EndIf
			Switch $vkCode
			   Case 0xA0 To 0xA5, 0x5B, 0x5C
				  Switch $vkCode
					 Case 0xA0, 0xA1
						$hkTb[0][9] = BitOR($hkTb[0][9], 0x01)
					 Case 0xA2, 0xA3
						$hkTb[0][9] = BitOR($hkTb[0][9], 0x02)
					 Case 0xA4, 0xA5
						$hkTb[0][9] = BitOR($hkTb[0][9], 0x04)
					 Case 0x5B, 0x5C
						$hkTb[0][9] = BitOR($hkTb[0][9], 0x08)
					 EndSwitch
				  If $hkTb[0][2] > 0 Then
					 $hkTb[0][2] = 0
				  EndIf
			   Case Else
				  If $hkTb[0][9] Then
					 __HK_Resolve()
				  EndIf

				  Local $Key = BitOR(BitShift($hkTb[0][9], -8), $vkCode)
				  Local $Int = False

				  If ($hkTb[0][2] = 0) Or ($hkTb[0][2] = $Key) Then
					 For $i = 1 To $hkTb[0][0]
						If (__HK_Active($hkTb[$i][2])) And ($hkTb[$i][0] = $Key) Then
						   If $hkTb[0][2] = $hkTb[$i][0] Then
							  If $hkTb[$i][5] = 0 Then
								 $Int = 1
							  EndIf
						   Else
							  $hkTb[0][2] = $hkTb[$i][0]
							  $hkTb[0][7] = $hkTb[$i][3]
							  $Int = 1
						   EndIf
						   If $hkTb[$i][3] = 0 Then
							  $Return = 1
						   EndIf
						   If $Int Then
							  __HK_Call($i)
						   EndIf
						   ExitLoop
						EndIf
					 Next
				  Else
					 $Return = 1
				  EndIf
			EndSwitch
			If $Return Then
			   Return -1
			EndIf
		 Case 0x0101, 0x0105
			Switch $vkCode
			   Case 0xA0 To 0xA5, 0x5B, 0x5C
				  Switch $vkCode
					 Case 0xA0, 0xA1
						$hkTb[0][9] = BitAND($hkTb[0][9], 0xFE)
					 Case 0xA2, 0xA3
						$hkTb[0][9] = BitAND($hkTb[0][9], 0xFD)
					 Case 0xA4, 0xA5
						$hkTb[0][9] = BitAND($hkTb[0][9], 0xFB)
					 Case 0x5B, 0x5C
						$hkTb[0][9] = BitAND($hkTb[0][9], 0xF7)
				  EndSwitch
				  If ($hkTb[0][2] > 0) And ($hkTb[0][7] = 0) And ($hkTb[0][9] = 0) Then
					 $hkTb[0][1] = 1
					 __HK_KeyUp($vkCode)
					 $hkTb[0][1] = 0
					 Return -1
				  EndIf
			   Case BitAND($hkTb[0][2], 0x00FF)
				  $hkRt[$vkCode] += 1
				  $hkTb[0][2] = 0
			   Case Else
				  $hkRt[$vkCode] += 1
			EndSwitch
	  EndSwitch
   EndIf
   Return _WinAPI_CallNextHookEx(0, $iCode, $wParam, $lParam)
EndFunc

Func __HK_Resolve()
   Local $Key = 0

   If __HK_IsPressed(0x10) Then
	  If Not @error Then
		 $Key = BitOR($Key, 0x01)
	  Else
		 Return
	  EndIf
   EndIf
   If __HK_IsPressed(0x11) Then
	  If Not @error Then
		 $Key = BitOR($Key, 0x02)
	  Else
		 Return
	  EndIf
   EndIf
   If __HK_IsPressed(0x12) Then
	  If Not @error Then
		 $Key = BitOR($Key, 0x04)
	  Else
		 Return
	  EndIf
   EndIf
   If __HK_IsPressed(0x5B) Or __HK_IsPressed(0x5C) Then
	  If Not @error Then
		 $Key = BitOR($Key, 0x08)
	  Else
		 Return
	  EndIf
   EndIf
   $hkTb[0][9] = $Key
EndFunc

Func __HK_KeyUp($vkCode)
   DllCall('user32.dll', 'int', 'keybd_event', 'int', 0x88, 'int', 0, 'int', 0, 'ptr', 0)
   DllCall('user32.dll', 'int', 'keybd_event', 'int', $vkCode, 'int', 0, 'int', 2, 'ptr', 0)
   DllCall('user32.dll', 'int', 'keybd_event', 'int', 0x88, 'int', 0, 'int', 2, 'ptr', 0)
EndFunc

Func __HK_Active($hWnd)
   If (IsInt($hWnd)) And ($hWnd = 0) Then
	  Return 1
   Else
	  If WinActive($hWnd) Then
		 Return 1
	  EndIf
   EndIf
   Return 0
EndFunc

Func __HK_Call($iIndex)
   If ($hkTb[$iIndex][4] = 0) Or ($hkTb[$iIndex][8] = 0) Then
	  If $hkTb[$iIndex][7] = 0 Then
		 DllCall('user32.dll', 'int', 'PostMessage', 'hwnd', $hkTb[0][10], 'uint', $HK_WM_HOTKEY, 'int', $iIndex, 'int', 0xAFAF)
	  Else
		 DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hkTb[0][10], 'uint', $HK_WM_HOTKEY, 'int', $iIndex, 'int', 0xAFAF)
	  EndIf
   EndIf
EndFunc

Func __HK_IsPressed($vkCode)
   Local $Ret = DllCall('user32.dll', 'short', 'GetAsyncKeyState', 'int', $vkCode)

   If (@error) Or ((Not $Ret[0]) And (_WinAPI_GetLastError())) Then
	  Return SetError(1, 0, 0)
   EndIf
   Return BitAND($Ret[0], 0x8000)
EndFunc

Func __HK_Reset()
   $hkTb[0][2] = 0
   $hkTb[0][7] = 0
   $hkTb[0][9] = 0
   For $i = 0 To 0xFF
	  $hkRt[$i] = 0
   Next
EndFunc

Func __HK_Raw($fRemove = 0)
   Local $tRID = DllStructCreate('ushort UsagePage;ushort Usage;dword Flags;hwnd hTarget')
   Local $Ret, $Length

   If @AutoItX64 Then
	  $Length = 16
   Else
	  $Length = 12
   EndIf
   DllStructSetData($tRID, 'UsagePage', 0x01)
   DllStructSetData($tRID, 'Usage', 0x06)
   If $fRemove Then
	  DllStructSetData($tRID, 'Flags', 0x00000001)
	  DllStructSetData($tRID, 'hTarget', 0)
   Else
	  DllStructSetData($tRID, 'Flags', 0x00000100)
	  DllStructSetData($tRID, 'hTarget', $hkTb[0][10])
   EndIf
   $Ret = DllCall('user32.dll', 'int', 'RegisterRawInputDevices', 'ptr', DllStructGetPtr($tRID), 'uint', 1, 'uint', $Length)
   If (@error) Or (Not $Ret[0]) Then
	  Return 0
   Else
	  Return 1
   EndIf
EndFunc

Func __HK_AutoItExit()
   If $hkTb[0][5] Then
	  _WinAPI_UnhookWindowsHookEx($hkTb[0][5])
   EndIf
EndFunc
#EndRegion

#Region Функции из GuiEdit.au3
Func _GUICtrlEdit_SetSel($hWnd, $iStart, $iEnd)
   If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
   _SendMessage($hWnd, $EM_SETSEL, $iStart, $iEnd)
EndFunc

Func _GUICtrlEdit_Scroll($hWnd, $iDirection)
   If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

   If $iDirection == 4 Then
	  Return _SendMessage($hWnd, $EM_SCROLLCARET)
   Else
	  Return _SendMessage($hWnd, $EM_SCROLL, $iDirection)
   EndIf
EndFunc
#EndRegion

#Region Функции из GuiListView.au3
Func _GUICtrlListView_GetItemCount($hWnd)
   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, $LVM_FIRST + 4)
   Else
	  Return GUICtrlSendMsg($hWnd, $LVM_FIRST + 4, 0, 0)
   EndIf
EndFunc

Func _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem = 0)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $tBuffer
   If $bUnicode Then
	  $tBuffer = DllStructCreate("wchar Text[4096]")
   Else
	  $tBuffer = DllStructCreate("char Text[4096]")
   EndIf
   Local $pBuffer = DllStructGetPtr($tBuffer)
   Local $tItem = DllStructCreate($tagLVITEM)
   DllStructSetData($tItem, "SubItem", $iSubItem)
   DllStructSetData($tItem, "TextMax", 4096)
   If IsHWnd($hWnd) Then
	  If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
		 DllStructSetData($tItem, "Text", $pBuffer)
		 _SendMessage($hWnd, $LVM_FIRST + 115, $iIndex, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 If $bUnicode Then
			_SendMessage($hWnd, $LVM_FIRST + 115, $iIndex, $pMemory, 0, "wparam", "ptr")
		 Else
			_SendMessage($hWnd, $LVM_FIRST + 45, $iIndex, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemRead($tMemMap, $pText, $tBuffer, 4096)
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  DllStructSetData($tItem, "Text", $pBuffer)
	  If $bUnicode Then
		 GUICtrlSendMsg($hWnd, $LVM_FIRST + 115, $iIndex, $pItem)
	  Else
		 GUICtrlSendMsg($hWnd, $LVM_FIRST + 45, $iIndex, $pItem)
	  EndIf
   EndIf
   Return DllStructGetData($tBuffer, "Text")
EndFunc

Func _GUICtrlListView_GetUnicodeFormat($hWnd)
   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, 0x2000 + 6) <> 0
   Else
	  Return GUICtrlSendMsg($hWnd, 0x2000 + 6, 0, 0) <> 0
   EndIf
EndFunc

Func _GUICtrlListView_DeleteItemsSelected($hWnd)
   Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
   ; Delete all?
   If _GUICtrlListView_GetSelectedCount($hWnd) = $iItemCount Then
	  Return _GUICtrlListView_DeleteAllItems($hWnd)
   Else
	  Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
	  If Not IsArray($aSelected) Then Return SetError(-1, -1, 0)
	  ; Unselect all items
	  _GUICtrlListView_SetItemSelected($hWnd, -1, False)
	  ; Determine ListView type
	  Local $vCID = 0, $iNative_Delete, $iUDF_Delete
	  If IsHWnd($hWnd) Then
		 ; Check if the ListView has a ControlID
		 $vCID = _WinAPI_GetDlgCtrlID($hWnd)
	  Else
		 $vCID = $hWnd
		 ; Get ListView handle
		 $hWnd = GUICtrlGetHandle($hWnd)
	  EndIf
	  ; Loop through items
	  For $iIndex = $aSelected[0] To 1 Step -1
		 ; If native ListView - could be either type of item
		 If $vCID < 10000 Then
			; Try deleting as native item
			Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$iIndex])
			; Check if LV item
			If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
			   ; Delete native item
			   $iNative_Delete = GUICtrlDelete($iParam)
			   ; If deletion successful move to next
			   If $iNative_Delete Then ContinueLoop
			EndIf
		 EndIf
		 ; Has to be UDF Listview and/or UDF item
		 $iUDF_Delete = _SendMessage($hWnd, $LVM_FIRST + 8, $aSelected[$iIndex])
		 ; Check for failed deletion
		 If $iNative_Delete + $iUDF_Delete = 0 Then
			; $iIndex will be > 0
			ExitLoop
		 EndIf
	  Next
	  ; If all deleted return True; else return False
	  Return Not $iIndex
   EndIf
EndFunc

Func _GUICtrlListView_GetSelectedCount($hWnd)
   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, $LVM_FIRST + 50)
   Else
	  Return GUICtrlSendMsg($hWnd, $LVM_FIRST + 50, 0, 0)
   EndIf
EndFunc

Func _GUICtrlListView_DeleteAllItems($hWnd)
   ; Check if deletion necessary
   If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
   ; Determine ListView type
   Local $vCID = 0
   If IsHWnd($hWnd) Then
	  ; Check ListView ControlID to detect UDF control
	  $vCID = _WinAPI_GetDlgCtrlID($hWnd)
   Else
	  $vCID = $hWnd
	  ; Get ListView handle
	  $hWnd = GUICtrlGetHandle($hWnd)
   EndIf
   ; If native ListView - could be either type of item
   If $vCID < 10000 Then
	  ; Try deleting as native items
	  Local $iParam = 0
	  For $iIndex = _GUICtrlListView_GetItemCount($hWnd) - 1 To 0 Step -1
		 $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
		 ; Check if LV item
		 If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
			GUICtrlDelete($iParam)
		 EndIf
	  Next
	  ; Return if no items left
	  If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
   EndIf
   ; Has to be UDF Listview and/or UDF items
   Return _SendMessage($hWnd, $LVM_DELETEALLITEMS) <> 0
EndFunc

Func _GUICtrlListView_GetSelectedIndices($hWnd, $bArray = False)
   Local $sIndices, $aIndices[1] = [0]
   Local $iRet, $iCount = _GUICtrlListView_GetItemCount($hWnd)
   For $iItem = 0 To $iCount
	  If IsHWnd($hWnd) Then
		 $iRet = _SendMessage($hWnd, $LVM_FIRST + 44, $iItem, 0x0002)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 44, $iItem, 0x0002)
	  EndIf
	  If $iRet Then
		 If (Not $bArray) Then
			If StringLen($sIndices) Then
			   $sIndices &= "|" & $iItem
			Else
			   $sIndices = $iItem
			EndIf
		 Else
			ReDim $aIndices[UBound($aIndices) + 1]
			$aIndices[0] = UBound($aIndices) - 1
			$aIndices[UBound($aIndices) - 1] = $iItem
		 EndIf
	  EndIf
   Next
   If (Not $bArray) Then
	  Return String($sIndices)
   Else
	  Return $aIndices
   EndIf
EndFunc

Func _GUICtrlListView_GetItemParam($hWnd, $iIndex)
   Local $tItem = DllStructCreate($tagLVITEM)
   DllStructSetData($tItem, "Mask", 0x00000004)
   DllStructSetData($tItem, "Item", $iIndex)
   _GUICtrlListView_GetItemEx($hWnd, $tItem)
   Return DllStructGetData($tItem, "Param")
EndFunc

Func _GUICtrlListView_GetItemEx($hWnd, ByRef $tItem)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $iRet
   If IsHWnd($hWnd) Then
	  If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
		 $iRet = _SendMessage($hWnd, $LVM_FIRST + 75, 0, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		 _MemWrite($tMemMap, $tItem)
		 If $bUnicode Then
			_SendMessage($hWnd, $LVM_FIRST + 75, 0, $pMemory, 0, "wparam", "ptr")
		 Else
			_SendMessage($hWnd, $LVM_FIRST + 5, 0, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemRead($tMemMap, $pMemory, $tItem, $iItem)
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 75, 0, $pItem)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 5, 0, $pItem)
	  EndIf
   EndIf
   Return $iRet <> 0
EndFunc

Func _GUICtrlListView_SetItemSelected($hWnd, $iIndex, $bSelected = True, $bFocused = False)
   Local $tStruct = DllStructCreate($tagLVITEM)
   Local $iRet, $iSelected = 0, $iFocused = 0, $iSize, $tMemMap, $pMemory
   If ($bSelected = True) Then $iSelected = 0x0002
   If ($bFocused = True And $iIndex <> -1) Then $iFocused = 0x0001
   DllStructSetData($tStruct, "Mask", 0x00000008)
   DllStructSetData($tStruct, "Item", $iIndex)
   DllStructSetData($tStruct, "State", BitOR($iSelected, $iFocused))
   DllStructSetData($tStruct, "StateMask", BitOR(0x0002, $iFocused))
   $iSize = DllStructGetSize($tStruct)
   If IsHWnd($hWnd) Then
	  $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
	  _MemWrite($tMemMap, $tStruct, $pMemory, $iSize)
	  $iRet = _SendMessage($hWnd, $LVM_FIRST + 43, $iIndex, $pMemory)
	  _MemFree($tMemMap)
   Else
	  $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 43, $iIndex, DllStructGetPtr($tStruct))
   EndIf
   Return $iRet <> 0
EndFunc

Func _GUICtrlListView_InsertItem($hWnd, $sText, $iIndex = -1, $iImage = -1, $iParam = 0)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $iBuffer, $tBuffer, $iRet
   If $iIndex = -1 Then $iIndex = 999999999

   Local $tItem = DllStructCreate($tagLVITEM)
   DllStructSetData($tItem, "Param", $iParam)
   ; If $sText <> -1 Then
   $iBuffer = StringLen($sText) + 1
   If $bUnicode Then
	  $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	  $iBuffer *= 2
   Else
	  $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
   EndIf
   DllStructSetData($tBuffer, "Text", $sText)
   DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
   DllStructSetData($tItem, "TextMax", $iBuffer)
   ; Else
   ; DllStructSetData($tItem, "Text", -1)
   ; EndIf
   Local $iMask = BitOR(0x00000001, 0x00000004)
   If $iImage >= 0 Then $iMask = BitOR($iMask, 0x00000002)
   DllStructSetData($tItem, "Mask", $iMask)
   DllStructSetData($tItem, "Item", $iIndex)
   DllStructSetData($tItem, "Image", $iImage)
   If IsHWnd($hWnd) Then
	  If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Or ($sText = -1) Then
		 $iRet = _SendMessage($hWnd, $LVM_FIRST + 77, 0, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 _MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		 If $bUnicode Then
			$iRet = _SendMessage($hWnd, $LVM_FIRST + 77, 0, $pMemory, 0, "wparam", "ptr")
		 Else
			$iRet = _SendMessage($hWnd, $LVM_FIRST + 7, 0, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 77, 0, $pItem)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 7, 0, $pItem)
	  EndIf
   EndIf
   Return $iRet
EndFunc

Func _GUICtrlListView_AddSubItem($hWnd, $iIndex, $sText, $iSubItem, $iImage = -1)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $iBuffer = StringLen($sText) + 1
   Local $tBuffer
   If $bUnicode Then
	  $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	  $iBuffer *= 2
   Else
	  $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
   EndIf
   Local $pBuffer = DllStructGetPtr($tBuffer)
   Local $tItem = DllStructCreate($tagLVITEM)
   Local $iMask = 0x00000001
   If $iImage <> -1 Then $iMask = BitOR($iMask, 0x00000002)
   DllStructSetData($tBuffer, "Text", $sText)
   DllStructSetData($tItem, "Mask", $iMask)
   DllStructSetData($tItem, "Item", $iIndex)
   DllStructSetData($tItem, "SubItem", $iSubItem)
   DllStructSetData($tItem, "Image", $iImage)
   Local $iRet
   If IsHWnd($hWnd) Then
	  If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
		 DllStructSetData($tItem, "Text", $pBuffer)
		 $iRet = _SendMessage($hWnd, $LVM_FIRST + 76, 0, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 _MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		 If $bUnicode Then
			$iRet = _SendMessage($hWnd, $LVM_FIRST + 76, 0, $pMemory, 0, "wparam", "ptr")
		 Else
			$iRet = _SendMessage($hWnd, $LVM_FIRST + 6, 0, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  DllStructSetData($tItem, "Text", $pBuffer)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 76, 0, $pItem)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 6, 0, $pItem)
	  EndIf
   EndIf
   Return $iRet <> 0
EndFunc

Func _GUICtrlListView_JustifyColumn($hWnd, $iIndex, $iAlign = -1)
	Local $aAlign[3] = [0x0000, 0x0001, 0x0002]
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iMask = 0x0001
	Local $iFmt = $aAlign[$iAlign]
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_FIRST + 96, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn, $tMemMap)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_FIRST + 96, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_FIRST + 26, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 96, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_FIRST + 26, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc

Func _GUICtrlListView_GetItemFocused($hWnd, $iIndex)
   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, $LVM_FIRST + 44, $iIndex, 0x0001) <> 0
   Else
	  Return GUICtrlSendMsg($hWnd, $LVM_FIRST + 44, $iIndex, 0x0001) <> 0
   EndIf
EndFunc
#EndRegion

#Region Функции из Memory.au3
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
   Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
		 "ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
   If @error Then Return SetError(@error, @extended, False)
   Return $aResult[0]
EndFunc

Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
   Local $aResult = DllCall("User32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
   If @error Then Return SetError(@error + 10, @extended, 0)
   Local $iProcessID = $aResult[2]
   If $iProcessID = 0 Then Return SetError(1, 0, 0) ; Invalid window handle

   Local $iAccess = BitOR(0x00000008, 0x00000010, 0x00000020)
   Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
   Local $iAlloc = BitOR(0x00002000, 0x00001000)
   Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, 0x00000004)

   If $pMemory = 0 Then Return SetError(2, 0, 0) ; Unable to allocate memory

   $tMemMap = DllStructCreate($tagMEMMAP)
   DllStructSetData($tMemMap, "hProc", $hProcess)
   DllStructSetData($tMemMap, "Size", $iSize)
   DllStructSetData($tMemMap, "Mem", $pMemory)
   Return $pMemory
EndFunc

Func __Mem_OpenProcess($iAccess, $bInherit, $iProcessID, $bDebugPriv = False)
   ; Attempt to open process with standard security priviliges
   Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
   If @error Then Return SetError(@error + 10, @extended, 0)
   If $aResult[0] Then Return $aResult[0]
   If Not $bDebugPriv Then Return 0

   ; Enable debug privileged mode
   Local $hToken = _Security__OpenThreadTokenEx(BitOR(0x00000020, 0x00000008))
   If @error Then Return SetError(@error + 20, @extended, 0)
   _Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
   Local $iError = @error
   Local $iLastError = @extended
   Local $iRet = 0
   If Not @error Then
	  ; Attempt to open process with debug privileges
	  $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
	  $iError = @error
	  $iLastError = @extended
	  If $aResult[0] Then $iRet = $aResult[0]

	  ; Disable debug privileged mode
	  _Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
	  If @error Then
		 $iError = @error + 30
		 $iLastError = @extended
	  EndIf
   Else
	  $iError = @error + 40
   EndIf
   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
   ; No need to test @error.

   Return SetError($iError, $iLastError, $iRet)
EndFunc

Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
   Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
   If @error Then Return SetError(@error, @extended, 0)
   Return $aResult[0]
EndFunc

Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
   If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
   If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
   Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
	     "ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
   If @error Then Return SetError(@error, @extended, False)
   Return $aResult[0]
EndFunc

Func _MemFree(ByRef $tMemMap)
   Local $pMemory = DllStructGetData($tMemMap, "Mem")
   Local $hProcess = DllStructGetData($tMemMap, "hProc")
   Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, 0x00008000)
   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
   If @error Then Return SetError(@error, @extended, False)
   Return $bResult
EndFunc

Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
   Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
   If @error Then Return SetError(@error, @extended, False)
   Return $aResult[0]
EndFunc
#EndRegion

#Region Функции из Security.au3
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
   Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
   If @error Then Return SetError(@error, @extended, False)

   Return Not ($aCall[0] = 0)
EndFunc

Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
   If $hThread = 0 Then
	  Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
	  If @error Then Return SetError(@error + 10, @extended, 0)
	  $hThread = $aResult[0]
   EndIf

   Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
   If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

   Return $aCall[4]
EndFunc

Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
   Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
   If $hToken = 0 Then
	  Local Const $ERROR_NO_TOKEN = 1008
	  If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
	  If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
	  $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
	  If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
   EndIf

   Return $hToken
EndFunc

Func _Security__ImpersonateSelf($iLevel = 2)
   Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
   If @error Then Return SetError(@error, @extended, False)

   Return Not ($aCall[0] = 0)
EndFunc

Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
   Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
   If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)

   Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
   Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
   Local $iCurrState = DllStructGetSize($tCurrState)
   Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
   Local $iPrevState = DllStructGetSize($tPrevState)
   Local $tRequired = DllStructCreate("int Data")
   ; Get current privilege setting
   DllStructSetData($tCurrState, "Count", 1)
   DllStructSetData($tCurrState, "LUID", $iLUID)
   If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)

   ; Set privilege based on prior setting
   DllStructSetData($tPrevState, "Count", 1)
   DllStructSetData($tPrevState, "LUID", $iLUID)
   Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
   If $bEnable Then
	  $iAttributes = BitOR($iAttributes, 0x00000002)
   Else
	  $iAttributes = BitAND($iAttributes, BitNOT(0x00000002))
   EndIf
   DllStructSetData($tPrevState, "Attributes", $iAttributes)

   If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then
	  Return SetError(3, @error, False)
   EndIf

   Return True
EndFunc

Func _Security__LookupPrivilegeValue($sSystem, $sName)
   Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
   If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

   Return $aCall[3] ; LUID
EndFunc
#EndRegion

#Region Функции из WinAPI.au3
Func _WinAPI_UnhookWindowsHookEx($hHook)
   Local $aResult = DllCall("user32.dll", "bool", "UnhookWindowsHookEx", "handle", $hHook)
   If @error Then Return SetError(@error, @extended, False)

   Return $aResult[0]
EndFunc

Func _WinAPI_SetWindowsHookEx($iHook, $pProc, $hDll, $iThreadId = 0)
   Local $aResult = DllCall("user32.dll", "handle", "SetWindowsHookEx", "int", $iHook, "ptr", $pProc, "handle", $hDll, _
		 "dword", $iThreadId)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_GetModuleHandle($sModuleName)
   Local $sModuleNameType = "wstr"
   If $sModuleName = "" Then
	  $sModuleName = 0
	  $sModuleNameType = "ptr"
   EndIf

   Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_CallNextHookEx($hHook, $iCode, $wParam, $lParam)
   Local $aResult = DllCall("user32.dll", "lresult", "CallNextHookEx", "handle", $hHook, "int", $iCode, "wparam", $wParam, "lparam", $lParam)
   If @error Then Return SetError(@error, @extended, -1)

   Return $aResult[0]
EndFunc

Func _WinAPI_RegisterWindowMessage($sMessage)
   Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
   If $hWnd = $hLastWnd Then Return True
   For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
	  If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
		 If $__g_aInProcess_WinAPI[$iI][1] Then
			$hLastWnd = $hWnd
			Return True
		 Else
			Return False
		 EndIf
	  EndIf
   Next
   Local $iPID
   _WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
   Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
   If $iCount >= 64 Then $iCount = 1
   $__g_aInProcess_WinAPI[0][0] = $iCount
   $__g_aInProcess_WinAPI[$iCount][0] = $hWnd
   $__g_aInProcess_WinAPI[$iCount][1] = ($iPID = @AutoItPID)
   Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc

Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
   Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
   If @error Then Return SetError(@error, @extended, 0)

   $iPID = $aResult[2]
   Return $aResult[0]
EndFunc

Func _WinAPI_GetDlgCtrlID($hWnd)
   Local $aResult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc
#EndRegion

#Region Функция из WinAPIError.au3
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
   Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
   Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
#EndRegion

#Region Функции из WinAPIProc.au3
Func _WinAPI_GetProcessFileName($iPID = 0)
   If Not $iPID Then Return @AutoItPID

   Local $hProcess = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", _OSVer(), _
			"bool", 0, "dword", $iPID)
   If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, "")

   Local $sPath = _WinAPI_GetModuleFileNameEx($hProcess[0])
   Local $iError = @error

   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
   If $iError Then Return SetError(@error, 0, "")

   Return $sPath
EndFunc

Func _WinAPI_GetModuleFileNameEx($hProcess, $hModule = 0)
   Local $aRet = DllCall(@SystemDir & "\psapi.dll", "dword", "GetModuleFileNameExW", "handle", $hProcess, "handle", $hModule, _
			"wstr", "", "int", 4096)
   If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, "")

   Return $aRet[3]
EndFunc

Func _OSVer()
   If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_2000" Then
	  Return 0x00000410
   Else
	  Return 0x00001010
   EndIf
EndFunc

Func _WinAPI_EnumChildProcess($iPID = 0)
   If Not $iPID Then $iPID = @AutoItPID

   Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
   If @error Or ($hSnapshot[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0) ; $INVALID_HANDLE_VALUE

   Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)
   Local $aResult[101][2] = [[0]]

   $hSnapshot = $hSnapshot[0]
   DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
   Local $aRet = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
   Local $iError = @error
   While (Not @error) And ($aRet[0])
	  If DllStructGetData($tPROCESSENTRY32, 'ParentProcessID') = $iPID Then
		 __Inc($aResult)
		 $aResult[$aResult[0][0]][0] = DllStructGetData($tPROCESSENTRY32, 'ProcessID')
		 $aResult[$aResult[0][0]][1] = DllStructGetData($tPROCESSENTRY32, 'ExeFile')
	  EndIf
	  $aRet = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	  $iError = @error
   WEnd
   DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
   If Not $aResult[0][0] Then Return SetError($iError + 20, 0, 0)

   __Inc($aResult, -1)
   Return $aResult
EndFunc
#EndRegion

#Region Функция из WinAPIInternals.au3
Func __Inc(ByRef $aData, $iIncrement = 100)
   Select
	  Case UBound($aData, 2)
		 If $iIncrement < 0 Then
			ReDim $aData[$aData[0][0] + 1][UBound($aData, 2)]
		 Else
			$aData[0][0] += 1
			If $aData[0][0] > UBound($aData) - 1 Then
			   ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, 2)]
			EndIf
		 EndIf
	  Case UBound($aData, 1)
		 If $iIncrement < 0 Then
			ReDim $aData[$aData[0] + 1]
		 Else
			$aData[0] += 1
			If $aData[0] > UBound($aData) - 1 Then
			   ReDim $aData[$aData[0] + $iIncrement]
			EndIf
		 EndIf
	  Case Else
		 Return 0
   EndSelect
   Return 1
EndFunc
#EndRegion

#Region Функция из SendMessage.au3
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
   Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
   If @error Then Return SetError(@error, @extended, "")
   If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
   Return $aResult
EndFunc
#EndRegion

#Region Функция __ArrayDualPivotSort() из Array.au3
Func _ArraySort(ByRef $aArray, $iStart = 0, $iEnd = UBound($aArray) - 1, $bLeftMost = True)
   If $iStart > $iEnd Then Return
   Local $iLength = $iEnd - $iStart + 1
   Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
   If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
	  If $bLeftMost Then
		 $i = $iStart
		 While $i < $iEnd
			$j = $i
			$iAi = $aArray[$i + 1]
			While $iAi < $aArray[$j]
			   $aArray[$j + 1] = $aArray[$j]
			   $j -= 1
			   If $j + 1 = $iStart Then ExitLoop
			WEnd
			$aArray[$j + 1] = $iAi
			$i += 1
		 WEnd
	  Else
		 While 1
			If $iStart >= $iEnd Then Return 1
			$iStart += 1
			If $aArray[$iStart] < $aArray[$iStart - 1] Then ExitLoop
		 WEnd
		 While 1
			$k = $iStart
			$iStart += 1
			If $iStart > $iEnd Then ExitLoop
			$iA1 = $aArray[$k]
			$iA2 = $aArray[$iStart]
			If $iA1 < $iA2 Then
			   $iA2 = $iA1
			   $iA1 = $aArray[$iStart]
			EndIf
			$k -= 1
			While $iA1 < $aArray[$k]
			   $aArray[$k + 2] = $aArray[$k]
			   $k -= 1
			WEnd
			$aArray[$k + 2] = $iA1
			While $iA2 < $aArray[$k]
			   $aArray[$k + 1] = $aArray[$k]
			   $k -= 1
			WEnd
			$aArray[$k + 1] = $iA2
			$iStart += 1
		 WEnd
		 $iLast = $aArray[$iEnd]
		 $iEnd -= 1
		 While $iLast < $aArray[$iEnd]
			$aArray[$iEnd + 1] = $aArray[$iEnd]
			$iEnd -= 1
		 WEnd
		 $aArray[$iEnd + 1] = $iLast
	  EndIf
	  Return 1
   EndIf
   Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
   Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
   $iE3 = Ceiling(($iStart + $iEnd) / 2)
   $iE2 = $iE3 - $iSeventh
   $iE1 = $iE2 - $iSeventh
   $iE4 = $iE3 + $iSeventh
   $iE5 = $iE4 + $iSeventh
   If $aArray[$iE2] < $aArray[$iE1] Then
	  $t = $aArray[$iE2]
	  $aArray[$iE2] = $aArray[$iE1]
	  $aArray[$iE1] = $t
   EndIf
   If $aArray[$iE3] < $aArray[$iE2] Then
	  $t = $aArray[$iE3]
	  $aArray[$iE3] = $aArray[$iE2]
	  $aArray[$iE2] = $t
	  If $t < $aArray[$iE1] Then
		 $aArray[$iE2] = $aArray[$iE1]
		 $aArray[$iE1] = $t
	  EndIf
   EndIf
   If $aArray[$iE4] < $aArray[$iE3] Then
	  $t = $aArray[$iE4]
	  $aArray[$iE4] = $aArray[$iE3]
	  $aArray[$iE3] = $t
	  If $t < $aArray[$iE2] Then
		 $aArray[$iE3] = $aArray[$iE2]
		 $aArray[$iE2] = $t
		 If $t < $aArray[$iE1] Then
			$aArray[$iE2] = $aArray[$iE1]
			$aArray[$iE1] = $t
		 EndIf
	  EndIf
   EndIf
   If $aArray[$iE5] < $aArray[$iE4] Then
	  $t = $aArray[$iE5]
	  $aArray[$iE5] = $aArray[$iE4]
	  $aArray[$iE4] = $t
	  If $t < $aArray[$iE3] Then
		 $aArray[$iE4] = $aArray[$iE3]
		 $aArray[$iE3] = $t
		 If $t < $aArray[$iE2] Then
			$aArray[$iE3] = $aArray[$iE2]
			$aArray[$iE2] = $t
			If $t < $aArray[$iE1] Then
			   $aArray[$iE2] = $aArray[$iE1]
			   $aArray[$iE1] = $t
			EndIf
		 EndIf
	  EndIf
   EndIf
   Local $iLess = $iStart
   Local $iGreater = $iEnd
   If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) _
   And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
	  Local $iPivot_1 = $aArray[$iE2]
	  Local $iPivot_2 = $aArray[$iE4]
	  $aArray[$iE2] = $aArray[$iStart]
	  $aArray[$iE4] = $aArray[$iEnd]
	  Do
		 $iLess += 1
	  Until $aArray[$iLess] >= $iPivot_1
	  Do
		 $iGreater -= 1
	  Until $aArray[$iGreater] <= $iPivot_2
	  $k = $iLess
	  While $k <= $iGreater
		 $iAk = $aArray[$k]
		 If $iAk < $iPivot_1 Then
			$aArray[$k] = $aArray[$iLess]
			$aArray[$iLess] = $iAk
			$iLess += 1
		 ElseIf $iAk > $iPivot_2 Then
			While $aArray[$iGreater] > $iPivot_2
			   $iGreater -= 1
			   If $iGreater + 1 = $k Then ExitLoop 2
			WEnd
			If $aArray[$iGreater] < $iPivot_1 Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $aArray[$iGreater]
			   $iLess += 1
			Else
			   $aArray[$k] = $aArray[$iGreater]
			EndIf
			$aArray[$iGreater] = $iAk
			$iGreater -= 1
		 EndIf
		 $k += 1
	  WEnd
	  $aArray[$iStart] = $aArray[$iLess - 1]
	  $aArray[$iLess - 1] = $iPivot_1
	  $aArray[$iEnd] = $aArray[$iGreater + 1]
	  $aArray[$iGreater + 1] = $iPivot_2
	  _ArraySort($aArray, $iStart, $iLess - 2, True)
	  _ArraySort($aArray, $iGreater + 2, $iEnd, False)
	  If ($iLess < $iE1) And ($iE5 < $iGreater) Then
		 While $aArray[$iLess] = $iPivot_1
			$iLess += 1
		 WEnd
		 While $aArray[$iGreater] = $iPivot_2
			$iGreater -= 1
		 WEnd
		 $k = $iLess
		 While $k <= $iGreater
			$iAk = $aArray[$k]
			If $iAk = $iPivot_1 Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $iAk
			   $iLess += 1
			ElseIf $iAk = $iPivot_2 Then
			   While $aArray[$iGreater] = $iPivot_2
				  $iGreater -= 1
				  If $iGreater + 1 = $k Then ExitLoop 2
			   WEnd
			   If $aArray[$iGreater] = $iPivot_1 Then
				  $aArray[$k] = $aArray[$iLess]
				  $aArray[$iLess] = $iPivot_1
				  $iLess += 1
			   Else
				  $aArray[$k] = $aArray[$iGreater]
			   EndIf
			   $aArray[$iGreater] = $iAk
			   $iGreater -= 1
			EndIf
			$k += 1
		 WEnd
	  EndIf
	  _ArraySort($aArray, $iLess, $iGreater, False)
   Else
	  Local $iPivot = $aArray[$iE3]
	  $k = $iLess
	  While $k <= $iGreater
		 If $aArray[$k] = $iPivot Then
			$k += 1
			ContinueLoop
		 EndIf
		 $iAk = $aArray[$k]
		 If $iAk < $iPivot Then
			$aArray[$k] = $aArray[$iLess]
			$aArray[$iLess] = $iAk
			$iLess += 1
		 Else
			While $aArray[$iGreater] > $iPivot
			   $iGreater -= 1
			WEnd
			If $aArray[$iGreater] < $iPivot Then
			   $aArray[$k] = $aArray[$iLess]
			   $aArray[$iLess] = $aArray[$iGreater]
			   $iLess += 1
			Else
			   $aArray[$k] = $iPivot
			EndIf
			$aArray[$iGreater] = $iAk
			$iGreater -= 1
		 EndIf
		 $k += 1
	  WEnd
	  _ArraySort($aArray, $iStart, $iLess - 1, True)
	  _ArraySort($aArray, $iGreater + 1, $iEnd, False)
   EndIf
EndFunc
#EndRegion
