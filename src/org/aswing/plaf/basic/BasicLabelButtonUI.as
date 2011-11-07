package org.aswing.plaf.basic{

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;

/**
 * @private
 */
public class BasicLabelButtonUI extends BasicButtonUI{
	
	public function BasicLabelButtonUI(){
		super();
	}
	
    override protected function getPropertyPrefix():String {
        return "LabelButton.";
    }
	
	override protected function installDefaults(bb:AbstractButton):void{
		super.installDefaults(bb);
    	bb.buttonMode = true;
	}
	
    override protected function getTextPaintColor(bb:AbstractButton):ASColor{
    	var b:JLabelButton = bb as JLabelButton;
		var pp:String = getPropertyPrefix();
		var cl:ASColor = bb.getForeground();
		var colors:StyleResult = new StyleResult(cl, bb.getStyleTune());
		
		var overColor:ASColor = b.getRollOverColor();
    	if(overColor == null || overColor is UIResource){
    		overColor = colors.clight;
    	}
    	var downColor:ASColor = b.getPressedColor();
    	if(downColor == null || downColor is UIResource){
    		downColor = colors.cdark;
    	}
    	
    	if(b.isEnabled()){
    		var model:ButtonModel = b.getModel();
    		if(model.isSelected() || (model.isPressed() && model.isArmed())){
    			return downColor;
    		}else if(b.isRollOverEnabled() && model.isRollOver()){
    			return overColor;
    		}
    		return cl;
    	}else{
    		return BasicGraphicsUtils.getDisabledColor(b);
    	}
    }
    
    /**
     * paint normal bg
     */
	override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void{
		if(c.isOpaque()){
			g.fillRectangle(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
		}		
	}
}
}