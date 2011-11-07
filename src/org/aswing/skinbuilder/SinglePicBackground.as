/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.DisplayObject;

import org.aswing.*;
import org.aswing.error.ImpMissError;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.*;

public class SinglePicBackground extends DefaultsDecoratorBase implements GroundDecorator, UIResource{
	protected var image:DisplayObject;
	protected var loaded:Boolean;
	protected var avoidBorderMargin:Boolean;
	
	public function SinglePicBackground(){
		loaded = false;
		avoidBorderMargin = true;
	}
	
	protected function getDefaltsKey():String{
		throw new ImpMissError();
		return null;
	}
	
	protected function checkLoad(c:Component):void{
		if(!loaded){
			var ui:ComponentUI = getDefaultsOwner(c);
			image = ui.getInstance(getDefaltsKey()) as DisplayObject;
			loaded = true;
		}
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):void{
		checkLoad(c);
		if(image){
			//not use bounds, avoid border margin
			if(avoidBorderMargin){
				image.x = 0;
				image.y = 0;
				image.width = c.width;
				image.height = c.height;
			}else{
				image.x = bounds.x;
				image.y = bounds.y;
				image.width = bounds.width;
				image.height = bounds.height;
			}
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		checkLoad(c);
		return image;
	}
	
}
}