package org.aswing.plaf.basic.background{
	
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import org.aswing.*;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * @private
 */
public class ToggleButtonBackground implements GroundDecorator, UIResource{
	
    protected var shape:Shape;
    
	public function ToggleButtonBackground(){
		shape = new Shape();
	} 
		
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):void{
		var b:AbstractButton = c as AbstractButton;
		if(b == null){
			return;
		}
		
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		bounds = bounds.clone();
		// make 2 pixel space for shadow filter effect
		bounds.width -= 2;
		bounds.height -= 2;
		
		var cl:ASColor = c.getBackground();
		var style:StyleResult;
		var adjuster:StyleTune = c.getStyleTune();
		
		if(c.isOpaque()){
			var model:ButtonModel = b.getModel();
	    	var isPressing:Boolean = model.isArmed() || model.isSelected();
			var shadowScale:Number = 1;
			var bo:IntRectangle = bounds.clone();
			var matrix:Matrix = new Matrix();
			var cDir:Number = Math.PI/2;
			var paintDefault:Boolean = false;
			
	    	if(isPressing){//pressed
	    		if(!b.isEnabled()){
		    		cl = cl.offsetHLS(0, 0.2, -0.06);
		    		adjuster = adjuster.sharpen(0.4);
		    		shadowScale = 2;
	    		}else if(model.isRollOver()){
	    			cl = cl.offsetHLS(0, 0.025, 0);
	    		}
				bounds.width += b.getShiftOffset();
				bounds.height += b.getShiftOffset();
				shadowScale *= 2.5;
				cDir = -Math.PI/2;
	    	}else{
	    		if(!b.isEnabled()){//disabled
		    		cl = cl.offsetHLS(0, 0.2, -0.06);
		    		adjuster = adjuster.sharpen(0.4);
	    		}else if(model.isRollOver()){//normal over
		    		cl = cl.offsetHLS(0, 0.06, 0);
		    	}else{//normal
		    	}
	    	}
	    	
			style = new StyleResult(cl, adjuster);
			
			BasicGraphicsUtils.fillGradientRoundRect(g, bounds, style, cDir);
			
			matrix.createGradientBox(bo.width, bo.height, Math.PI/2, bo.x, bo.y);
			
			g.beginFill(new GradientBrush(
				GradientType.LINEAR, 
				[style.bdark.getRGB(), style.bdark.getRGB()], 
				[1, 0.6], 
				[0, 255], 
				matrix));
			BasicGraphicsUtils.drawRoundRectLine(g, bo.x, bo.y, bo.width, bo.height, style.round, 1);
			g.endFill();
			
			//if(!isPressing){
				matrix.createGradientBox(bo.width, bo.height, Math.PI/6, bo.x, bo.y);
				g.beginFill(new GradientBrush(
					GradientType.LINEAR, 
					[style.blight.getRGB(), style.blight.getRGB()], 
					[1, 0.5], 
					[0, 255], 
					matrix));
				bo.grow(-1, -1);
				BasicGraphicsUtils.drawRoundRectLine(g, bo.x, bo.y, bo.width, bo.height, style.round-1, 1);
				g.endFill();
			//}
			
    		shape.filters = [new DropShadowFilter(isPressing ? 2 : 1, 45, 0x0, style.shadow*shadowScale, 2, 2, 1, 1, isPressing)];
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
}