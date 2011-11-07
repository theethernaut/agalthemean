/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.adjuster{

import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.basic.BasicSliderUI;

/**
 * SliderUI for JAdjuster popup slider.
 * @author iiley
 * @private
 */
public class PopupSliderUI extends BasicSliderUI{
	
	public function PopupSliderUI(){
		super();
	}
	
	override protected function getPropertyPrefix():String {
		return "Adjuster.";
	}
	
	override protected function countTrackRect(b:IntRectangle):void{
		var thumbSize:IntDimension = getThumbSize();
		var h_margin:int, v_margin:int;
		if(isVertical()){
			v_margin = Math.ceil(thumbSize.height/2.0);
			h_margin = (thumbSize.width - 4)/2;;
			trackDrawRect.setRectXYWH(b.x+h_margin, b.y+v_margin, 
				thumbSize.width-h_margin*2, b.height-v_margin*2);
			trackRect.setRectXYWH(b.x, b.y+v_margin, 
				thumbSize.width, b.height-v_margin*2);
		}else{
			h_margin = Math.ceil(thumbSize.width/2.0);
			v_margin = (thumbSize.height - 4)/2;
			trackDrawRect.setRectXYWH(b.x+h_margin, b.y+v_margin, 
				b.width-h_margin*2, thumbSize.height-v_margin*2);
			trackRect.setRectXYWH(b.x+h_margin, b.y, 
				b.width-h_margin*2, thumbSize.height);
		}
	}
	
	override protected function paintTrack(g:Graphics2D, drawRect:IntRectangle):void{
		trackCanvas.graphics.clear();
		if(!slider.getPaintTrack()){
			return;
		}
		g = new Graphics2D(trackCanvas.graphics);
		var verticle:Boolean = (slider.getOrientation() == AsWingConstants.VERTICAL);
		var style:StyleTune = slider.getStyleTune();
		var b:IntRectangle = drawRect.clone();
		var radius:Number = 0;
		if(verticle){
			radius = Math.floor(b.width/2);
		}else{
			radius = Math.floor(b.height/2);
		}
		if(radius > style.round){
			radius = style.round;
		}
		g.fillRoundRect(new SolidBrush(slider.getBackground()), b.x, b.y, b.width, b.height, radius);
		trackCanvas.filters = [
			new GlowFilter(0x0, style.shadowAlpha, 5, 5, 1, 1, true), 
			new DropShadowFilter(1, 45, 0xFFFFFF, 0.3, 1, 1, 1, 1)];		
	}
		
		
	override protected function getPrefferedLength():int{
		return 100;
	}
}
}