#Include  %A_LineFile%\..\KomodotoolIcon.ahk
/**
	Class Komodotool
*/
Class Komodotool {

	KomodotoolIcon	:= new KomodotoolIcon()
	file	:= ""
	updated	:= false
	data	:= ""
	template	:=	{"snippet":	{"keyboard_shortcut":	""
				,"name":	""
				,"value":	[]
				,"set_selection":	"false"
				,"version":	"1.0.12"
				,"treat_as_ejs":	"true"
				,"type":	"snippet"
				,"indent_relative":	"true"
				,"icon":	 ""
				,"auto_abbreviation": "false"}}

	__New(){
		;MsgBox,262144,, Komodotool, 2
	}
	/*---------------------------------------------
		FILE
	-----------------------------------------------
	*/
	/** path to *.komodotool
	*/
	setFile($file_path){
		this.file := $file_path
		this.setData()
		this.setName()
		return this
	}

	/** updateFile
	*/
	updateFile(){
		if(this.updated==true)
			this.writeToFile()
		return this
	}
	/** createNewFile
	*/
	createNewFile($overwrite:=false){
		if(!FileExist( this.file )|| $overwrite==1)
			this.writeToFile()
	}
	/** writeToFile
	*/
	writeToFile(){
		Json().objToJsonFile(this.data, this.file)
		return this
	}

	/*---------------------------------------------
		DATA
	-----------------------------------------------
	*/

	/** setData
	*/
	setData(){
		if(FileExist( this.file )){
			this.data := Json().jsonFileToObj(this.file)
			this.sanitizeData()
			return this
		} else if(!this.data){
			MsgBox,262144,Class Komodotool, TEMPLATE IS NOT DEFINED`n`nuse method: .setTemplate("snippet|macro")`nbefore .setFile()
			exitApp
		}
	}

    /*
	*/
	sanitizeData(){
		Loop % this.data.value.Length()
		{
			this.data.value[A_Index]	:= RegExReplace( this.data.value[A_Index], "(?<!\\)\\(?!\\)", "\\" )	; keep escaped
			this.data.value[A_Index]	:= RegExReplace( this.data.value[A_Index], "`t", "\t" )	; keep tabs
		}
	}
	/** setTemplate
		@param string $komodotool_type "snippet|macro"
	*/
	setTemplate($komodotool_type){
		this.data := this.template[$komodotool_type]
		return this
	}
	/*---------------------------------------------
		DATA VALUES
	-----------------------------------------------
	*/
	/** set Name of snippet show in toolbox
		@param string $snippet_name filename without extension used if parameter is blank
	*/
	setName($snippet_name:=""){
		if($snippet_name=="")
			SplitPath, % this.file,,,, $snippet_name
		this.data.name := $snippet_name
		return this
	}
	/** Set snippet content
		@param [string] $content
	*/
	setValue($content){
		this.data.value := $content
		return this
	}
	/** Set treat as EJS
	*/
	setEjs($value:=true){
		this.data.treat_as_ejs := this._getBooleanValue($value)
		return this
	}
	/** setIcon
	*/
	setIcon(){

		if(this.data.type == "snippet")
			this.data.icon := ""
		else
			$new_icon := this.KomodotoolIcon.setFile(this.file).setData(this.data).getIcon()

		;dump($new_icon, "$new_icon", 1)
		if($new_icon){
			this.data.icon	:= $new_icon
			this.updated	:= true
		}
		return this
	}
	/** Maintain indentation
	*/
	setIndent($value:=true){
		this.data.indent_relative := this._getBooleanValue($value)
		return this
	}
	/*---------------------------------------------
		PRIVATE METHOD
	-----------------------------------------------
	*/
	/** _getBooleanValue
	*/
	_getBooleanValue($value){
		return % $value==true||$value==1||$value=="true"? "true" : "false"
	}

}
