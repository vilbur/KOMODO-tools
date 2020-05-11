#SingleInstance force

;#Include  %A_LineFile%\..\Autofolder\KomodotoolIni.ahk
#Include  %A_LineFile%\..\..\Komodo\Lib\Komodotool\Komodotool.ahk
#Include  %A_LineFile%\..\Lib\AutoKomodotool.ahk


/** Class Autofolder
*/
Class Autofolder {

	AutoKomodotool	:= new AutoKomodotool()
	directory	:= ""
	url_documentation	:= ""
	snippet_name	:= ""
	ini_defaults	:=	{"{1}url":	{";link to documentation is added to comment of each snippet":""
				,";documentation":	"https://www.url/to/documentation/{snippet_name}.html"}
			,"{2}file":	{"{4};;;Search and replace in {snippet}, result is name of file":""
				,"{3};search":	"i)^(.*)$"
				,"{2};replace":	"$1"
				,"{1};capital":	true}
			,"{3}name":	{"{4};;;Search and replace in {snippet}, result is name of snippet":"Filename is used if not defined"
				,"{3};search":	"i)^(.*)$"
				,"{2};replace":	"$1"
				,"{1};capital":	true}
			,"{4}value":	{"{3};;;Search and replace in {snippet}, result is content of snippet":""
				,"{2};search":	"i)^(.*)$"
				,"{1};replace":	"$1($[[%tabstop:param]])[[%tabstop:]]"}
			,"{5}folders":{";folders":      "names of folders to create"}
			,"{6}snippet":{";snippet_name": "names of snippets to create"}}

	;KomodotoolIni	:= new KomodotoolIni()

	/** createAutofolderFile
	*/
	createAutofolderFile($path){
		this.setAutofolderIni($path "\autofolder.ini" )
	}
	/** processAutofolderFile
	*/
	processAutofolderFile($path){
		;MsgBox,262144,, processAutofolderFile(), 2
		this.setAutofolderIni($path)
		this.createFolderdataFile()
		this.creatateFolders()
		;dump(this, "this", 0)
		this.createKomodotoolFiles()

	}
	/** setAutofolderIni
	*/
	setAutofolderIni($autofolder_ini){
		;MsgBox,262144,, %$autofolder_ini%
		this._INI	:= INI($autofolder_ini)
		this.ini	:= this._INI.data
		this.directory	:= File($autofolder_ini).parentDir()
		this._setIniDefaults()
	}

	/** creatateFolders
	*/
	creatateFolders(){
		For $folder, $value in this.ini.folders
			this.createFolder($folder)
	}
	/** create Folder and ".folderdata" file
	*/
	createFolder($folder:=""){
		$dir := this.directory "\\" $folder
		FileCreateDir, %$dir%
		this.createFolderdataFile($folder)

		$AutofolderNew :=  new Autofolder()
		;$AutofolderNew.ini_defaults["{1}url"] := this.ini["url"]
		$AutofolderNew.createAutofolderFile($dir)
	}
	/** create Folder and ".folderdata" file
	*/
	createFolderdataFile($folder:=""){
		$dir := this.directory "\\" $folder
		Json().objToJsonFile(	{"priority": 100
			,"version": "1.0.12"
			,"type": "folder"
			,"name": $folder}
			,$dir "\.folderdata")
	}
	/** createKomodotoolFiles
	*/
	createKomodotoolFiles(){
		this.AutoKomodotool.setIni(this.ini).setDirectory(this.directory)
		For $snippet_name, $s in this.ini.snippet
			if($snippet_name!="")
				this.AutoKomodotool.createKomodotool($snippet_name)
	}
	/** _setIniDefaults
	*/
	_setIniDefaults(){
		$documentation_url := this.ini.url.documentation ? this.ini.url.documentation : "https://www.url/to/documentation/{snippet_name}.html"

		this._INI.setDefaults(this.ini_defaults)
	}
	;_reloadTotalCommander(){
	;	TotalCommander().reload()
	;}

}



/* EXECUTE CALL CLASS FUNCTION
*/
$path	= %1%
if(!RegExMatch( $path, "i)autofolder.ini$" ))
	new Autofolder().createAutofolderFile($path)
else
	new Autofolder().processAutofolderFile($path)

/* Refresh Total commander
  */
TotalCommander().reload()

exitApp