/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border{

/**
 * Discard in aswing 2.0(Background raped his job)
 * @private
 */
public class TextFieldBorder extends TextComponentBorder{
	
	public function TextFieldBorder(){
		super();
	}
	
	//override this to the sub component's prefix
	override protected function getPropertyPrefix():String {
		return "TextField.";
	}
}
}