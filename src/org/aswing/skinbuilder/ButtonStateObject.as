/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.Sprite;
import flash.display.DisplayObject;
import org.aswing.geom.IntRectangle;

/**
 * A sprite that can view different child with different state set.
 * And scale by setSize().
 * @author iiley
 */
public class ButtonStateObject extends Sprite{
	
    protected var defaultImage:DisplayObject;
    protected var pressedImage:DisplayObject;
    protected var pressedSelectedImage:DisplayObject;
    protected var disabledImage:DisplayObject;
    protected var selectedImage:DisplayObject;
    protected var disabledSelectedImage:DisplayObject;
    protected var rolloverImage:DisplayObject;
    protected var rolloverSelectedImage:DisplayObject;
    protected var defaultButtonImage:DisplayObject;
    
    protected var enabled:Boolean = true;
    protected var pressed:Boolean = false;
    protected var selected:Boolean = false;
    protected var rollovered:Boolean = false;
    protected var defaultButton:Boolean = false;
    
    protected var lastViewedImage:DisplayObject;
    
	public function ButtonStateObject(){
		super();
		name = "ButtonStateObject";
		mouseEnabled = false;
		tabEnabled = false;
	}
	
	/**
	 * update the right image to view.
	 * @param r the bounds, null if not need to change the bounds of assets
	 */
	public function updateRepresent(r:IntRectangle=null):void{
 		var image:DisplayObject = defaultImage;
		var tmpImage:DisplayObject;
		if(!enabled){
			if(selected && disabledSelectedImage){
				tmpImage = disabledSelectedImage;
			}else{
				tmpImage = disabledImage;
			}
		}else if(pressed){
			if(selected && pressedSelectedImage){
				tmpImage = pressedSelectedImage;
			}else{
				tmpImage = pressedImage;
			}
		}else if(rollovered){
			if(selected && rolloverSelectedImage){
				tmpImage = rolloverSelectedImage;
			}else{
				tmpImage = rolloverImage;
			}
		}else if(selected){
			tmpImage = selectedImage;
		}else if(defaultButton){
			tmpImage = defaultButtonImage;
		}
		if(tmpImage != null){
			image = tmpImage;
		}
		if(image != lastViewedImage){
			if(lastViewedImage) lastViewedImage.visible = false;
			if(image) image.visible = true;
			lastViewedImage = image;
		}
		if(r != null){
			if(image){
				image.width = r.width;
				image.height = r.height;
			}
			this.x = r.x;
			this.y = r.y;
		}
	}
	
	public function setEnabled(b:Boolean):void{
		this.enabled = b;
	}
	
	public function setPressed(b:Boolean):void{
		this.pressed = b;
	}
	
	public function setSelected(b:Boolean):void{
		this.selected = b;
	}
	
	public function setRollovered(b:Boolean):void{
		this.rollovered = b;
	}
	
	public function setDefaultButton(b:Boolean):void{
		this.defaultButton = b;
	}
	
	protected function checkAsset(image:DisplayObject):void{
		if(image != null && contains(image)){
			throw new Error("You are set a already exists asset!");
		}
	}
	
	override public function addChild(child:DisplayObject):DisplayObject{
		if(child != null){
			child.visible = false;
			return super.addChild(child);
		}
		return null;
	}
	
	public function setDefaultButtonImage(image:DisplayObject):void{
		checkAsset(defaultButtonImage);
		defaultButtonImage = image;
		addChild(image);
	}
	
	public function setDefaultImage(image:DisplayObject):void{
		checkAsset(defaultImage);
		defaultImage = image;
		addChild(image);
	}
	
	public function setPressedImage(image:DisplayObject):void{
		checkAsset(pressedImage);
		pressedImage = image;
		addChild(image);
	}
	
	public function setPressedSelectedImage(image:DisplayObject):void{
		checkAsset(pressedSelectedImage);
		pressedSelectedImage = image;
		addChild(image);
	}
	
	public function setDisabledImage(image:DisplayObject):void{
		checkAsset(disabledImage);
		disabledImage = image;
		addChild(image);
	}
	
	public function setSelectedImage(image:DisplayObject):void{
		checkAsset(selectedImage);
		selectedImage = image;
		addChild(image);
	}
	
	public function setDisabledSelectedImage(image:DisplayObject):void{
		checkAsset(disabledSelectedImage);
		disabledSelectedImage = image;
		addChild(image);
	}
	
	public function setRolloverImage(image:DisplayObject):void{
		checkAsset(rolloverImage);
		rolloverImage = image;
		addChild(image);
	}
	
	public function setRolloverSelectedImage(image:DisplayObject):void{
		checkAsset(rolloverSelectedImage);
		rolloverSelectedImage = image;
		addChild(image);
	}
}
}