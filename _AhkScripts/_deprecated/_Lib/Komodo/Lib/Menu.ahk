/**
	Class Menu
*/
Class Menu {

	ini_path	:= ""
	menu	:= ""

	__New($menu){
		this.menu	:= $menu
		this.ini_path	:= A_LineFile "\..\\" $menu ".ini"
		this._openMenu()
	}
	
	/** item
	*/
	item($item){
		IniRead, $items_ini, % this.ini_path
		this.goToItem($items_ini, $item )
		return this
	}
	/** _setSubItemNumber
	*/
	submenu($item){
		IniRead, $items_ini, % this.ini_path, % this.menu_item
		this.goToItem($items_ini, $item )
	}
	
	/** goToItem
	*/
	goToItem($items_ini, $item){
		$menu_items	:= Arr(StrSplit( $items_ini, "`n"))
		$item_num	:= $menu_items.indexOf($item)
		;;; /* select items from TOP or BOTTOM */
		$arrow_keys	:= $item_num > $menu_items.length()/2 ? "up " $menu_items.length() - $item_num +1 : "down " $item_num -1
		;MsgBox,262144,, %$arrow_keys%, 2
		Blockinput, On
		SetKeyDelay, 1, 1
		if($item_num>1)
			ControlSend,, % "{" $arrow_keys "}", ahk_exe komodo.exe
		ControlSend,, {enter}, ahk_exe komodo.exe
		Blockinput, Off		
	}

	/** _openMenu
		@param string $menu_item "File|Edit|Code|..."
	*/
	_openMenu(){
		Blockinput, On
		ControlSend,, {Esc 3},	ahk_exe komodo.exe				
		SetKeyDelay, 50, 50
		ControlSend,Scintilla7, % "!" RegExReplace( this.menu, "i)^(\w).*", "$1"), ahk_exe komodo.exe		
		sleep, 50
		Blockinput, Off		
	}
	
	
}

/*
-----------------------------------------------
	TEST FUNCTIONS
-----------------------------------------------
*/
/** Menu_goToMenuItem
*/
Menu_goToMenuItem(){
	new Menu("View").goItem("Tabs & Sidebars")
					.goSubmenu("Toolbox")
					.goSubmenu("Code")
					.goSubmenu("DOM")		
}

/* 
-----------------------------------------------
	RUN TEST
-----------------------------------------------
*/
;Menu_goToMenuItem()






