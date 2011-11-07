/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{
	
import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.LineScaleMode;
import flash.events.*;
import flash.geom.Point;

import org.aswing.*;
import org.aswing.event.*;
import org.aswing.geom.IntDimension;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * The thumb decorator for JScrollBar.
 * @author iiley
 * @private
 */
public class ScrollBarThumb implements GroundDecorator, UIResource{
	
	protected var bar:JScrollBar;
    protected var thumb:AWSprite;
    protected var size:IntDimension;
    protected var verticle:Boolean;
        
	protected var rollover:Boolean;
	protected var pressed:Boolean;
    
	public function ScrollBarThumb(){
		thumb = new AWSprite();
		rollover = false;
		pressed = false;
		initSelfHandlers();
	}
		
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):void{
		thumb.x = bounds.x;
		thumb.y = bounds.y;
		size = bounds.getSize();
		bar = JScrollBar(c);
		verticle = (bar.getOrientation() == JScrollBar.VERTICAL);
		paint();
	}
	
	private function paint():void{
		var x:Number = 0;
		var y:Number = 0;
    	var w:Number = size.width;
    	var h:Number = size.height;
    	thumb.graphics.clear();
    	var g:Graphics2D = new Graphics2D(thumb.graphics);
    	var b:IntRectangle;
		var direction:Number;
		var notchSize:int;
    	if(verticle){
			direction = Math.PI/2;
			notchSize = w - 6;
    	}else{
			direction = 0;
			notchSize = h - 6;
    	}
    	b = new IntRectangle(x, y, w, h);
    	var tune:StyleTune = bar.getStyleTune().mide;
    	var style:StyleResult;
    	var cl:ASColor = bar.getMideground().changeAlpha(1);
    	if(!bar.isEnabled()){//disabled
    		cl = cl.offsetHLS(0, -0.06, -0.03);
    		tune = tune.sharpen(0.4);
    	}else if(pressed){//pressed
    		tune = tune.sharpen(0.8);
    	}else if(rollover){//over
    		cl = cl.offsetHLS(0, 0.06, 0);
    	}

    	style = new StyleResult(cl, tune);
		BasicGraphicsUtils.fillGradientRoundRect(g, b, style, direction);
		BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, style, direction);
		b = b.clone();
		b.grow(-1, -1);
		var innerStyle:StyleResult = new StyleResult(cl, tune);
		innerStyle.bdark = innerStyle.cdark.offsetHLS(0, 0.06, 0);
		innerStyle.blight = innerStyle.clight.offsetHLS(0, 0.06, 0);
		BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, innerStyle, direction);
		
		var snotchX:int = 0;
		var snotchY:int = 0;
		var lightPen:Pen = new Pen(innerStyle.blight, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE);
		var darkPen:Pen = new Pen(style.blight, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE);
		
    	if(verticle){
			snotchX = x + 3;
			snotchY = y + h/2 - 3;
			g.drawLine(lightPen, snotchX, snotchY, snotchX + notchSize, snotchY);
			snotchY += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX + notchSize, snotchY);
			snotchY += 1;
			g.drawLine(lightPen, snotchX, snotchY, snotchX + notchSize, snotchY);
			snotchY += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX + notchSize, snotchY);
			snotchY += 1;
			g.drawLine(lightPen, snotchX, snotchY, snotchX + notchSize, snotchY);
			snotchY += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX + notchSize, snotchY);
    	}else{
			snotchX = x + w/2 - 3;
			snotchY = y + 3;
			g.drawLine(lightPen, snotchX, snotchY, snotchX, snotchY + notchSize);
			snotchX += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX, snotchY + notchSize);
			snotchX += 1;
			g.drawLine(lightPen, snotchX, snotchY, snotchX, snotchY + notchSize);
			snotchX += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX, snotchY + notchSize);
			snotchX += 1;
			g.drawLine(lightPen, snotchX, snotchY, snotchX, snotchY + notchSize);
			snotchX += 1;
			g.drawLine(darkPen, snotchX, snotchY, snotchX, snotchY + notchSize);
    	}
		thumb.alpha = bar.getMideground().getAlpha();
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return thumb;
	}

	private function initSelfHandlers():void{
		thumb.addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
		thumb.addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
		thumb.addEventListener(ReleaseEvent.RELEASE, __mouseUpListener);
	}
	
	private function __rollOverListener(e:Event):void{
		rollover = true;
		paint();
	}
	private function __rollOutListener(e:Event):void{
		rollover = false;
		if(!pressed){
			paint();
		}
	}
	private function __mouseDownListener(e:Event):void{
		pressed = true;
		paint();
	}
	private function __mouseUpListener(e:Event):void{
		if(pressed){
			pressed = false;
			paint();
		}
	}
}

}