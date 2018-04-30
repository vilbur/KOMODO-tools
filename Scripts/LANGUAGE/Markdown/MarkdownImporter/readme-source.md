# MarkdownImporter  
* Search in tree of current file, and write links to files matching criteria  


## Example  

``` markdown  

## Structure  
* __[LibNested](Test/TestFolders/Lib/LibNested)__  
	* __[LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)__  
* __[MainA](Test/TestFolders/MainA)__  
	* __[SubA](Test/TestFolders/MainA/SubA)__  
		* __[SubSubA](Test/TestFolders/MainA/SubA/SubSubA)__  

## Redme  
[Readme source](Test/TestFolders/readme-source.md)  

## Result  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  

```  