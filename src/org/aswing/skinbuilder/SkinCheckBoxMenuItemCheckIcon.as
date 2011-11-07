/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{
	
import org.aswing.*;
import org.aswing.graphics.Graphics2D;

public class SkinCheckBoxMenuItemCheckIcon extends SinglePicIcon{
	override protected function getDefaltsKey():String{
		return "CheckBoxMenuItem.checkIconImage";
	}	
	
	override public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		super.updateIcon(c, g, x, y);
		if(image){
			image.visible = AbstractButton(c).isSelected();
		}
	}	
}
}