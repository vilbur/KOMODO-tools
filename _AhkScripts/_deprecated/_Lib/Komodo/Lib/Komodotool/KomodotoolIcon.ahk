/**
	Class KomodotoolIcon
*/
Class KomodotoolIcon {
	
	file	:= ""
	data	:= {}	
	ini	:= {}
	/** setKomodotoolIni($komodotool_ini)
	*/
	setFile($file_path){
		this.file := $file_path
		return this
	}
	/** setData
	*/
	setData($data){
		this.data := $data
		return this
	}
 
	/** _setIni
	*/
	_setIni(){
		this.ini	:= INI(A_LineFile).data
	}
    /* set icon by type, if icon is not custom file
	*/
	getIcon(){
		if (!RegExMatch( this.data.icon, "^file" ))
			if(this.data.type == "macro"){
				this._setIni() ; DEFINE IN HERE, BECAUSE OF SPEED OPTIMALiZATION			  
				RegExMatch( this.file, "i)\\+(Menu|Toolbar)", $file_type_match)
				if($file_type_match1){
					StringUpper, $file_type, $file_type_match1, T
					return % this["_getIcon" $file_type]()
					
				}else
					return % this._getIconMacro()
			}
			
		return false
	}
	
	/*---------------------------------------------
		Get icon by type
	-----------------------------------------------
	*/
    /** get icon of macro IF trigger was once enabled
	*/
	_getIconMacro(){
		$current_icon	:= this.data.icon
		$icon_set	:= StrSplit(this.ini["macro"][this.data.trigger], "|")
		
		if(this.data.trigger_enabled || $current_icon==$icon_set[1] || $current_icon==$icon_set[2] ) ; DO NOT OVERWRITE CUSTOM ICON
			return % $icon_set[(this.data.trigger_enabled + 1)]
		return false
	}
	
	/**
	 *	_getIconToolbar
	*/
	_getIconToolbar(){
		return false

		;;;; DEATH CODE BELOW, CUSTOM ICON BY FORST LETTER< WILL BE DELTED
		;;;if(this.data.icon == "" || RegExMatch( this.data.icon, "Alphabet" ) > 0 )
		;;;	$force := 1
		;;;	
		;;;StringLeft, $first_letter, % this.filename, 1
		;;;
		;;;;$path_icon	:= "file:///C:/GoogleDrive/TotalComander/Icons/Alphabet/Aikawns/" $first_letter "/blue.ico"
		;;;$path_icon	:= Path_Get("file:///%Commander_Path%/Icons/Alphabet/Aikawns/" $first_letter "/blue.ico")		
		;;;
		;;;if($force==1)
		;;;	;If FileExist( $path_icon ) 
		;;;		this.data.icon := $path_icon
		
	}
	/*
	 *	_getIconMenu
	*/
	_getIconMenu(){
		return false
		;if(this.data.icon == "" )
		;	$force := 1
		;	
		;if($force==1)
		;	this.data.icon := "koicon://ko-svg/chrome/icomoon/skin/list.svg"
	}
	         
    /*
	*/
	_getIconSnippet(){
		return false

		;$icons_folder	:= RegExReplace( this.ini.data.paths.icons, "\\", "/$1/" )
		;
		;loop, %$icons_folder%\*, 2
		;	if (RegExMatch( this.path, "\\" A_LoopFileName, $path_match ) >0 )
		;		$icon_dir := $icons_folder "//" A_LoopFileName
		;		
		;$icon := $icon_dir "//default.png" 
		; 
		;if($icon_dir!=""){   
		;
		;$icon_attributes := () 			
		;$icon_attributes := Array()			
		;if ( this.data.auto_abbreviation == "true"  ) 
		;	$icon_attributes.insert("auto") 
		;if ( this.data.treat_as_ejs == "true"  ) 
		;	$icon_attributes.insert("ejs") 
		;
		;if($icon_attributes.Length() > 0 )
		;	$icon_attributes := $icon_dir "//" Array_Join($icon_attributes, "_") ".png" 
		;If FileExist( $icon_attributes )
		;	$icon	:= $icon_attributes 			
		;
		;	If FileExist( $icon )
		;		this.data.icon	:= "file://" $icon
		;	else
		;		this.data.delete("icon")
		;}
	}
	
}
