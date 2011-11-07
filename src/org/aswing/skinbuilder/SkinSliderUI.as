/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.plaf.basic.*;
import org.aswing.*;
import org.aswing.plaf.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.util.*;
import org.aswing.event.*;
import flash.events.*;
import flash.display.*;

public class SkinSliderUI extends BasicSliderUI{
	
	protected var vertical_trackImage:DisplayObject;
	protected var vertical_trackDisabledImage:DisplayObject;
	protected var vertical_trackProgressImage:DisplayObject;
	protected var vertical_trackProgressDisabledImage:DisplayObject;
	
	protected var horizontal_trackImage:DisplayObject;
	protected var horizontal_trackDisabledImage:DisplayObject;
	protected var horizontal_trackProgressImage:DisplayObject;
	protected var horizontal_trackProgressDisabledImage:DisplayObject;
	
	protected var trackContainer:Sprite;
	protected var progressContainer:Sprite;
	protected var thumIconSize:IntDimension;
	protected var trackOriginalLength:int;
	
	public function SkinSliderUI(){
		super();
	}
	
	override protected function installComponents():void{
		progressCanvas = new Shape();//to make super class runnable
		var pp:String = getPropertyPrefix();
		vertical_trackImage = getInstance(pp+"vertical.trackImage") as DisplayObject;
		vertical_trackDisabledImage = getInstance(pp+"vertical.trackDisabledImage") as DisplayObject;
		vertical_trackProgressImage = getInstance(pp+"vertical.trackProgressImage") as DisplayObject;
		vertical_trackProgressDisabledImage = getInstance(pp+"vertical.trackProgressDisabledImage") as DisplayObject;
		horizontal_trackImage = getInstance(pp+"horizontal.trackImage") as DisplayObject;
		horizontal_trackDisabledImage = getInstance(pp+"horizontal.trackDisabledImage") as DisplayObject;
		horizontal_trackProgressImage = getInstance(pp+"horizontal.trackProgressImage") as DisplayObject;
		horizontal_trackProgressDisabledImage = getInstance(pp+"horizontal.trackProgressDisabledImage") as DisplayObject;
		
		trackOriginalLength = horizontal_trackImage.width;
		
		trackContainer = AsWingUtils.createSprite(null, "trackContainer");
		progressContainer = AsWingUtils.createSprite(null, "progressContainer");
		slider.addChild(trackContainer);
		slider.addChild(progressContainer);
		
		thumbIcon = getIcon(pp+"thumbIcon");
		var thumbAsset:DisplayObject = thumbIcon.getDisplay(slider);
		if(thumbAsset == null){
			throw new Error("Slider thumb icon must has its own display object(getDisplay()!=null)!");
		}
		slider.addChild(thumbAsset);
		thumIconSize = new IntDimension(thumbIcon.getIconWidth(slider), thumbIcon.getIconHeight(slider));
	}
	
	override protected function uninstallComponents():void{
		slider.removeChild(trackContainer);
		slider.removeChild(progressContainer);
		slider.removeChild(thumbIcon.getDisplay(slider));
		progressCanvas = null;
	}
	

	override protected function getPrefferedLength():int{
		return trackOriginalLength;
	}
		
	override protected function getThumbSize():IntDimension{
		if(isVertical()){
			return new IntDimension(thumIconSize.height, thumIconSize.width);
		}else{
			return new IntDimension(thumIconSize.width, thumIconSize.height);
		}
	}
	
	override protected function countTrackRect(b:IntRectangle):void{
		var thumbSize:IntDimension = getThumbSize();
		var drawRect:IntRectangle;
		var left:int = thumIconSize.width/2;
		var mwidth:int = thumIconSize.width;
		if(isVertical()){
			trackDrawRect.setRectXYWH(b.x, b.y, 
				thumbSize.width, b.height);
			trackRect.setRectXYWH(b.x, b.y+left, 
				thumbSize.width, b.height-mwidth);
		}else{
			trackDrawRect.setRectXYWH(b.x, b.y, 
				b.width, thumbSize.height);
			trackRect.setRectXYWH(b.x+left, b.y, 
				b.width-mwidth, thumbSize.height);
		}
	}
	
	override protected function paintThumb(g:Graphics2D, drawRect:IntRectangle):void{
		thumbIcon.updateIcon(slider, g, drawRect.x, drawRect.y);
	}

	override protected function paintTrack(g:Graphics2D, drawRect:IntRectangle):void{
		trackContainer.visible = slider.getPaintTrack();
		if(!trackContainer.visible){
			return;
		}
		if(trackContainer.numChildren > 0){
			trackContainer.removeChildAt(0);
		}
		var tImage:DisplayObject;
		if(slider.isEnabled()){
			if(isVertical()){
				tImage = vertical_trackImage;
			}else{
				tImage = horizontal_trackImage;
			}
		}else{
			if(isVertical()){
				tImage = vertical_trackDisabledImage;
			}else{
				tImage = horizontal_trackDisabledImage;
			}
		}
		trackContainer.addChild(tImage);
		trackContainer.x = drawRect.x;
		trackContainer.y = drawRect.y;
		tImage.width = drawRect.width;
		tImage.height = drawRect.height;
		paintTrackProgress(null, drawRect);
	}
	
	override protected function paintTrackProgress(g:Graphics2D, trackDrawRect:IntRectangle):void{
		progressContainer.visible = slider.getPaintTrack();
		if(!progressContainer.visible){
			return;
		}

		if(progressContainer.numChildren > 0){
			progressContainer.removeChildAt(0);
		}
		var tImage:DisplayObject;
		if(slider.isEnabled()){
			if(isVertical()){
				tImage = vertical_trackProgressImage;
			}else{
				tImage = horizontal_trackProgressImage;
			}
		}else{
			if(isVertical()){
				tImage = vertical_trackProgressDisabledImage;
			}else{
				tImage = horizontal_trackProgressDisabledImage;
			}
		}
		progressContainer.addChild(tImage);
				
		var rect:IntRectangle = trackRect.clone();
		var width:int;
		var height:int;
		var x:int;
		var y:int;
		var inverted:Boolean = slider.getInverted();
		if(isVertical()){
			width = rect.width;
			height = thumbRect.y + thumbRect.height/2 - rect.y;
			x = rect.x;
			if(inverted){
				y = rect.y;
			}else{
				height = rect.y + rect.height - thumbRect.y - thumbRect.height/2;
				y = thumbRect.y + thumbRect.height/2;
			}
		}else{
			height = rect.height;
			if(inverted){
				width = rect.x + rect.width - thumbRect.x - thumbRect.width/2;
				x = thumbRect.x + thumbRect.width/2;
			}else{
				width = thumbRect.x + thumbRect.width/2 - rect.x;
				x = rect.x;
			}
			y = rect.y;
		}
		progressContainer.x = x;
		progressContainer.y = y;
		tImage.width = width;
		tImage.height = height;		
	}	
}
}