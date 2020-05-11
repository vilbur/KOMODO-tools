/* Class UserChrome
*/
Class UserChrome {
	
	ui_colors_file	:= Path("c:\GoogleDrive\Programs\Core\Komodo\AppData\10.1\userChrome\!variables.less")
	ui_colors	:= {}
	
	__New(){
		;MsgBox,262144,, UserChrome, 2
		this._setUiColors()
		;dump(this.ui_colors, "this.ui_colors", 0)
		;sleep,5000
	}
	
	/** find
	*/
	find($key, $item){
		$color := this.ui_colors[$key][$item]
		;MsgBox,262144,, %$color%
		return % this._findColor($color)
		
	}
	/** _setUiColors
		get variables from file // E.G: @item_color: #8CB0D1;
	*/
	_setUiColors(){
		if(this.ui_colors_file.exist(true))
			For $i, $key_value in  StrSplit(TF_Find(this.ui_colors_file.path, "", "", "@", 0, 1) , ";")
				this._parseKeyValue($key_value)
	}
	/** parse Key Value
		"item_color: #8CB0D1" >>> {"item_color":"#8CB0D1"}
	*/
	_parseKeyValue($key_value){
		;dump($key_value, "$key_value", 0)
		$key_value_match_count	:= RegExMatch( $key_value, "i)@([^-]+)-([^:]+):\s*(\S+)", $key_value_match )
		if(!this.ui_colors[$key_value_match1])
			this.ui_colors[$key_value_match1] := {}
		
		this.ui_colors[$key_value_match1][$key_value_match2] := $key_value_match3
	}
	
	/**
	  
	*/
	_findColor($color){
		;MsgBox,262144,, WinTitle:`n%$WinTitle%, 5
			
		$color := RegExReplace( $color, "^#*", "0x" ) ;;; CONVERT "#55C15C" >>  "0x55C15C" 
		
		;WinGetActiveTitle, $current_WinTitle
		$current_CoordModePixel = %A_CoordModePixel%
		;$current_TitleMatchMode = %A_TitleMatchMode%
		
		/* GET WINDOW DIMENSIONS
		*/
		WinGetPos, $win_X, $win_Y, $win_width, $win_height, ahk_exe komodo.exe
		/* GET SEARCH COORDINATES IN SCREEN COORDMODE, correnction windows border 
		*/
		$start_X	:= $win_X
		$start_Y	:= $win_Y
		$end_X	:= $win_X + $win_width
		$end_Y	:= $win_Y + $win_height
		/*
			;;; TEST WINDOW DIMENSIONS
			CoordMode, mouse, Screen
			MouseMove, %$start_X%, %$start_Y%, 30
			sleep, 2000
			MouseMove, %$end_X%, %$end_Y%, 30
			sleep, 2000		
		*/
		;CoordMode, Mouse, Screen
		;MouseMove, %$start_X%, %$start_Y%, 30
		;sleep, 2000
		;MouseMove, %$end_X%, %$end_Y%, 30
		;sleep, 2000		
		
		;;; search pixel in screen space, so window does need to be active
		CoordMode, Pixel, Screen		
		PixelSearch $pixel_pos_X, $pixel_pos_Y,  %$start_X%, %$start_Y%, %$end_X%, %$end_Y%, %$color%, , RGB FAST	
		
		/* RESTORE SETTINGS
		*/
		CoordMode, Pixel,  %$current_CoordModePixel%
		;setTitleMatchMode, %$current_TitleMatchMode%
		
		if not ErrorLevel {
			;;; get window coordinates
			$pixel_win_X := $pixel_pos_X - $win_X
			$pixel_win_Y := $pixel_pos_Y - $win_Y
				
			$position := {"x":$pixel_win_X,"y":$pixel_win_Y}
			return %$position%
		}
	
	}
	
}