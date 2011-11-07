package org.aswing.skinbuilder{

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;

import org.aswing.Component;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.BitmapBrush;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.DefaultsDecoratorBase;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.tree.ExpandControl;
import org.aswing.tree.TreePath;

public class SkinTreeExpandControl extends DefaultsDecoratorBase implements ExpandControl, UIResource{
	
	protected var leafControlImage:DisplayObject;
	protected var folderExpandedControlImage:DisplayObject;
	protected var folderCollapsedControlImage:DisplayObject;
	protected var loaded:Boolean = false;
	protected var leafBitmapBuffer:BitmapData;
	protected var expandedBitmapBuffer:BitmapData;
	protected var collapsedBitmapBuffer:BitmapData;
	
	public function SkinTreeExpandControl(){
		leafBitmapBuffer = new BitmapData(1, 1, true, 0x00000000);
		expandedBitmapBuffer = new BitmapData(1, 1, true, 0x00000000);
		collapsedBitmapBuffer = new BitmapData(1, 1, true, 0x00000000);
	}
	
	public function paintExpandControl(c:Component, g:Graphics2D, bounds:IntRectangle, 
		totalChildIndent:int, path:TreePath, row:int, expanded:Boolean, leaf:Boolean):void{
		if(!loaded){
			var ui:ComponentUI = getDefaultsOwner(c);
			leafControlImage = ui.getInstance("Tree.leafControlImage") as DisplayObject;
			folderExpandedControlImage = ui.getInstance("Tree.folderExpandedControlImage") as DisplayObject;
			folderCollapsedControlImage = ui.getInstance("Tree.folderCollapsedControlImage") as DisplayObject;
			loaded = true;
		}
		
		var x:int = bounds.x - totalChildIndent;
		var y:int = bounds.y;
		var w:int = bounds.width;
		var h:int = bounds.height;
		var matrix:Matrix = new Matrix();
		matrix.translate(x, y);
		if(leaf){
			w = leafControlImage.width;
			if(w != leafBitmapBuffer.width || h != leafBitmapBuffer.height){
				leafControlImage.width = w;
				leafControlImage.height = h;
				leafBitmapBuffer = new BitmapData(w, h, true, 0x00000000);
				leafBitmapBuffer.draw(leafControlImage);
			}
			g.beginFill(new BitmapBrush(leafBitmapBuffer, matrix, false));
		}else if(expanded){
			w = folderExpandedControlImage.width;
			if(w != expandedBitmapBuffer.width || h != expandedBitmapBuffer.height){
				folderExpandedControlImage.width = w;
				folderExpandedControlImage.height = h;
				expandedBitmapBuffer = new BitmapData(w, h, true, 0x00000000);
				expandedBitmapBuffer.draw(folderExpandedControlImage);
			}
			g.beginFill(new BitmapBrush(expandedBitmapBuffer, matrix, false));
		}else{
			w = folderCollapsedControlImage.width;
			if(w != collapsedBitmapBuffer.width || h != collapsedBitmapBuffer.height){
				folderCollapsedControlImage.width = w;
				folderCollapsedControlImage.height = h;
				collapsedBitmapBuffer = new BitmapData(w, h, true, 0x00000000);
				collapsedBitmapBuffer.draw(folderCollapsedControlImage);
			}
			g.beginFill(new BitmapBrush(collapsedBitmapBuffer, matrix, false));
		}
		g.rectangle(x, y, w, h);
		g.endFill();
	}
	
}
}