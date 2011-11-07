/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic{

import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.FrameTitleBar;
import org.aswing.LookAndFeel;
import org.aswing.StyleResult;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.BaseComponentUI;

/**
 * @private
 * @author iiley
 */
public class BasicFrameTitleBarUI extends BaseComponentUI{
	
	protected var bar:FrameTitleBar;
	
	public function BasicFrameTitleBarUI(){
		super();
	}

	override public function installUI(c:Component):void {
		bar = c as FrameTitleBar;
		installDefaults();
		installComponent();
	}

	override public function uninstallUI(c:Component):void {
		uninstallDefaults();
		uninstallComponent();
		bar = null;
	}

	protected function installDefaults():void {
		var pp:String = "FrameTitleBar.";
		LookAndFeel.installColorsAndFont(bar.getSelf(), pp);
		LookAndFeel.installBorderAndBFDecorators(bar.getSelf(), pp);
		LookAndFeel.installBasicProperties(bar.getSelf(), pp);
	}
	
	protected function installComponent():void{
		if(bar.getIconifiedButton()){
			bar.getIconifiedButton().setIcon(getIcon("FrameTitleBar.iconifiedIcon"));
		}
		if(bar.getMaximizeButton()){
			bar.getMaximizeButton().setIcon(getIcon("FrameTitleBar.maximizeIcon"));
		}
		if(bar.getRestoreButton()){
			bar.getRestoreButton().setIcon(getIcon("FrameTitleBar.normalIcon"));
		}
		if(bar.getCloseButton()){
			bar.getCloseButton().setIcon(getIcon("FrameTitleBar.closeIcon"));
		}
			
		bar.setButtonIconGap(getInt("FrameTitleBar.buttonGap"));
		bar.setMinimizeHeight(getInt("FrameTitleBar.titleBarHeight"));
		bar.getSelf().revalidateIfNecessary();
	}
	
	protected function uninstallComponent():void{
	}
	
	protected function uninstallDefaults():void {
		LookAndFeel.uninstallBorderAndBFDecorators(bar.getSelf());
	}
	
	override public function paint(c:Component, g:Graphics2D, b:IntRectangle):void{
		super.paint(c, g, b);
		
		var cl:ASColor = bar.getSelf().getForeground();
		var colors:StyleResult = new StyleResult(cl, bar.getSelf().getStyleTune());
		bar.getLabel().setForeground(bar.isActive() ? colors.bdark : colors.blight);
		bar.getLabel().setFont(bar.getSelf().getFont());
		bar.getLabel().paintImmediately();
	}
	
	override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void{
		//do nothing, bg decorator will do this job
	}	
}
}