/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.DisplayObject;
import flash.display.Sprite;

import org.aswing.*;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.graphics.SolidBrush;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.DefaultsDecoratorBase;
import org.aswing.plaf.UIResource;

public class SkinFrameBackground extends DefaultsDecoratorBase implements GroundDecorator, UIResource{
	
	protected var imageContainer:Sprite;
	protected var activeBG:DisplayObject;
	protected var inactiveBG:DisplayObject;
	
	public function SkinFrameBackground(){
		imageContainer = AsWingUtils.createSprite(null, "bgContainer");
	}
	
	private function reloadAssets(ui:ComponentUI):void{
		activeBG = ui.getInstance("Frame.activeBG") as DisplayObject;
		inactiveBG = ui.getInstance("Frame.inactiveBG") as DisplayObject;
		imageContainer.addChild(activeBG);
		imageContainer.addChild(inactiveBG);
		inactiveBG.visible = false;
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, b:IntRectangle):void{
		if(activeBG == null){
			reloadAssets(getDefaultsOwner(c));
		}
		var frame:JFrame = JFrame(c);
		activeBG.visible = frame.getFrameUI().isPaintActivedFrame();
		inactiveBG.visible = !frame.getFrameUI().isPaintActivedFrame();
		//not use bounds, avoid the border
		activeBG.width = inactiveBG.width = c.width;
		activeBG.height = inactiveBG.height = c.height;
		
		if(c.isOpaque()){
			g.fillRectangle(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return imageContainer;
	}
	
}
}