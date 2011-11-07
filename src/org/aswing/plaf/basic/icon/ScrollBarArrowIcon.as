/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{

import flash.display.DisplayObject;
import flash.display.Shape;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * The scrollbar arrow decorator for buttons.
 * @author iiley
 * @private
 */
public class ScrollBarArrowIcon implements Icon, UIResource{
	
	protected var direction:Number;
	protected var width:Number;
	protected var height:Number;
	protected var shape:Shape;
	protected var verticle:Boolean;
	
	public function ScrollBarArrowIcon(direction:Number, width:int, height:int){
		this.direction = direction;
		this.width = width;
		this.height = height;
		this.shape = shape;
		if(Math.abs(direction % Math.PI) < 0.2){
			verticle = false;
		}else{
			verticle = true;
		}
		shape = new Shape();
	}

	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
	public function getIconWidth(c:Component):int{
		return width;
	}
	
	public function getIconHeight(c:Component):int{
		return height;
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		x = 0;
		y = 0;
    	var w:Number = width;
    	var h:Number = height;
    	shape.graphics.clear();
    	var bar:AbstractButton = c as AbstractButton;
    	var g:Graphics2D = new Graphics2D(shape.graphics);
    	var b:IntRectangle = new IntRectangle(x, y, w, h);
		var gradientDir:Number = 0;
    	if(verticle){
			gradientDir = Math.PI/2;
    	}else{
			gradientDir = 0;
    	}
    	var tune:StyleTune = c.getStyleTune().mide;
    	var style:StyleResult;
    	var cl:ASColor = c.getMideground().changeAlpha(1);
		var model:ButtonModel = bar.getModel();
    	var isPressing:Boolean = model.isArmed() || model.isSelected();
    	if(!bar.isEnabled()){//disabled
    		cl = cl.offsetHLS(0, -0.06, -0.03);
    		tune = tune.sharpen(0.4);
    	}else if(isPressing){//pressed
    		tune = tune.sharpen(0.8);
    	}else if(model.isRollOver()){//over
    		cl = cl.offsetHLS(0, 0.06, 0);
    	}

    	style = new StyleResult(cl, tune);
		BasicGraphicsUtils.fillGradientRoundRect(g, b, style, gradientDir);
		BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, style, gradientDir);
		b = b.clone();
		b.grow(-1, -1);
		var innerStyle:StyleResult = new StyleResult(cl, tune);
		innerStyle.bdark = innerStyle.cdark.offsetHLS(0, 0.06, 0);
		innerStyle.blight = innerStyle.clight.offsetHLS(0, 0.06, 0);
		BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, innerStyle, gradientDir);
		
		var light:SolidBrush = new SolidBrush(innerStyle.blight);
		var dark:SolidBrush = new SolidBrush(style.blight);
		var cx:Number = w/2;
		var cy:Number = h/2;
		var arrowW:Number = Math.round(w/2);
    	if(verticle){
    		cy += 1;
			g.fillPolygon(light, 
				BasicGraphicsUtils.getArrowPath(arrowW, direction, cx, cy));
			cy -= 1;
			g.fillPolygon(dark, 
				BasicGraphicsUtils.getArrowPath(arrowW, direction, cx, cy));
    	}else{
    		cx += 1;
			g.fillPolygon(light, 
				BasicGraphicsUtils.getArrowPath(arrowW, direction, cx, cy));
			cx -= 1;
			g.fillPolygon(dark, 
				BasicGraphicsUtils.getArrowPath(arrowW, direction, cx, cy));
    	}		
	}
	
}
}