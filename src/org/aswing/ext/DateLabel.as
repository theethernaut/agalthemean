package org.aswing.ext{

import flash.events.MouseEvent;

import org.aswing.ASColor;
import org.aswing.Icon;
import org.aswing.JLabel;
import org.aswing.UIManager;


/**
 * @author iiley (Burstyx Studio)
 */
public class DateLabel extends JLabel{
	
	protected var selectionBackground:ASColor;
	protected var selectionForeground:ASColor;
	protected var highlightColor:ASColor;
	protected var disabledColor:ASColor;
	protected var enabledColor:ASColor;
	
	protected var date:int;
	protected var dateEnabled:Boolean = true;
	protected var selected:Boolean = false;
	
	public function DateLabel(date:int){
		super(date+"");
		this.date = date;
		selectionForeground = UIManager.getColor("selectionForeground");
		selectionBackground = UIManager.getColor("selectionBackground");
		highlightColor = ASColor.RED;
		disabledColor = getForeground().brighter().brighter();
		enabledColor = getForeground().darker();
		
		setForeground(enabledColor);
		mouseChildren = false;
		
		addEventListener(MouseEvent.ROLL_OVER, __over);
		addEventListener(MouseEvent.ROLL_OUT, __out);
		addEventListener(MouseEvent.MOUSE_DOWN, __down);
	}
	
	public function getDate():int{
		return date;
	}
	
	private function __over(e:MouseEvent):void{
		onMouseOver(e);
	}
	
	private function __out(e:MouseEvent):void{
		onMouseOut(e);
	}
	
	private function __down(e:MouseEvent):void{
		onMouseDown(e);
	}
	
	protected function onMouseOver(e:MouseEvent):void{
		updateView(true, false);
	}
	
	protected function onMouseOut(e:MouseEvent):void{
		updateView(false, true);
	}
	
	protected function onMouseDown(e:MouseEvent):void{
	}
	
	public function setSelected(b:Boolean):void{
		if(b != selected){
			selected = b;
			updateView();
		}
	}
	
	protected function updateView(over:Boolean=false, out:Boolean=false):void{
		if(!isDateEnabled()){
			setForeground(disabledColor);
			if(selected){
				setBackground(selectionBackground);
				setOpaque(true);
			}else{
				setOpaque(false);
			}
		}else if(selected){
			setForeground(selectionForeground);
			setBackground(selectionBackground);
			setOpaque(true);
		}else if(over){
			setBackground(selectionBackground.changeAlpha(0.5));
			setForeground(selectionForeground);
			setOpaque(true);
		}else if(out){
			setForeground(enabledColor);
			setOpaque(false);
		}else{
			setForeground(enabledColor);
			setOpaque(false);
		}
	}
	
	public function isSelected():Boolean{
		return selected;
	}
	
	public function setDateEnabled(b:Boolean):void{
		if(b != dateEnabled){
			dateEnabled = b;
			mouseEnabled = b;
			updateView();
		}
	}
	
	public function isDateEnabled():Boolean{
		return dateEnabled;
	}
}
}