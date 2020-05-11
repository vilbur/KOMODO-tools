#Include  %A_LineFile%\..\Menu.ahk
#Include  %A_LineFile%\..\Toolbox.ahk
/**
	Class UI
*/
Class UI {

	;Menu	:= new Menu()
	Toolbox	:= new Toolbox()
	menu_paths	:= {"toolbox":["view", "down|right|down 4"]}
	
	;__New(){
	;	;MsgBox,262144,, UI, 2
	;}
	/** activate
	*/
	activate(){
		;MsgBox,262144,, activate, 2
		;dump($UserChrome, "$UserChrome", 1)
		;sleep, 5000
		WinActivate, ahk_exe komodo.exe
		return this
	}	
	/** open
	*/
	sidebar($sidebar){
		this.activate()
		if($UserChrome.find("sidebar",$sidebar)) ; if sidebar is displayed
			return
		SetKeyDelay, 100, 50
		if(!$is_shown)
		new Menu("View").item("Tabs & Sidebars").submenu($sidebar)
		sleep, 200 ; wait for animation
	}
	/** expertMode
	*/
	expertMode(){
		this.activate()
		new Menu("View").item("Full Screen")
		sleep, 200
		;WinGet, $win_state, MinMax, ahk_exe komodo.exe
		;if ( $win_state != 0 ){
			;sleep, 2000		
			WinMaximize, ahk_exe komodo.exe
		;}
		
		return this

	}
	
	/** getPathOfSelectedKomodotool
	*/
	getPathOfSelectedKomodotool(){
		this.sidebar("Toolbox")
		return % this.Toolbox.getPathOfSelected()
	}
	

}


/*
-----------------------------------------------
	TEST FUNCTIONS
-----------------------------------------------
*/
/** Komodo_OpenToolbox
*/
UI_OpenToolbox(){
	global $UserChrome := new UserChrome()
	$UI := new UI()
	$UI.expertMode()
	;$UI.getPathOfSelectedKomodotool()
				;.openContextMenu()
				
				
	;$UI.Toolbox
	
	.cursorToSelectedFolder()
}

/* 
----------------------------------------------------------------------------------------------
	RUN TEST - LAUNCH TESTS VIA Komodo.ahk because of includes
----------------------------------------------------------------------------------------------
*/
;UI_OpenToolbox()
	