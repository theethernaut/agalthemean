/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.tabbedpane{

import org.aswing.*;

/**
 * BasicTabbedPaneTab implemented with a JLabel 
 * @author iiley
 * @private
 */
public class BasicTabbedPaneTab implements Tab{
		
	protected var button:AbstractButton;
	protected var owner:Component;
	protected var placement:int;
	
	public function BasicTabbedPaneTab(){
		placement = 0;
	}
	
	public function initTab(owner:Component):void{
		this.owner = owner;
		button = createHeaderButton();
	}
	
	public function setTabPlacement(tp:int):void{	
		placement = tp;
	}
	
	public function getTabPlacement():int{
		return placement;
	}
	
	protected function createHeaderButton():AbstractButton{
		var btn:AbstractButton = new JButton();
		btn.setBackgroundDecorator(new TabBackground(this));
		btn.setTextFilters([]);
		return btn;
	}
	
	public function setTextAndIcon(text : String, icon : Icon) : void {
		button.setText(text);
		button.setIcon(icon);
	}
	
	public function setFont(font:ASFont):void{
		button.setFont(font);
	}
	
	public function setForeground(color:ASColor):void{
		button.setForeground(color);
	}
	
	public function setSelected(b:Boolean):void{
		//Do nothing here, if your header is selectable, you can set it here like
		button.setSelected(b);
	}
	
    public function setVerticalAlignment(alignment:int):void {
    	button.setVerticalAlignment(alignment);
    }
    public function setHorizontalAlignment(alignment:int):void {
    	button.setHorizontalAlignment(alignment);
    }
    public function setVerticalTextPosition(textPosition:int):void {
    	button.setVerticalTextPosition(textPosition);
    }
    public function setHorizontalTextPosition(textPosition:int):void {
    	button.setHorizontalTextPosition(textPosition);
    }
    public function setIconTextGap(iconTextGap:int):void {
    	button.setIconTextGap(iconTextGap);
    }
    public function setMargin(m:Insets):void{
    	button.setMargin(m);
    }

	public function getTabComponent() : Component {
		return button;
	}

}
}