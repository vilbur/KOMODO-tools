/** Class File
*/
Class KomodoFile
{
	
	current_file := {"file":"", "project":""}
	
	/** get File path from window title
	*/
	getFile()
	{
		this._setFileInfo()
		
		return % this.current_file.file
	}
	/** get Project name from window title
	*/
	getProject()
	{
		this._setFileInfo()
		
		return % this.current_file.project
	}
	/** get project name and file path via Komodo title
	*/
	_setFileInfo()
	{
		WinGetTitle, $win_title, ahk_exe komodo.exe

		RegExMatch( $win_title, "(\S+)\**\s\(([^,)]+)", $file_path_match )
		RegExMatch( $win_title, "Project\s(\S+)\)", $project_match )
	
		if ( $file_path_match ){
			$filePath	 = %$file_path_match2%\%$file_path_match1% 
			this.current_file.file	:= $filePath
		}
					
		if ( $project_match )
			this.current_file.project := $project_match1
	}
}