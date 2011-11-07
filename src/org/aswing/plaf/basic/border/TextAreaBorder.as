/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border{

/**
 * Discard in aswing 2.0(Background raped his job)
 * @private
 */
public class TextAreaBorder extends TextComponentBorder{
	
	public function TextAreaBorder(){
		super();
	}
	
	//override this to the sub component's prefix
	override protected function getPropertyPrefix():String {
		return "TextArea.";
	}
	
}
}