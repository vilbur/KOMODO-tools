/**  Simulate drag & drop of files into window
 *	https://autohotkey.com/board/topic/109578-simulating-drag-and-drop-file-on-to-program/#post_id_651231
 *
 * @example DropFiles( "ahk_class Notepad", "C:\SomeName.txt" ) 
 *
 */
DropFiles(window, files*)
{
  for k,v in files
    memRequired+=StrLen(v)+1
  hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired+21)
  dropfiles := DllCall("GlobalLock", "ptr", hGlobal)
  NumPut(offset := 20, dropfiles+0, 0, "uint")
  for k,v in files
    StrPut(v, dropfiles+offset, "utf-8"), offset+=StrLen(v)+1
  DllCall("GlobalUnlock", "ptr", hGlobal)
  PostMessage, 0x233, hGlobal, 0,, %window%
  if ErrorLevel
    DllCall("GlobalFree", "ptr", hGlobal)
}

/**
 */
bringMaxWindowsToFront()
{
	GroupAdd, $win_group, ahk_exe 3dsmax.exe
	
	WinSet, AlwaysOnTop, On,  ahk_group $win_group
	WinSet, AlwaysOnTop, Off, ahk_group $win_group
}


/*---------------------------------------
	RUN DropFiles() BY CALL OF THIS FILE
-----------------------------------------
*/
$file	= %1%
DropFiles("ahk_class 3DSMAX", $file )

bringMaxWindowsToFront()