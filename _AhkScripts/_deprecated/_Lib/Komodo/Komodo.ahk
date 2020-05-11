;#NoTrayIcon
#SingleInstance force
    
#Include  %A_LineFile%\..\Lib\KomodoBase.ahk
#Include  %A_LineFile%\..\Lib\UserChrome.ahk
#Include  %A_LineFile%\..\Lib\UI.ahk
#Include  %A_LineFile%\..\Lib\KomodoFile.ahk
#Include  %A_LineFile%\..\Lib\Komodotool\Komodotool.ahk

global $UserChrome
/**
	Class Komodo
*/
Class Komodo extends KomodoBase {
	
	Komodotool	:= new Komodotool()
	UI	:= new UI()
	KomodoFile	:= new KomodoFile()	
	
	__New(){
		$UserChrome := new UserChrome()
	}
	/** activate
	*/
	activate(){
		WinActivate, ahk_exe komodo.exe
		return this
	}
	
	
}


/*
-----------------------------------------------
	TEST FUNCTIONS
-----------------------------------------------
*/
/** Komodo_OpenToolbox
*/
Komodo_OpenToolbox(){
	new Komodo()
		;.UI.sidebar("toolbox")
		.goToSelectedToolboxItem()
}
/** Komodo_File
*/
Komodo_File(){
	$KomodoFile := new Komodo().KomodoFile
	dump($KomodoFile.getFile(), "$KomodoFile.getFile()", 0)
	dump($KomodoFile.getProject(), "$KomodoFile.getProject()", 0)
}
/** Komodo_updateIconOfSelectedTool
*/
Komodo_updateIconOfSelectedTool(){
	$Komodo	:= Komodo()
	$Komodotool_path	:= $Komodo.UI.getPathOfSelectedKomodotool()
	$Komodo.Komodotool.setFile($Komodotool_path).setIcon().updateFile()
-
}

/* 
-----------------------------------------------
	RUN TEST
-----------------------------------------------
*/
;Komodo_OpenToolbox()
;Komodo_File()
