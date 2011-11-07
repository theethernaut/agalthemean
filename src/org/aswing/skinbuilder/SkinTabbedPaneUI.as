/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.DisplayObject;
import flash.display.Sprite;

import org.aswing.*;
import org.aswing.event.InteractiveEvent;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.*;
import org.aswing.plaf.basic.tabbedpane.Tab;

public class SkinTabbedPaneUI extends BasicTabbedPaneUI implements GroundDecorator, UIResource{
	
	protected var contentRoundImageContainer:Sprite;
	protected var top_contentRoundImage:DisplayObject;
	protected var bottom_contentRoundImage:DisplayObject;
	protected var left_contentRoundImage:DisplayObject;
	protected var right_contentRoundImage:DisplayObject;
	protected var contentRoundImageSetPlacement:int;
		
	public function SkinTabbedPaneUI(){
		super();
		contentRoundImageContainer = AsWingUtils.createSprite(null, "contentRoundImageContainer");
	}
	
	override protected function installDefaults():void{
		super.installDefaults();
		
		top_contentRoundImage = getInstance(getPropertyPrefix() + "top.contentRoundImage") as DisplayObject;
		contentRoundImageContainer.addChild(top_contentRoundImage);
		contentRoundImageSetPlacement = JTabbedPane.TOP;
		
		bottom_contentRoundImage = getInstance(getPropertyPrefix() + "bottom.contentRoundImage") as DisplayObject;
		left_contentRoundImage = getInstance(getPropertyPrefix() + "left.contentRoundImage") as DisplayObject;
		right_contentRoundImage = getInstance(getPropertyPrefix() + "right.contentRoundImage") as DisplayObject;
		
		tabbedPane.setBackgroundDecorator(this);
	}
	
	override protected function uninstallDefaults():void{
		super.uninstallDefaults();
		if(contentRoundImageContainer.numChildren > 0){
			contentRoundImageContainer.removeChildAt(0);
		}

		while(tabs.length > 0){
			var header:Tab = Tab(tabs.pop());
			tabBarMC.removeChild(header.getTabComponent());
		}
	}
    
	override protected function createNextButton():AbstractButton{
		var b:JButton = new JButton();
		b.setIcon(new SkinButtonIcon(-1, -1, getPropertyPrefix() + "arrowRight.", tabbedPane));
		b.setBackgroundDecorator(null);
		return b;
	}
	
	override protected function createPrevButton():AbstractButton{
		var b:JButton = new JButton();
		b.setIcon(new SkinButtonIcon(-1, -1, getPropertyPrefix() + "arrowLeft.", tabbedPane));
		b.setBackgroundDecorator(null);
		return b;
	}

	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):void{}
	public function getDisplay(c:Component):DisplayObject{
		return contentRoundImageContainer;
	}
	
    override protected function drawBaseLine(tabBarBounds:IntRectangle, g:Graphics2D, fullB:IntRectangle, selTabB:IntRectangle):void{
    	var b:IntRectangle = tabBarBounds.clone();
    	var placement:int = tabbedPane.getTabPlacement();
    	
    	var contentRoundImage:DisplayObject;
		if(placement == JTabbedPane.TOP){
			contentRoundImage = top_contentRoundImage;
		}else if(placement == JTabbedPane.BOTTOM){
			contentRoundImage = bottom_contentRoundImage;
		}else if(placement == JTabbedPane.LEFT){
			contentRoundImage = left_contentRoundImage;
		}else{
			contentRoundImage = right_contentRoundImage;
		}
		
    	if(contentRoundImage.parent != contentRoundImageContainer){
    		contentRoundImageContainer.removeChildAt(0);
    		contentRoundImageContainer.addChild(contentRoundImage);
    	}
    	
    	if(isTabHorizontalPlacing()){
    		var isTop:Boolean = (placement == JTabbedPane.TOP);
    		if(isTop){
    			b.y = b.y + b.height - contentMargin.top;
    		}
    		b.height = contentMargin.top;
    		b.width = fullB.width;
    		b.x = fullB.x;
			if(isTop){
				contentRoundImage.x = b.x;
				contentRoundImage.y = b.y;
				contentRoundImage.width = fullB.width;
				contentRoundImage.height = fullB.rightBottom().y - b.y;
			}else{
				contentRoundImage.x = fullB.x;
				contentRoundImage.y = fullB.y;
				contentRoundImage.width = fullB.width;
				contentRoundImage.height = b.y+b.height-fullB.y;
			}
    	}else{
    		var isLeft:Boolean = (placement == JTabbedPane.LEFT);
    		if(isLeft){
    			b.x = b.x + b.width - contentMargin.top;
    		}
    		b.width = contentMargin.top;
    		b.height = fullB.height;
    		b.y = fullB.y;
			if(isLeft){
				contentRoundImage.x = b.x;
				contentRoundImage.y = b.y;
				contentRoundImage.width = fullB.rightTop().x-b.x;
				contentRoundImage.height = b.height;
			}else{
				contentRoundImage.x = fullB.x;
				contentRoundImage.y = fullB.y;
				contentRoundImage.width = b.x+b.width-fullB.x;
				contentRoundImage.height = b.height;
			}
    	}
    }    
    
    override protected function drawTabBorderAt(index:int, b:IntRectangle, paneBounds:IntRectangle, g:Graphics2D):void{
    	var placement:int = tabbedPane.getTabPlacement();
    	b = b.clone();//make a clone to be safty modification
    	if(index == tabbedPane.getSelectedIndex()){
    		if(isTabHorizontalPlacing()){
    			b.x -= selectedTabExpandInsets.left;
    			b.width += (selectedTabExpandInsets.left + selectedTabExpandInsets.right);
	    		b.height += Math.round(topBlankSpace/2+contentRoundLineThickness);
    			if(placement == JTabbedPane.BOTTOM){
	    			b.y -= contentRoundLineThickness;
    			}else{
	    			b.y -= Math.round(topBlankSpace/2);
    			}
    		}else{
    			b.y -= selectedTabExpandInsets.left;
    			b.height += (selectedTabExpandInsets.left + selectedTabExpandInsets.right);
	    		b.width += Math.round(topBlankSpace/2+contentRoundLineThickness);
    			if(placement == JTabbedPane.RIGHT){
	    			b.x -= contentRoundLineThickness;
    			}else{
	    			b.x -= Math.round(topBlankSpace/2);
    			}
    		}
    	}
    	//This is important, should call this in sub-implemented drawTabBorderAt method
    	setDrawnTabBounds(index, b, paneBounds);
		var tab:SkinTabbedPaneTab = getTab(index) as SkinTabbedPaneTab;
		tab.setTabPlacement(placement);
    }
	
	override protected function drawTabAt(index:int, bounds:IntRectangle, paneBounds:IntRectangle, g:Graphics2D, transformedTabMargin:Insets):void{
		//trace("drawTabAt : " + index + ", bounds : " + bounds + ", g : " + g);
		drawTabBorderAt(index, bounds, paneBounds, g);
		
		var tab:Tab = getTab(index);
		tab.setSelected(index == tabbedPane.getSelectedIndex());
		var tc:Component = tab.getTabComponent();
		tc.setComBounds(getDrawnTabBounds(index));
		if(index == tabbedPane.getSelectedIndex()){
			if (tc.parent.contains(topTabCom)){
				tc.parent.swapChildren(tc, topTabCom);
			}
			topTabCom = tc;
		}
	}
	
    override protected function createNewTab():Tab{
    	var tab:Tab = super.createNewTab();
    	topTabCom = tab.getTabComponent();
    	return tab;
    }
    	
    override protected function setTabMarginProperty(tab:Tab, margin:Insets):void{
    	tab.setMargin(margin);
    }
	
	override protected function __onSelectionChanged(e:InteractiveEvent):void{
		tabbedPane.revalidate();
		tabbedPane.paintImmediately();
	}  
}
}