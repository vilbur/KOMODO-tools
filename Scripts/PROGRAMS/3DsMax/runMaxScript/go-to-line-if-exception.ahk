/** 1) Close '3Ds Max script exception window' if exist
 *  2) Call 'goToLineInKomodoIfException.komodotool'
 *	
 */

/** Call 'goToLineInKomodoIfException.komodotool'
 */
goToLineInKomodoIfException()
{
	if( checkMaxscriptException() )
		Run, %A_LineFile%\..\get-line-info-from-max.ahk
	
	sleep, 500
	
	$komodo_window :=  WinExist( "ahk_exe komodo.exe" ) 
	
	if( $komodo_window )
		ControlSend,, {Ctrl down}{Alt down}{Shift down}M{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%

}

/** Close '3Ds Max script exception window' 
 */
checkMaxscriptException()
{
	$ms_exception_window :=  WinExist( "MAXScript FileIn Exception" ) 

	if( ! $ms_exception_window )
		return
	
	ControlSend, Button1, {Enter}, ahk_id %$ms_exception_window%
	
	return true
}

goToLineInKomodoIfException()