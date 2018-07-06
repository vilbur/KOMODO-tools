/** Open maxscript in Komodo and go to line of MaxScript editor
 *	
 *	1) Get current file and position in 3Ds Max script editor
 *	2) Save position
 *	
 *	
 *	
 */


if( ! WinExist( "ahk_class MXS_SciTEWindow") )
	return
	
/**
 */
createFileInfoFile(  )
{
	$line_info	:= getLineInfoFromMaxscriptEditor()
	$line_info.exception	:= getTextFromExceptionWindow()
	;Dump($line_info, "line_info", 1)
	
	if( iExcluded( $line_info.file ) )
		return
	
	$line_info_file	= %A_LineFile%\..\line-info.json
	
	FileDelete, %$line_info_file% 
	FileAppend, % _joinObject($line_info), %$line_info_file%
}

/**
 */
getTextFromExceptionWindow()
{
	WinGetText, $exception,	MAXScript FileIn Exception 
	

	
	$exception := % SubStr( $exception, 8, StrLen($exception) - 9 ) ; remove 'OK -- Type error:'
	
	$exception	:= RegExReplace( $exception, """", "'" ) ; "
	$exception	:= RegExReplace( $exception, "\t+", "" ) ; "
	$exception	:= RegExReplace( $exception, "\n", "" ) ; "
	
	return $exception	
}

/**
 */
getLineInfoFromMaxscriptEditor()
{
	WinGetTitle, $win_title,	ahk_class MXS_SciTEWindow 
	StatusBarGetText, $status_bar_text,,	ahk_class MXS_SciTEWindow 	

	$file_path	:= RegExReplace( $win_title, "\s-\sMAXScript", "" ) 
	
	RegExMatch( $status_bar_text, "i)li=(\d+)\sco=(\d+)\soffset=(\d+).*", $line_info )
	
	closeMaxscriptEditorFile()

	return	{file:	RegExReplace( $file_path, "\\", "\\" ) 
		,line:	$line_info1
		,col:	$line_info2
		,offset:	$line_info3}
}
/* Close current file in editor
*/
closeMaxscriptEditorFile()
{
	;$editor_window :=  WinExist( "ahk_class MXS_SciTEWindow" ) 
	;ControlSend,, {Ctrl down}W{Ctrl up}, ahk_id %$editor_window%
	
	$hwnd_active := WinActive( "A" ) 
	
	sleep 500
	;SetKeyDelay, 100, 100
	WinActivate, ahk_class MXS_SciTEWindow 
	;ControlSend,, {Ctrl down}w{Ctrl up}, ahk_class MXS_SciTEWindow
	Send, ^w
	sleep 500
	
	WinActivate, ahk_id %$hwnd_active% 
	
}

 /** join object
*/
_joinObject($object, $delimeter:="`n")
{
   For $key, $value in $object
	   $string .= """" $key """:	""" $value ""","
   
   $string := % SubStr( $string, 1, StrLen($string) - 1 )
   ;Dump($string, "string", 1)
   return "{" $string "}"
}



/**
 */
iExcluded( $filepath )
{
	return RegExMatch( $filepath, "i)untitled" )		
} 


createFileInfoFile()
