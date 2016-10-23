#Region КОНСТАНТЫ И ПЕРЕМЕННЫЕ
Global Const $HK_RID = True
Global Const $HK_WM_HOTKEY = _WinAPI_RegisterWindowMessage('{509ADA08-BDC8-45BC-8082-1FFA4CB8D1C8}')

Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_EVENT_CLOSE = -3

Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_THICKFRAME = 0x00040000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_STATICEDGE = 0x00020000
Global Const $WS_OVERLAPPEDWINDOW = BitOR($WS_CAPTION, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, _
			   $WS_OVERLAPPED, $WS_SYSMENU, $WS_THICKFRAME)
Global Const $WS_POPUP = 0x80000000
Global Const $DS_SETFOREGROUND = 0x0200
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000

Global Const $SS_LEFT = 0x0
Global Const $SS_CENTERIMAGE = 0x0200

Global Const $BS_CENTER = 0x0300
Global Const $BS_MULTILINE = 0x2000
Global Const $BS_AUTOCHECKBOX = 0x0003

Global Const $PBS_MARQUEE = 0x00000008
Global Const $PBS_SMOOTH = 1

Global Const $CBS_DROPDOWNLIST = 0x3
Global Const $CB_GETITEMHEIGHT = 0x154
Global Const $CBS_NOINTEGRALHEIGHT = 0x400

Global Const $ES_MULTILINE = 4
Global Const $ES_AUTOVSCROLL = 64
Global Const $ES_AUTOHSCROLL = 128
Global Const $ES_WANTRETURN = 4096
Global Const $ES_NOHIDESEL = 256
Global Const $ES_READONLY = 2048
Global Const $EM_LIMITTEXT = 0xC5
Global Const $EM_SETSEL = 0xB1

Global Const $LVSCW_AUTOSIZE_USEHEADER = -2
Global Const $LVSIL_NORMAL = 0
Global Const $LVSIL_SMALL = 1
Global Const $LVSIL_STATE = 2
Global Const $LVS_REPORT = 0x0001
Global Const $LVS_SHOWSELALWAYS = 0x0008
Global Const $LVS_EX_CHECKBOXES = 0x00000004
Global Const $LVS_EX_SUBITEMIMAGES = 0x00000002
Global Const $LVS_EX_FULLROWSELECT = 0x00000020
Global Const $LVS_EX_GRIDLINES = 0x00000001
Global Const $LVS_EX_INFOTIP = 0x00000400
Global Const $LVM_FIRST = 0x1000
Global Const $LVM_SETCOLUMNWIDTH = ($LVM_FIRST + 30)
Global Const $LVM_DELETEALLITEMS = ($LVM_FIRST + 9)
Global Const $LVM_SCROLL = ($LVM_FIRST + 20)
Global Const $LVM_SETIMAGELIST = ($LVM_FIRST + 3)
Global Const $LVM_GETITEMA = ($LVM_FIRST + 5)
Global Const $LVM_GETITEMW = ($LVM_FIRST + 75)
Global Const $LVM_GETITEMCOUNT = ($LVM_FIRST + 4)
Global Const $LVM_SETITEMA = ($LVM_FIRST + 6)
Global Const $LVM_SETITEMW = ($LVM_FIRST + 76)

Global Const $ILC_MASK = 0x00000001
Global Const $ILC_COLOR = 0x00000000
Global Const $ILC_COLORDDB = 0x000000FE
Global Const $ILC_COLOR4 = 0x00000004
Global Const $ILC_COLOR8 = 0x00000008
Global Const $ILC_COLOR16 = 0x00000010
Global Const $ILC_COLOR24 = 0x00000018
Global Const $ILC_COLOR32 = 0x00000020
Global Const $ILC_MIRROR = 0x00002000
Global Const $ILC_PERITEMMIRROR = 0x00008000

Global Const $FILE_BEGIN = 0
Global Const $FILE_END = 2

Global Const $TRAY_ENABLE = 64
Global Const $TRAY_DISABLE = 128

Global $hkTb[1][12] = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, GUICreate('')]], $hkRt[256]
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True

Global Const $tagKBDLLHOOKSTRUCT = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"

Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagGDIPENCODERPARAM = "struct;byte GUID[16];ulong NumberOfValues;ulong Type;ptr Values;endstruct"
Global Const $tagGDIPENCODERPARAMS = "uint Count;" & $tagGDIPENCODERPARAM
Global Const $tagGDIPIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;" & _
			"ptr FormatDesc;ptr FileExt;ptr MimeType;dword Flags;dword Version;dword SigCount;" & _
			"dword SigSize;ptr SigPattern;ptr SigMask"
Global Const $tagGUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"

Global Const $tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;" & _
			"int TextMax;int Image;lparam Param;int Indent;int GroupID;uint Columns;ptr pColumns;" & _
			"ptr piColFmt;int iGroup;endstruct"
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"

Global $__g_hLVLastWnd

Global $__g_vEnum

Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
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

#Region Функции из GDIPlus.au3
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
   $__g_iGDIPRef += 1
   If $__g_iGDIPRef > 1 Then Return True

   If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"

   $__g_hGDIPDll = DllOpen($sGDIPDLL)
   If $__g_hGDIPDll = -1 Then
	  $__g_iGDIPRef = 0
	  Return SetError(1, 2, False)
   EndIf

   Local $sVer = FileGetVersion($sGDIPDLL)
   $sVer = StringSplit($sVer, ".")
   If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False

   Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
   Local $tToken = DllStructCreate("ulong_ptr Data")
   DllStructSetData($tInput, "Version", 1)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   $__g_iGDIPToken = DllStructGetData($tToken, "Data")
   If $bRetDllHandle Then Return $__g_hGDIPDll
   Return SetExtended($sVer[1], True)
EndFunc

Func _GDIPlus_ImageLoadFromFile($sFileName)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "handle*", 0)
   If @error Then Return SetError(@error, @extended, 0)
   If $aResult[0] Then Return SetError(10, $aResult[0], 0)

   Return $aResult[2]
EndFunc

Func _GDIPlus_ImageResize($hImage, $iNewWidth, $iNewHeight, $iInterpolationMode = 7)
   Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iNewWidth, $iNewHeight)
   If @error Then Return SetError(1, 0, 0)
   Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
   If @error Then
	  _GDIPlus_BitmapDispose($hBitmap)
	  Return SetError(2, @extended, 0)
   EndIf
   _GDIPlus_GraphicsSetInterpolationMode($hBmpCtxt, $iInterpolationMode)
   If @error Then
	  _GDIPlus_GraphicsDispose($hBmpCtxt)
	  _GDIPlus_BitmapDispose($hBitmap)
	  Return SetError(3, @extended, 0)
   EndIf
   _GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iNewWidth, $iNewHeight)
   If @error Then
	  _GDIPlus_GraphicsDispose($hBmpCtxt)
	  _GDIPlus_BitmapDispose($hBitmap)
	  Return SetError(4, @extended, 0)
   EndIf
   _GDIPlus_GraphicsDispose($hBmpCtxt)
   Return $hBitmap
EndFunc

Func _GDIPlus_EncodersGetCLSID($sFileExt)
   Local $aEncoders = _GDIPlus_Encoders()
   If @error Then Return SetError(@error, 0, "")
   For $iI = 1 To $aEncoders[0][0]
	  If StringInStr($aEncoders[$iI][6], "*." & $sFileExt) > 0 Then Return $aEncoders[$iI][1]
   Next
   Return SetError(-1, -1, "")
EndFunc

Func _GDIPlus_ParamInit($iCount)
   Local $sStruct = $tagGDIPENCODERPARAMS
   For $i = 2 To $iCount
	  $sStruct &= ";struct;byte[16];ulong;ulong;ptr;endstruct"
   Next
   Return DllStructCreate($sStruct)
EndFunc

Func _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iNbOfValues, $iType, $pValues)
   Local $iCount = DllStructGetData($tParams, "Count")
   Local $pGUID = DllStructGetPtr($tParams, "GUID") + ($iCount * _GDIPlus_ParamSize())
   Local $tParam = DllStructCreate($tagGDIPENCODERPARAM, $pGUID)
   _WinAPI_GUIDFromStringEx($sGUID, $pGUID)
   DllStructSetData($tParam, "Type", $iType)
   DllStructSetData($tParam, "NumberOfValues", $iNbOfValues)
   DllStructSetData($tParam, "Values", $pValues)

   DllStructSetData($tParams, "Count", $iCount + 1)
EndFunc

Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $pParams = 0)
   Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $pParams)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_ImageDispose($hImage)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_Shutdown()
   If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)

   $__g_iGDIPRef -= 1
   If $__g_iGDIPRef = 0 Then
	  DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
	  DllClose($__g_hGDIPDll)
	  $__g_hGDIPDll = 0
   EndIf
   Return True
EndFunc

Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iPixelFormat = 0x0026200A, $iStride = 0, $pScan0 = 0)
   Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "ptr", $pScan0, "handle*", 0)
   If @error Then Return SetError(@error, @extended, 0)
   If $aResult[0] Then Return SetError(10, $aResult[0], 0)

   Return $aResult[6]
EndFunc

Func _GDIPlus_ImageGetGraphicsContext($hImage)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "handle*", 0)
   If @error Then Return SetError(@error, @extended, 0)
   If $aResult[0] Then Return SetError(10, $aResult[0], 0)

   Return $aResult[2]
EndFunc

Func _GDIPlus_BitmapDispose($hBitmap)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_GraphicsDispose($hGraphics)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetInterpolationMode", "handle", $hGraphics, "int", $iInterpolationMode)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $nX, $nY, $nW, $nH)
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRect", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY, _
		 "float", $nW, "float", $nH)
   If @error Then Return SetError(@error, @extended, False)
   If $aResult[0] Then Return SetError(10, $aResult[0], False)

   Return True
EndFunc

Func _GDIPlus_Encoders()
   Local $iCount = _GDIPlus_EncodersGetCount()
   Local $iSize = _GDIPlus_EncodersGetSize()
   Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
   If @error Then Return SetError(@error, @extended, 0)
   If $aResult[0] Then Return SetError(10, $aResult[0], 0)

   Local $pBuffer = DllStructGetPtr($tBuffer)
   Local $tCodec, $aInfo[$iCount + 1][14]
   $aInfo[0][0] = $iCount
   For $iI = 1 To $iCount
	  $tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
	  $aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
	  $aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
	  $aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
	  $aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
	  $aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
	  $aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
	  $aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
	  $aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
	  $aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
	  $aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
	  $aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
	  $aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
	  $aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
	  $pBuffer += DllStructGetSize($tCodec)
   Next
   Return $aInfo
EndFunc

Func _GDIPlus_EncodersGetCount()
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
   If @error Then Return SetError(@error, @extended, -1)
   If $aResult[0] Then Return SetError(10, $aResult[0], -1)

   Return $aResult[1]
EndFunc

Func _GDIPlus_EncodersGetSize()
   Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
   If @error Then Return SetError(@error, @extended, -1)
   If $aResult[0] Then Return SetError(10, $aResult[0], -1)

   Return $aResult[2]
EndFunc

Func _GDIPlus_ParamSize()
   Local $tParam = DllStructCreate($tagGDIPENCODERPARAM)

   Return DllStructGetSize($tParam)
EndFunc
#EndRegion

#Region Функции из GuiComboBox.au3
Func _GUICtrlComboBox_GetItemHeight($hWnd, $iIndex = -1)
   If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

   Return _SendMessage($hWnd, $CB_GETITEMHEIGHT, $iIndex)
EndFunc
#EndRegion

#Region Функции из GuiListView.au3
Func _GUICtrlListView_SetImageList($hWnd, $hHandle, $iType = 0)
   Local $aType[3] = [$LVSIL_NORMAL, $LVSIL_SMALL, $LVSIL_STATE]

   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle, 0, "wparam", "handle", "handle")
   Else
	  Return Ptr(GUICtrlSendMsg($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle))
   EndIf
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
		 $iRet = _SendMessage($hWnd, 0x1000 + 77, 0, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 _MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		 If $bUnicode Then
			$iRet = _SendMessage($hWnd, 0x1000 + 77, 0, $pMemory, 0, "wparam", "ptr")
		 Else
			$iRet = _SendMessage($hWnd, 0x1000 + 7, 0, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, 0x1000 + 77, 0, $pItem)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, 0x1000 + 7, 0, $pItem)
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
		 $iRet = _SendMessage($hWnd, 0x1000 + 76, 0, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 _MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		 If $bUnicode Then
			$iRet = _SendMessage($hWnd, 0x1000 + 76, 0, $pMemory, 0, "wparam", "ptr")
		 Else
			$iRet = _SendMessage($hWnd, 0x1000 + 6, 0, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  DllStructSetData($tItem, "Text", $pBuffer)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, 0x1000 + 76, 0, $pItem)
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, 0x1000 + 6, 0, $pItem)
	  EndIf
   EndIf
   Return $iRet <> 0
EndFunc

Func _GUICtrlListView_GetItemChecked($hWnd, $iIndex)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $tLVITEM = DllStructCreate($tagLVITEM)
   Local $iSize = DllStructGetSize($tLVITEM)
   If @error Then Return SetError(-1, -1, False)
   DllStructSetData($tLVITEM, "Mask", 0x00000008)
   DllStructSetData($tLVITEM, "Item", $iIndex)
   DllStructSetData($tLVITEM, "StateMask", 0xffff)

   Local $iRet
   If IsHWnd($hWnd) Then
	  If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
		 $iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tLVITEM, 0, "wparam", "struct*") <> 0
	  Else
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		 _MemWrite($tMemMap, $tLVITEM)
		 If $bUnicode Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr") <> 0
		 Else
			$iRet = _SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr") <> 0
		 EndIf
		 _MemRead($tMemMap, $pMemory, $tLVITEM, $iSize)
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tLVITEM)
	  If $bUnicode Then
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem) <> 0
	  Else
		 $iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem) <> 0
	  EndIf
   EndIf

   If Not $iRet Then Return SetError(-1, -1, False)
   Return BitAND(DllStructGetData($tLVITEM, "State"), 0x2000) <> 0
EndFunc

Func _GUICtrlListView_SetItemChecked($hWnd, $iIndex, $bCheck = True)
   Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

   Local $pMemory, $tMemMap, $iRet

   Local $tItem = DllStructCreate($tagLVITEM)
   Local $pItem = DllStructGetPtr($tItem)
   Local $iItem = DllStructGetSize($tItem)
   If @error Then Return SetError(-1, -1, -1)
   If $iIndex <> -1 Then
	  DllStructSetData($tItem, "Mask", 0x00000008)
	  DllStructSetData($tItem, "Item", $iIndex)
	  If ($bCheck) Then
		 DllStructSetData($tItem, "State", 0x2000)
	  Else
		 DllStructSetData($tItem, "State", 0x1000)
	  EndIf
	  DllStructSetData($tItem, "StateMask", 0xf000)
	  If IsHWnd($hWnd) Then
		 If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			Return _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0
		 Else
			$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			_MemWrite($tMemMap, $tItem)
			If $bUnicode Then
			   $iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
			   $iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
			Return $iRet <> 0
		 EndIf
	  Else
		 If $bUnicode Then
			Return GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0
		 Else
			Return GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0
		 EndIf
	  EndIf
   Else
	  Local $y = _GUICtrlListView_GetItemCount($hWnd) - 1
	  For $x = 0 To $y
		 DllStructSetData($tItem, "Mask", 0x00000008)
		 DllStructSetData($tItem, "Item", $x)
		 If ($bCheck) Then
			DllStructSetData($tItem, "State", 0x2000)
		 Else
			DllStructSetData($tItem, "State", 0x1000)
		 EndIf
		 DllStructSetData($tItem, "StateMask", 0xf000)
		 If IsHWnd($hWnd) Then
			If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			   If Not _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0 Then Return SetError(-1, -1, -1)
			Else
			   $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			   _MemWrite($tMemMap, $tItem)
			   If $bUnicode Then
				  $iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			   Else
				  $iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			   EndIf
			   _MemFree($tMemMap)
			   If Not $iRet <> 0 Then Return SetError(-1, -1, -1)
			EndIf
		 Else
			If $bUnicode Then
			   If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0 Then Return SetError(-1, -1, -1)
			Else
			   If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0 Then Return SetError(-1, -1, -1)
			EndIf
		 EndIf
	  Next
	  Return True
   EndIf
   Return False
EndFunc

Func _GUICtrlListView_GetItemCount($hWnd)
   If IsHWnd($hWnd) Then
	  Return _SendMessage($hWnd, $LVM_GETITEMCOUNT)
   Else
	  Return GUICtrlSendMsg($hWnd, $LVM_GETITEMCOUNT, 0, 0)
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
		 _SendMessage($hWnd, 0x1000 + 115, $iIndex, $tItem, 0, "wparam", "struct*")
	  Else
		 Local $iItem = DllStructGetSize($tItem)
		 Local $tMemMap
		 Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
		 Local $pText = $pMemory + $iItem
		 DllStructSetData($tItem, "Text", $pText)
		 _MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		 If $bUnicode Then
			_SendMessage($hWnd, 0x1000 + 115, $iIndex, $pMemory, 0, "wparam", "ptr")
		 Else
			_SendMessage($hWnd, 0x1000 + 45, $iIndex, $pMemory, 0, "wparam", "ptr")
		 EndIf
		 _MemRead($tMemMap, $pText, $tBuffer, 4096)
		 _MemFree($tMemMap)
	  EndIf
   Else
	  Local $pItem = DllStructGetPtr($tItem)
	  DllStructSetData($tItem, "Text", $pBuffer)
	  If $bUnicode Then
		 GUICtrlSendMsg($hWnd, 0x1000 + 115, $iIndex, $pItem)
	  Else
		 GUICtrlSendMsg($hWnd, 0x1000 + 45, $iIndex, $pItem)
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

#Region Функции из SendMessage.au3
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
   Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
   If @error Then Return SetError(@error, @extended, "")
   If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
   Return $aResult
EndFunc
#EndRegion

#Region Функции из GuiImageList.au3
Func _GUIImageList_Create($iCX = 16, $iCY = 16, $iColor = 4, $iOptions = 0, $iInitial = 4, $iGrow = 4)
   Local Const $aColor[7] = [$ILC_COLOR, $ILC_COLOR4, $ILC_COLOR8, $ILC_COLOR16, $ILC_COLOR24, $ILC_COLOR32, $ILC_COLORDDB]
   Local $iFlags = 0

   If BitAND($iOptions, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MASK)
   If BitAND($iOptions, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MIRROR)
   If BitAND($iOptions, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILC_PERITEMMIRROR)
   $iFlags = BitOR($iFlags, $aColor[$iColor])
   Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", $iCX, "int", $iCY, "uint", $iFlags, "int", $iInitial, "int", $iGrow)
   If @error Then Return SetError(@error, @extended, 0)
   Return $aResult[0]
EndFunc

Func _GUIImageList_AddIcon($hWnd, $sFile, $iIndex = 0)
   Local $iRet, $tIcon = DllStructCreate("handle Handle")

   $iRet = _WinAPI_ExtractIconEx($sFile, $iIndex, $tIcon, 0, 1)
   If $iRet <= 0 Then Return SetError(-1, $iRet, -1)

   Local $hIcon = DllStructGetData($tIcon, "Handle")
   $iRet = _GUIImageList_ReplaceIcon($hWnd, -1, $hIcon)
   _WinAPI_DestroyIcon($hIcon)
   If $iRet = -1 Then Return SetError(-2, $iRet, -1)
   Return $iRet
EndFunc

Func _GUIImageList_AddIconEx($hWnd, $sFile, $iIndex, $iCX = 16, $iCY = 16)
   Local $iRet, $hInstance, $aData, $iGroupName = 0, $hResource, $hData, $pData, $iIcon, $iSize, $hIcon

   $hInstance = _WinAPI_LoadLibraryEx($sFile, 2)
   If Not $hInstance Then
	  Return SetError(-1, 0, -1)
   EndIf

   $aData = _WinAPI_EnumResourceNames($hInstance, 14)
   If @error Then
	  _WinAPI_FreeLibrary($hInstance)
	  Return SetError(-2, 0, -1)
   EndIf
   For $i = 1 To $aData[0]
	  If $i = $iIndex Then
		 $iGroupName = $aData[$i]
		 ExitLoop
	  EndIf
   Next
   If $iGroupName = 0 Then
	  _WinAPI_FreeLibrary($hInstance)
	  Return SetError(-3, 0, -1)
   EndIf

   $hResource = _WinAPI_FindResource($hInstance, 14, $iGroupName)
   $hData = _WinAPI_LoadResource($hInstance, $hResource)
   $pData = _WinAPI_LockResource($hData)

   If $iCX <= 32 And $iCY <= 32 Then
	  $iIcon = _WinAPI_LookupIconIdFromDirectoryEx($pData, True, 32, 32)
   ElseIf $iCX <= 48 And $iCY <= 48 Then
	  $iIcon = _WinAPI_LookupIconIdFromDirectoryEx($pData, True, 48, 48)
   ElseIf $iCX <= 256 And $iCY <= 256 Then
	  $iIcon = _WinAPI_LookupIconIdFromDirectoryEx($pData, True, 256, 256)
   Else
	  $iIcon = _WinAPI_LookupIconIdFromDirectoryEx($pData, True, 2*$iCX, 2*$iCY)
   EndIf

   $hResource = _WinAPI_FindResource($hInstance, 3, $iIcon)
   $iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
   $hData = _WinAPI_LoadResource($hInstance, $hResource)
   $pData = _WinAPI_LockResource($hData)

   $hIcon = _WinAPI_CreateIconFromResourceEx($pData, $iSize)
   _WinAPI_FreeLibrary($hInstance)

   $iRet = _GUIImageList_ReplaceIcon($hWnd, -1, $hIcon)
   _WinAPI_DestroyIcon($hIcon)
   Return $iRet
EndFunc

Func _GUIImageList_ReplaceIcon($hWnd, $iIndex, $hIcon)
   Local $aResult = DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "handle", $hWnd, "int", $iIndex, "handle", $hIcon)
   If @error Then Return SetError(@error, @extended, -1)
   Return $aResult[0]
EndFunc
#EndRegion

#Region Функции из WinAPIRes.au3
Func _WinAPI_EnumResourceNames($hModule, $sType)
   Local $aRet, $hEnumProc
   Dim $__g_vEnum[101] = [0]
   $hEnumProc = DllCallbackRegister("__EnumResNamesProc", "bool", "handle;ptr;ptr;long_ptr")
   $aRet = DllCall("kernel32.dll", "bool", "EnumResourceNamesW", "handle", $hModule, "int", $sType, _
		 "ptr", DllCallbackGetPtr($hEnumProc), "long_ptr", 0)
   If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then $__g_vEnum = @error + 10
   DllCallbackFree($hEnumProc)
   If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

   __Inc($__g_vEnum, -1)
   Return $__g_vEnum
EndFunc

Func __EnumResNamesProc($hModule, $iType, $iName, $lParam)
   #forceref $hModule, $iType, $lParam

   Local $iLength = _WinAPI_StrLen($iName)
   __Inc($__g_vEnum)
   If $iLength Then
	  $__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate("wchar[" & ($iLength + 1) & "]", $iName), 1)
   Else
	  $__g_vEnum[$__g_vEnum[0]] = Number($iName)
   EndIf
   Return 1
EndFunc

Func _WinAPI_FindResource($hInstance, $sType, $sName)
   Local $sTypeOfType = "int", $sTypeOfName = "int"
   If IsString($sType) Then $sTypeOfType = "wstr"
   If IsString($sName) Then $sTypeOfName = "wstr"

   Local $aRet = DllCall("kernel32.dll", "handle", "FindResourceW", "handle", $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
   If @error Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_LoadResource($hInstance, $hResource)
   Local $aRet = DllCall("kernel32.dll", "handle", "LoadResource", "handle", $hInstance, "handle", $hResource)
   If @error Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_LockResource($hData)
   Local $aRet = DllCall("kernel32.dll", "ptr", "LockResource", "handle", $hData)
   If @error Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_LookupIconIdFromDirectoryEx($pData, $bIcon = True, $iXDesired = 0, $iYDesired = 0, $iFlags = 0)
   Local $aRet = DllCall("user32.dll", "int", "LookupIconIdFromDirectoryEx", "ptr", $pData, "bool", $bIcon, _
		 "int", $iXDesired, "int", $iYDesired, "uint", $iFlags)
   If @error Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_SizeOfResource($hInstance, $hResource)
   Local $aRet = DllCall("kernel32.dll", "dword", "SizeofResource", "handle", $hInstance, "handle", $hResource)
   If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_CreateIconFromResourceEx($pData, $iSize, $bIcon = True, $iDesiredX = 0, $iDesiredY = 0, $iFlags = 0)
   Local $aRet = DllCall("user32.dll", "handle", "CreateIconFromResourceEx", "ptr", $pData, "dword", $iSize, "bool", $bIcon, _
		 "dword", 0x00030000, "int", $iDesiredX, "int", $iDesiredY, "uint", $iFlags)
   If @error Then Return SetError(@error, @extended, 0)
   ; If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc
#EndRegion

#Region Функции из WinAPIInternals.au3
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

Func _WinAPI_StrLen($pString)
   Local $aRet = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pString)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aRet[0]
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

Func _WinAPI_GUIDFromString($sGUID)
   Local $tGUID = DllStructCreate($tagGUID)
   _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
   If @error Then Return SetError(@error + 10, @extended, 0)
   ; If Not _WinAPI_GUIDFromStringEx($sGUID, $tGUID) Then Return SetError(@error + 10, @extended, 0)

   Return $tGUID
EndFunc

Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
   Local $aResult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
   If @error Then Return SetError(@error, @extended, False)

   Return $aResult[0]
EndFunc

Func _WinAPI_WideCharToMultiByte($vUnicode, $iCodePage = 0, $bRetString = True)
   Local $sUnicodeType = "wstr"
   If Not IsString($vUnicode) Then $sUnicodeType = "struct*"
   Local $aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, "int", -1, _
		 	       "ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
   If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, "")

   Local $tMultiByte = DllStructCreate("char[" & $aResult[0] & "]")

   $aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, _
		     "int", -1, "struct*", $tMultiByte, "int", $aResult[0], "ptr", 0, "ptr", 0)
   If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

   If $bRetString Then Return DllStructGetData($tMultiByte, 1)
   Return $tMultiByte
EndFunc

Func _WinAPI_StringFromGUID($tGUID)
   Local $aResult = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $tGUID, "wstr", "", "int", 40)
   If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

   Return SetExtended($aResult[0], $aResult[2])
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

Func _WinAPI_ExtractIconEx($sFile, $iIndex, $pLarge, $pSmall, $iIcons)
   Local $aResult = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sFile, "int", $iIndex, "struct*", $pLarge, _
		 "struct*", $pSmall, "uint", $iIcons)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_DestroyIcon($hIcon)
   Local $aResult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
   If @error Then Return SetError(@error, @extended, False)

   Return $aResult[0]
EndFunc

Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
   Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_FreeLibrary($hModule)
   Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
   If @error Then Return SetError(@error, @extended, False)

   Return $aResult[0]
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
#EndRegion

#Region Функции из WinAPIError.au3
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
   Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
   Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
#EndRegion
