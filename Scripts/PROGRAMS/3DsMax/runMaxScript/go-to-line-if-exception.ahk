/** 1) Close '3Ds Max script exception window' if exist
 *  2) Call 'goToLineInKomodoIfException.komodotool'
 *
 *
 * IMPORTANT NOTE:
 * Script 'goToLineInKomodoIfException.komodotool'
 * 	MUST HAS SAME SHORTCUT which is send with sendKeyShortcut() 
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
	
	if( !$komodo_window )
		return
		
	sendKeyShortcut($komodo_window)
}
/** Execute 'goToLineInKomodoIfException.komodotool'
 */
sendKeyShortcut($komodo_window)
{
	SetKeyDelay, 10, 10
	BlockInput, on
	
	ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%
	;ControlSend,, {Ctrl down}{Alt down}{Shift down},	ahk_id %$komodo_window%
	;ControlSend,, M,	ahk_id %$komodo_window%
	;ControlSend,, {Ctrl up}{Alt up}{Shift up},	ahk_id %$komodo_window%
	
	BlockInput, off
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