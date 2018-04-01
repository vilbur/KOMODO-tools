/** Class Autohotkey
*/
Class Autohotkey extends Class
{

	__New($parameter:="value"){
		this.parameter := $parameter
		MsgBox,262144,, Autohotkey, 2
	}

	/** Summary public function.
	  *
	  * Description Lorem ipsum luctus habitasse ac aenean donec ultrices maecenas arcu,
	  * risus primis sodales urna feugiat platea conubia volutpat duis nisl,
	  * eleifend netus dolor iaculis ante diam turpis duis.
	  * 
	  * @param string	$param1 Foo description for param 1
	  
	  * @param boolean	$param2 Bar description for param 2
	  *
	  * @example foo example
	  *
	  */
	publicFunction( $param1 := "fooString", $param2:=true,pArray:=[1,2,3] )
	{

	}

	/**
	  * @param boolean	$param2 Bar description for param 2
	 */
	_privateFunction( $param1, $param2 )
	{

	}

}