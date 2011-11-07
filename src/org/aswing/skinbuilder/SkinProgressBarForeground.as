/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.*;

import org.aswing.*;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.*;

public class SkinProgressBarForeground extends DefaultsDecoratorBase implements GroundDecorator, UIResource{

	protected var verticalImage:DisplayObject;
	protected var horizotalImage:DisplayObject;
	protected var imageContainer:Sprite;
	protected var fgMargin:Insets;
	protected var loaded:Boolean;
	protected var indeterminatePercent:Number;
	
	public function SkinProgressBarForeground(){
		imageContainer = AsWingUtils.createSprite(null, "imageContainer");
		imageContainer.mouseChildren = false;
		loaded = false;
		indeterminatePercent = 0;
	}
	
	protected function checkReloadAssets(c:Component):void{
		if(!loaded){
			var ui:ComponentUI = getDefaultsOwner(c);
			verticalImage = ui.getInstance(getPropertyPrefix()+"verticalFGImage") as DisplayObject;
			horizotalImage = ui.getInstance(getPropertyPrefix()+"horizotalFGImage") as DisplayObject;
			fgMargin = ui.getInsets(getPropertyPrefix()+"fgMargin");
			loaded = true;
		}
	}
    	
    protected function getPropertyPrefix():String {
        return "ProgressBar.";
    }
	
	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):void{
		checkReloadAssets(com);
		var bar:JProgressBar = JProgressBar(com);
		var image:DisplayObject;
		var removeImage:DisplayObject;
		if(bar.getOrientation() == AsWingConstants.HORIZONTAL){
			image = horizotalImage;
			removeImage = verticalImage;
		}else{
			image = verticalImage;
			removeImage = horizotalImage;
		}

		if(image){
			if(!imageContainer.contains(image)){
				imageContainer.addChild(image);
			}
		}
		if(removeImage){
			if(imageContainer.contains(removeImage)){
				imageContainer.removeChild(removeImage);
			}
		}
		var percent:Number;
		if(bar.isIndeterminate()){
			percent = indeterminatePercent;
			indeterminatePercent += 0.05;
			if(indeterminatePercent > 1){
				indeterminatePercent = 0;
			}
		}else{
			percent = bar.getPercentComplete();
		}
		var bounds:IntRectangle = bounds.clone();
		if(fgMargin != null){
			if(bar.getOrientation() == AsWingConstants.HORIZONTAL){
				bounds = fgMargin.getInsideBounds(bounds);
			}else{//transfer if vertical
				bounds = new Insets(fgMargin.right, fgMargin.top, fgMargin.left, fgMargin.bottom).getInsideBounds(bounds);
			}
		}
		imageContainer.x = bounds.x;
		imageContainer.y = bounds.y;
		if(image){
			if(bar.getOrientation() == AsWingConstants.HORIZONTAL){
				image.width = Math.round(bounds.width * percent);
				image.height = bounds.height;
				image.y = 0;
				image.x = 0;
			}else{
				image.width = bounds.width;
				image.height = Math.round(bounds.height * percent);
				image.y = bounds.height - image.height;
				image.x = 0;
			}
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		checkReloadAssets(c);
		return imageContainer;
	}
	
}
}