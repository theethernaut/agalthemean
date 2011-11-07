/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.*;
import org.aswing.plaf.basic.accordion.BasicAccordionHeader;

public class SkinAccordionHeader extends BasicAccordionHeader{
	
	public function SkinAccordionHeader(){
		super();
	}

	override protected function createHeaderButton():AbstractButton{
		var tb:JButton = new JButton();
		var sbg:SkinButtonBackground = new SkinButtonBackground(getPropertyPrefix());
		sbg.setDefaultsOwner(owner.getUI());
		tb.setBackgroundDecorator(sbg);
		return tb;
	}
	
	protected function getPropertyPrefix():String{
		return "Accordion.header.";
	}
	
	override public function setSelected(b:Boolean):void{
		button.setSelected(b);
	}
}
}