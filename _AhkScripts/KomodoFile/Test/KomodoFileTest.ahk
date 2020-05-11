#SingleInstance force

#Include %A_LineFile%\..\..\KomodoFile.ahk

$KomodoFile 	:= new KomodoFile()


dump( $KomodoFile.getFile(), 	"getFile()" )
dump( $KomodoFile.getProject(),	"getProject()" )