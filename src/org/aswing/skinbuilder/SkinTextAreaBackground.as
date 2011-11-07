/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

public class SkinTextAreaBackground extends SkinAbsEditorBackground{
	
	public function SkinTextAreaBackground(){
		super();
	}
	
	override protected function getPropertyPrefix():String {
        return "TextArea.";
    }
}
}