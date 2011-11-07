package org.aswing.plaf.basic.border{

import flash.display.*;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilterType;
import flash.filters.DropShadowFilter;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * @private
 */
public class PopupMenuBorder implements Border, UIResource{
	
	protected var shape:Shape;
	
	public function PopupMenuBorder(){
		shape = new Shape();
	}
	
	public function updateBorder(c:Component, g:Graphics2D, b:IntRectangle):void{
		shape.graphics.clear();
		if(c.isOpaque()){
			b = b.clone();
			b.height -= 4;
			b.width -= 4;
			g = new Graphics2D(shape.graphics);
			var tune:StyleTune = c.getStyleTune();
			var cl:ASColor = c.getBackground();
			var style:StyleResult = new StyleResult(cl.changeAlpha(1), tune);
			
			BasicGraphicsUtils.fillGradientRoundRect(g, b, style, Math.PI/2);
			BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, style, Math.PI/2);
			shape.filters = [
				//new BevelFilter(1, 90, style.blight.offsetHLS(0, 0, 0.2).getRGB(), 0.9, 0x0, 0.0, 1, 1, 1, 1, BitmapFilterType.INNER), 
				new DropShadowFilter(1, 45, 0x0, style.shadow, 4, 4, 1, 1), 
			];
			shape.alpha = cl.getAlpha();
		}
		shape.visible = c.isOpaque();		
	}
	
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets{
		return new Insets(2, 2, 6, 6);
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
}