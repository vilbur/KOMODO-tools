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
	
	return	{file:	RegExReplace( $file_path, "\\", "\\" ) 
		,line:	$line_info1
		,col:	$line_info2
		,offset:	$line_info3}
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
createFileInfoFile(  )
{
	$line_info	:= getLineInfoFromMaxscriptEditor()
	$line_info.exception	:= getTextFromExceptionWindow()
	;Dump($line_info, "line_info", 1)
	;MsgBox,262144,, % getTextFromExceptionWindow(),2 
	$line_info_file	= %A_LineFile%\..\line-info.json
	
	FileDelete, %$line_info_file% 
	FileAppend, % _joinObject($line_info), %$line_info_file%
}


createFileInfoFile()
