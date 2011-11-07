/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.*;
import flash.events.*;

import org.aswing.*;
import org.aswing.error.ImpMissError;
import org.aswing.event.*;
import org.aswing.geom.*;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.*;

public class SelfHandleStateDecorator extends DefaultsDecoratorBase implements GroundDecorator, Icon, UIResource{
	
    protected var thumb:ButtonStateObject;
    
    protected var defaultImage:DisplayObject;
    protected var pressedImage:DisplayObject;
    protected var disabledImage:DisplayObject;
    protected var rolloverImage:DisplayObject;
    
    protected var size:IntDimension;
    
    protected var enabled:Boolean;
	protected var rollover:Boolean;
	protected var pressed:Boolean;
	
	protected var origWidth:int;
	protected var origHeight:int;
	
	protected var loaded:Boolean;
	
	public function SelfHandleStateDecorator(){
		thumb = new ButtonStateObject();
		rollover = false;
		pressed = false;
		enabled = true;
		loaded = false;
		initSelfHandlers();
	}
	
	private function checkReloadAssets(c:Component):void{
		if(loaded){
			return;
		}
		loaded = true;
		var ui:ComponentUI = getDefaultsOwner(c);
		var defaultImage:DisplayObject = getAsset(ui, "defaultImage");
		origWidth = defaultImage.width;
		origHeight = defaultImage.height;
		thumb.setDefaultImage(defaultImage);
		thumb.setPressedImage(getAsset(ui, "pressedImage"));
		thumb.setDisabledImage(getAsset(ui, "disabledImage"));
		thumb.setRolloverImage(getAsset(ui, "rolloverImage"));
		thumb.mouseEnabled = c.isEnabled();
	}
	
	
    protected function getAsset(ui:ComponentUI, exName:String):DisplayObject {
        return ui.getInstance(getPropertyPrefix()+exName) as DisplayObject;
    }
    
    protected function getPropertyPrefix():String{
    	throw new ImpMissError();
    	return null;
    }
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):void{
		checkReloadAssets(c);
		thumb.x = bounds.x;
		thumb.y = bounds.y;
		size = bounds.getSize();
		enabled = c.isEnabled();
		paint();
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		checkReloadAssets(c);
		thumb.x = x;
		thumb.y = y;
		size = null;
		enabled = c.isEnabled();
		paint();
	}
	
	public function getIconHeight(c:Component):int{
		checkReloadAssets(c);
		return origHeight;
	}
	
	public function getIconWidth(c:Component):int{
		checkReloadAssets(c);
		return origWidth;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		checkReloadAssets(c);
		return thumb;
	}
	
	protected function paint():void{
		thumb.mouseEnabled = enabled;
		thumb.setEnabled(enabled);
		thumb.setPressed(pressed);
		thumb.setRollovered(rollover);
		thumb.updateRepresent(size != null ? size.getBounds() : null);
	}

	private function initSelfHandlers():void{
		thumb.addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
		thumb.addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
	}
	
	private function __rollOverListener(e:Event):void{
		rollover = true;
		paint();
	}
	private function __rollOutListener(e:Event):void{
		rollover = false;
		if(!pressed){
			paint();
		}
	}
	private function __mouseDownListener(e:Event):void{
		pressed = true;
		paint();
		if(thumb.stage){
			thumb.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpListener, false, 0, true);
		}
	}
	private function __mouseUpListener(e:Event):void{
		if(pressed){
			pressed = false;
			paint();
		}
		var st:Stage = e.currentTarget as Stage;
		st.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpListener);
	}
	
}
}