/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon{

import flash.display.*;
import flash.geom.Matrix;

import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.Icon;
import org.aswing.StyleResult;
import org.aswing.StyleTune;
import org.aswing.graphics.*;
import org.aswing.plaf.*;

/**
 * @private
 */
public class SliderThumbIcon implements Icon, UIResource{
	
	protected var thumb:Sprite;
	protected var enabledButton:SimpleButton;
	protected var disabledButton:SimpleButton;
	protected var overButton:SimpleButton;
		
	public function SliderThumbIcon(){
		thumb = new Sprite();
	}
	
	protected function getPropertyPrefix():String {
		return "Slider.";
	}	
	
	protected function initThumb(c:Component):void{
		//enabled
		enabledButton = new SimpleButton();
		var upState:Shape = new Shape();
		var g:Graphics2D = new Graphics2D(upState.graphics);
    	paintThumb(g, c, true, false);
		var overState:Shape = new Shape();
		g = new Graphics2D(overState.graphics);
    	paintThumb(g, c, true, true);    	
    	
    	enabledButton.upState = upState; 
		enabledButton.overState = overState;
		enabledButton.downState = overState;
		enabledButton.hitTestState = upState;
		enabledButton.useHandCursor = false;
		thumb.addChild(enabledButton);
		
		//disabled
		disabledButton = new SimpleButton();
		upState = new Shape();
		g = new Graphics2D(upState.graphics);
    	
    	paintThumb(g, c, false, false);
    	disabledButton.upState = upState; 
		disabledButton.overState = upState;
		disabledButton.downState = upState;
		disabledButton.hitTestState = upState;
		disabledButton.useHandCursor = false;
		thumb.addChild(disabledButton);
		disabledButton.visible = false;
	}
	
	private function paintThumb(g:Graphics2D, c:Component, enabled:Boolean, over:Boolean):void{
    	var tune:StyleTune = c.getStyleTune().mide;
    	var cl:ASColor = c.getMideground();
    	if(!enabled){//disabled
    		cl = cl.offsetHLS(0, -0.1, -0.1);
    		tune = tune.sharpen(0.2);
    	}else if(over){//pressed
    		cl = cl.offsetHLS(-0.20, 0, 0);
    	}
    	var style:StyleResult = new StyleResult(cl, tune);
    	var w:int = getIconWidth(null);
    	var h:int = getIconHeight(null);
    	var matrix:Matrix = new Matrix();
    	matrix.createGradientBox(w, h, Math.PI/2, 0, 0);
    	var brush:GradientBrush = new GradientBrush(
    		GradientBrush.LINEAR, 
    		[style.blight.getRGB(), style.bdark.getRGB()], 
    		[style.blight.getAlpha(), style.bdark.getAlpha()], 
    		[0, 255], 
    		matrix
    	);
    	g.fillEllipse(brush, 0, 0, w, h);
    	
    	matrix.createGradientBox(w, h, -Math.PI/2, 0, 0);
    	brush.setColors([style.clight.getRGB(), style.cdark.getRGB()]);
    	brush.setAlphas([style.clight.getAlpha(), style.cdark.getAlpha()]);
    	g.fillEllipse(brush, 1, 1, w-2, h-2);
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		if(enabledButton == null){
			initThumb(c);
		}
		thumb.x = x;
		thumb.y = y;
		disabledButton.visible = !c.isEnabled();
		enabledButton.visible = c.isEnabled();
	}
	
	public function getIconHeight(c:Component):int{
		return 14;
	}
	
	public function getIconWidth(c:Component):int{
		return 14;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return thumb;
	}
	
}
}