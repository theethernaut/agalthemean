/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;

/**
 * The icon for frame normal.
 * @author iiley
 * @private
 */
public class FrameNormalIcon extends FrameIcon{

	public function FrameNormalIcon(){
		super();
	}

	override public function updateIconImp(c:StyleResult, g:Graphics2D, x:int, y:int):void{
		var gap:int = 4;
		var w:int = 5;
		var h:int = 4;
		var x1:int = x+gap;
		var y2:int = y+gap;
		var x2:int = x1 + 3;
		var y1:int = y2 + 3;
		var lightBrush:SolidBrush = new SolidBrush(c.bdark);
		var darkBrush:SolidBrush = new SolidBrush(c.bdark);
		g.fillRectangle(lightBrush, x2, y2, w, 1);
		g.fillRectangle(darkBrush, x2, y2+1, w, 1);
		g.fillRectangle(darkBrush, x2+w-1, y2+2, 1, h-1);
		g.fillRectangle(darkBrush, x2+w-2, y2+h, 1, 1);
		
		g.fillRectangle(lightBrush, x1, y1, w, 1);
		g.fillRectangleRingWithThickness(darkBrush, x1, y1+1, w, h, 1);
	}	
}
}