/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import flash.display.DisplayObject;

import org.aswing.*;
import org.aswing.plaf.basic.BasicScrollBarUI;
import org.aswing.geom.*;

public class SkinScrollBarUI extends BasicScrollBarUI{
	
	protected var scrollBarHeight:int;
	
	public function SkinScrollBarUI(){
		super();
	}
	
    override protected function createArrowButton():JButton{
		var b:JButton = new JButton();
		b.setFocusable(false);
		b.setOpaque(false);
		b.setBackgroundDecorator(null);
		b.setBorder(null);
		b.setMargin(new Insets());
		return b;
    }	

	override protected function createIcons():void{
		var pp:String = getPropertyPrefix();
    	leftIcon = new SkinButtonIcon(-1, -1, pp+"arrowLeft.", scrollbar);
    	rightIcon = new SkinButtonIcon(-1, -1, pp+"arrowRight.", scrollbar);
    	upIcon = new SkinButtonIcon(-1, -1, pp+"arrowUp.", scrollbar);
    	downIcon = new SkinButtonIcon(-1, -1, pp+"arrowDown.", scrollbar);
    	
    	scrollBarWidth = upIcon.getIconWidth(scrollbar);
    	scrollBarHeight = upIcon.getIconHeight(scrollbar);
    }
    //--------------------------Dimensions----------------------------
    
    override public function getPreferredSize(c:Component):IntDimension{
		var w:int, h:int;
		if(isVertical()){
			w = scrollBarWidth;
			h = scrollBarHeight*2;
		}else{
			w = scrollBarHeight*2;
			h = scrollBarWidth;
		}
		return scrollbar.getInsets().getOutsideSize(new IntDimension(w, h));
    }

    override public function getMaximumSize(c:Component):IntDimension{
		var w:int, h:int;
		if(isVertical()){
			w = scrollBarWidth;
			h = 100000;
		}else{
			w = 100000;
			h = scrollBarWidth;
		}
		return scrollbar.getInsets().getOutsideSize(new IntDimension(w, h));
    }

    override public function getMinimumSize(c:Component):IntDimension{
		return getPreferredSize(c);
    }
	
	//--------------------------Layout----------------------------
	override protected function layoutVScrollbar(sb:JScrollBar):void{
    	var rd:IntRectangle = sb.getPaintBounds();
    	var w:int = scrollBarWidth;
		var h:int = scrollBarHeight;
    	decrButton.setComBoundsXYWH(rd.x, rd.y, w, h);
    	incrButton.setComBoundsXYWH(rd.x, rd.y + rd.height - h, w, h);
	}
	
	override protected function layoutHScrollbar(sb:JScrollBar):void{
    	var rd:IntRectangle = sb.getPaintBounds();
    	var w:int = scrollBarWidth;
		var h:int = scrollBarHeight;
    	decrButton.setComBoundsXYWH(rd.x, rd.y, h, w);
    	incrButton.setComBoundsXYWH(rd.x + rd.width - h, rd.y, h, w);
	}
}
}