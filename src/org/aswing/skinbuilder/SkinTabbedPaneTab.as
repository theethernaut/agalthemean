/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.*;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.basic.accordion.BasicAccordionHeader;

public class SkinTabbedPaneTab extends BasicAccordionHeader{
	
	protected var topBG:SkinButtonBackground;
	protected var bottomBG:SkinButtonBackground;
	protected var leftBG:SkinButtonBackground;
	protected var rightBG:SkinButtonBackground;
	protected var tabPlacement:int;	
	protected var defaultsOwner:ComponentUI;
	
	public function SkinTabbedPaneTab(){
		super();
		tabPlacement = -1;
	}
	
	override public function setTabPlacement(tp:int):void{
		if(tabPlacement != tp){
			tabPlacement = tp;
			if(tp == JTabbedPane.TOP){
				button.setBackgroundDecorator(topBG);
			}else if(tp == JTabbedPane.LEFT){
				button.setBackgroundDecorator(leftBG);
			}else if(tp == JTabbedPane.RIGHT){
				button.setBackgroundDecorator(rightBG);
			}else{
				button.setBackgroundDecorator(bottomBG);
			}
			button.repaint();
		}
	}
	
	override protected function createHeaderButton():AbstractButton{
		var tb:JButton = new JButton();
		tb.setTextFilters([]);
		topBG = new SkinButtonBackground(getPropertyPrefix() + "top.tab.");
		bottomBG = new SkinButtonBackground(getPropertyPrefix() + "bottom.tab.");
		leftBG = new SkinButtonBackground(getPropertyPrefix() + "left.tab.");
		rightBG = new SkinButtonBackground(getPropertyPrefix() + "right.tab.");
		topBG.setDefaultsOwner(owner.getUI());
		bottomBG.setDefaultsOwner(owner.getUI());
		leftBG.setDefaultsOwner(owner.getUI());
		rightBG.setDefaultsOwner(owner.getUI());
		tb.setBackgroundDecorator(topBG);
		return tb;
	}
	
	protected function getPropertyPrefix():String{
		return "TabbedPane.";
	}
	
	override public function setSelected(b:Boolean):void{
		button.setSelected(b);
	}
}
}