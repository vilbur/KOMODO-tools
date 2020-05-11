/** Class File
*/
Class KomodoFile {
	
	file_info := {"file":"", "project":""}
	
	
	/** get File path
	*/
	getFile(){
		this._setFileInfo()
		return % this.file_info.file
	}
	/** get Project name
	*/
	getProject(){
		this._setFileInfo()
		return % this.file_info.project
	}
	/** get project name and file path via Komodo title
	*/
	_setFileInfo(){
		WinGetTitle, $win_title, ahk_exe komodo.exe

		RegExMatch( $win_title, "(\S+)\**\s\(([^,)]+)", $file_path_match )
		RegExMatch( $win_title, "Project\s(\S+)", $project_match )
	
		if ( $file_path_match ){
			$filePath	 = %$file_path_match2%\%$file_path_match1% 
			this.file_info.file	:= $filePath
		}
					
		if ( $project_match )
			this.file_info.project_name := $project_match1

	}
	
		
}
	
	
	
	

