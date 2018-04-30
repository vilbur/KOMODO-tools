# MarkdownImporter  
* Search in tree of current file, and write links to files matching criteria  


## Examples  
[include:\Test\IncluderTest.komodotool]  


## Result in source of markdown file  

``` markdown  

## Structure Test  
* __[LibNested](Test/TestFolders/Lib/LibNested)__  
	* __[LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)__  
* __[MainA](Test/TestFolders/MainA)__  
	* __[SubA](Test/TestFolders/MainA/SubA)__  
		* __[SubSubA](Test/TestFolders/MainA/SubA/SubSubA)__  

## Readme Test  
[Readme source](Test/TestFolders/readme-source.md)  

## Result Test  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  

```  

## Result rendered  
---  
## Structure Test  
* __[LibNested](Test/TestFolders/Lib/LibNested)__  
	* __[LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)__  
* __[MainA](Test/TestFolders/MainA)__  
	* __[SubA](Test/TestFolders/MainA/SubA)__  
		* __[SubSubA](Test/TestFolders/MainA/SubA/SubSubA)__  

## Readme Test  
[Readme source](Test/TestFolders/readme-source.md)  

## Result Test  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  