/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;

/**
 * The icon for frame maximize.
 * @author iiley
 * @private
 */
public class FrameMaximizeIcon extends FrameIcon{

	public function FrameMaximizeIcon(){
		super();
	}	

	override public function updateIconImp(c:StyleResult, g:Graphics2D, x:int, y:int):void{
		var gap:int = 4;
		x = x+gap;
		y = y+gap;
		var w:int = width -1 - gap*2;
		var h:int = height - 1 - gap*2 - 2;
		g.fillRectangle(new SolidBrush(c.bdark), x, y, w, 1);
		var darkBrush:SolidBrush = new SolidBrush(c.bdark);
		g.fillRectangle(darkBrush, x, y+1, w, 1);
		g.fillRectangleRingWithThickness(darkBrush, x, y+2, w, h, 1);		
	}	
}

}