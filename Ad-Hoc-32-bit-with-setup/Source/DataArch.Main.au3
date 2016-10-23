#NoTrayIcon

Global Const $tagICONRESDIR = "byte Width;byte Height;byte ColorCount;byte Reserved;ushort Planes;ushort BitCount;dword BytesInRes;ushort IconId;"
Global Const $tagNEWHEADER = "ushort Reserved;ushort ResType;ushort ResCount;" ; & $tagICONRESDIR[ResCount]

Local $FO[2], $ReadStr, $iError
Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)
Local $Dir[5] = [$UpDir & '\App\PortApp\', 'PortApp\App\DefData', $UpDir & '\App\PortApp\Data', _
			    $UpDir & '\Data\DataArchTmp\', EnvGet('LocalAppData') & '\AutoIt v3']
Local $File[7] = [$UpDir & '\Data\Settings.ini', $Dir[3] & 'AppDataFiles.txt', _
			    $UpDir & '\App\AutoIt\Aut2Exe\Aut2exe.exe', $Dir[3] & 'FileInstTmp.au3', _
			    $Dir[1] & '\DefaultData.exe', $Dir[3] & 'Install.ico', $Dir[3] & 'InstallGrey.ico']

#Region œŒƒ√Œ“Œ¬ ¿ .EXE-‘¿…À¿
If Not FileExists($Dir[2]) Then Exit
$FO[1] = FileOpen($File[3], 2+8+32)
RunWait(@ComSpec & ' /U /C DIR "' & $Dir[2] & '" /A /B /S > "' & $File[1] & '"', '', @SW_HIDE)
$FO[0] = FileOpen($File[1], 32)
If $FO[0] = -1 Then Exit
FileWriteLine($FO[1], _
'$UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)' & @CRLF & _
'$UpDir = StringLeft($UpDir, StringInStr($UpDir, "\", 0, -1)-1)' & @CRLF & _
'If $UpDir & "\App\DefData" = @ScriptDir Then' & @CRLF & _
'   Local $Path = $UpDir & "\"' & @CRLF & _
'Else' & @CRLF & _
'   Local $Path = ""' & @CRLF & _
'EndIf' & @CRLF & _
'DirCreate($Path & "Data")' & @CRLF)
While True
   $ReadStr = FileReadLine($FO[0])
   If @error = -1 Then ExitLoop
   If StringInStr(FileGetAttrib($ReadStr), "D", 2) Then
	  FileWriteLine($FO[1], 'DirCreate($Path & "' & StringReplace($ReadStr, $Dir[0], "", 1) & '")')
	  If FileGetAttrib($ReadStr) <> "D" Then
		 FileWriteLine($FO[1], 'FileSetAttrib($Path & "' & StringReplace($ReadStr, $Dir[0], "", 1) & '", ' & _
		 '"+' & StringReplace(FileGetAttrib($ReadStr), "D", "", 1) & '")')
	  EndIf
   Else
	  FileWriteLine($FO[1], 'FileInstall("' & $ReadStr & '", $Path & "' & StringReplace($ReadStr, _
	  $Dir[0], "", 1) & '", 1)')
	  If FileGetAttrib($ReadStr) <> "A" Then
		 FileWriteLine($FO[1], 'FileSetAttrib($Path & "' & StringReplace($ReadStr, $Dir[0], "", 1) & '", ' & _
		 '"+' & FileGetAttrib($ReadStr) & '")')
	  EndIf
   EndIf
WEnd
FileClose($FO[0])
FileClose($FO[1])

If Not FileExists($Dir[1]) Then DirCreate($Dir[1])
FileInstall("Resources\Install.ico", $File[5])
FileInstall("Resources\InstallGrey.ico", $File[6])

Local $IniVal = IniRead($File[0], "DataArch", "Compress", "")
If $IniVal = "0" Or $IniVal = "1" Or $IniVal = "2" Or $IniVal = "3" Or $IniVal = "4" Then
   If @AutoItX64 Then
	  RunWait('"' & $File[2] & '"' & ' /in ' & '"' & $File[3] & '"' & ' /out ' & _
	  '"' & $File[4] & '"' & ' /icon ' & '"' & $File[5] & '"' & ' /comp ' & $IniVal & _
	  ' /nopack /x64', '', @SW_HIDE)
   Else
	  RunWait('"' & $File[2] & '"' & ' /in ' & '"' & $File[3] & '"' & ' /out ' & _
	  '"' & $File[4] & '"' & ' /icon ' & '"' & $File[5] & '"' & ' /comp ' & $IniVal & _
	  ' /nopack /x86', '', @SW_HIDE)
   EndIf
Else
   If @AutoItX64 Then
	  RunWait('"' & $File[2] & '"' & ' /in ' & '"' & $File[3] & '"' & ' /out ' & _
	  '"' & $File[4] & '"' & ' /icon ' & '"' & $File[5] & '"' & ' /comp 2 /nopack /x64', _
	  '', @SW_HIDE)
   Else
	  RunWait('"' & $File[2] & '"' & ' /in ' & '"' & $File[3] & '"' & ' /out ' & _
	  '"' & $File[4] & '"' & ' /icon ' & '"' & $File[5] & '"' & ' /comp 2 /nopack /x86', _
	  '', @SW_HIDE)
   EndIf
EndIf
#EndRegion

#Region «¿Ã≈Õ¿ «Õ¿◊ ¿ ¬ “–≈≈
$iError = 1
Do
   ;Begin update resources
   Local $hUpdate = _WinAPI_BeginUpdateResource($File[4])
   If @error Then
	  ExitLoop
   EndIf
   ;Read .ico file as raw binary data into the structure
   Local $tIcon = DllStructCreate("ushort Reserved;ushort Type;ushort Count;byte[" & (FileGetSize($File[6])-6) & "]")
   Local $hFile = _WinAPI_CreateFile($File[6], 2, 2)
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
#EndRegion

DirRemove($Dir[3], 1)
DirRemove($Dir[4], 1)

#Region ‘ÛÌÍˆËË ËÁ WinAPIRes.au3
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

#Region ‘ÛÌÍˆËË ËÁ WinAPI.au3
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
