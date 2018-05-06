/** Merge includes in markdown file
 *
 * Edited file must has name '-source.md'	E.G: 'readme-source.md'
 * Compiled file has suffix removed	E.G: 'readme.md'
 *
 * INCLUDE SYNTAX:
 * 		{include:relative\path} 
 * 	E.G:	{include:\Documentation\controls\controls-items\controls-items.ahk} 
 * 
 */

if( typeof ko.extensions.vilbur === 'undefined'  )
	ko.extensions.vilbur = {};
	

ko.extensions.vilbur.markdownFormatter = function()
{
	
	var Logger	= ko.extensions.Logger_v3 ? new ko.extensions.Logger_v3(this).clear(false).off(false) : require('ko/console');
	var koEditor	= require("ko/editor");
	var koFile	= require("ko/file");
	var koFileEx	= Components.classes["@activestate.com/koFileEx;1"].createInstance(Components.interfaces.koIFileEx);

	var current_file	= ko.views.manager.currentView.koDoc.file.path;
	var current_dir	= koFile.dirname(current_file);
	//var file_content	= koEditor.getValue();
	var file_content	= removeEmptyEverySecondLine(koEditor.getValue());
	var includes	= file_content.match(/\[include:.*\]/gi);
	
	if (! current_file.match(/-source.md$/gi) )
		return;

	/** file read add empty line below every line
	 */
	function removeEmptyEverySecondLine(string)
	{
		//return string.replace(/^/gm, '~~~').replace(/~~~\n~~~/gm, '~~~').replace(/~~~/gm, '');
		return string
			.replace(/^/gm, '~~~')
			.replace(/~~~\n~~~/gm, '~~~')
			.replace(/~~~/gm, '');		
	}
		
	/** get icluded file content and wraop to codeblock
	 */
	function getIncludeContent(path)
	{
		
		/** Include *.ahk file
		 */
		this.include_ahk = function(file_content)
		{
			/** remove line starts with #
			 */
			function removeDirectives()
			{
				//return string.replace(/#.*([\r\n]|$)/gmi, '');
				file_content = file_content.replace(/#.*([\r\n]+|$)/gmi, '');				
			}
			/** remove lines with commented autohotkey dump E.G.: ";;;Dump(...)"
			 */
			function removeDumps()
			{
				file_content = file_content.replace(/[\r\n]\s*;+\s*Dump.*([\r\n]|$)/gmi, '');		
			}
			
			removeDirectives();
			removeDumps();
			
			return removeEmptyEverySecondLine(file_content).replace(/^\s+/gi, '');
		}; 
		/** Include *.komodotool file
		 */
		this.include_komodotool = function(file_content)
		{
			var file_content_obj	= JSON.parse(file_content); 
			var value	= file_content_obj.value;
		
			return value.join('\n').trim();
		};
		/** getLang
		 */
		var getLang = function(extension)
		{
			switch (extension) {
				case 'ahk':	return "php";
				case 'js':case 'komodotool':	return "javascript";
				default:	return extension;
			}
		}; 
		
		
		/* INCLUDE BY FILEYPE
		 *
		 */
		var file_content	= koFile.read(current_dir+path);
		var extension	= /(ahk|php|js|komodotool)/gi.exec(path).pop().toLowerCase();
		var method	= 'include_'+extension;
		var include_content	= this[method](file_content);
		
		return '\n``` '+getLang(extension)+'\n'+include_content+'\n```';
	}

	
	function writeToFile(path, content)
	{
		
		if(koFile.exists(path))
			koFile.remove(path);
			
		koFile.create( path ); 
		koFileEx.path = path;  
		koFileEx.open("w");
		koFileEx.puts(content);
		koFileEx.close();
	}
	/** Escape for Markdown synatax
	 */
	var escapeContent = function(string)
	{
		return string
				.replace(/(\w)\|(\w)\|*/gi, '$1\\|$2') // sanitize "|" pipe E.G.: "A|B"
				.replace(/\t/gi, '    ');
				//.replace(/\|/gi, '$1!\\|$2') // sanitize "|" pipe E.G.: "A|B"				
	}; 

	
	/* Escape readme content wihtout included scripts
	 **/
	file_content =  escapeContent(file_content);
	
	
	/**
	 */
	if( includes )
		for(var i=0; i<includes.length;i++){
			var path = new RegExp(/\[include:(.*)\]/gi).exec(includes[i]).pop();		
			file_content = file_content.replace(includes[i], getIncludeContent(path));
		}

	//writeToFile(current_file.replace(/-source.md$/gi, '.md'), removeEmptyEverySecondLine(file_content));
	writeToFile(current_file.replace(/-source.md$/gi, '.md'), file_content);
	//writeToFile(current_file.replace(/-source.md$/gi, '.md'),); 		

	
};


/* TEST */
//ko.extensions.vilbur.markdownFormatter();









