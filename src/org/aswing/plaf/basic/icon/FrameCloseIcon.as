/*
 Copyright aswing.org, see the LICENCE.txt.
*/


package org.aswing.plaf.basic.icon{
	
import flash.display.CapsStyle;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;

/**
 * The icon for frame close.
 * @author iiley
 * @private
 */
public class FrameCloseIcon extends FrameIcon{
	
	public function FrameCloseIcon(){
		super();
	}
	
	override public function updateIconImp(c:StyleResult, g:Graphics2D, x:int, y:int):void{
		var gap:int = 5;
		var w:int = width-1-gap*2;
		var h:int = height-1-gap*2;
		var x1:int = x+gap;
		var y1:int = y+gap;
		var cl:ASColor = c.bdark;
		var lightPane:Pen = new Pen(cl, 2, true, "normal", CapsStyle.ROUND);
		g.drawLine(lightPane, x1, y1, x1+w, y1+h);
		g.drawLine(lightPane, x1+w, y1, x1, y1+h);
	}
}
}