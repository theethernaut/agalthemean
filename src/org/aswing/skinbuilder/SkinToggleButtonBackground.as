/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

public class SkinToggleButtonBackground extends SkinButtonBackground{
	
	public function SkinToggleButtonBackground(){
		super();
	}
	
	override protected function getPropertyPrefix():String {
        return "ToggleButton.";
    }
}
}