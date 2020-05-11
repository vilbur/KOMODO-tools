;;;#NoTrayIcon
#SingleInstance force

 /** Show current file in places
  *  Makes dir root
  *
  *	@param	string	%1%	Path to browed dir
  *	
  */

;if %1%
;{
	WinGetActiveTitle, ko_title
	$KomodoTitle := "Komodo"
	
	IfNotInString, ko_title, %$KomodoTitle%:
	{
        WinActivate, ahk_exe komodo.exe            
	}
	
	Send, ^!d  ; run script OpenDirInPlaces, open folder browser 
	
	sleep, 50
	SendInput, %1% ; go to dir
	
	Send, {space}{tab}{enter} ; press "Select folder button"
    
;}
