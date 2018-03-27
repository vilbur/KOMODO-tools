/** Class Autohotkey
*/
Class Autohotkey extends Class
{

	__New($parameter:="value"){
		this.parameter := $parameter
		MsgBox,262144,, Autohotkey, 2
	}

	/** public function summary.
	  *
	  * @param string	$param1 foo description
	  * @param boolean	$param2 foo description
	  *
	  */
	publicFunction( $param1:="fooString", $param2:=true,pArray:=[1,2,3] )
	{

	}

	/**
	 */
	privateFunction( $param1, $param2 )
	{

	}

}