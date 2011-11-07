/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilterType;
import flash.filters.DropShadowFilter;

import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.GroundDecorator;
import org.aswing.JFrame;
import org.aswing.StyleResult;
import org.aswing.StyleTune;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.FrameUI;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * @private
 */
public class FrameBackground implements GroundDecorator, UIResource{
	
	protected var shape:Sprite;
	protected var bar:Shape;
	
	public function FrameBackground(){
		shape = new Sprite();
		bar = new Shape();
		shape.mouseChildren = false;
		shape.mouseEnabled = false;
		shape.addChild(bar);
	}

	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, b:IntRectangle):void{
		shape.graphics.clear();
		bar.graphics.clear();
		if(c.isOpaque()){
			var shadowW:Number = 6;
			var shadowH:Number = 6;
			var cl:ASColor = c.getMideground();
			var style:StyleResult;
			var adjuster:StyleTune = c.getStyleTune().mide;
			var shadowScale:Number = 1;
			b = new IntRectangle(
				1, 
				2, 
				c.width-shadowW - 1, 
				c.height-shadowH - 2);
			
			g = new Graphics2D(bar.graphics);
			var barHeight:int = 24;
			if(c is JFrame){
				barHeight = (c as JFrame).getTitleBar().getSelf().getHeight();
			}
			style = new StyleResult(cl, adjuster);
			BasicGraphicsUtils.fillGradientRoundRectBottomRightAngle(g, 
				new IntRectangle(b.x, b.y, b.width, Math.min(barHeight-2, b.height)), 
				style, Math.PI/2);
			bar.filters = [
				new BevelFilter(1, 90, 0xFFFFFF, adjuster.shadowAlpha, 0x0, 0.1, 1, 1, 1, 1, BitmapFilterType.INNER), 
				new BevelFilter(1, 90, 0x0, 0.1, 0xFFFFFF, adjuster.shadowAlpha, 1, 1, 1, 1, BitmapFilterType.OUTER)
			];
			
			g = new Graphics2D(shape.graphics);
			var ui:FrameUI = c.getUI() as FrameUI;
			if(ui){
				if(!ui.isPaintActivedFrame()){
					shadowScale = 0.5;
				}
			}
			cl = c.getBackground();
			adjuster = c.getStyleTune();
			style = new StyleResult(cl, adjuster);
			var ratioScale:Number = Math.min(1, barHeight*2.2/b.height);
			var ratios:Array = [255*(1-ratioScale), 255];
			BasicGraphicsUtils.fillGradientRoundRect(g, b, style, -Math.PI/2, false, null, ratios);
			shape.filters = [ 
				new DropShadowFilter(2, 45, 0x0, style.shadow*shadowScale, shadowW, shadowH, 1, 1)
			];
		}
		shape.visible = c.isOpaque();
	}
	
}
}