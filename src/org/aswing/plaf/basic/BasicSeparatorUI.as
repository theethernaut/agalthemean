/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic
{
import flash.geom.Matrix;

import org.aswing.*;
import org.aswing.geom.IntDimension;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.GradientBrush;
import org.aswing.graphics.Graphics2D;
import org.aswing.graphics.Pen;
import org.aswing.plaf.BaseComponentUI;
/**
 * A Basic L&F implementation of SeparatorUI.  This implementation 
 * is a "combined" view/controller.
 *
 * @author senkay
 * @private
 */
public class BasicSeparatorUI extends BaseComponentUI
{
		
	public function BasicSeparatorUI(){
		super();
	}
	
    protected function getPropertyPrefix():String {
        return "Separator.";
    }
	
	override public function installUI(c:Component):void{
		installDefaults(JSeparator(c));
	}
	
	override public function uninstallUI(c:Component):void{
		uninstallDefaults(JSeparator(c));
	}
	
	public function installDefaults(s:JSeparator):void{
		var pp:String = getPropertyPrefix();
		
		LookAndFeel.installColors(s, pp);
		LookAndFeel.installBasicProperties(s, pp);
		LookAndFeel.installBorderAndBFDecorators(s, pp);
		s.setAlignmentX(0.5);
		s.setAlignmentY(0.5);
	}
	
	public function uninstallDefaults(s:JSeparator):void{
		LookAndFeel.uninstallBorderAndBFDecorators(s);
	}

	override public function paint(c:Component, g:Graphics2D, b:IntRectangle):void{
    	super.paint(c, g, b);
		var sp:JSeparator = JSeparator(c);
		var dark:ASColor = c.getBackground()
		var matrix:Matrix = new Matrix();
		var brush:GradientBrush;
		if (sp.getOrientation() == JSeparator.VERTICAL){
			var halfH:int = int(b.height/2);
			var gradientH:int = Math.min(30, halfH);
			matrix.createGradientBox(1, gradientH, Math.PI/2, b.x, b.y);
			brush = new GradientBrush(
				GradientBrush.LINEAR, 
				[dark.getRGB(), dark.getRGB()], 
				[0, dark.getAlpha()], 
				[0, 255], 
				matrix 
				);
			g.fillRectangle(brush, b.x, b.y, 1, halfH);
			matrix.createGradientBox(1, gradientH, -Math.PI/2, b.x, b.y+b.height-gradientH);
			g.fillRectangle(brush, b.x, b.y+halfH, 1, b.height-halfH);
		}else{
			var halfW:int = int(b.width/2);
			var gradientW:int = Math.min(30, halfW);
			matrix.createGradientBox(gradientW, 1, 0, b.x, b.y);
			brush = new GradientBrush(
				GradientBrush.LINEAR, 
				[dark.getRGB(), dark.getRGB()], 
				[0, dark.getAlpha()], 
				[0, 255], 
				matrix 
				);
			g.fillRectangle(brush, b.x, b.y, halfW, 1);
			matrix.createGradientBox(gradientW, 1, Math.PI, b.x+b.width-gradientW, b.y);
			g.fillRectangle(brush, b.x+halfW, b.y, b.width-halfW, 1);
		}
	}
	
	override public function getPreferredSize(c:Component):IntDimension{
		var sp:JSeparator = JSeparator(c);
		var insets:Insets = sp.getInsets();
		if (sp.getOrientation() == JSeparator.VERTICAL){
			return insets.getOutsideSize(new IntDimension(1, 0));
		}else{
			return insets.getOutsideSize(new IntDimension(0, 1));
		}
	}
    override public function getMaximumSize(c:Component):IntDimension{
		var sp:JSeparator = JSeparator(c);
		var insets:Insets = sp.getInsets();
		var size:IntDimension = insets.getOutsideSize();
		if (sp.getOrientation() == JSeparator.VERTICAL){
			return new IntDimension(1 + size.width, 100000);
		}else{
			return new IntDimension(100000, 1 + size.height);
		}
    }
    
	override public function getMinimumSize(c:Component):IntDimension
	{
		return getPreferredSize(c);
	}    
}
}