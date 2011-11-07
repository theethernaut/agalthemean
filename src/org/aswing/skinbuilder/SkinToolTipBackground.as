/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.AssetBackground;
import flash.display.DisplayObject;
import org.aswing.plaf.UIResource;

public class SkinToolTipBackground extends SinglePicBackground{
	
	public function SkinToolTipBackground(){
		super();
	}
	
	override protected function getDefaltsKey():String{
		return "ToolTip.bgImage";
	}
}
}