#Include  %A_LineFile%\..\..\..\_Lib\Komodo\komodo.ahk



$Komodo	:= new Komodo()
$path	:= $Komodo.UI.getPathOfSelectedKomodotool()
;dump($path, "$path", 0)
;$Komodo.Komodotool.setFile($path).setIcon().updateFile()

TotalCommander().goTo($path)

