/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic
{

import org.aswing.*;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.BaseComponentUI;

/**
 * @private
 * @author iiley
 */
public class BasicPanelUI extends BaseComponentUI
{
	public function BasicPanelUI()
	{
		super();
	}
	
	override public function installUI(c:Component):void {
		var p:JPanel = JPanel(c);
		installDefaults(p);
	}

	override public function uninstallUI(c:Component):void {
		var p:JPanel = JPanel(c);
		uninstallDefaults(p);
	}

	protected function installDefaults(p:JPanel):void {
		var pp:String = "Panel.";
		LookAndFeel.installColorsAndFont(p, pp);
		LookAndFeel.installBorderAndBFDecorators(p, pp);
		LookAndFeel.installBasicProperties(p, pp);
	}

	protected function uninstallDefaults(p:JPanel):void {
		LookAndFeel.uninstallBorderAndBFDecorators(p);
	}
	
	override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void{
		//do nothing, bg decorator will do this job
	}
}
}