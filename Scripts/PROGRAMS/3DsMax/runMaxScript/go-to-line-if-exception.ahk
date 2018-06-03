/** 1) Close '3Ds Max script exception window' if exist
 *  2) Call 'goToLineInKomodoIfException.komodotool'
 *	
 */

/** Call 'goToLineInKomodoIfException.komodotool'
 */
goToLineInKomodoIfException()
{
	if( ! maxscriptExceptionWindowExists() )
		return
		
	Run, %A_LineFile%\..\get-line-info-from-max.ahk
	
	sleep, 100
	
	closeExceptionWindow()
	
	$komodo_window :=  WinExist( "ahk_exe komodo.exe" ) 
	
	if( $komodo_window )
		ControlSend,, {Ctrl down}{Alt down}{Shift down}M{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%
}



/** Close '3Ds Max script exception window' 
 */
maxscriptExceptionWindowExists()
{
	return % WinExist( "MAXScript FileIn Exception" ) 
}
/**
 */
closeExceptionWindow()
{
	GroupAdd, MaxExceptions, MAXScript FileIn Exception
	
	WinClose, ahk_group MaxExceptions

	return true	
}
goToLineInKomodoIfException()