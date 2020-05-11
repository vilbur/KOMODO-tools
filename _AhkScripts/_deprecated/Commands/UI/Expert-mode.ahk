#Include  %A_LineFile%\..\..\..\_Lib\Komodo\komodo.ahk

$^+x::

IfWinActive, ahk_exe komodo.exe
	new Komodo().UI.expertMode()

else  
	Send, ^+x
	
exitApp