/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

public class SkinCheckBoxIcon extends SkinButtonIcon{
	
	public function SkinCheckBoxIcon(){
		super();
	}
	
	override protected function getPropertyPrefix():String {
        return "CheckBox.";
    }
}
}