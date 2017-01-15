#include "AdHoc.01.Include.au3"

#Region ÎÁÚßÂËÅÍÈÅ ÏÅÐÅÌÅÍÍÛÕ
Local $MSG, $EncodID, $PrmLst, $QualCreate, $PntrStruc, $FO[3], $LvImg, $AddIcn, $VarDr[2], $IniVal, $RS_D, _
	  $ReadStr, $InsTxt, $RunProc, $NumPr, $IniNumPr
Local $Win[6], $Pic[20], $ImRsz[12], $Sep[4], $Blk[16], $Grp[4], $Rad[2], $Bar[6], $ChkBox[4], $LiVw[2] = [0, 0], _
	  $Combo, $Edit, $NextBtn[5], $BackBtn[6], $CancBtn[3], $AbrtBtn[6], $BtnSc[2], $BtnSet[2], $MsgBtn[4], _
	  $TrayItm[7], $CmbTmp, $BtnTmp
#EndRegion

#Region ÈÍÈÖÈÀËÈÇÀÖÈß ÏÅÐÅÌÅÍÍÛÕ
Global Const $CK_CONTROL = 0x0200
Global Const $VK_ADD = 0x6B
Global Const $VK_SUBTRACT = 0x6D

Local $DrLst = DriveGetDrive("FIXED")
Local $Chk[5] = [False, True, False, False, False]
Local $RegStr[2] = ["HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "AppliedDPI"]
Local $FileMask[12] = [".exe", ".msi", ".bat", ".cmd", ".js", ".jse", ".msc", ".ps1", ".vbe", ".vbs", ".wsf", ".wsh"]
Local $DPI = RegRead($RegStr[0], $RegStr[1]), $TxtSize = Ceiling(8.5*25/2400*$DPI)

Switch @OSLang
   Case "0419", "0819"
	  #include "AdHoc.01.01.Russian.au3"

	  Local $Proc = ProcessList(@ScriptName)
	  For $i = 1 To $Proc[0][0]
		 If _WinAPI_GetProcessFileName($Proc[$i][1]) = @ScriptFullPath Then
			If $Chk[0] Then
			   MsgBox(48, "", "Ïðèëîæåíèå óæå çàïóùåíî")
			   Exit
			EndIf
			$Chk[0] = True
		 EndIf
	  Next
   Case Else
	  #include "AdHoc.01.02.English.au3"

	  Local $Proc = ProcessList(@ScriptName)
	  For $i = 1 To $Proc[0][0]
		 If _WinAPI_GetProcessFileName($Proc[$i][1]) = @ScriptFullPath Then
			If $Chk[0] Then
			   MsgBox(48, "", "The application is already running")
			   Exit
			EndIf
			$Chk[0] = True
		 EndIf
	  Next
EndSwitch

If Int(@DesktopWidth/@DesktopHeight*100) >= 170 Then
   Local $WinHeight[4] = [36*$TxtSize, Round(30.6*$TxtSize), Round(0.331*34*$TxtSize), Round(0.39*34*$TxtSize)]
   Local $WinWidth[4] = [Round(1.67*$WinHeight[0]), Round(1.76*$WinHeight[1]), Round(1.11*$WinHeight[0]), Round(1.25*$WinHeight[0])]
Else
   Local $WinHeight[4] = [36*$TxtSize, Round(30.6*$TxtSize), Round(0.331*34*$TxtSize), Round(0.39*34*$TxtSize)]
   Local $WinWidth[4] = [Round(1.62*$WinHeight[0]), Round(1.67*$WinHeight[1]), Round(1.07*$WinHeight[0]), Round(1.17*$WinHeight[0])]
EndIf

If $DPI > 220 And $DPI < 481 Then
   For $i = 0 To 3
	  $WinHeight[$i] = Round(1.05*$WinHeight[$i])
	  $WinWidth[$i] = Round(1.05*$WinWidth[$i])
   Next
ElseIf $DPI > 480 Then
   For $i = 0 To 3
	  $WinHeight[$i] = Round(1.1*$WinHeight[$i])
	  $WinWidth[$i] = Round(1.1*$WinWidth[$i])
   Next
EndIf

Local $ScriptDir = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, "\", 0, -1))
Local $IniPrm[2] = ["HKEY_LOCAL_MACHINE", "HKEY_CURRENT_USER"]
Local $Dir[6] = [@TempDir & "\Ad\", "App\PortApp\", "App\PortApp\Data\", _
					 "App\PortApp\Source\", "App\", "Data\"]
Local $File[22] = ["AdHoc.02.2.FileInstall.au3", "Data\Settings.ini", "Data\SysFiles_", _
					 "Data\RegData_", "Data\FilesDiff.txt", "Data\DataFilesTmp.txt", _
					 "Data\NotCpMv.txt", "Data\DataFiles.txt", "Data\RegKeys.txt", _
					 "Data\RegInfo.ini", "StrMngr.exe", "Data\AppExe.txt", _
					 "Data\AppExeLnch.txt", "App\FileDiff.exe", "App\RegDiff.exe", _
					 "App\Vrf_Prep.exe", "App\GenAu3.exe", "App\DataArch.exe", _
					 "App\GenExe.exe", "MakeInst.exe", "App\LVIcons.dll", _
					 "AdHoc.02.3.FileInstall.au3"]
Local $Envir[12] = ["AppData", "LocalAppData", "UserProfile", "Public", "AllUsersProfile", _
					 "CommonProgramFiles", "CommonProgramFiles(x86)", "ProgramFiles", _
					 "ProgramFiles(x86)", "WinDir", "Temp", "HomeDrive"]
If FileExists($Dir[0]) Then $Dir[0] = $Dir[5] & "Ad\"

Local Const $WinSty[3] = [Default, BitOR($WS_CAPTION, $WS_OVERLAPPED, $WS_SYSMENU, $DS_SETFOREGROUND), _
		     BitOR($WS_OVERLAPPEDWINDOW, $WS_POPUP)]
Local Const $WinParnt[2] = [Default, $Win[0]], $WinColr = 0xfafafa

Local $PicWidth[7], $PicHeight[7], $PicLeft[7], $PicTop[7]
	  $PicWidth[0] = Int($WinWidth[0]/3)
	  $PicWidth[1] = Int($WinWidth[0]/6)
	  $PicWidth[2] = $PicWidth[1]
	  $PicWidth[3] = Int($WinWidth[0]/5.6)
	  $PicWidth[4] = Int($WinWidth[0]/2.9)
	  $PicWidth[5] = Round($WinHeight[0]/10)
	  $PicWidth[6] = Round($WinHeight[0]/9)
	  $PicHeight[0] = $WinHeight[0]-2*Int($WinHeight[0]/14.7)-2*Int(Int($WinHeight[0]/13.4)/2)+Int($WinHeight[0]/13.4)-1
	  $PicHeight[1] = Int($PicWidth[1]/2)
	  $PicHeight[2] = $PicHeight[1]
	  $PicHeight[3] = Int($PicWidth[3]*1029/1257)
	  $PicHeight[4] = Int($PicWidth[4]*1029/1257)
	  $PicHeight[5] = $PicWidth[5]
	  $PicHeight[6] = $PicWidth[6]
	  $PicLeft[0] = 0
	  $PicLeft[1] = Int($WinHeight[0]/22.5)
	  $PicLeft[2] = $WinWidth[0]-$PicLeft[1]-$PicWidth[2]
	  $PicLeft[3] = Int($WinHeight[0]/5)
	  $PicLeft[4] = $WinWidth[0]-$PicLeft[3]-$PicWidth[4]
	  $PicLeft[5] = Int(1/5*$WinWidth[2])-$PicWidth[5]
	  $PicLeft[6] = Int(1/5.8*$WinWidth[3])-$PicWidth[6]
	  $PicTop[0] = 0
	  $PicTop[1] = Int(0.6*Int($WinHeight[0]/7.5))-Int($PicHeight[1]/2)
	  $PicTop[2] = $PicTop[1]
	  $PicTop[3] = $PicHeight[0]-$PicHeight[3]-Int($WinHeight[0]/9.73)
	  $PicTop[4] = $PicHeight[0]-$PicHeight[4]-Int($WinHeight[0]/12.8)
	  $PicTop[5] = Round($WinHeight[2]/4.5)
	  $PicTop[6] = Round($WinHeight[3]/4.1)

Local Const $SepSty = $SS_LEFT, $SepColr = 0x878787
Local $SepWidth[4], $SepHeight[4], $SepLeft[4], $SepTop[4], $SepTmp = Int($WinHeight[0]/11.6)
	  $SepWidth[0] = $WinWidth[0]
	  $SepWidth[1] = 1
	  $SepWidth[2] = $SepWidth[0]
	  $SepWidth[3] = $WinWidth[1]
	  $SepHeight[0] = 1
	  $SepHeight[1] = $PicHeight[0]
	  $SepHeight[2] = $SepHeight[0]
	  $SepHeight[3] = $SepHeight[0]
	  $SepLeft[0] = 0
	  $SepLeft[1] = $PicWidth[0]
	  $SepLeft[2] = $SepLeft[0]
	  $SepLeft[3] = $SepLeft[0]
	  $SepTop[0] = Int(1.2*Int($WinHeight[0]/7.5))
	  $SepTop[1] = 0
	  $SepTop[2] = $PicHeight[0]
	  $SepTop[3] = $WinHeight[1]-2*Int($WinHeight[1]/12.6)-2*Int($SepTmp/2)+$SepTmp-$SepHeight[0]

Local Const $BlkSty[2] = [$SS_LEFT, $SS_CENTERIMAGE], $BlkTxt[2] = ["Lucida Sans Unicode", "Tahoma"]
If $DPI > 103 And $DPI < 112 Or $DPI > 135 And $DPI < 144 Then
   Local Const $BlkTxtSz[2] = [11, 9]
Else
   Local Const $BlkTxtSz[2] = [11, 8.5]
EndIf
Local $BlkWidth[16], $BlkHeight[16], $BlkLeft[16], $BlkTop[16]
	  $BlkWidth[0] = $WinWidth[0]
	  $BlkWidth[1] = Int(2/3*$WinWidth[0])-Int($WinHeight[0]/10)
	  $BlkWidth[2] = $BlkWidth[1]
	  $BlkWidth[3] = $WinWidth[0]-2*Int($WinHeight[0]/20)
	  $BlkWidth[4] = $WinWidth[0]-2*Int($WinHeight[0]/13.3)
	  For $i = 5 To 9
	     $BlkWidth[$i] = $BlkWidth[3]
	  Next
	  $BlkWidth[10] = $WinWidth[0]-2*Int($WinHeight[0]/16)
	  $BlkWidth[11] = $BlkWidth[3]
	  $BlkWidth[12] = $WinWidth[1]-2*Int($WinHeight[0]/20)
	  $BlkWidth[13] = Int($WinHeight[0]/8)
	  $BlkWidth[14] = $WinWidth[2]-3*$PicLeft[5]
	  $BlkWidth[15] = $WinWidth[3]-3*$PicLeft[6]
	  $BlkHeight[0] = $SepTop[0]-1
	  $BlkHeight[1] = Int($WinHeight[0]/16.36)
	  $BlkHeight[2] = $SepTop[2]-Int(2.6*Int($WinHeight[0]/13))-Int($WinHeight[0]/13)+1
	  $BlkHeight[3] = Int($WinHeight[0]/20)
	  $BlkHeight[4] = $SepTop[2]-$SepTop[0]-2*Int($WinHeight[0]/13)
	  For $i = 5 To 10
	     $BlkHeight[$i] = $BlkHeight[3]
	  Next
	  $BlkHeight[11] = $BlkHeight[3]
	  $BlkHeight[12] = $BlkHeight[3]
	  $BlkHeight[13] = Int($WinHeight[0]/15)
	  $BlkHeight[14] = Int($WinHeight[0]/20)
	  $BlkHeight[15] = Int($WinHeight[0]/10)
	  $BlkLeft[0] = 0
	  $BlkLeft[1] = $PicWidth[0]+Int(1.8*$TxtSize)
	  $BlkLeft[2] = $BlkLeft[1]
	  $BlkLeft[3] = Int($WinHeight[0]/20)
	  $BlkLeft[4] = Int($WinHeight[0]/13.3)
	  For $i = 5 To 9
	     $BlkLeft[$i] = $BlkLeft[3]
	  Next
	  $BlkLeft[10] = Int($WinHeight[0]/16)
	  $BlkLeft[11] = $BlkLeft[3]
	  $BlkLeft[12] = $BlkLeft[3]
	  $BlkLeft[13] = $BlkLeft[12]
	  $BlkLeft[14] = $PicLeft[5]+$PicWidth[5]+Int($WinHeight[0]/40)
	  $BlkLeft[15] = $PicLeft[6]+$PicWidth[6]+Int($WinHeight[0]/40)
	  $BlkTop[0] = 0
	  $BlkTop[1] = Int($WinHeight[0]/13)
	  $BlkTop[2] = Int(2.6*$BlkTop[1])-1
	  $BlkTop[3] = $SepTop[0]+$BlkTop[1]
	  $BlkTop[4] = $BlkTop[3]
	  For $i = 5 To 8
	     $BlkTop[$i] = $BlkTop[3]
	  Next
	  $BlkTop[9] = Int(1.1*($SepTop[0])+0.55*($BlkTop[1]))-Int($WinHeight[0]/40)
	  $BlkTop[10] = Int(1.55*$SepTop[0])
	  $BlkTop[11] = $SepTop[0]+Int($WinHeight[0]/14)
	  $BlkTop[12] = Int($WinHeight[0]/36)
	  $BlkTop[13] = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int($BlkHeight[13]/2)
	  $BlkTop[14] = $PicTop[5]+Round(0.33*$BlkHeight[14])
	  $BlkTop[15] = $PicTop[6]+Round(0.08*$BlkHeight[14])

Local Const $GrpTxt = "Tahoma", $GrpTxtSz = $BlkTxtSz[1]
Local $GrpSty[4]
	  $GrpSty[0] = Default
	  $GrpSty[1] = $BS_CENTER
	  $GrpSty[2] = $GrpSty[1]
	  $GrpSty[3] = $GrpSty[0]
Local $GrpLeft[4], $GrpTop[4], $GrpWidth[4], $GrpHeight[4]
	  $GrpLeft[0] = $BlkLeft[3]
	  $GrpLeft[1] = $GrpLeft[0]
	  $GrpLeft[2] = $GrpLeft[0]
	  $GrpLeft[3] = Int($WinHeight[0]/13.3)
	  $GrpTop[0] = $BlkTop[3]
	  $GrpTop[1] = $GrpTop[0]
	  $GrpTop[2] = $GrpTop[0]
	  $GrpTop[3] = Round(0.36*$WinHeight[1])+Int($WinHeight[0]/8)
	  $GrpWidth[0] = $WinWidth[0]-2*$GrpLeft[0]+1
	  $GrpWidth[1] = $GrpWidth[0]
	  $GrpWidth[2] = $GrpWidth[0]
	  $GrpWidth[3] = $WinWidth[1]-2*$GrpLeft[3]+1
	  $GrpHeight[0] = $WinHeight[0]-2*$GrpTop[0]
	  $GrpHeight[1] = Int(0.67*$WinHeight[0])-$GrpTop[0]
	  $GrpHeight[2] = $GrpHeight[1]
	  $GrpHeight[3] = 6*Round(0.3*$WinHeight[1]/6)

Local Const $RadTxt = "Tahoma", $RadTxtSz = $BlkTxtSz[1]
Local $RadLeft[2], $RadTop[2], $RadWidth[2], $RadHeight[2]
	  $RadLeft[0] = Int($WinWidth[0]/10.5)
	  $RadLeft[1] = $RadLeft[0]
	  $RadTop[0] = $GrpTop[0]+Int((11/40)*$GrpHeight[0])
	  $RadTop[1] = $GrpTop[0]+Int(0.51*$GrpHeight[0])
	  $RadWidth[0] = $WinWidth[0]-2*$RadLeft[0]
	  $RadWidth[1] = $RadWidth[0]
	  $RadHeight[0] = Int($WinHeight[0]/20)
	  $RadHeight[1] = $RadHeight[0]

Local Const $ChkSty = BitOR($BS_AUTOCHECKBOX, $BS_MULTILINE), $ChkTxt = "Tahoma", $ChkTxtSz = $BlkTxtSz[1]
Local $ChkLeft[4], $ChkTop[4], $ChkWidth[4], $ChkHeight[4]
	  $ChkLeft[0] = Int(4.8*$TxtSize)
	  $ChkLeft[1] = $ChkLeft[0]
	  $ChkLeft[2] = $GrpLeft[3]
	  $ChkLeft[3] = $BlkLeft[3]
	  $ChkTop[0] = $GrpTop[3]+$GrpHeight[3]/3-2*Int($WinHeight[0]/160)+1
	  $ChkTop[1] = $GrpTop[3]+$GrpHeight[3]*2/3-2*Int($WinHeight[0]/160)+1
	  $ChkTop[2] = $WinHeight[1]-Int($WinHeight[1]/7.4)-1
	  $ChkTop[3] = $WinHeight[0]-Int(($SepTop[0]+Int($WinHeight[0]/40))/2)
	  $ChkWidth[0] = $WinWidth[1]-2*$ChkLeft[0]
	  $ChkWidth[1] = $ChkWidth[0]
	  $ChkWidth[2] = $WinWidth[1]-6*$ChkLeft[2]
	  $ChkWidth[3] = Int(0.4*$WinWidth[1])
	  $ChkHeight[0] = 2*Int($BlkHeight[3]/2)
	  $ChkHeight[1] = $ChkHeight[0]
	  $ChkHeight[2] = 2*$ChkHeight[0]
	  $ChkHeight[3] = $ChkHeight[0]

Local $BarSty[6]
	  $BarSty[0] = BitOR($PBS_MARQUEE, $PBS_SMOOTH)
	  $BarSty[1] = $BarSty[0]
	  $BarSty[2] = $BarSty[0]
	  $BarSty[3] = $PBS_SMOOTH
	  $BarSty[4] = $BarSty[0]
	  $BarSty[5] = $BarSty[0]
Local $BarLeft, $BarTop, $BarWidth, $BarHeight
	  $BarLeft = $BlkLeft[4]
	  $BarTop = Int(1.6*$GrpTop[0])
	  $BarWidth = $WinWidth[0]-2*$BarLeft
	  $BarHeight = Int($WinHeight[0]/18)

Local Const $LiVwColWd[2] = [Int($WinHeight[0]/2.05), $LVSCW_AUTOSIZE_USEHEADER]
Local Const $LiVwSty[3] = [BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), _
		     BitOR($LVS_EX_CHECKBOXES, $LVS_EX_SUBITEMIMAGES, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE), _
		     BitOR($LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE)]
If $DPI < 104 Then
   Local Const $LiVwImg[2] = [17, 17]
Else
   Local Const $LiVwImg[2] = [Round($WinHeight[0]/20), Round($WinHeight[0]/20)]
EndIf
Local $LiVwLeft[2], $LiVwTop[2], $LiVwWidth[2], $LiVwHeight[2]
	  $LiVwLeft[0] = Int($WinHeight[0]/13.3)
	  $LiVwLeft[1] = $LiVwLeft[0]
	  $LiVwTop[0] = Int(1.1*$GrpTop[0])
	  $LiVwTop[1] = Int($WinHeight[0]/9.5)
	  $LiVwWidth[0] = $WinWidth[0]-2*$LiVwLeft[0]
	  $LiVwWidth[1] = $WinWidth[1]-2*$LiVwLeft[1]
	  $LiVwHeight[0] = $SepTop[2]-$LiVwTop[0]+$SepHeight[2]
	  $LiVwHeight[1] = Int(0.35*$WinHeight[1])

Local Const $CmbSty = BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_NOINTEGRALHEIGHT)
Local $CmbWidth, $CmbHeight, $CmbLeft, $CmbTop
	  $CmbWidth = Int(1.1*$BlkWidth[13])
	  $CmbHeight = Int($WinHeight[0]/4)
	  $CmbLeft = $BlkLeft[13]+$BlkWidth[13]
	  $CmbTop = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int(Int($WinHeight[0]/15)/2)

Local Const $EditSty[2] = [BitOR($ES_MULTILINE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $WS_VSCROLL, $WS_HSCROLL, $ES_NOHIDESEL, $ES_READONLY, $ES_WANTRETURN), _
		     BitOR($WS_EX_STATICEDGE, $WS_EX_CLIENTEDGE)]
Local Const $EditTxt = "Segoe UI", $EditTxtSz = $BlkTxtSz[1]+1
Local $EditLeft, $EditTop, $EditWidth, $EditHeight
	  $EditLeft = 0
	  $EditTop = 0
	  $EditWidth = Int(1.8*$WinHeight[0])
	  $EditHeight = $WinHeight[0]

Local Const $BtnTxt = "Tahoma", $BtnTxtSz[2] = [$BlkTxtSz[1], $BlkTxtSz[1]+1]
Local $BtnHeight[6+2], $BtnWidth[6+2], $BtnTop[6+2], $BtnLeft[6+2*4]
	  $BtnHeight[0] = Int($WinHeight[0]/13.4)
	  $BtnHeight[1] = $BtnHeight[0]
	  $BtnHeight[2] = $BtnHeight[0]
	  $BtnHeight[3] = Int(Int($WinHeight[0]/7.5)/1.72)
	  $BtnHeight[4] = $BtnHeight[0]
	  $BtnHeight[5] = $BtnHeight[0]
	  $BtnHeight[6] = $BtnHeight[0]
	  $BtnHeight[7] = $BtnHeight[0]
	  $BtnWidth[0] = Int(0.25*$WinHeight[0])
	  $BtnWidth[1] = $BtnWidth[0]
	  $BtnWidth[2] = $BtnWidth[0]
	  $BtnWidth[3] = 2*Int(0.14*$WinHeight[0])
	  $BtnWidth[4] = 2*Int($BtnWidth[0]/2)
	  $BtnWidth[5] = $BtnWidth[0]
	  $BtnWidth[6] = $BtnWidth[0]
	  $BtnWidth[7] = $BtnWidth[0]
	  $BtnTop[0] = $WinHeight[0]-Int($WinHeight[0]/14.7)-Int($BtnHeight[0]/2)
	  $BtnTop[1] = $BtnTop[0]
	  $BtnTop[2] = $BtnTop[0]
	  $BtnTop[3] = $GrpTop[1]+Int(0.29*$GrpHeight[1])
	  $BtnTop[4] = $GrpTop[1]+Int(0.6*$GrpHeight[1])
	  $BtnTop[5] = $WinHeight[1]-Int($WinHeight[1]/12.6)-Int($BtnHeight[5]/2)
	  $BtnTop[6] = $WinHeight[2]-Int($WinHeight[2]/5.5)-Int($BtnHeight[6]/2)
	  $BtnTop[7] = $WinHeight[3]-Int($WinHeight[3]/6.5)-Int($BtnHeight[7]/2)
	  $BtnLeft[0] = $WinWidth[0]-Int(1.17*$BtnWidth[0])
	  $BtnLeft[1] = $BtnLeft[0]-Int(10/9*$BtnWidth[0])
	  $BtnLeft[2] = $BtnLeft[1]-$BtnWidth[1]
	  $BtnLeft[3] = Int(($WinWidth[0]-$BtnWidth[3])/2)
	  $BtnLeft[4] = Int(($WinWidth[0]-$BtnWidth[4])/2)
	  $BtnLeft[5] = $WinWidth[1]-Int(1.19*$BtnWidth[1])
	  $BtnLeft[9] = $WinWidth[2]-$BtnWidth[6]-Int($WinHeight[2]/5.5)-Int($BtnHeight[6]/2)+$BtnHeight[6]
	  $BtnLeft[8] = $BtnLeft[9]-$BtnWidth[6]-Round($TxtSize/10)
	  $BtnLeft[7] = $BtnLeft[9]-2*$BtnWidth[6]-2*Round($TxtSize/10)
	  $BtnLeft[6] = $BtnLeft[9]-3*$BtnWidth[6]-3*Round($TxtSize/10)
	  $BtnLeft[13] = $WinWidth[3]-$BtnWidth[7]-Int($WinHeight[3]/6.5)-Int($BtnHeight[7]/2)+$BtnHeight[7]
	  $BtnLeft[12] = $BtnLeft[13]-$BtnWidth[7]-Round($TxtSize/10)
	  $BtnLeft[11] = $BtnLeft[13]-2*$BtnWidth[7]-2*Round($TxtSize/10)
	  $BtnLeft[10] = $BtnLeft[13]-3*$BtnWidth[7]-3*Round($TxtSize/10)
#EndRegion
