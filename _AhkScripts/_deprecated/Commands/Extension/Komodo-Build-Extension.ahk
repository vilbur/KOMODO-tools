#Include %A_LineFile%\..\includes.ahk
/*
	Build "*.xpi" Komodo extension file
	@param string $path	is path to extension source folder, this folder must contain file "chrome.manifest"

*/
;;;#NoTrayIcon
#SingleInstance force
$reinstall	= %1%

$compile_dir := A_WorkingDir
;MsgBox,262144,SCRIPT NEED REVISION, c:\GoogleDrive\Programs\Core\Komodo\_AhkScripts\Commands\Extension\Komodo-Build-Extension.ahk

if(InStr( FileExist($compile_dir), "D" )==0 )
	SplitPath, $compile_dir,, $compile_dir
$compile_dir := RegExReplace( $compile_dir, "\\+$", "" )

If FileExist( $compile_dir ) {
	GoSub, BuldExtension
	if($reinstall!="")
		GoSub,	installAndRestartKomodo
}
else
	MsgBox,262144,, Path:%$compile_dir%`nDoes not contain chrome.manifest file, 5

return

/*
	BuldExtension
*/
	BuldExtension:
		$ini = %A_AppData%\AppsConfig\Programs.ini

		$path_python := """C:\Program Files (x86)\ActiveState Komodo IDE 10\lib\python\python.exe"""

		;;; FOR  EXTENSION
		;$path_koext := """C:\Program Files (x86)\ActiveState Komodo IDE 10\lib\sdk\bin\koext.py"" build -i chrome.manifest -d"
		$path_koext := """C:\Program Files (x86)\ActiveState Komodo IDE 10\lib\sdk\bin\koext.py"" build -i chrome.manifest -d"

		$cmd := $path_python " " $path_koext " """ $compile_dir """"
		;MsgBox,262144,, cmd:`n%$cmd%, 20
		clipboard := $cmd
		RunWait, %$cmd%

return

/*
	installAndRestartKomodo
*/
installAndRestartKomodo:

	;$path_komodo	:= INI($ini).get("paths", "komodo")
	;MsgBox,262144,, path_install:`n%$path_install%, 20

	loop, %$compile_dir%\*.xpi, 0, 0-Recurseive
		$path_install	:= "komodo.exe "	" """ A_LoopFileFullPath """"
		;$path_xpi	:=
		
	;MsgBox,262144,path_install, %$path_install% 

	if($path_install!="")
	{
		Run, %$path_install%
		setTitleMatchMode, 1
		WinWaitActive, Komodo, , 2
		if not ErrorLevel
			send, !r
	}



return

