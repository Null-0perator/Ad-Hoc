Local $StrWin[4] = ["Ad Hoc 1.00", "System scan settings", "Attention!", "This files were not copied/moved:"]

Local $StrMsg[4] = ["Comparison is not possible. Check system scan settings.", _
	 "Do you want to clear out the ""...\PortApp\Data"" folder?", _
	 "Do you want to make an installation file of existing portable application?", _
	 "Are you sure?"]

Local $StrBlk[16] = ["", _
	 "You have run Ad Hoc 1.00", _
	 "This program is intended for portable applications creating in the PAF format (PortableApps.com Format)." & @CRLF & @CRLF & _
	 "A brief description of the PAF structure consists of a launcher, directory with the installed application and directory with the application settings." & @CRLF & @CRLF & _
	 "The portable application that was created by Ad Hoc runs from any directory and it does not leave any traces of its work in the operating system." & @CRLF & @CRLF & _
	 "Click Next button to continue.", _
	 "Please wait...", _
	 "Now proceed with the application installation." & @CRLF & @CRLF & _
	 "The application should be installed in the ""...\Ad Hoc\App\PortApp\App"" directory. For more details about portable program structure see Readme.rtf." & @CRLF & @CRLF & _
	 "After installing a program if it prompts you to reboot the computer, do it.", _
	 "Data comparison...", _
	 "Copying files...", _
	 "Moving files...", _
	 "File verification and lists preparing...", _
	 "Select executable files for the launchers:", _
	 "Creating AutoIt source code...", _
	 "Done. Click Compile button to build launchers.", _
	 "Select disks for scan:", _
	 "CPUs:", _
	 "Do you want to edit data with StrMngr.exe?", _
	 "Would you like to add ""...\PortApp\Data"" folder to the archive, thereby creating a backup copy of it?"]

Local $StrBtn[14] = ["Next >", "< Back", "Abort", "Cancel", "OK", "Compile", "Run", "Settings", _
	 "Yes", "Yes, always", "No", "No, never", "Always add", "Never add"]

Local $StrGrp[4] = ["Choose one of two options:", _
	 "Perform an initial registry and file system scan", _
	 "Perform a final registry and file system scan", _
	 "Select registry root keys for scan:"]

Local $StrRad[2] = ["Primary data collection", "Search for file system changes"]

Local $StrTlTp[5] = ["Check it if application has not been installed" & @CRLF & "yet", _
	 "Select it if reboot has been done after installing" & @CRLF & "application", _
	 "If checked, all files in the ""...\Ad Hoc\Data"" will be" & @CRLF & "deleted except Settings.ini", _
	 "Adding to archive...", _
	 "Compiling..."]

Local $StrChk[4] = ["HKEY_LOCAL_MACHINE", "HKEY_CURRENT_USER", " Move files and registry data instead of" & @CRLF & " copying its", _
	 "Delete temporary files"]

Local $StrLiVw[2] = ["Name|Path", "Disk name|Volume"]

Local $StrCntxt[5] = ["Select", "Unselect", "", "Select all", "Unselect all"]

Local $StrUnitInf = " GB"

Local $StrTray[7] = ["Retry adding to archive", "Retry compiling scripts", "", _
	 "Abort adding to archive", "Abort compiling scripts", "", "Exit"]
