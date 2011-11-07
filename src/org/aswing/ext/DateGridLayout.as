package org.aswing.ext{

import org.aswing.Component;
import org.aswing.Container;
import org.aswing.Insets;
import org.aswing.LayoutManager;
import org.aswing.geom.IntDimension;


/**
 * @author iiley (Burstyx Studio)
 */
public class DateGridLayout implements LayoutManager{
	
	protected var indent:int;
	protected var days:int;
	
	protected var hgap:int;
	protected var vgap:int;
	protected var rows:int;
	protected var cols:int;
	
	/**
	 * DateGrid's rows and cols are fixed after construction.
	 */
	public function DateGridLayout(rows:int, cols:int, hgap:int=0, vgap:int=0){
		this.rows = rows;
		this.cols = cols;
		this.hgap = hgap;
		this.vgap = vgap;
		indent = 0;
		days = 31;
	}
	
	public function setMonth(indent:int, days:int):void{
		this.indent = indent;
		this.days   = days;
	}
	
	public function addLayoutComponent(comp:Component, constraints:Object):void{
	}
	
	public function removeLayoutComponent(comp:Component):void{
	}
	
	protected function countLayoutSize(target:Container, sizeFuncName:String):IntDimension{
		var n:int = target.getComponentCount();
		var w:int = 0;
		var h:int = 0;
		for(var i:int=0; i<n; i++){
			var c:Component = target.getComponent(i);
			var size:IntDimension = c[sizeFuncName]();
			if(size.width > w){
				w = size.width;
			}
			if(size.height > h){
				h = size.height;
			}
		}
		var insets:Insets = target.getInsets();
		return new IntDimension((((insets.left + insets.right) + (cols * w)) + ((cols - 1) * hgap)), (((insets.top + insets.bottom) + (rows * h)) + ((rows - 1) * vgap))); 	
	}
	
	public function preferredLayoutSize(target:Container):IntDimension{
		return countLayoutSize(target, "getPreferredSize");
	}
	
	public function minimumLayoutSize(target:Container):IntDimension{
		return countLayoutSize(target, "getMinimumSize");
	}
	
	public function maximumLayoutSize(target:Container):IntDimension{
		return new IntDimension(1000000, 1000000);
	}
	
	public function layoutContainer(target:Container):void{
		var insets:Insets = target.getInsets();
		var n:int = target.getComponentCount();
		if (n == 0){
			return ;
		}
		var w:int = (target.getWidth() - (insets.left + insets.right));
		var h:int = (target.getHeight() - (insets.top + insets.bottom));
		w = Math.floor((w - ((cols - 1) * hgap)) / cols);
		h = Math.floor((h - ((rows - 1) * vgap)) / rows);
		var x:int = insets.left;
		var y:int = insets.top;
		
		var i:int=0;
		for(var r:int=0; r<rows; r++){
			x = insets.left;
			for(var c:int=0; c<cols; c++){
				i = ((r * cols) + c - indent);
				if(i>=0 && i<days && i<n){
					var comp:Component = target.getComponent(i);
					target.getComponent(i).setComBoundsXYWH(x, y, w, h);
				}
				x += (w + hgap);
			}
			y += (h + vgap);
		}
		
		//TODO remainder children's
		//for()
	}
	
	public function getLayoutAlignmentX(target:Container):Number{
		return 0.5;
	}
	
	public function getLayoutAlignmentY(target:Container):Number{
		return 0.5;
	}
	
	public function invalidateLayout(target:Container):void{
	}
	
}
}