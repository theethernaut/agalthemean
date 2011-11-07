package org.aswing.paling
{
import flash.display.*;

import org.aswing.Component;
import org.aswing.Icon;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.UIResource;

public class PalingFrameIcon implements Icon, UIResource
{
	protected var stateAsset:Sprite;
	private var ifGet:Boolean=false;
	
	public function PalingFrameIcon(){
		stateAsset=new Sprite();
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		if(!ifGet){
		   ifGet=true;
		   var ui:ComponentUI=c.getUI();
		   stateAsset.addChild(ui.getInstance("Frame.icon.defaultImage"));
		}
		return stateAsset;
	}
	
	public function getIconWidth(c:Component):int
	{
		return 18;
	}
	
	public function getIconHeight(c:Component):int
	{
		return 24;
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void
	{
	}
	
}
}