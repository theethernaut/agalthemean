/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.filters.GlowFilter;

import org.aswing.AsWingConstants;
import org.aswing.AsWingManager;
import org.aswing.Component;
import org.aswing.GroundDecorator;
import org.aswing.Orientable;
import org.aswing.StyleTune;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.graphics.SolidBrush;
import org.aswing.plaf.UIResource;

/**
 * @private
 */
public class ProgressBarBackground implements GroundDecorator, UIResource{
	
	protected var shape:Shape;
	
	public function ProgressBarBackground(){
		shape = new Shape();
	}

	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, b:IntRectangle):void{
		if(c is Orientable && c.isOpaque()){
			var bar:Orientable = c as Orientable;
			var verticle:Boolean = (bar.getOrientation() == AsWingConstants.VERTICAL);
			shape.graphics.clear();
			var style:StyleTune = c.getStyleTune();
			g = new Graphics2D(shape.graphics);
			b = b.clone();
			var radius:Number = 0;
			if(verticle){
				radius = Math.floor(b.width/2);
			}else{
				radius = Math.floor(b.height/2);
			}
			if(radius > style.round){
				radius = style.round;
			}
			g.fillRoundRect(new SolidBrush(c.getBackground().changeAlpha(1)), b.x, b.y, b.width, b.height, radius);
			shape.filters = [new GlowFilter(0x0, style.shadowAlpha, 5, 5, 1, 1, true)];
			shape.alpha = c.getBackground().getAlpha();
		}
	}
	
}
}