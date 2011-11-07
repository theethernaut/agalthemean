package org.aswing{

import flash.events.Event;

import org.aswing.border.EmptyBorder;
import org.aswing.event.FrameEvent;
import org.aswing.event.InteractiveEvent;
import org.aswing.event.WindowEvent;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.basic.BasicFrameTitleBarUI;

/**
 * The default Imp of FrameTitleBar
 */
public class JFrameTitleBar extends Container implements FrameTitleBar, UIResource{
	
	protected var iconifiedButton:AbstractButton;
	protected var maximizeButton:AbstractButton;
	protected var restoreButton:AbstractButton;
	protected var closeButton:AbstractButton;
	protected var titleLabel:JLabel;
	protected var icon:Icon;
	protected var text:String;
	protected var titleEnabled:Boolean;
	protected var minimizeHeight:int;
	
	protected var buttonPane:Container;
	protected var buttonPaneLayout:SoftBoxLayout;
	
	protected var owner:JWindow;
	protected var frame:JFrame;
	
	public function JFrameTitleBar(){
		super();
		titleEnabled = true;
		minimizeHeight = 22;
		setLayout(new FrameTitleBarLayout());
		
		buttonPane = new Container();
		buttonPane.setCachePreferSizes(false);
		buttonPaneLayout = new SoftBoxLayout(SoftBoxLayout.X_AXIS, 0);
		buttonPane.setLayout(buttonPaneLayout);
		var labelPane:Container = new Container();
		labelPane.setBorder(new EmptyBorder(null, new Insets(-3)));//make label y offset -3
		labelPane.setLayout(new BorderLayout());
		titleLabel = new JLabel();
		titleLabel.setHorizontalAlignment(JLabel.LEFT);
		titleLabel.setVerticalAlignment(JLabel.CENTER);
		titleLabel.setUIElement(true);
		labelPane.setUIElement(true);
		labelPane.append(titleLabel, BorderLayout.CENTER);
		labelPane.mouseEnabled = false;
		labelPane.mouseChildren = false;
		
		append(labelPane, BorderLayout.CENTER);
		var btnpP:Container = new Container();
		btnpP.setLayout(new BorderLayout());
		btnpP.append(buttonPane, BorderLayout.NORTH);
		append(btnpP, BorderLayout.EAST);
		
		setIconifiedButton(createIconifiedButton());
		setMaximizeButton(createMaximizeButton());
		setRestoreButton(createRestoreButton());
		setCloseButton(createCloseButton());
		setMaximizeButtonVisible(false);
		buttonPane.appendAll(iconifiedButton, restoreButton, maximizeButton, closeButton);
		buttonPane.setUIElement(true);
		
		updateUI();
	}
	
	override public function updateUI():void{
    	setUI(UIManager.getUI(this));
    }
	
    override public function getDefaultBasicUIClass():Class{
    	return org.aswing.plaf.basic.BasicFrameTitleBarUI;
    }
	
	protected function createPureButton():JButton{
		var b:JButton = new JButton();
		b.setBackgroundDecorator(null);
		b.setMargin(new Insets());
		b.setStyleTune(null);
		b.setBackground(null);
		b.setForeground(null);
		b.setMideground(null);
		b.setStyleProxy(this);
		return b;
	}
	
	protected function createIconifiedButton():AbstractButton{
		return createPureButton();
	}
	
	protected function createMaximizeButton():AbstractButton{
		return createPureButton();
	}
	
	protected function createRestoreButton():AbstractButton{
		return createPureButton();
	}
	
	protected function createCloseButton():AbstractButton{
		return createPureButton();
	}
	
	public function setButtonIconGap(gap:int):void{
		buttonPaneLayout.setGap(gap);
	}
	
	public function getSelf():Component{
		return this;
	}
	
	public function setFrame(f:JWindow):void{
		if(owner){
			owner.removeEventListener(FrameEvent.FRAME_ABILITY_CHANGED, __frameAbilityChanged);
			owner.removeEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged);
			owner.removeEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange);
			owner.removeEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange);
		}
		owner = f;
		frame = f as JFrame;
		if(owner){
			owner.addEventListener(FrameEvent.FRAME_ABILITY_CHANGED, __frameAbilityChanged, false, 0, true);
			owner.addEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged, false, 0, true);
			owner.addEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange, false, 0, true);
			owner.addEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange, false, 0, true);
		}
		__stateChanged(null);
		repaint();
	}
	
	public function getFrame():JWindow{
		return owner;
	}
	
	public function setTitleEnabled(b:Boolean):void{
		titleEnabled = b;
	}
	
	public function isTitleEnabled():Boolean{
		return titleEnabled;
	}
	
	public function setMinimizeHeight(h:int):void{
		minimizeHeight = h;
	}
	
	public function getMinimizeHeight():int{
		return minimizeHeight;
	}
		
	public function addExtraControl(c:Component, position:int):void{
		if(position == AsWingConstants.LEFT){
			buttonPane.insert(0, c);
		}else{
			buttonPane.append(c);
		}
	}
	
	public function removeExtraControl(c:Component):Component{
		return buttonPane.remove(c);
	}
	
	public function getLabel():JLabel{
		return titleLabel;
	}
	
	public function setIcon(i:Icon):void{
		icon = i;
		if(titleLabel){
			titleLabel.setIcon(i);
		}
	}
	
	public function getIcon():Icon{
		return icon;
	}
	
	public function setText(t:String):void{
		text = t;
		if(titleLabel){
			titleLabel.setText(t);
		}
	}
	
	public function getText():String{
		return text;
	}
	
	public function isActive():Boolean{
		if(owner){
			return owner.isActive();
		}
		return true;
	}
	
	public function setIconifiedButton(b:AbstractButton):void{
		if(iconifiedButton != b){
			var index:int = -1;
			if(iconifiedButton){
				index = buttonPane.getIndex(iconifiedButton);
				buttonPane.removeAt(index);
				iconifiedButton.removeActionListener(__iconifiedPressed);
			}
			iconifiedButton = b;
			if(iconifiedButton){
				buttonPane.insert(index, iconifiedButton);
				iconifiedButton.addActionListener(__iconifiedPressed);
			}
		}
	}
	
	public function setMaximizeButton(b:AbstractButton):void{
		if(maximizeButton != b){
			var index:int = -1;
			if(maximizeButton){
				index = buttonPane.getIndex(maximizeButton);
				buttonPane.removeAt(index);
				maximizeButton.removeActionListener(__maximizePressed);
			}
			maximizeButton = b;
			if(maximizeButton){
				buttonPane.insert(index, maximizeButton);
				maximizeButton.addActionListener(__maximizePressed);
			}
		}
	}
	
	public function setRestoreButton(b:AbstractButton):void{
		if(restoreButton != b){
			var index:int = -1;
			if(restoreButton){
				index = buttonPane.getIndex(restoreButton);
				buttonPane.removeAt(index);
				restoreButton.removeActionListener(__restorePressed);
			}
			restoreButton = b;
			if(restoreButton){
				buttonPane.insert(index, restoreButton);
				restoreButton.addActionListener(__restorePressed);
			}
		}
	}
	
	public function setCloseButton(b:AbstractButton):void{
		if(closeButton != b){
			var index:int = -1;
			if(closeButton){
				index = buttonPane.getIndex(closeButton);
				buttonPane.removeAt(index);
				closeButton.removeActionListener(__closePressed);
			}
			closeButton = b;
			if(closeButton){
				buttonPane.insert(index, closeButton);
				closeButton.addActionListener(__closePressed);
			}
		}
	}
	
	public function getIconifiedButton():AbstractButton{
		return iconifiedButton;
	}
	
	public function getMaximizeButton():AbstractButton{
		return maximizeButton;
	}
	
	public function getRestoreButton():AbstractButton{
		return restoreButton;
	}
	
	public function getCloseButton():AbstractButton{
		return closeButton;
	}
	
	public function setIconifiedButtonVisible(b:Boolean):void{
		if(getIconifiedButton()){
			getIconifiedButton().setVisible(b);
		}
	}
	
	public function setMaximizeButtonVisible(b:Boolean):void{
		if(getMaximizeButton()){
			getMaximizeButton().setVisible(b);
		}
	}
	
	public function setRestoreButtonVisible(b:Boolean):void{
		if(getRestoreButton()){
			getRestoreButton().setVisible(b);
		}
	}
	
	public function setCloseButtonVisible(b:Boolean):void{
		if(getCloseButton()){
			getCloseButton().setVisible(b);
		}
	}
	
	private function __iconifiedPressed(e:Event):void{
		if(frame && isTitleEnabled()){
			frame.setState(JFrame.ICONIFIED, false);
		}
	}
	
	private function __maximizePressed(e:Event):void{
		if(frame && isTitleEnabled()){
			frame.setState(JFrame.MAXIMIZED, false);
		}
	}
	
	private function __restorePressed(e:Event):void{
		if(frame && isTitleEnabled()){
			frame.setState(JFrame.NORMAL, false);
		}
	}
	
	private function __closePressed(e:Event):void{
		if(frame && isTitleEnabled()){
			frame.closeReleased();
		}
	}
	
	private function __activeChange(e:Event):void{
		repaint();
		//or paintImmediately();
	}
			
	private function __frameAbilityChanged(e:FrameEvent):void{
		__stateChanged(null);
	}
	
	private function __stateChanged(e:InteractiveEvent):void{
		if(frame == null){
			return;
		}
		var state:int = frame.getState();
		if(state != JFrame.ICONIFIED 
			&& state != JFrame.NORMAL
			&& state != JFrame.MAXIMIZED_HORIZ
			&& state != JFrame.MAXIMIZED_VERT
			&& state != JFrame.MAXIMIZED){
			state = JFrame.NORMAL;
		}
		if(state == JFrame.ICONIFIED){
			setIconifiedButtonVisible(false);
			setMaximizeButtonVisible(false);
			setRestoreButtonVisible(true);
			setCloseButtonVisible(frame.isClosable());
		}else if(state == JFrame.NORMAL){
			setIconifiedButtonVisible(frame.isResizable());
			setRestoreButtonVisible(false);
			setMaximizeButtonVisible(frame.isResizable());
			setCloseButtonVisible(frame.isClosable());
		}else{
			setIconifiedButtonVisible(frame.isResizable());
			setRestoreButtonVisible(frame.isResizable());
			setMaximizeButtonVisible(false);
			setCloseButtonVisible(frame.isClosable());
		}
		revalidateIfNecessary();
	}
}
}