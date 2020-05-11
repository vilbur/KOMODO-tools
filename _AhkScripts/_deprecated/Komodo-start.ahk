;#NoTrayIcon
#SingleInstance force

Run Komodo
;$path := File(INI(A_LineFile "\..\SetPoint.vini").get("paths","SetPoint")).getPath()
;
;if($path)
;	Run *RunAs %$path%
;else
;	MsgBox,262144,, % "MISSING PATH TO SetPoint.exe`n`nTO FILE:`n" A_ScriptDir "\SetPoint.vini`n`nADD THIS:`n[paths]`nSetPoint=Path\To\SetPoint.exe"