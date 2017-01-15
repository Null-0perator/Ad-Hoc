#NoTrayIcon

Global Const $tagICONRESDIR = "byte Width;byte Height;byte ColorCount;byte Reserved;ushort Planes;ushort BitCount;dword BytesInRes;ushort IconId;"
Global Const $tagNEWHEADER = "ushort Reserved;ushort ResType;ushort ResCount;" ; & $tagICONRESDIR[ResCount]

Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPED = 0
Global Const $WS_SYSMENU = 0x00080000
Global Const $DS_SETFOREGROUND = 0x0200
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $WS_EX_CLIENTEDGE = 0x00000200

Global Const $SS_LEFT = 0x0
Global Const $SS_CENTERIMAGE = 0x0200

Global Const $PBS_MARQUEE = 0x00000008
Global Const $PBS_SMOOTH = 1

Global Const $CBS_DROPDOWNLIST = 0x3
Global Const $CB_GETITEMHEIGHT = 0x154

Global Const $GUI_DROPACCEPTED = 8
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_EVENT_CLOSE = -3

Local $Win, $Input, $Combo, $CmbTmp, $Bar, $SelFldr, $Btn[4], $Compr = 2, $FO[2], $Path, $RunProc, $ReadStr, $Chk, $s = '', $iError

Local $ScriptDir = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, "\", 0, -1)-1)
Local $Dir[3] = [$ScriptDir & '\MakeInstTmp\', '\App\PortApp', EnvGet('LocalAppData') & '\AutoIt v3']
If FileExists('Data') Then
   While FileExists($ScriptDir & '\Data\MakeInstTmp' & $s & '\')
	  $s = $s+1
   WEnd
   $Dir[0] = $ScriptDir & '\Data\MakeInstTmp' & $s
   DirCreate($Dir[0])
   FileSetAttrib($Dir[0], "+H")
Else
   While FileExists($ScriptDir & '\MakeInstTmp' & $s & '\')
	  $s = $s+1
   WEnd
   $Dir[0] = $ScriptDir & '\MakeInstTmp' & $s
   DirCreate($Dir[0])
   FileSetAttrib($Dir[0], "+H")
EndIf
Local $File[6] = [$Dir[0] & '\List.txt', 'App\AutoIt\Aut2Exe\Aut2exe.exe', $Dir[0] & '\Tmp.au3', _
			     $ScriptDir & '\AppArch' & $s & '.exe', $Dir[0] & '\Install.ico', $Dir[0] & '\InstallGrey.ico']
If Not FileExists($File[1]) Then $File[1] = 'Aut2exe.exe'
If Not FileExists($File[1]) Then
   DirRemove($Dir[0], 1)
   Exit
EndIf

Local $RegStr[2] = ["HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI"]
Local $DPI = RegRead($RegStr[0], $RegStr[1]), $TxtSize = Ceiling(8.5*25/2400*$DPI)
If Int(@DesktopWidth/@DesktopHeight*100) >= 170 Then
   Local $WinHeight = Round(14.5*$TxtSize)
   Local $WinWidth = Round(2.4*$WinHeight)
Else
   Local $WinHeight = Round(14.5*$TxtSize)
   Local $WinWidth = Round(2.2*$WinHeight)
EndIf

If $DPI > 220 And $DPI < 481 Then
   $WinHeight = Round(1.05*$WinHeight)
   $WinWidth = Round(1.05*$WinWidth)
ElseIf $DPI > 480 Then
   $WinHeight = Round(1.1*$WinHeight)
   $WinWidth = Round(1.1*$WinWidth)
EndIf

Switch @OSLang
   Case "0419", "0819"
	  Local $Text[12] = ['Упаковщик переносного приложения', 'Введите путь с каталогом "PortApp":', _
		    'Выберите уровень сжатия:', 'Выполнено', 'Архив с приложением находится здесь:', _
		    @CRLF & @CRLF & 'Нажмите кнопку <Да>, если вы хотите удалить исходный каталог ' & _
		    '"PortApp" и создать новый шаблон, <Нет> - только удалить каталог, <Отмена> или <Закрыть> - ' &  _
		    'оставить данный каталог.', '...', 'OK', 'Прервать', 'Закрыть', _
		    'Каталог ', ' уже существует. Продолжить?']
   Case Else
	  Local $Text[12] = ['Portable application packer', 'Enter the path with the "PortApp" folder:', _
		    'Select the compression level:', 'Done', 'Archive with the application is available here:', _
		    @CRLF & @CRLF & 'Press <Yes> button if you want to delete the "PortApp" directory ' & _
		    'and create a new template, <No> - just delete directory, <Cancel> or <Close> - ' &  _
		    'if you don''t want to delete this directory.', '...', 'OK', 'Abort', 'Close', _
		    'Directory ', ' already exists. Do you want to continue?']
EndSwitch

Local $WinSty[2] = [BitOR($WS_CAPTION, $WS_OVERLAPPED, $WS_SYSMENU, $DS_SETFOREGROUND), $WS_EX_ACCEPTFILES]
Local $WinTxt = "Tahoma"
Local $WinColr = 0xfafafa

Local Const $BlkTxt = "Tahoma"
If $DPI > 103 And $DPI < 112 Or $DPI > 135 And $DPI < 144 Then
   Local Const $BlkTxtSz = 9
Else
   Local Const $BlkTxtSz = 8.5
EndIf
Local $BlkLeft[2] = [$TxtSize, $TxtSize]
Local $BlkTop[2] = [Int($WinHeight/14), Int($WinHeight/2.05)]
Local $BlkWidth[2] = [$WinWidth-2*$BlkLeft[0], Int($WinWidth/1.62)]
Local $BlkHeight[2] = [2*$TxtSize, 2*$TxtSize]
Local $BlkSty[2] = [$SS_LEFT, $SS_CENTERIMAGE]

Local $InputLeft = $BlkLeft[0]
Local $InputTop = $BlkTop[0]+Round(2.8*$TxtSize)
Local $InputWidth = Int($WinWidth/1.3)
Local $InputHeight = Round(2.2*$TxtSize)
Local $InputSty = $WS_EX_CLIENTEDGE

Local $BarLeft = $BlkLeft[0]
Local $BarTop = $WinHeight-Round(3.3*$BlkTop[0])
Local $BarWidth = Int($WinWidth/1.62)
Local $BarHeight = 2*Int($WinHeight/14.0)+1
Local $BarSty = BitOR($PBS_MARQUEE, $PBS_SMOOTH)

Local $CmbWidth = Int($WinWidth/5.6)
Local $CmbHeight = Int(2.5*$TxtSize)
Local $CmbLeft = $WinWidth-$CmbWidth-2*$BlkLeft[0]
Local $CmbTop = $BlkTop[1]
Local $CmbSty = $CBS_DROPDOWNLIST

Local Const $BtnTxt = "Tahoma", $BtnTxtSz = $BlkTxtSz
Local $BtnHeight[2] = [Ceiling(2.46*$TxtSize), 2*Int($WinHeight/11.0)+1]
Local $BtnWidth[2] = [Int(1.96*$BtnHeight[0]), 2*Int(5/3*$BtnHeight[1])]
Local $BtnLeft[2] = [$WinWidth-$BtnWidth[0]-$BlkLeft[0], $WinWidth-$BtnWidth[1]-$BlkLeft[0]]
Local $BtnTop[2] = [$InputTop-1, $BarTop+Round($BarHeight/2)-Round($BtnHeight[1]/2)]

$Win = GUICreate($Text[0], $WinWidth, $WinHeight, Default, Default, $WinSty[0], $WinSty[1])
GUISetFont($BlkTxtSz, 400, 0, $WinTxt)
GUISetBkColor($WinColr, $Win)

$Input = GUICtrlCreateInput("", $InputLeft, $InputTop, $InputWidth, $InputHeight, -1, $InputSty)
GUICtrlSetState($Input, $GUI_DROPACCEPTED)

$Combo = GUICtrlCreateCombo("", $CmbLeft, $CmbTop, $CmbWidth, $CmbHeight, $CmbSty)
GUICtrlSetData($Combo, " 0| 1| 2| 3| 4", " 2")
$CmbTmp = _GUICtrlComboBox_GetItemHeight($Combo)+2*3

For $i = 0 To 1
   GUICtrlCreateLabel($Text[$i+1], $BlkLeft[$i], $BlkTop[$i], $BlkWidth[$i], $BlkHeight[$i], $BlkSty[$i])
   GUICtrlSetFont(-1, $BlkTxtSz, 400, 0, $BlkTxt)
Next
GUICtrlSetPos(-1, $BlkLeft[1], Int($BlkTop[1]-$CmbTmp/10), $BlkWidth[1], $CmbTmp)

$Bar = GUICtrlCreateProgress($BarLeft, $BarTop, $BarWidth, $BarHeight, $BarSty)
GUICtrlSetState($Bar, $GUI_HIDE)

$Btn[0] = GUICtrlCreateButton($Text[6], $BtnLeft[0], $BtnTop[0], $BtnWidth[0], $BtnHeight[0])
GUICtrlSetFont($Btn[0], $BtnTxtSz, 400, 0, $BtnTxt)
For $i = 1 To 3
   $Btn[$i] = GUICtrlCreateButton($Text[$i+6], $BtnLeft[1], $BtnTop[1], $BtnWidth[1], $BtnHeight[1])
   GUICtrlSetFont($Btn[$i], $BtnTxtSz, 400, 0, $BtnTxt)
Next
For $i = 2 To 3
   GUICtrlSetState($Btn[$i], $GUI_HIDE)
Next

GUISetState(@SW_SHOW, $Win)
If FileExists($ScriptDir & $Dir[1]) Then
   GUICtrlSetData($Input, $ScriptDir & $Dir[1])
Else
   If StringInStr($ScriptDir, "\") Then
	  GUICtrlSetData($Input, $ScriptDir)
   Else
	  GUICtrlSetData($Input, $ScriptDir & "\")
   EndIf
EndIf

Func _ArchAdd()
   $Path = StringRegExpReplace(GUICtrlRead($Input), "\\+$", "")

   GUICtrlSetState($Input, $GUI_DISABLE)
   GUICtrlSetState($Combo, $GUI_DISABLE)
   GUICtrlSetState($Btn[0], $GUI_DISABLE)
   GUICtrlSetState($Btn[1], $GUI_HIDE)
   GUICtrlSetState($Btn[2], $GUI_SHOW+$GUI_DISABLE)

   $FO[1] = FileOpen($File[2], 2+32)
   RunWait(@ComSpec & ' /U /C DIR /A /B /S > "' & $File[0] & '"', $Path, @SW_HIDE)

   $FO[0] = FileOpen($File[0], 32)
   If $FO[0] = -1 Then
	  FileClose($FO[1])
	  DirRemove($Dir[0], 1)
	  Exit
   EndIf
   FileWrite($FO[1], 'Local $PrcLst = ProcessList(), $Name, $DirName' & @CRLF & _
   'For $i = 1 To $PrcLst[0][0]' & @CRLF & _
   '   If $PrcLst[$i][1] = @AutoItPID Then' & @CRLF & _
   '	  $Name = StringTrimRight($PrcLst[$i][0], 4)' & @CRLF & _
   '	  ExitLoop' & @CRLF & _
   '   EndIf' & @CRLF & _
   'Next' & @CRLF & _
   '$DirName = StringReplace("' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & _
   '", "' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & '", $Name, 1)' & @CRLF & _
   'If FileExists($DirName) Then' & @CRLF & _
   '   If MsgBox(1+32, "", "' & $Text[10] & '""" & $DirName & """' & $Text[11] & '", 10) = 2 Then Exit' & @CRLF & _
   'EndIf' & @CRLF & _
   'DirCreate($DirName)' & @CRLF)
   While True
	  $ReadStr = FileReadLine($FO[0])
	  If @error = -1 Then ExitLoop
	  If StringInStr(FileGetAttrib($ReadStr), "D", 2) <> 0 Then
		 FileWriteLine($FO[1], 'DirCreate(StringReplace("' & StringReplace($ReadStr, _
		 StringTrimRight($Path, StringLen($Path)-StringInStr($Path, "\", 0, -1)), "", 1) & _
		 '", "' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & '", $Name, 1))')
		 If FileGetAttrib($ReadStr) <> "D" Then
			FileWriteLine($FO[1], 'FileSetAttrib(StringReplace("' & StringReplace($ReadStr, _
			StringTrimRight($Path, StringLen($Path)-StringInStr($Path, "\", 0, -1)), "", 1) & _
			'", "' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & '", $Name, 1), "+' & _
			StringReplace(FileGetAttrib($ReadStr), "D", "", 1) & '")')
		 EndIf
	  Else
		 FileWriteLine($FO[1], 'FileInstall("' & $ReadStr & '", StringReplace("' & StringReplace($ReadStr, _
		 StringTrimRight($Path, StringLen($Path)-StringInStr($Path, "\", 0, -1)), "", 1) & _
		 '", "' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & '", $Name, 1), 1)')
		 If FileGetAttrib($ReadStr) <> "A" Then
			FileWriteLine($FO[1], 'FileSetAttrib(StringReplace("' & StringReplace($ReadStr, _
			StringTrimRight($Path, StringLen($Path)-StringInStr($Path, "\", 0, -1)), "", 1) & _
			'", "' & StringTrimLeft($Path, StringInStr($Path, "\", 0, -1)) & '", $Name, 1), "+' & FileGetAttrib($ReadStr) & '")')
		 EndIf
	  EndIf
   WEnd

   FileInstall("Resources\Install.ico", $File[4])
   FileInstall("Resources\InstallGrey.ico", $File[5])
   FileClose($FO[0])
   FileClose($FO[1])

   GUICtrlSetState($Bar, $GUI_SHOW)
   GUICtrlSetState($Btn[2], $GUI_ENABLE)

   If @AutoItX64 Then
	  $RunProc = Run('"' & $File[1] & '"' & ' /in ' & '"' & $File[2] & '"' & ' /out ' & _
	  '"' & $File[3] & '"' & ' /icon ' & '"' & $File[4] & '"' & ' /comp ' & $Compr & _
	  ' /nopack /x64', '', @SW_HIDE)
   Else
	  $RunProc = Run('"' & $File[1] & '"' & ' /in ' & '"' & $File[2] & '"' & ' /out ' & _
	  '"' & $File[3] & '"' & ' /icon ' & '"' & $File[4] & '"' & ' /comp ' & $Compr & _
	  ' /nopack /x86', '', @SW_HIDE)
   EndIf

   $s = 0
   While ProcessExists($RunProc)
	  $s = $s+1
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $Btn[2]
			ProcessClose($RunProc)
			$Chk = 1
			ExitLoop
		 Case Else
			GUICtrlSetData($Bar, $s)
			$Chk = 0
	  EndSwitch
	  Sleep(25)
   WEnd

   GUICtrlSetState($Input, $GUI_ENABLE)
   GUICtrlSetState($Combo, $GUI_ENABLE)
   GUICtrlSetState($Btn[0], $GUI_ENABLE)
   GUICtrlSetState($Bar, $GUI_HIDE)
   GUICtrlSetState($Btn[2], $GUI_HIDE)

   If $Chk = 0 Then
	  GUICtrlSetState($Btn[3], $GUI_SHOW)

	  $iError = 1
	  Do
		 ;Begin update resources
		 Local $hUpdate = _WinAPI_BeginUpdateResource($File[3])
		 If @error Then
			ExitLoop
		 EndIf
		 ;Read .ico file as raw binary data into the structure
		 Local $tIcon = DllStructCreate("ushort Reserved;ushort Type;ushort Count;byte[" & (FileGetSize($File[5])-6) & "]")
		 Local $hFile = _WinAPI_CreateFile($File[5], 2, 2)
		 If Not $hFile Then
			ExitLoop
		 EndIf
		 Local $iBytes = 0
		 _WinAPI_ReadFile($hFile, $tIcon, DllStructGetSize($tIcon), $iBytes)
		 _WinAPI_CloseHandle($hFile)
		 If Not $iBytes Then
			ExitLoop
		 EndIf
		 ;Add all icons from .ico file into the RT_ICON resources and fill group icons structure
		 Local $iCount = DllStructGetData($tIcon, "Count")
		 Local $tDir = DllStructCreate($tagNEWHEADER & "byte[" & (14*$iCount) & "]")
		 Local $pDir = DllStructGetPtr($tDir)
		 DllStructSetData($tDir, "Reserved", 0)
		 DllStructSetData($tDir, "ResType", 1)
		 DllStructSetData($tDir, "ResCount", $iCount)
		 Local $tInfo, $iSize, $tData, $iID = 1
		 Local $pIcon = DllStructGetPtr($tIcon)
		 For $i = 1 To $iCount
			$tInfo = DllStructCreate("byte Width;byte Heigth;byte Colors;byte Reserved;ushort Planes;ushort BPP;dword Size;dword Offset", $pIcon+6+16*($i-1))
			$iSize = DllStructGetData($tInfo, "Size")
			If Not _WinAPI_UpdateResource($hUpdate, 3, $iID, 2057, $pIcon+DllStructGetData($tInfo, "Offset"), $iSize) Then
			   ExitLoop 2
			EndIf
			$tData = DllStructCreate($tagICONRESDIR, $pDir+6+14*($i-1))
			DllStructSetData($tData, "Width", DllStructGetData($tInfo, "Width"))
			DllStructSetData($tData, "Height", DllStructGetData($tInfo, "Heigth"))
			DllStructSetData($tData, "ColorCount", DllStructGetData($tInfo, "Colors"))
			DllStructSetData($tData, "Reserved", 0)
			DllStructSetData($tData, "Planes", DllStructGetData($tInfo, "Planes"))
			DllStructSetData($tData, "BitCount", DllStructGetData($tInfo, "BPP"))
			DllStructSetData($tData, "BytesInRes", $iSize)
			DllStructSetData($tData, "IconId", $iID)
			$iID += 1
		 Next
		 ;Add new RT_GROUP_ICON resource
		 If Not _WinAPI_UpdateResource($hUpdate, 14, 164, 2057, $pDir, DllStructGetSize($tDir)) Then
			ExitLoop
		 EndIf
		 $iError = 0
	  Until True
	  _WinAPI_EndUpdateResource($hUpdate, $iError)

	  Switch MsgBox(3+64, $Text[3], $Text[4] & @CRLF & '"' & $File[3] & '"' & $Text[5], 0, $Win)
		 Case 6
			_NewApp()
		 Case 7
			DirRemove(GUICtrlRead($Input), 1)
	  EndSwitch
   Else
	  GUICtrlSetState($Btn[1], $GUI_SHOW)
   EndIf
EndFunc

Func _NewApp()
   DirRemove(GUICtrlRead($Input), 1)
   DirCreate(GUICtrlRead($Input))
   DirCreate(GUICtrlRead($Input) & "\App")
   DirCreate(GUICtrlRead($Input) & "\Data")
   DirCreate(GUICtrlRead($Input) & "\Source")
   FileWrite(GUICtrlRead($Input) & "\SetLnch.ini", _
   "[CopyMove]" & @CRLF & _
   "ActionBefore=Move" & @CRLF & _
   "ActionAfter=Move" & @CRLF & _
   "[Clean]" & @CRLF & _
   "CleanUpBefore=False" & @CRLF & _
   "CleanUpAfter=False" & @CRLF & _
   "[Splash]" & @CRLF & _
   "SplashShowBefore=False" & @CRLF & _
   "SplashShowAfter=False" & @CRLF & _
   "[Internal]" & @CRLF & _
   "FilesOperations=Success" & @CRLF & _
   "KeysOperations=Success" & @CRLF & _
   "Prog=0" & @CRLF)
EndFunc

While True
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 DirRemove($Dir[0], 1)
		 DirRemove($Dir[2], 1)
		 Exit
	  Case $Combo
		 $Compr = GUICtrlRead($Combo)
	  Case $Btn[0]
		 $SelFldr = FileSelectFolder("", $ScriptDir)
		 If $SelFldr <> "" Then
			GUICtrlSetData($Input, $SelFldr)
		 Else
			GUICtrlSetData($Input, GUICtrlRead($Input))
		 EndIf
	  Case $Btn[1]
		 _ArchAdd()
	  Case $Btn[3]
		 DirRemove($Dir[0], 1)
		 DirRemove($Dir[2], 1)
		 Exit
   EndSwitch
WEnd

#Region Функция из GuiComboBox.au3
Func _GUICtrlComboBox_GetItemHeight($hWnd, $iIndex = -1)
   If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

   Return _SendMessage($hWnd, $CB_GETITEMHEIGHT, $iIndex)
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

#Region Функции из WinAPIRes.au3
Func _WinAPI_BeginUpdateResource($sFilePath, $bDelete = False)
   Local $aRet = DllCall("kernel32.dll", "handle", "BeginUpdateResourceW", "wstr", $sFilePath, "bool", $bDelete)
   If @error Then Return SetError(@error, @extended, 0)
   ;If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_UpdateResource($hUpdate, $sType, $sName, $iLanguage, $pData, $iSize)
   Local $sTypeOfType = "int", $sTypeOfName = "int"
   If IsString($sType) Then
	  $sTypeOfType = "wstr"
   EndIf
   If IsString($sName) Then
	  $sTypeOfName = "wstr"
   EndIf

   Local $aRet = DllCall("kernel32.dll", "bool", "UpdateResourceW", "handle", $hUpdate, $sTypeOfType, $sType, $sTypeOfName, $sName, _
		 "word", $iLanguage, "ptr", $pData, "dword", $iSize)
   If @error Then Return SetError(@error, @extended, False)
   ;If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc

Func _WinAPI_EndUpdateResource($hUpdate, $bDiscard = False)
   Local $aRet = DllCall("kernel32.dll", "bool", "EndUpdateResourceW", "handle", $hUpdate, "bool", $bDiscard)
   If @error Then Return SetError(@error, @extended, False)
   ;If Not $aRet[0] Then Return SetError(1000, 0, 0)

   Return $aRet[0]
EndFunc
#EndRegion

#Region Функции из WinAPI.au3
Func _WinAPI_CreateFile($sFileName, $iCreation, $iAccess = 4, $iShare = 0, $iAttributes = 0, $tSecurity = 0)
   Local $iDA = 0, $iSM = 0, $iCD = 0, $iFA = 0

   If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($iDA, 0x20000000)
   If BitAND($iAccess, 2) <> 0 Then $iDA = BitOR($iDA, 0x80000000)
   If BitAND($iAccess, 4) <> 0 Then $iDA = BitOR($iDA, 0x40000000)

   If BitAND($iShare, 1) <> 0 Then $iSM = BitOR($iSM, 0x00000004)
   If BitAND($iShare, 2) <> 0 Then $iSM = BitOR($iSM, 0x00000001)
   If BitAND($iShare, 4) <> 0 Then $iSM = BitOR($iSM, 0x00000002)

   Switch $iCreation
	  Case 0
		 $iCD = 1
	  Case 1
		 $iCD = 2
	  Case 2
		 $iCD = 3
	  Case 3
		 $iCD = 4
	  Case 4
		 $iCD = 5
   EndSwitch

   If BitAND($iAttributes, 1) <> 0 Then $iFA = BitOR($iFA, 0x00000020)
   If BitAND($iAttributes, 2) <> 0 Then $iFA = BitOR($iFA, 0x00000002)
   If BitAND($iAttributes, 4) <> 0 Then $iFA = BitOR($iFA, 0x00000001)
   If BitAND($iAttributes, 8) <> 0 Then $iFA = BitOR($iFA, 0x00000004)

   Local $aResult = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFileName, "dword", $iDA, "dword", $iSM, _
		 "struct*", $tSecurity, "dword", $iCD, "dword", $iFA, "ptr", 0)
   If @error Or ($aResult[0] = Ptr(-1)) Then Return SetError(@error, @extended, 0)

   Return $aResult[0]
EndFunc

Func _WinAPI_ReadFile($hFile, $pBuffer, $iToRead, ByRef $iRead, $tOverlapped = 0)
   Local $aResult = DllCall("kernel32.dll", "bool", "ReadFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToRead, _
		 "dword*", 0, "struct*", $tOverlapped)
   If @error Then Return SetError(@error, @extended, False)

   $iRead = $aResult[4]
   Return $aResult[0]
EndFunc

Func _WinAPI_CloseHandle($hObject)
   Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
   If @error Then Return SetError(@error, @extended, False)

   Return $aResult[0]
EndFunc
#EndRegion
