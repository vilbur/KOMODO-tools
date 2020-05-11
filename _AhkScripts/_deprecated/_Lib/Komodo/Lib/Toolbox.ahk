#Include  %A_LineFile%\..\KomodoBase.ahk
/**
	Class Toolbox
*/
Class Toolbox extends KomodoBase {

	

	/** getPathOfSelected
	*/
	getPathOfSelected(){
		$selected_item	:= this.contextMenuClick("Show")
		;this.contextMenuClick("Rename", $selected_item.type)
		$path := this._getPathInExplorer($selected_item.type=="item"?"file":"folder")
		return %$path%
	}
	/** Move cursor to selected item if given $type is selected, or any item if $type==""
		@param string $type empty string OR "item|folder_opened|folder_closed"
	*/
	cursorToSelectedItem($type:=""){
		$selected_item := this._selectedItem()
		if($type=="" || $type==$selected_item.type ){
			this.moveCursorToPos($selected_item)
			return %$selected_item%
		}
	}
	/** get type and position of selected item in toolbox
		@return {x:int, y:int, type:"item|folder_opened|folder_closed"}		
	*/
	_selectedItem(){
		$types := ["item", "folder_opened", "folder_closed"]
		For $i, $type in $types {
			$selected_item	:= this._itemPosAndType($type)
			if($selected_item)
				return %$selected_item%
		}
	}
	/** get position and type of selected item
		@param string $type "item|folder_opened|folder_closed" 
		@return {x:int, y:int, type:$type}		
	*/
	_itemPosAndType($type){
		$position	:= $UserChrome.find("toolbox",$type "_sel")
		if($position){
			$position.x	:= $position.x - 50 ;move outside scroll bar
			$position.y	:= $position.y + 10 ;move to middle of item
			$position.type	:= $type
		}
		return %$position%
	}
	
	/** moveCursorToPos
		@param {x:int, y:int} $win_coord
	*/
	moveCursorToPos($win_coord){
		WinActivate, ahk_exe komodo.exe
		CoordMode, mouse, Window	
		;MouseClick, right, % $selceted_item_pos.x + 20, % $selceted_item_pos.y + 10, 1, 0
		if ( $win_coord )
			MouseMove, % $win_coord.x, % $win_coord.y , 0	
	}
	/** contextMenuClick
		@param string $menu_item first word of toolbox context menu E.G: "Copy|Paste|Show"
	*/
	contextMenuClick($item){
		Blockinput, On
		ControlSend,, {Esc},	ahk_exe komodo.exe
		
		$Mouse	:= Mouse().posSave()
		$monitor_height	:= Window().setProcess("komodo.exe").getDimensions("height")
		$selected_item	:= this.cursorToSelectedItem()
		
		$menu_shared	:= ["Share", "Cut", "Copy", "Paste", "Show", "Save", "Rename", "Reload", "Delete"]
		$menu_by_type	:= $selected_item.type=="item" ? ["Insert|Execute", "Edit"] : ["Add", "Import"]
		$menu_items	:= Arr($menu_by_type).merge($menu_shared)
		;dump($monitor_height, "$monitor_height", 1)
		;dump($Mouse.getPos().y  , "$Window", 1)		
		;dump($menu_items.length()*28, "$menu_items.Length()", 0)
		;;dump($selected_item, "$selected_item", 1)
		;;dump($menu_items, "$menu_items", 1)
		;;dump($item_number, "$item_number", 0)
		
		if($item_number==0)
				return
		;;; /* context menu opening up if item is on bottom */
		$item_is_at_bottom	:= $Mouse.getPos().y > ( $monitor_height - $menu_items.length()*28)
		$item_number	:= $item_is_at_bottom ?  $menu_items.reverse().indexOf($item)*28*-1 : $menu_items.indexOf($item)*28
		
		this.contextMenuOpen()
		sleep, 50
		
		;;;;/* CLICK ON MENU ITEM, Mouse click is used instead of keys, because of keys count is changing +-1 for some reason */
		MouseClick, left, 0, $item_number -14, 1, 0, , R ; DEBUG MOUSE MOVE
		;MouseMove,0, $item_number -14,20, R
		;dump($mouse_pos, "$mouse_pos", 1)
		;sleep, 50
		$Mouse.posRestore()
		Blockinput, Off		
		return %$selected_item%
	}
	
	/** Open komodo tool in Explorer via context menu if item is selected in Komodo Toolbox Floating box
	*/
    contextMenuOpen(){
		MouseClick, right, 0, 0, 1, 0, , R
 		return this				
   }
	/** get path of selected files in Explorer
		@param string $type of path "file|folder"
	*/
	_getPathInExplorer($type:="file") {
		
		WinWaitActive ahk_exe explorer.exe
		WinGet, process, processName, %	"ahk_id" hwnd := hwnd? hwnd:WinExist("A")
		WinGetClass $class, ahk_id %hwnd%
		
		if (process="explorer.exe")
			if ($class ~= "(Cabinet|Explore)WClass")
				for $window in ComObjCreate("Shell.Application").Windows
					if	($window.hwnd==hwnd)
						$result := this._getExplorerFileOrFolder($window, $type)
		
		sleep, 100
		WinClose, ahk_exe explorer.exe
		return	%$result%
	}
	/** _getExplorerFileOrFolder
	*/
	_getExplorerFileOrFolder($window, $type){
		;dump($type, "$type", 0)
		if($type!="file")
			return % SubStr($window.LocationURL, 9)
	
		$sel :=	$window.Document.SelectedItems
		for $item in $sel
			$result .=	$item.path "`n"
	
		return	Trim($result,"`n")
	}
	/** Close all opened toolbox falders
	*/
	closeAllFolders($close_all:=1){
		BlockInput, Send		

		SetKeyDelay, 5, 1		
		this.cursorToSelectedItem()
		MouseClick, left,, , 2,10
		ControlSend,, {end}, ahk_exe komodo.exe ; select bottom of treeview	
		$folder_is_open := $UserChrome.find("Toolbox", "folder_opened")
		
		while ($folder_is_open) {
			if($UserChrome.find("Toolbox", "folder_opened_sel")){
				ControlSend,, {enter}, ahk_exe komodo.exe ; select bottom of treeview
				sleep, 100
			}
			$folder_is_open := $UserChrome.find("Toolbox", "folder_opened")
			ControlSend,, {up}, ahk_exe komodo.exe ; select bottom of treeview	
		}
		BlockInput, Off		
		MsgBox,262144,, All closed, 1
	}
	
	/** _findToolBoxItem
	*/
	_findToolBoxItem($item){
		;if(!this.tool_box_item_pos)
		this.toolbox_items_x := $UserChrome.find("Toolbox", "folder_closed").x
		this.moveCursorToPos(this.tool_box_item_pos)
		sleep, 2000
		this.tool_box_item_pos.y := Window().setProcess("komodo.exe").getDimensions("height")
		this.moveCursorToPos(this.tool_box_item_pos)

	}


}



/*
-----------------------------------------------
	TEST FUNCTIONS
-----------------------------------------------
*/
/** Toolbox_MoveCursorToSelectedItem
*/
Toolbox_MoveCursorToSelectedItem(){
	global $UserChrome	:= new UserChrome()
	$Toolbox	:= new Toolbox()
	$selected_item	:= $Toolbox._selectedItem()
	;dump($selected_item, "$selected_item", 1)
	$Toolbox.cursorToSelectedItem()	; MOVE TO ANY ITEM
	;$Toolbox.cursorToSelectedItem("item")	; MOVE TO SNIPPET	IF SELECTED
	;$Toolbox.cursorToSelectedItem("folder_closed")	; MOVE TO FOLDER CLOSED	IF SELECTED
	;$Toolbox.cursorToSelectedItem("folder_opened")	; MOVE TO FOLDER OPENED	IF SELECTED
}
/** Toolbox_ContextMenuClick
*/
Toolbox_ContextMenuClick(){
	global $UserChrome	:= new UserChrome()
	$Toolbox	:= new Toolbox()
	$Toolbox.contextMenuClick("Show")
	sleep, 3000
	WinClose, ahk_exe explorer.exe
	
	$Toolbox.contextMenuClick("Copy")
	sleep, 3000
	
	$Toolbox.contextMenuClick("Edit")
	sleep, 3000
	
	$Toolbox.contextMenuClick("Rename")
	sleep, 3000
	;;; cancel rename dialog
	ControlSend,, {Esc},	ahk_exe komodo.exe
	
}

/** Toolbox_getPathOfSelectedItem
*/
Toolbox_getPathOfSelectedItem(){
	global $UserChrome	:= new UserChrome()
	$Toolbox	:= new Toolbox()
	$path	:= $Toolbox.getPathOfSelected()
	dump($path, "$path", 1)
}

/** Toolbox_closeAllFolders
*/
Toolbox_closeAllFolders(){
	global $UserChrome	:= new UserChrome()
	new Toolbox().closeAllFolders()
}

/* 
----------------------------------------------------------------------------------------------
	RUN TEST - LAUNCH TESTS VIA Komodo.ahk because of includes
----------------------------------------------------------------------------------------------
*/
;Toolbox_MoveCursorToSelectedItem()
;Toolbox_ContextMenuClick()
;Toolbox_getPathOfSelectedItem()
;Toolbox_closeAllFolders()

