/**
	Class KomodoBase
*/
Class KomodoBase {
	
	komodo_title	:= "ActiveState Komodo IDE"
	
	__New(){
		;MsgBox,262144,, Komodo, 2
	}
	
	/** activate
	*/
	activate(){
		;WinActivate, ahk_exe komodo.exe
		;return this	
	}
}
	
	
	
	