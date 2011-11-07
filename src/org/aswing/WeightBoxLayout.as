package org.aswing{

import org.aswing.geom.IntDimension;
import org.aswing.geom.IntRectangle;


/**
 * Each child will have a weight, for its width(X_AXIS) or height(Y_AXIS) share from parent.
 * @author iiley (Burstyx Studio)
 */
public class WeightBoxLayout implements LayoutManager{
	
	/**
	 * Specifies that components should be laid out left to right.
	 */
	public static const X_AXIS:int = AsWingConstants.HORIZONTAL;
	
	/**
	 * Specifies that components should be laid out top to bottom.
	 */
	public static const Y_AXIS:int = AsWingConstants.VERTICAL;
	
	protected var axis:int;
	protected var gap:int;
	
	public function WeightBoxLayout(axis:int=X_AXIS, gap:int=0){
		this.axis = axis;
		this.gap  = gap;
	}
	
	/**
	 * Sets new axis. Must be one of:
	 * <ul>
	 *  <li>X_AXIS
	 *  <li>Y_AXIS
	 * </ul> Default is X_AXIS.
	 * @param axis new axis
	 */
	public function setAxis(axis:int = X_AXIS):void {
		this.axis = axis ;
	}
	
	/**
	 * Gets axis.
	 * @return axis
	 */
	public function getAxis():int {
		return axis;	
	}
	
	/**
	 * Sets new gap.
	 * @param get new gap
	 */	
	public function setGap(gap:int = 0):void {
		this.gap = gap ;
	}
	
	/**
	 * Gets gap.
	 * @return gap
	 */
	public function getGap():int {
		return gap;	
	}
		
	
	public function addLayoutComponent(comp:Component, constraints:Object):void{
		comp.setConstraints(constraints);
	}
	
	public function removeLayoutComponent(comp:Component):void{
	}
	
	public function preferredLayoutSize(target:Container):IntDimension{
		var count:int = target.getComponentCount();
		var insets:Insets = target.getInsets();
		var width:int = 0;
		var height:int = 0;
		var wTotal:int = 0;
		var hTotal:int = 0;
		for(var i:int=0; i<count; i++){
			var c:Component = target.getComponent(i);
			if(c.isVisible()){
				var size:IntDimension = c.getPreferredSize();
				width = Math.max(width, size.width);
				height = Math.max(height, size.height);
				var g:int = i > 0 ? gap : 0;
				wTotal += (size.width + g);
				hTotal += (size.height + g);
			}
		}
		if(axis == Y_AXIS){
			height = hTotal;
		}else{
			width = wTotal;
		}
		
		var dim:IntDimension = new IntDimension(width, height);
		return insets.getOutsideSize(dim);
	}
	
	public function minimumLayoutSize(target:Container):IntDimension{
		return target.getInsets().getOutsideSize();;
	}
	
	public function maximumLayoutSize(target:Container):IntDimension{
		return new IntDimension(100000, 100000);
	}
	
	protected function getWeightOfComp(c:Component):Number{
		var weight:Number = Number(c.getConstraints());
		if(isNaN(weight)){
			weight = 0;
		}
		return weight;
	}
	
	public function layoutContainer(target:Container):void{
		var count:int = target.getComponentCount();
		var size:IntDimension = target.getSize();
		var insets:Insets = target.getInsets();
		var rd:IntRectangle = insets.getInsideBounds(size.getBounds());
		var ch:int = rd.height;
		var cw:int = rd.width;
		var x:int = rd.x;
		var y:int = rd.y;
		var i:int = 0;
		var sumWeight:Number = 0;
		for(i=0; i<count; i++){
			sumWeight += getWeightOfComp(target.getComponent(i));
		}
		
		var sumGap:int = (count-1) * gap;
		
		var comp:Component;
		var weight:Number;
		if(axis == X_AXIS){
			var contentW:int = cw - sumGap;
			for(i=0; i<count; i++){
				comp = target.getComponent(i);
				weight = getWeightOfComp(comp);
				var compW:int = Math.floor(weight/sumWeight*contentW);
				target.getComponent(i).setComBoundsXYWH(x, y, compW, ch);
				x += (gap + compW);
			}
		}else{
			var contentH:int = ch - sumGap;
			for(i=0; i<count; i++){
				comp = target.getComponent(i);
				weight = getWeightOfComp(comp);
				var compH:int = Math.floor(weight/sumWeight*contentH);
				target.getComponent(i).setComBoundsXYWH(x, y, cw, compH);
				y += (gap + compH);
			}
		}
		
	}
	
	public function getLayoutAlignmentX(target:Container):Number{
		return 0;
	}
	
	public function getLayoutAlignmentY(target:Container):Number{
		return 0;
	}
	
	public function invalidateLayout(target:Container):void{
	}
	
}
}