#SingleInstance Force
;#InstallKeybdHook
;#NoTrayIcon



/**
 */
saveIni($current_path)
{
	;%A_LineFile%
	
	SplitPath, A_LineFile	,,$path_parent
	SplitPath, $current_path	,$filename
	
	$ini_path := $path_parent "\run-maxscript-via-notepad-komodo.ini"

	
	IniRead, $last_path, %$ini_path%, last_executed_maxscript, path

	
	if( $last_path == "ERROR" || $last_path != $current_path  )
		IniWrite, %$current_path%, %$ini_path%, last_executed_maxscript, path
	
	
	if( $last_path != $current_path )
	
		MsgBox,262144,New script, %$filename%,2
	
}

/** Close '3Ds Max script exception window' 
 */
killMaxscriptExceptionWindow()
{
	
	SetTitleMatchMode, RegEx

	While WinExist( "MAXScript.*Exception") != "0x0"

	{
		$hwnd :=  WinExist( "MAXScript.*Exception")

		sleep 500

		ControlSend, , {NumpadEnter}, ahk_id %$hwnd%
	}
}
/**
 */
sendFilePathTomaxListener( $file_in_path )
{

	$file_in_command := "filein @""" $file_in_path """"

	saveIni($file_in_path)

	
	WinActivate, ahk_class Qt5151QWindowIcon
	;MsgBox,262144,file_in_command, %$file_in_command%
	ControlSetText , MXS_Scintilla2, %$file_in_command% , A

	ControlSend, MXS_Scintilla2, {NumpadEnter}, A

	
}

/**
 */
runMaxscript()
{
	;killMaxscriptExceptionWindow()

	WinGetTitle, $notepad_title,	ahk_exe notepad++.exe 
	WinGetTitle, $komodo_title,	ahk_exe komodo.exe

	if( $notepad_title != "" )
	
	{
		RegExMatch( $notepad_title, "i)(.*\.ms)", $win_title_match )

	
		sendFilePathTomaxListener( $win_title_match )
	
	}
	else if( $komodo_title != "" )
	{

		RegExMatch( $komodo_title,  "i)(.*\.ms)\**.*\((.*)\).*", $win_title_match )
		RegExMatch( $komodo_title,  "\*", $file_is_not_saved )

		if( $win_title_match != "" )
		{

			if( $file_is_not_saved != "" )		
			{

				WinActivate, ahk_exe komodo.exe
	
				Send {Ctrl down}{s}{Ctrl up}
	
			}
	
			sendFilePathTomaxListener(  $win_title_match2 "\\" $win_title_match1 )
	
		}

	}

}
runMaxscript()
;saveIni()
