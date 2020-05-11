/**
	Class AutoKomodotool
*/
Class AutoKomodotool {

	directory	:= ""
	snippet_name	:= ""

	/** setIni
	*/
	setIni($ini){
		this.ini	:= $ini
		;Dump(this.ini, "this.ini", 1)
		;sleep,2000
		return this
	}
	/** setDirectory
	*/
	setDirectory($directory){
		this.directory	:= $directory
		return this
	}

	/** createKomodotool
	*/
	createKomodotool($snippet_name){
		;MsgBox,262144,, %$snippet_name%, 2
		;Dump($snippet_name, "snippet_name", 1)

		this.snippet_name	:= this._sanitizeSnippetName($snippet_name)
		$filename	:= this._searchAndReplaceInValue(this.snippet_name, "file")
		$name	:= this.ini.name.search ? this._searchAndReplaceInValue(this.snippet_name, "name") : $filename
		;if($name==this.snippet_name &&  )

		$Komodotool := new Komodotool()
				.setTemplate("snippet")
				.setFile( this.directory "\\" $filename ".komodotool")
				.setName($name)
				.setValue( this._getValue() )
				.setEjs()
				.createNewFile()

	}
	/** _sanitizeSnippetName
	*/
	_sanitizeSnippetName($snippet_name){
		return % RegExReplace( $snippet_name, "i)(\s+[A-Z]\s+|[\s\/\\]+)", "" ) ; remove empty space, slashes and single letters
	}
	/** _getValue
	*/
	_getValue(){
		$value	:= [this._searchAndReplaceInValue(this.snippet_name, "value")]
		;$documentation	:= this._getDocumentationUrl(this.snippet_name)
		;if($documentation)
		;	$value.push($documentation)
		return %$value%
	}
	/** _searchAndReplaceInValue()
	*/
	_searchAndReplaceInValue($snippet_name, $type){
		$search	:= this.ini[$type].search

		if(this.ini[$type].capital)
			$snippet_name := RegExReplace($snippet_name, "(\w)(.*)","$U1$2") ;;; Capitalize first letter

		return % $search ? RegExReplace( $snippet_name, $search,this.ini[$type].replace ) : $snippet_name
	}

	/** _getDocumentationUrl
	*/
	_getDocumentationUrl(){
		;dump(this.ini.url.documentation, "this.ini.url.documentation", 0)
		if(this.ini.url.documentation)
			$url := RegExReplace( this.ini.url.documentation, "{snippet}", this.snippet_name )
		$url_documentation := $url ? "<%/* " $url " */%>" : ""
		;dump($url_documentation, "$url_documentation", 0)
		return %$url_documentation%
	}



}