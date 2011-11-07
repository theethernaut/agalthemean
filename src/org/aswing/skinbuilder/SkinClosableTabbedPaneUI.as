package org.aswing.skinbuilder{

import org.aswing.*;
import org.aswing.plaf.basic.tabbedpane.ClosableTab;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.DisplayObject;
import org.aswing.event.TabCloseEvent;
import org.aswing.plaf.basic.tabbedpane.Tab;

public class SkinClosableTabbedPaneUI extends SkinTabbedPaneUI{
	
	public function SkinClosableTabbedPaneUI(){
		super();
	}
	
    override protected function getPropertyPrefix():String {
        return "ClosableTabbedPane.";
    }
	
	protected function getClosableTab(i:int):ClosableTab{
    	return ClosableTab(tabs[i]);
	}
	
    override protected function setTabProperties(header:Tab, i:int):void{
    	super.setTabProperties(header, i);
    	ClosableTab(header).getCloseButton().setEnabled(
    		JClosableTabbedPane(tabbedPane).isCloseEnabledAt(i)
    		&& tabbedPane.isEnabledAt(i));
    }
	
	override protected function installListeners():void{
		super.installListeners();
		tabbedPane.addEventListener(MouseEvent.CLICK, __onTabPaneClicked);
	}
	
	override protected function uninstallListeners():void{
		super.uninstallListeners();
		tabbedPane.removeEventListener(MouseEvent.CLICK, __onTabPaneClicked);
	}
	
	override protected function __onTabPanePressed(e:Event):void{
		if((prevButton.hitTestMouse() || nextButton.hitTestMouse())
			&& (prevButton.isShowing() && nextButton.isShowing())){
			return;
		}
		var index:int = getMousedOnTabIndex();
		if(index >= 0 && tabbedPane.isEnabledAt(index) && !isButtonEvent(e, index)){
			tabbedPane.setSelectedIndex(index);
		}
	}
	    
	protected function isButtonEvent(e:Event, index:int):Boolean{
		var eventTarget:DisplayObject = e.target as DisplayObject;
		if(eventTarget){
			var button:Component = getClosableTab(index).getCloseButton();
			if(button == eventTarget || button.contains(eventTarget)){
				return true;
			}
		}
		return false;
	}
	
	protected function __onTabPaneClicked(e:Event):void{
		var index:int = getMousedOnTabIndex();
		if(index >= 0 && tabbedPane.isEnabledAt(index) && isButtonEvent(e, index)){
			tabbedPane.dispatchEvent(new TabCloseEvent(index));
		}
	}	
}
}