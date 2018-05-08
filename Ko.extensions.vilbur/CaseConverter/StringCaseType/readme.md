# StringCaseType  * Get case type of string  
``` javascript
/*---------------------------------------
	SUPPORTED TYPES OF CASE
-----------------------------------------
*/
var case_types = [
	'lower case',
	'Capital case',
	'Title Case',
	'UPPER CASE',
	
	'snake_case',
	'Snake_capital_case',
	'Snake_Title_Case',	
	'SNAKE_UPPER_CASE',
	
	'kebab-case',
	'Kebab-capital-case',
	'Kebab-Title-Case',	
	'KEBAB-UPPER-CASE',
	
	'camelCase',	
	'PascalCase',
];

/*--------------------------------------- 
	TEST
-----------------------------------------
*/
var getStringTypeTest = function()
{
	var Logger	=  require('ko/console');

	for(var c=0; c<case_types.length;c++)
		Logger.info(
			new ko.extensions.vilbur.StringCaseType(case_types[c]).getStringType(),
		case_types[c]);
};
getStringTypeTest();

/* RESULT
    lower case         = lower case
    Capital case       = capital case
    Title Case         = title case
    UPPER CASE         = upper case
    snake_case         = lower snake case
    Snake_capital_case = capital snake case
    Snake_Title_Case   = title snake case
    SNAKE_UPPER_CASE   = upper snake case
    kebab-case         = lower kebab case
    Kebab-capital-case = capital kebab case
    Kebab-Title-Case   = title kebab case
    KEBAB-UPPER-CASE   = upper kebab case
    camelCase          = camel case
    PascalCase         = pascal case
*/
```    