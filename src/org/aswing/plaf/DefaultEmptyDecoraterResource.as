/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf
{
	
import flash.display.DisplayObject;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;

/**
 * The default empty border to be the component border as default. So it can be 
 * replaced by LAF specified.
 * 
 * @author iiley
 */
public class DefaultEmptyDecoraterResource implements Icon, Border, GroundDecorator, UIResource
{
	/**
	 * Shared instance.
	 */
	public static const INSTANCE:DefaultEmptyDecoraterResource = new DefaultEmptyDecoraterResource();
	
	public static const DEFAULT_BACKGROUND_COLOR:ASColorUIResource = new ASColorUIResource(0);
	public static const DEFAULT_FOREGROUND_COLOR:ASColorUIResource = new ASColorUIResource(0xFFFFFF);
	public static const DEFAULT_MIDEGROUND_COLOR:ASColorUIResource = new ASColorUIResource(0x1987FF);
	public static const DEFAULT_FONT:ASFontUIResource = new ASFontUIResource();
	public static const DEFAULT_STYLE_TUNE:UIStyleTune = new UIStyleTune();		
	
	/**
	 * Used to be a null ui resource color. it is not a UIResource instance, so can't be replace by another LAF.
	 */
	public static const NULL_COLOR:ASColor = new ASColor(0);
	
	/**
	 * Used to be a null ui resource font. it is not a UIResource instance, so can't be replace by another LAF.
	 */
	public static const NULL_FONT:ASFont = new ASFont();
	
	/**
	 * Used to be a null ui resource style tune. it is not a UIResource instance, so can't be replace by another LAF.
	 */
	public static const NULL_STYLE_TUNE:StyleTune = new StyleTune(0, 0, 0);
	
	public function DefaultEmptyDecoraterResource(){
	}
	
	/**
	 * return null
	 */
	public function getDisplay(c:Component):DisplayObject{
		return null;
	}	
	
	/**
	 * return 0
	 */
	public function getIconWidth(c:Component):int{
		return 0;
	}
	
	/**
	 * return 0
	 */
	public function getIconHeight(c:Component):int{
		return 0;
	}
	
	/**
	 * do nothing
	 */
	public function updateIcon(com:Component, g:Graphics2D, x:int, y:int):void{
	}	
	

	/**
	 * do nothing
	 */
	public function updateBorder(com:Component, g:Graphics2D, bounds:IntRectangle):void{
	}
	
	/**
	 * return new Insets(0,0,0,0)
	 */
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets{
		return new Insets(0,0,0,0);
	}
	
	/**
	 * do nothing
	 */
	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):void{
	}
}
}