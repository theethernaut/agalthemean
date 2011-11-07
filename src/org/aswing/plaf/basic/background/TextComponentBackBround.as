/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.filters.DropShadowFilter;

import org.aswing.ASColor;
import org.aswing.AsWingManager;
import org.aswing.Component;
import org.aswing.EditableComponent;
import org.aswing.GroundDecorator;
import org.aswing.StyleResult;
import org.aswing.StyleTune;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.*;
import org.aswing.plaf.UIResource;

/**
 * @private
 */
public class TextComponentBackBround implements GroundDecorator, UIResource{
	
	protected var shape:Shape;
	
	public function TextComponentBackBround(){
		shape = new Shape();
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, r:IntRectangle):void{
    	shape.visible = c.isOpaque();
    	if(c.isOpaque()){
    		shape.graphics.clear();
    		g = new Graphics2D(shape.graphics);
			var cl:ASColor = c.getBackground();
			var tune:StyleTune = c.getStyleTune();
			var result:StyleResult = new StyleResult(cl, tune);
			var ml:ASColor = result.bdark;
			var ed:EditableComponent = c as EditableComponent;
			var editable:Boolean = true;
			if(ed != null){
				editable = ed.isEditable();
			}
			if(!c.isEnabled() || !editable){
				ml = ml.changeAlpha(ml.getAlpha()*getChangeSharpen(c.isEnabled(), editable));
				cl = cl.changeAlpha(cl.getAlpha()*getChangeAlpha(c.isEnabled(), editable));
			}
			
			r = new IntRectangle(0, 0, c.width-1, c.height-1);
			var round:Number = tune.round;
			if(round >= 1){
				g.fillRoundRect(new SolidBrush(cl), r.x, r.y, r.width, r.height, round);
				g.fillRoundRectRingWithThickness(new SolidBrush(ml), r.x, r.y, r.width, r.height, round, 1, round-1);
			}else{
				g.fillRectangle(new SolidBrush(cl), r.x, r.y, r.width, r.height);
				g.fillRectangleRingWithThickness(new SolidBrush(ml), r.x, r.y, r.width, r.height, 1);
			}
			
			shape.filters = [new DropShadowFilter(1, 45, cl.getRGB(), tune.shadowAlpha*cl.getAlpha(), 0, 0, 1, 1)];
    	}
	}
	
	protected function getChangeSharpen(enabled:Boolean, editable:Boolean):Number{
		if(!enabled){
			return 0.2;
		}else if(!editable){
			return 1;
		}else{
			return 1;
		}
	}
	
	protected function getChangeAlpha(enabled:Boolean, editable:Boolean):Number{
		if(!enabled){
			return 0.2;
		}else if(!editable){
			return 0.3;
		}else{
			return 1;
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
}