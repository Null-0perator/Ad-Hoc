#NoTrayIcon

Local $ScriptDir = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, "\", 0, -1)-1)

FileCopy($ScriptDir & '\SciTE.session', EnvGet('UserProfile') & '\SciTE.session', 1)
RunWait('SciTE.exe', '', @SW_MAXIMIZE)
DirRemove(EnvGet('LocalAppData') & '\AutoIt v3', 1)
FileMove(EnvGet('UserProfile') & '\SciTE.session', $ScriptDir & '\SciTE.session', 1)
