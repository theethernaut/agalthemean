/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;

/**
 * The icon for frame iconified.
 * @author iiley
 * @private
 */
public class FrameIconifiedIcon extends FrameIcon{
	
	public function FrameIconifiedIcon(){
		super();
	}
	
	override public function updateIconImp(c:StyleResult, g:Graphics2D, x:int, y:int):void{	
		var w:Number = width - 8 - 1;
		var h:Number = 2;
		y = Math.round(y+Math.floor((height-2)*3/4-2));
		x = x+4;
		g.fillRectangle(new SolidBrush(c.bdark), x, y, w, h);
	}	
}
}