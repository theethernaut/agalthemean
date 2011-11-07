/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{
	
import flash.display.*;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilterType;

import org.aswing.*;
import org.aswing.graphics.*;

/**
 * @private
 */
public class RadioButtonMenuItemCheckIcon extends MenuCheckIcon{
	
	private var shape:Shape;
	
	public function RadioButtonMenuItemCheckIcon(){
		shape = new Shape();
	}
	
	override public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		var menu:AbstractButton = AbstractButton(c);
		if(menu.isSelected()){
			g.fillCircle(new SolidBrush(c.getMideground()), x+4, y+5, 3);
		}
		shape.filters = 
			[new BevelFilter(1, 80, 0x0, 0, 0xFFFFFF, 1, 1, 1, 1, 1, BitmapFilterType.OUTER)];
	}
	
	override public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
}
}