#NoTrayIcon

Local $FO, $ReadStr, $Icons, $ExtrtIcn, $n = -1
Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)
Local $Dir[3] = ['PortApp\Source\', 'PortApp\', EnvGet('LocalAppData') & '\AutoIt v3']
Local $File[3] = ['', 'AutoIt\Aut2Exe\Aut2exe.exe', $UpDir & '\Data\AppExeLnch.txt']

If Not FileExists($Dir[0]) Then Exit
RunWait(@ComSpec & ' /U /C DEL "' & $UpDir & '\App\PortApp\*.exe' & '" /A /Q /F', '', @SW_HIDE)

If FileGetSize($File[2]) <= 2 And FileExists($Dir[0] & 'PortApp.au3') Then
   If @AutoItX64 Then
	  RunWait('"' & $File[1] & '" /in "' & $Dir[0] & 'PortApp.au3' & '" /out "' & _
	  $Dir[1] & 'PortApp.exe' & '" /icon "' & $Icons & '" /comp 3 /x64', '', @SW_HIDE)
   Else
	  RunWait('"' & $File[1] & '" /in "' & $Dir[0] & 'PortApp.au3' & '" /out "' & _
	  $Dir[1] & 'PortApp.exe' & '" /icon "' & $Icons & '" /comp 3 /x86', '', @SW_HIDE)
   EndIf
   DirRemove($Dir[2], 1)
   Exit
EndIf

$FO = FileOpen($File[2], 32)
If $FO = -1 Then Exit
While True
   $ReadStr = FileReadLine($FO)
   If @error = -1 Then ExitLoop
   $n = $n+1
   $File[0] = StringRegExpReplace($ReadStr, "^(?:.*\\)([^\\]*?)(?:\.[^.]+)?$", "\1") & '.portable'

   If FileExists($Dir[0] & $File[0] & '_' & $n & '.au3') Then
	  $Icons = $Dir[0] & $File[0] & '_' & $n & '.ico'
	  $ExtrtIcn = _ExtractIcon($ReadStr, 1, $Icons)
	  If Not $ExtrtIcn Then $Icons = ''

	  If @AutoItX64 Then
		 RunWait('"' & $File[1] & '" /in "' & $Dir[0] & $File[0] & '_' & $n & '.au3' & '" /out "' & _
		 $Dir[1] & $File[0] & '_' & $n & '.exe' & '" /icon "' & $Icons & '" /comp 3 /x64', '', @SW_HIDE)
	  Else
		 RunWait('"' & $File[1] & '" /in "' & $Dir[0] & $File[0] & '_' & $n & '.au3' & '" /out "' & _
		 $Dir[1] & $File[0] & '_' & $n & '.exe' & '" /icon "' & $Icons & '" /comp 3 /x86', '', @SW_HIDE)
	  EndIf
   ElseIf FileExists($Dir[0] & $File[0] & '.au3') Then
	  $Icons = $Dir[0] & $File[0] & '.ico'
	  $ExtrtIcn = _ExtractIcon($ReadStr, 1, $Icons)
	  If Not $ExtrtIcn Then $Icons = ''

	  If @AutoItX64 Then
		 RunWait('"' & $File[1] & '" /in "' & $Dir[0] & $File[0] & '.au3' & '" /out "' & _
		 $Dir[1] & $File[0] & '.exe' & '" /icon "' & $Icons & '" /comp 3 /x64', '', @SW_HIDE)
	  Else
		 RunWait('"' & $File[1] & '" /in "' & $Dir[0] & $File[0] & '.au3' & '" /out "' & _
		 $Dir[1] & $File[0] & '.exe' & '" /icon "' & $Icons & '" /comp 3 /x86', '', @SW_HIDE)
	  EndIf
   EndIf
WEnd
DirRemove($Dir[2], 1)

Func _ExtractIcon($sFileInput, $iIndex, $sFileOutput)
   Local $hInst, $aResNames, $iGroupName = 0, $IconData, $iID, $aData, $sHDR, $iOffset, $iMIcon, $hFileOpen
   Global $__g_vEnum

   $hInst = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileInput, "ptr", 0, "dword", 2)
   If $hInst[0] = 0 Then
	  Return SetError(-1, 0, "")
   EndIf

   $aResNames = _WinAPI_EnumResourceNames($hInst[0], 14)
   If @error Then
	  DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])
	  Return SetError(-2, 0, "")
   EndIf
   For $i = 1 To $aResNames[0]
	  If $i = $iIndex Then
		 $iGroupName = $aResNames[$i]
		 ExitLoop
	  EndIf
   Next
   If $iGroupName = 0 Then
	  DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])
	  Return SetError(-3, 0, "")
   EndIf

   $IconData = __IconData($hInst[0], 14, $iGroupName)
   If Not $IconData Then
	  DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])
	  Return SetError(-4, 0, "")
   EndIf
   $iID = Dec(__Rb(StringMid($IconData, 11, 4)))
   $aData = StringRegExp(StringTrimLeft(BinaryMid($IconData, 7), 2), "(.{28})", 3)

   Local $aIcon[$iID][2]
   DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])
   $hInst = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileInput, "ptr", 0, "dword", 2)
   For $i = 0 To $iID-1
	  $IconData = __IconData($hInst[0], 3, Dec(__Rb(StringRight($aData[$i], 4))))
	  If Not $IconData Then
		 DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])
		 Return SetError(-4, 0, "")
	  EndIf
	  $aIcon[$i][0] = StringTrimRight($aData[$i], 4)
	  $aIcon[$i][1] = $IconData
   Next
   DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hInst[0])

   $sHDR = "0x00000100" & __Rb(Hex($iID, 4))
   $iOffset = 16*$iID+6
   For $i = 0 To $iID-1
	  $sHDR = $sHDR & $aIcon[$i][0] & __Rb(Hex($iOffset))
	  $iOffset = $iOffset+Dec(__Rb(StringMid($aIcon[$i][0], 17, 8)))
	  $iMIcon = $iMIcon & StringTrimLeft($aIcon[$i][1], 2)
   Next

   $hFileOpen = FileOpen($sFileOutput, 2+8+16)
   If Not FileWrite($hFileOpen, $sHDR & $iMIcon) Then
	  FileClose($hFileOpen)
	  Return SetError(-5, 0, "")
   EndIf
   FileClose($hFileOpen)

   Return True
EndFunc

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

Func _WinAPI_StrLen($pString)
   Local $aRet = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pString)
   If @error Then Return SetError(@error, @extended, 0)

   Return $aRet[0]
EndFunc

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

Func __IconData($hInstance, $sType, $sName)
   Local $hResource, $hData, $pData, $iSize, $tResource, $tData

   $hResource = DllCall("kernel32.dll", "handle", "FindResourceA", "handle", $hInstance, "int", $sName, "int", $sType)
   If @error Then Return SetError(@error, @extended, 0)

   $iSize = DllCall("kernel32.dll", "dword", "SizeofResource", "handle", $hInstance, "handle", $hResource[0])
   If @error Then Return SetError(@error, @extended, 0)

   $hData = DllCall("kernel32.dll", "handle", "LoadResource", "handle", $hInstance, "handle", $hResource[0])
   If @error Then Return SetError(@error, @extended, 0)

   $pData = DllCall("kernel32.dll", "ptr", "LockResource", "handle", $hData[0])
   If @error Then Return SetError(@error, @extended, 0)

   $tResource = DllStructCreate("byte[" & $iSize[0] & "]", $pData[0])
   $tData = DllStructGetData($tResource, 1)

   Return $tData
EndFunc

Func __Rb($sBYTE)
   Local $AX = StringRegExp($SBYTE, "(.{2})", 3), $SX = ""
   For $i = UBound($AX) - 1 To 0 Step -1
	  $SX = $SX & $AX[$i]
   Next
   Return $SX
EndFunc
