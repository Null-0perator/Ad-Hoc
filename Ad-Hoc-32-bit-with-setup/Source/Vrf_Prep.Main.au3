#NoTrayIcon

Local $IniVal, $FO[3], $ReadStr, $WrStr, $RunProc, $Msv, $Bnd
Local $FileMask = '*.bat *.cmd *.exe *.js *.jse *.msc *.msi *.ps1 *.vbe *.vbs *.wsf *.wsh'
Local $UpDir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "\", 0, -1)-1)
Local $Dir = $UpDir & '\App\PortApp'
Local $File[6] = [$UpDir & '\Data\Settings.ini', $UpDir & '\Data\FilesDiff.txt', _
			    $UpDir & '\Data\DataFilesTmp.txt', $UpDir & '\Data\NotCpMv.txt', _
				$UpDir & '\Data\AppExe.txt', $UpDir & '\Data\DataFiles.txt']

$IniVal = IniRead($File[0], "Vrf_Prep", "IsVerify", "")
If $IniVal = "True" Then
   $IniVal = IniRead($File[0], "CopyMove", "IsMove", "0")
   If $IniVal = "1" Then
	  $FO[0] = FileOpen($File[1], 32)
	  If $FO[0] = -1 Then Exit
	  $FO[1] = FileOpen($File[3], 2+32)
	  While True
		 $ReadStr = FileReadLine($FO[0])
		 If @error = -1 Then ExitLoop
		 If FileExists($ReadStr) Then
			FileWriteLine($FO[1], $ReadStr)
		 EndIf
	  WEnd
	  FileClose($FO[0])
	  FileClose($FO[1])
   Else
	  $FO[0] = FileOpen($File[1], 32)
	  If $FO[0] = -1 Then Exit
	  $FO[1] = FileOpen($File[2], 32)
	  If $FO[1] = -1 Then
		 FileClose($FO[0])
		 Exit
	  EndIf
	  $FO[2] = FileOpen($File[3], 2+32)
	  While True
		 $WrStr = FileReadLine($FO[0])
		 $ReadStr = FileReadLine($FO[1])
		 If @error = -1 Then ExitLoop
		 If Not FileExists($ReadStr) Then
			FileWriteLine($FO[2], $WrStr)
		 EndIf
	  WEnd
	  FileClose($FO[0])
	  FileClose($FO[1])
	  FileClose($FO[2])
   EndIf
Else
   $FO[0] = FileOpen($File[3], 2+32)
   FileClose($FO[0])
EndIf

$RunProc = Run(@ComSpec & ' /U /C DIR ' & $FileMask & ' /A:-D /B /S > "' & $File[4] & '"', $Dir, @SW_HIDE)

$FO[0] = FileOpen($File[5], 32)
$Msv = FileReadToArray($FO[0])
_ArraySort($Msv)
$Bnd = UBound($Msv)-1
FileClose($FO[0])

$FO[0] = FileOpen($File[5], 2+32)
For $i = 0 To $Bnd
   FileWriteLine($FO[0], $Msv[$i])
Next
FileClose($FO[0])

While ProcessExists($RunProc)
   Sleep(100)
WEnd

;Функция __ArrayDualPivotSort() из Array.au3
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
