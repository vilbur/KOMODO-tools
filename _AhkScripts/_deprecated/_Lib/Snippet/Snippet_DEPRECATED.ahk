/*
	Class for work with Komodo snippet

	@example
		$Snippet := Snippet()
		
		$Snippet.getSnippetPathFromFloatingPane()	; open selected item Explorer
		$Snippet.FindInTotlaCommander()				; Find selected item in Total Commander		
		
		$Snippet.setNewNameInput()					; set new snippet filename

		$Snippet.WriteToFile()						; write snippet json data from $Snippet.data to *.komodotool file
		$Snippet.RenameFile() )						; rename *.komodotool file

*/


/*
	GET NEW CLASS OBJECT
*/
Snippet($path:=""){
	return % new Snippet($path)
}

/*
	Class Snippet
*/
Class Snippet {
	
	/*
		;this.path	; path to 	  *.komodotool
		;this.filename	; filename of *.komodotool
		;this.data	; content of  *.komodotool
	*/
	__New($path:=""){
		this.setPath($path)
		;this.ini_file := A_AppData "\AppsConfig\Komodo\Snippet.ini"
		this.ini  := INI()
		return this
	}
    /*  
	*/
    setPath($path:=""){
		if(FileExist($path ) && RegExMatch( $path, ".komodotool$" )!= 0){
			this.path := $path
			this.setFilename()
			this.setData()
		}
    }
	/*
		get json content of *.komodotool
		
		NOselectFunction($sadsa)
		
		selectFunction($sadsa){		
	*/
	setData(){ 
		this.data := JSON(this.path).data
		this.replaceTabCharactersInSnipet()
	}
    /*
	*/
	replaceTabCharactersInSnipet(){
		Loop % this.data.value.Length()
		{
			this.data.value[A_Index]	:= RegExReplace( this.data.value[A_Index], "(?<!\\)\\(?!\\)", "\\" ) ; double only single slashes '\'
			this.data.value[A_Index]	:= RegExReplace( this.data.value[A_Index], "`t", "\t" )
		}
	}
    /* set icon by type, if icon is not custom file
	*/
	setIcon(){
	
		if (RegExMatch( this.data.icon, "^file", $path_match ) ==0 ){
			
			if (RegExMatch( this.path, "\\Abbreviations", $path_match ) >0 )
				this._setIconAbbreviation()
				
			else if (RegExMatch( this.path, "\\Scripts",  $path_match ) >0 )
				this._setIconScript()
				
			else if (RegExMatch( this.path, "\\Menu",     $path_match ) >0 )
				this._setIconMenu()
				
			else if (RegExMatch( this.path, "\\Toolbar_\d+",  $path_match ) >0 )
				this._setIconToolbar()
		}
	
	}
    /*
	*/
	_setIconScript(){

		$icons:={	"trigger_startup":	["chrome://fugue/skin/icons/cross-script.png",	"chrome://fugue/skin/icons/tick.png"]
			,"trigger_postsave":	["chrome://famfamfamsilk/skin/icons/disk_error.png",	"chrome://famfamfamsilk/skin/icons/disk_download.png"]
			,"trigger_postopen":	["chrome://famfamfamsilk/skin/icons/disk_error.png",	"chrome://famfamfamsilk/skin/icons/disk_upload.png"]
			,"trigger_quit":	["chrome://fugue/skin/icons/control-power-small.png",	"chrome://fugue/skin/icons/control-power.png"] }

		$file_event	:= this.data.trigger
		
		if(this.data.trigger) {
			$new_icon := $icons[this.data.trigger][(this.data.trigger_enabled + 1)]
			;;; IF icon is empty, OR if in icon set ( THIS DO NOT REWRITE CUSTOM ICON )
			if( this.data.icon=="" || this.data.icon==$icons[this.data.trigger][1] || this.data.icon==$icons[this.data.trigger][2] )
				this.data.icon := $new_icon
		}
		
	}
	
	/*
	 *	_setIconToolbar
	*/
	_setIconToolbar($force:=0){

		if(this.data.icon == "" || RegExMatch( this.data.icon, "Alphabet" ) > 0 )
			$force := 1
			
		StringLeft, $first_letter, % this.filename, 1

		;$path_icon	:= "file:///C:/GoogleDrive/TotalComander/Icons/Alphabet/Aikawns/" $first_letter "/blue.ico"
		$path_icon	:= Path_Get("file:///%Commander_Path%/Icons/Alphabet/Aikawns/" $first_letter "/blue.ico")		
		
		if($force==1)
			;If FileExist( $path_icon ) 
				this.data.icon := $path_icon
	}
	/*
	 *	_setIconMenu
	*/
	_setIconMenu($force:=0){
		if(this.data.icon == "" )
			$force := 1
			
		if($force==1)
			this.data.icon := "koicon://ko-svg/chrome/icomoon/skin/list.svg"
	}
	         
    /*
	*/
	_setIconAbbreviation(){
		
		$icons_folder	:= RegExReplace( this.ini.data.paths.icons, "\\", "/$1/" )
		
		loop, %$icons_folder%\*, 2
			if (RegExMatch( this.path, "\\" A_LoopFileName, $path_match ) >0 )
				$icon_dir := $icons_folder "//" A_LoopFileName
				
		$icon := $icon_dir "//default.png" 
		 
		if($icon_dir!=""){   
		
		$icon_attributes := () 			
		$icon_attributes := Array()			
		if ( this.data.auto_abbreviation == "true"  ) 
			$icon_attributes.insert("auto") 
		if ( this.data.treat_as_ejs == "true"  ) 
			$icon_attributes.insert("ejs") 
		
		if($icon_attributes.Length() > 0 )
			$icon_attributes := $icon_dir "//" Array_Join($icon_attributes, "_") ".png" 
		If FileExist( $icon_attributes )
			$icon	:= $icon_attributes 			

			If FileExist( $icon )
				this.data.icon	:= "file://" $icon
			else
				this.data.delete("icon")
		}
	}
	
	
    /*
	*/
    setFilename($filename:=""){
		if($filename=="")
			SplitPath, % this.path,,,,$filename
		this.filename := $filename
    }

    
	/*
		Open komodo tool in Explorer via context menu if item is selected in Komodo Toolbox Floating box
	*/
    getSnippetPathFromFloatingPane(){

		;MsgBox,262144,, getSnippetPathFromFloatingPane(), 2
;        BlockInput, On
        setTitleMatchMode, 2
        WinSet, AlwaysOnTop, On, ActiveState Komodo IDE

		MouseClick, right, 0, 0, 1, 0, , R
		Send ,, {Up 6}{enter}
		sleep, 150
		
		this.setPath(this.GetSelectedFileInExplorer())
		sleep, 100
		WinClose, A	; close Explorer window
		
		BlockInput, off
		WinSet, AlwaysOnTop, Off, ActiveState Komodo IDE
				
    } 
	
	/*
		get path of selected files in Explorer
	*/
	GetSelectedFileInExplorer() {
		WinGet, process, processName, %	"ahk_id" hwnd := hwnd? hwnd:WinExist("A")
		WinGetClass class, ahk_id %hwnd%
		
		if (process="explorer.exe")
			
			if(class ~= "Progman|WorkerW"){
				ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%
				Loop, Parse, files, `n, `r
					ToReturn .=	A_Desktop "\" A_LoopField "`n" ;;;; "
			}
			else	if (class ~= "(Cabinet|Explore)WClass") {
				for window in ComObjCreate("Shell.Application").Windows
					if	(window.hwnd==hwnd)
						sel :=	window.Document.SelectedItems
				for item in sel
					ToReturn .=	item.path "`n"
			}
			
		return	Trim(ToReturn,"`n")
		
	}
	
    /*
	*/
	setNewNameInput(){
        sleep, 150
        $path := this.path
        ;MsgBox,262144,, setNewNameInput, 2
        if (  $path!="" ) {
            SplitPath, $path,,,, $noext
            $parent_folder		:= Path_getParentFolder($path)
            $path_match_count	:= RegExMatch( $path, ".*Abbreviations\\([^\\]+)(\\.*).komodotool.*", $path_match )
            $input_text 		:= $noext

            InputBox, $new_name, Set snippet file name - %$path_match1% ,,,,128,,,,, %$noext%
            this.filename := $new_name
        }
		this.setDataName()
    }

    /*
	*/
	setDataName(){
        $short_parts:= Array()
        ;$shortcuts  := this.ini.get("snippet_shorcuts")
        $shortcuts  := INI().get("snippet_shorcuts")
		$filename 	:= this.filename

        ;;; Sanitize Filename
        $filename		:= RegExReplace( $filename, "([A-Z])", "_$1" )	;;; set underscore before Capital	E.G.: CapiTalize   TO _Capi_Talize
        $filename		:= RegExReplace( $filename, "^_", "" )			;;; remove first underscore  		E.G.: _Capi_Talize TO Capi_Talize
        $filename_split := StrSplit($filename, "_")						;;; replace underscore with space	E.G.: Capi_Talize  TO "Capi Talize"

        ;;; -------------------------------------------------------------------------------------------------------------------------
        ;;; SET SNIPPET SHORCUT PARTS
        ;;; -------------------------------------------------------------------------------------------------------------------------
        For $key, $shortcut in $filename_split
        {
            if ( $shortcuts[$shortcut] != "" )
                $short_parts.insert( $shortcuts[$shortcut] )    ;;; if word is defined in INI

            else if (  StrLen($shortcut) <= 2 )
                $short_parts.insert( $shortcut )

            else
                $short_parts.insert( SubStr($shortcut, 1, 1) )	;;; get first letter from word
        }
        ;return % this.CamelCaseArray( $short_parts )
		this.data.name := this.CamelCaseArray( $short_parts )
    }
    /*
		camelCase array items E.G.: FROM ['fi', 'n', 'c'] GET "fiNc"
	*/
    CamelCaseArray($array){
        ;dump($array, 50) 
        ;MsgBox,262144,, CamelCaseArray: %$CamelCaseArray%, 5
        $array_camelCase := Array()
        $char_type := "low"
        For $key, $letter in $array {
            if ( $char_type == "up" ) 	;;;;;  let capital "I" as "i" - capital I is poor for reading
                StringUpper, $letter_formated, $letter, T
             else
                StringLower , $letter_formated, $letter

            $array_camelCase.insert( $letter_formated  )
            $char_type := ( StrLen($letter_formated) > 1 || $char_type == "low" ) ? "up" : "low"
        }
        $snippet_string :=  Array_Join($array_camelCase, "")
        $snippet_sanitized := RegExReplace( $snippet_string, "i)I", "i" )           ;;; replace "fooI"  with "fooi"
        $snippet_sanitized := RegExReplace( $snippet_sanitized, "i)(A-Z)l", "$1L" ) ;;; replace "fooBl" with "fooBL"
		
        return %$snippet_sanitized%
    }


    /*
	*/
	WriteToFile( ){
		JSON(this.data).toFile(this.path)
	}
    /*
	*/
    RenameFile( ){
        SplitPath, % this.path , $name, $dir, $ext, $noext
		StringCaseSense, On
		
		if ( $noext != this.filename ) {
			$path_new := $dir "\\" this.filename ".komodotool"
			If !FileExist($path_new)
				FileMove, % this.path , %$path_new%, 1
		}
    }
    /*
	*/
    FindInTotlaCommander(){
            If FileExist( this.path ) {
            $cmd := path_tc_exe " /S /O """ this.path """"
            RunWait, %$cmd%
            sleep, 100
            WinActivate, Total Commander
        } else {
			MsgBox,262144,, Class Snippet`nVariable Sninppet.path is not defined`n`nToolbox needs to be reloaded probably
		}
    }

	/*
	 *	_createKomodoToolsFilelist
	*/
	_createKomodoToolsFilelist(){
		$path_komodo_tools := % this.ini.data.paths.komodo_tools
		$komodo_tool_paths	:= Object()
		loop, %$path_komodo_tools%\*.*, 0, 0
			if A_LoopFileExt in % "komodotool"
			{
				SplitPath, A_LoopFileFullPath, $name, $dir, $ext, $noext, $drive
				$Snippet := Snippet(A_LoopFileFullPath)
				$komodo_tool_paths[$Snippet.data.name ($Snippet.data.type == "macro" ? ".js" : ".snippet") ] := A_LoopFileFullPath	
			}
		;dump($komodo_tool_paths,,1)
		
		
		$JSON := new JSON($komodo_tool_paths)
		$JSON.toFile(A_AppData "\AppsConfig\Komodotool_list.json")
	}


}






