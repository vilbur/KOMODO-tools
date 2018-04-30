# MarkdownImporter  * Search in tree of current file, and write links to files matching criteria  ## Examples  
``` javascript
/** Loop all subdirs
 *  Find all files which name is same as folder name E.G.: "FooBar\FooBar.php"
 *
 * Search extension is recognized from search_extensions variable
 */
function includeFileStructureTest()
{
	new ko.extensions.vilbur.markdown.Includer()
										.matchDirName()
										.label('Structure Test')
										.includeIndent();
}

/** Search files with name matching '-source' with extension 'md' in main directory
 */
function searchByNameWithMaxLevelTest()
{
	new ko.extensions.vilbur.markdown.Includer()
										.searchName('.*-source')
										.searchExt('md')
										.label('Readme Test')
										.maxLevel(1)
										.include();
}

/** Search images named as folder with any suffix in 4 level of subfolders
*/
function searchImagesWithAnySuffix()
{
	new ko.extensions.vilbur.markdown.Includer()
										.searchExt('jpg')
										.matchDirName('prefix')
										.label('Result Test')
										.maxLevel(4)
										.unique(false) // include even if link is in file already
										.include();
}
/*---------------------------------------
	RUN TEST
-----------------------------------------
*/
includeFileStructureTest();
searchByNameWithMaxLevelTest();
searchImagesWithAnySuffix();
```  ## Result in source of markdown file  ``` markdown  ## Structure Test  * __[LibNested](Test/TestFolders/Lib/LibNested)__      * __[LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)__  * __[MainA](Test/TestFolders/MainA)__      * __[SubA](Test/TestFolders/MainA/SubA)__          * __[SubSubA](Test/TestFolders/MainA/SubA/SubSubA)__  ## Readme Test  [Readme source](Test/TestFolders/readme-source.md)  ## Result Test  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ```  ## Result rendered  ---  ## Structure Test  * __[LibNested](Test/TestFolders/Lib/LibNested)__      * __[LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)__  * __[MainA](Test/TestFolders/MainA)__      * __[SubA](Test/TestFolders/MainA/SubA)__          * __[SubSubA](Test/TestFolders/MainA/SubA/SubSubA)__  ## Readme Test  [Readme source](Test/TestFolders/readme-source.md)  ## Result Test  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  