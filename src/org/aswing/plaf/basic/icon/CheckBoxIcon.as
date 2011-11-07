/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{
	
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilterType;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.aswing.*;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * @private
 */
public class CheckBoxIcon implements Icon, UIResource{    
	
	protected var sprite:Sprite;
	protected var box:Shape;
	protected var dot:Shape;
	
	public function CheckBoxIcon(){
		sprite = new Sprite();
		sprite.mouseChildren = false;
		sprite.mouseEnabled = false;
		box = new Shape();
		dot = new Shape();
		sprite.addChild(box);
		sprite.addChild(dot);
	}
		
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		var b:AbstractButton = AbstractButton(c);
		var model:ButtonModel = b.getModel();
		var drawDot:Boolean = model.isSelected();
		
		box.graphics.clear();
		var g:Graphics2D = new Graphics2D(box.graphics);
		
		var w:int = getIconWidth(c)-5;
		var h:int = getIconHeight(c)-5;
		x += 1;
		y += 3;
		var cl:ASColor = c.getBackground();
		var style:StyleResult;
		var adjuster:StyleTune = c.getStyleTune();
		
    	var isPressing:Boolean = model.isArmed() || model.isSelected();
		var shadowScale:Number = 1;
		var innerDis:Number = 2;
		var alpha:Number = 1;
    	if(isPressing){//pressed
	    	innerDis = 3;
	    	adjuster = adjuster.clone();
	    	adjuster.bGradient *= 0.8;
	    	adjuster.cGradient *= 0.8;
    		if(!b.isEnabled()){
	    		cl = cl.offsetHLS(0, 0, -0.03);
	    		adjuster = adjuster.sharpen(0.6);
	    		alpha = 0.5;
    		}else if(model.isRollOver()){
    			cl = cl.offsetHLS(0, 0.06, 0.06);
    			adjuster = adjuster.sharpen(0.8);
	    		innerDis = 4;
    		}else if(model.isArmed()){
    			adjuster = adjuster.sharpen(0.8);
    		}
			//shadowScale = 0.5;
    	}else{
    		if(!b.isEnabled()){//disabled
	    		cl = cl.offsetHLS(0, -0.06, -0.03);
	    		adjuster = adjuster.sharpen(0.6);
	    		alpha = 0.5;
    		}else if(model.isRollOver()){//normal over
	    		cl = cl.offsetHLS(0, 0.06, 0.06);
	    		innerDis = 4;
	    	}else{//normal
	    	}
    	}
		style = new StyleResult(cl, adjuster);
		g.beginFill(new SolidBrush(style.bdark));
		BasicGraphicsUtils.drawRoundRect(g, x, y, w, h, style.round);
		g.endFill();
		g.beginFill(new SolidBrush(style.clight));
		var r2:Number = style.round - 1;
		r2 = Math.max(0, r2);
		BasicGraphicsUtils.drawRoundRect(g, x+1, y+1, w-2, h-2, r2);
		g.endFill();
		
		dot.graphics.clear();
		if(drawDot){
			g = new Graphics2D(dot.graphics);
			cl = c.getMideground();
			adjuster = c.getStyleTune().mide;
			if(model.isArmed()){
				cl = cl.offsetHLS(0, -0.04, 0.03);
			}else if(model.isRollOver()){
				cl = cl.offsetHLS(0, 0.06, 0.00);
	    		adjuster = adjuster.sharpen(0.8);
			}else if(!b.isEnabled()){
	    		cl = cl.offsetHLS(0, 0.0, -0.3);
	    		adjuster = adjuster.sharpen(0.6);
			}else{
				
			}
			var mcls:StyleResult = new StyleResult(cl, adjuster);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w/2-3, h*3/4-5, Math.PI*3/4, x+3, y+5);
			dot.graphics.lineStyle(1.5, cl.getRGB());
			g.moveTo(x+4, y+5);
			g.lineTo(x+w/2+1, y+h*3/4-1);
			matrix.createGradientBox(w/2, h*3/4-2, Math.PI/4, x+w/2, y+2);
			g.lineTo(x+w+2.5, y);
			g.endDraw();
			dot.filters = 
				[new DropShadowFilter(0, 45, mcls.bdark.getRGB(), mcls.shadow, 2, 2, 4, 1, false)];
		}
		dot.visible = drawDot;
		box.alpha = alpha;
		box.filters = [
			new DropShadowFilter(innerDis, 45, 0x0, style.shadow*shadowScale, 5, 5, 1, 1, true), 
			new BevelFilter(1, 45, 0x0, style.shadow, 0xFFFFFF, style.shadow, 3, 3, 1, 1, BitmapFilterType.FULL)
		];
	}
	
	public function getIconHeight(c:Component):int{
		return 17;
	}
	
	public function getIconWidth(c:Component):int{
		return 17;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return sprite;
	}
	
}
}