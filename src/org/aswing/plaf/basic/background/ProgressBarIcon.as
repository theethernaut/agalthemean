/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{
	
import flash.display.*;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * The barIcon decorator for ProgressBar.
 * @private
 */
public class ProgressBarIcon implements GroundDecorator, UIResource{
	
	protected var shape:Shape;
	protected var indeterminatePercent:Number;
	
	public function ProgressBarIcon(){
		shape = new Shape();
		indeterminatePercent = 0;
	}

	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, b:IntRectangle):void{
		if(c is JProgressBar){
			var bar:JProgressBar = JProgressBar(c);
			
			b = b.clone();
			var percent:Number;
			if(bar.isIndeterminate()){
				percent = indeterminatePercent;
				indeterminatePercent += 0.1;
				if(indeterminatePercent > 1){
					indeterminatePercent = 0;
				}
			}else{
				percent = bar.getPercentComplete();
			}
			var verticle:Boolean = (bar.getOrientation() == AsWingConstants.VERTICAL);
			shape.graphics.clear();
			var style:StyleTune = c.getStyleTune().mide;
			g = new Graphics2D(shape.graphics);
			var radius:Number = 0;
			var direction:Number;
			if(verticle){
				radius = Math.floor(b.width/2);
				direction = 0;
				b.height *= percent;
			}else{
				radius = Math.floor(b.height/2);
				direction = Math.PI/2;
				b.width *= percent;
			}
			if(radius > style.round){
				radius = style.round;
			}
			if(b.width > 1){
				var result:StyleResult = new StyleResult(c.getMideground(), style);
				BasicGraphicsUtils.fillGradientRoundRect(g, b, result, direction);
				BasicGraphicsUtils.drawGradientRoundRectLine(g, b, 1, result, direction);
				if(b.width-radius*2 > 0){
					g.fillRectangle(new SolidBrush(c.getMideground().changeAlpha(0.3)), radius, b.height-2.5, b.width-radius*2, 1.5);
				}
			}
			//shape.filters = [new GlowFilter(0x0, result.shadow, 1, 1, 8, 1, true)];
		}
	}
	
}
}