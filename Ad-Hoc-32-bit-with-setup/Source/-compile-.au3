#NoTrayIcon

Global Const $tagICONRESDIR = "byte Width;byte Height;byte ColorCount;byte Reserved;ushort Planes;ushort BitCount;dword BytesInRes;ushort IconId;"
Global Const $tagNEWHEADER = "ushort Reserved;ushort ResType;ushort ResCount;" ; & $tagICONRESDIR[ResCount]

Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1))
Local $FileCompIn[] = ['AdHoc.Main', 'Vrf_Prep.Main', 'DataArch.Main', 'FileDiff.Main', 'GenAu3.Main', _
	  'GenExe.Main', 'MakeInst.Main', 'RegDiff.Main', 'StrMngr.Main', 'SciTE.portable', 'SetPort.Main']
Local $FileCompOut[] = ['AdHoc', 'App\Vrf_Prep', 'App\DataArch', 'App\FileDiff', 'App\GenAu3', _
	  'App\GenExe', 'MakeInst', 'App\RegDiff', 'App\StrMngr', 'App\AutoIt\SciTe\SciTE.portable', _
	  'SetPort']
Local $FileIco[] = ['AdHoc.Icon', 'Vrf_Prep.Icon', 'DataArch.Icon', 'FileDiff.Icon', 'GenAu3.Icon', _
	  'GenExe.Icon', 'MakeInst.Icon', 'RegDiff.Icon', 'StrMngr.Icon', 'SciTE.Icon', 'SetPortUnPort.Icon', _
	  'SetPortPort.Icon']

Switch @OSLang
   Case "0419", "0819"
	  Local $MsgB = MsgBox(3, "", "Скомпилировать скрипты для 64-битных версий Windows?")
   Case Else
	  Local $MsgB = MsgBox(3, "", "Do you want to compile scripts for systems with x64 (64-bit) architecture?")
EndSwitch

If $MsgB = 6 Then
   For $i = 0 To UBound($FileCompIn)-1
	  RunWait('"' & $UpDir & 'App\AutoIt\Aut2Exe\Aut2exe.exe" /in ' & $FileCompIn[$i] & _
	  '.au3 /out "' & $UpDir & $FileCompOut[$i] & '.exe" /icon Resources\' & $FileIco[$i] & _
	  '.ico /comp 3 /x64')
   Next
   FileCopy('Resources\LVIcons.dll', $UpDir & 'App\')
ElseIf $MsgB = 7 Then
   For $i = 0 To UBound($FileCompIn)-1
	  RunWait('"' & $UpDir & 'App\AutoIt\Aut2Exe\Aut2exe.exe" /in ' & $FileCompIn[$i] & _
	  '.au3 /out "' & $UpDir & $FileCompOut[$i] & '.exe" /icon Resources\' & $FileIco[$i] & _
	  '.ico /comp 3 /x86')
   Next
   FileCopy('Resources\LVIcons.dll', $UpDir & 'App\')
Else
   Exit
EndIf

Local $iError = 1
Do
   ;Begin update resources
   Local $hUpdate = _WinAPI_BeginUpdateResource($UpDir & $FileCompOut[10] & ".exe")
   If @error Then
	  ExitLoop
   EndIf
   ;Read .ico file as raw binary data into the structure
   Local $tIcon = DllStructCreate("ushort Reserved;ushort Type;ushort Count;byte[" & _
	     (FileGetSize("Resources\" & $FileIco[UBound($FileIco)-1] & ".ico")-6) & "]")
   Local $hFile = _WinAPI_CreateFile("Resources\" & $FileIco[UBound($FileIco)-1] & ".ico", 2, 2)
   If Not $hFile Then
	  ExitLoop
   EndIf
   Local $iBytes = 0
   _WinAPI_ReadFile($hFile, $tIcon, DllStructGetSize($tIcon), $iBytes)
   _WinAPI_CloseHandle($hFile)
   If Not $iBytes Then
	  ExitLoop
   EndIf
   ;Add all icons from .ico file into the RT_ICON resources identified as 400, 401, etc., and fill group icons structure
   Local $iCount = DllStructGetData($tIcon, "Count")
   Local $tDir = DllStructCreate($tagNEWHEADER & "byte[" & (14*$iCount) & "]")
   Local $pDir = DllStructGetPtr($tDir)
   DllStructSetData($tDir, "Reserved", 0)
   DllStructSetData($tDir, "ResType", 1)
   DllStructSetData($tDir, "ResCount", $iCount)
   Local $tInfo, $iSize, $tData, $iID = 400
   Local $pIcon = DllStructGetPtr($tIcon)
   For $i = 1 To $iCount
	  $tInfo = DllStructCreate("byte Width;byte Heigth;byte Colors;byte Reserved;ushort Planes;ushort BPP;dword Size;dword Offset", $pIcon+6+16*($i-1))
	  $iSize = DllStructGetData($tInfo, "Size")
	  If Not _WinAPI_UpdateResource($hUpdate, 3, $iID, 0, $pIcon+DllStructGetData($tInfo, "Offset"), $iSize) Then
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
   If Not _WinAPI_UpdateResource($hUpdate, 14, '', 0, $pDir, DllStructGetSize($tDir)) Then
	  ExitLoop
   EndIf
   $iError = 0
Until True
_WinAPI_EndUpdateResource($hUpdate, $iError)

DirRemove(EnvGet('LocalAppData') & '\AutoIt v3', 1)

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
