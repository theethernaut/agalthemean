/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{
	
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.geom.Point;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;

/**
 * @private
 */
public class ArrowIcon implements Icon, UIResource{
	
	protected var shape:Shape;
	protected var arrow:Number;
	protected var width:int;
	protected var height:int;
	
	public function ArrowIcon(arrow:Number, size:int){
		this.arrow = arrow;
		this.width = size;
		this.height = size;
		shape = new Shape();
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		var center:Point = new Point(c.getWidth()/2, c.getHeight()/2);
		var w:Number = width - 6;
		var ps1:Array = new Array();
		ps1.push(nextPoint(center, arrow, w/2/2));
		var back:Point = nextPoint(center, arrow + Math.PI, w/2/2);
		ps1.push(nextPoint(back, arrow - Math.PI/2, w/2));
		ps1.push(nextPoint(back, arrow + Math.PI/2, w/2));
		
		var cl:ASColor = c.getMideground();
		var style:StyleResult;
		var adjuster:StyleTune = c.getStyleTune().mide;
		if(c is AbstractButton){
			var b:AbstractButton = c as AbstractButton;
			var model:ButtonModel = b.getModel();
	    	var isPressing:Boolean = model.isArmed() || model.isSelected();
    		var hue:Number = cl.getHue();
    		var offHue:Number = hue + 0.21;
    		if(offHue > 1) offHue = offHue - 1;
    		if(offHue < 0) offHue = offHue + 1;
	    	if(!b.isEnabled()){//disabled
	    		cl = cl.offsetHLS(0, -0.06, -0.03);
	    		adjuster = adjuster.sharpen(0.4);
	    		cl = cl.offsetHLS(0, -0.10, -0.10);
	    	}else if(isPressing){//pressed
	    		adjuster = adjuster.sharpen(0.8);
	    		cl = cl.offsetHLS(offHue-hue, -0.06, 0);
	    	}else if(model.isRollOver()){//over
	    		cl = cl.offsetHLS(offHue-hue, 0.1, 0.3);
	    	}
		}
		style = new StyleResult(cl, adjuster);
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(w+1, w+1, 60/180*Math.PI, x+w/8-0.5, y+w/8-0.5);
		/*var brush:GradientBrush = new GradientBrush(
			GradientBrush.LINEAR, 
			[style.cdark.getRGB(), style.clight.getRGB(), style.cdark.getRGB()], 
			[style.cdark.getAlpha(), style.clight.getAlpha(), style.cdark.getAlpha()], 
			[0, 120, 255], 
			matrix
		);*/
		var brush:GradientBrush = new GradientBrush(
			GradientBrush.RADIAL, 
			[style.clight.getRGB(), style.cdark.getRGB()], 
			[style.clight.getAlpha(), style.cdark.getAlpha()], 
			[0, 255], 
			matrix
		);		
		g.fillPolygon(brush, ps1);
		shape.filters = [new DropShadowFilter(1, 45, 0x0, style.shadow, 0, 0, 1, 1)];
	}
	
	protected function nextPoint(p:Point, dir:Number, dis:Number):Point{
		return new Point(p.x+Math.cos(dir)*dis, p.y+Math.sin(dir)*dis);
	}
	
	public function getIconHeight(c:Component):int{
		return width;
	}
	
	public function getIconWidth(c:Component):int{
		return height;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
}