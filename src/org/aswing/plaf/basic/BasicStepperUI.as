/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic{
	
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import org.aswing.*;
import org.aswing.event.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.icon.ArrowIcon;
import org.aswing.util.Timer;

/**
 * Basic stepper ui imp.
 * @private
 */
public class BasicStepperUI extends BaseComponentUI{

	protected var upButton:Component;
	protected var downButton:Component;
	protected var inputText:JTextField;
	protected var stepper:JStepper;
	
	private static var continueSpeedThrottle:int = 60; // delay in milli seconds
    private static var initialContinueSpeedThrottle:int = 500; // first delay in milli seconds
    private var continueTimer:Timer;
    
	public function BasicStepperUI() {
		super();
		inputText  = new JTextField("", 3);
	}
	
    override public function installUI(c:Component):void{
    	stepper = JStepper(c);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	override public function uninstallUI(c:Component):void{
    	stepper = JStepper(c);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
	protected function getPropertyPrefix():String {
		return "Stepper.";
	}
	
	protected function installDefaults():void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installBorderAndBFDecorators(stepper, pp);
        LookAndFeel.installColorsAndFont(stepper, pp);
        LookAndFeel.installBasicProperties(stepper, pp);
	}
    
    protected function uninstallDefaults():void{
    	LookAndFeel.uninstallBorderAndBFDecorators(stepper);
    }
    
	protected function installComponents():void{
		upButton   = createButton(-Math.PI/2);
		downButton = createButton(Math.PI/2);
		inputText.setBackgroundDecorator(null);
		inputText.setBorder(null);
		//make it proxy to the stepper
		inputText.setForeground(null);
		inputText.setBackground(null);
    	inputText.setMideground(null);
    	inputText.setStyleTune(null);
		
		upButton.setUIElement(true);
		downButton.setUIElement(true);
		inputText.setUIElement(true);
		
		upButton.setFocusable(false);
		downButton.setFocusable(false);
		inputText.setFocusable(false);
		
		stepper.addChild(inputText);
		stepper.addChild(upButton);
		stepper.addChild(downButton);
    }
    
	protected function uninstallComponents():void{
		stepper.removeChild(inputText);
		stepper.removeChild(upButton);
		stepper.removeChild(downButton);
    }
	
	protected function installListeners():void{
		stepper.addStateListener(__onValueChanged);
		stepper.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onInputTextKeyDown);
		stepper.addEventListener(AWEvent.FOCUS_GAINED, __onFocusGained);
		stepper.addEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
		
		inputText.addEventListener(MouseEvent.MOUSE_WHEEL, __onInputTextMouseWheel);
		inputText.getTextField().addEventListener(Event.CHANGE, __textChanged);
		upButton.addEventListener(MouseEvent.MOUSE_DOWN, __onUpButtonPressed);
		upButton.addEventListener(ReleaseEvent.RELEASE, __onUpButtonReleased);
		downButton.addEventListener(MouseEvent.MOUSE_DOWN, __onDownButtonPressed);
		downButton.addEventListener(ReleaseEvent.RELEASE, __onDownButtonReleased);
		
		continueTimer = new Timer(continueSpeedThrottle);
		continueTimer.setInitialDelay(initialContinueSpeedThrottle);
		continueTimer.addActionListener(__continueTimerPerformed);		
	}
    
    protected function uninstallListeners():void{
		stepper.removeStateListener(__onValueChanged);
		stepper.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onInputTextKeyDown);
		stepper.removeEventListener(AWEvent.FOCUS_GAINED, __onFocusGained);
		stepper.removeEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
		
		inputText.removeEventListener(MouseEvent.MOUSE_WHEEL, __onInputTextMouseWheel);
		inputText.getTextField().removeEventListener(Event.CHANGE, __textChanged);
		upButton.removeEventListener(MouseEvent.MOUSE_DOWN, __onUpButtonPressed);
		upButton.removeEventListener(ReleaseEvent.RELEASE, __onUpButtonReleased);
		downButton.removeEventListener(MouseEvent.MOUSE_DOWN, __onDownButtonPressed);
		downButton.removeEventListener(ReleaseEvent.RELEASE, __onDownButtonReleased);
		
		continueTimer.stop();
		continueTimer = null;
    }
    
	override public function paint(c:Component, g:Graphics2D, b:IntRectangle):void{
		super.paint(c, g, b);
		layoutStepper();
		upButton.setEnabled(stepper.isEnabled());
		downButton.setEnabled(stepper.isEnabled());
		inputText.setFont(stepper.getFont());
		inputText.setForeground(stepper.getForeground());
		inputText.setMaxChars(stepper.getMaxChars());
		inputText.setRestrict(stepper.getRestrict());
		inputText.setEditable(stepper.isEditable());
		inputText.setEnabled(stepper.isEnabled());
		fillInputTextWithCurrentValue();
	}
        
    override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void{
    	//do nothing, background decorator will paint it
    }
    
    /**
     * Just override this method if you want other LAF drop down buttons.
     */
    protected function createButton(direction:Number):Component{
    	var btn:JButton = new JButton("", new ArrowIcon(
    				direction, 15
    	));
    	btn.setFocusable(false);
    	btn.setPreferredSize(new IntDimension(15, 15));
    	btn.setBackgroundDecorator(null);
    	btn.setMargin(new Insets());
    	btn.setBorder(null);
    	//make it proxy to the stepper
    	btn.setMideground(null);
    	btn.setStyleTune(null);
    	return btn;
    }
    
    /**
     * Returns the input text to receive the focus for the component.
     * @param c the component
     * @return the object to receive the focus.
     */
	override public function getInternalFocusObject(c:Component):InteractiveObject{
		return inputText.getTextField();
	}
	
	protected function fillInputTextWithCurrentValue():void{
		inputText.setText(getShouldFilledText());
	}
	
	protected function getShouldFilledText():String{
		var value:Number = stepper.getValue();
		var text:String = stepper.getValueTranslator()(value);
		return text;
	}
		
	//--------------------- handlers--------------------
	
	private function __onValueChanged(e:Event):void{
		if(!textInputing){
			fillInputTextWithCurrentValue();
		}
	}
	
	private function __onInputTextMouseWheel(e:MouseEvent):void{
		stepper.setValue(
				stepper.getValue()+e.delta*stepper.getUnitIncrement(),
				false
		);
	}
	
	private var textInputing:Boolean = false;
	private function __textChanged(e:Event):void{
		textInputing = true;
		var text:String = inputText.getText();
		var value:Number = stepper.getValueParser()(text);
		stepper.setValue(value, false);
		textInputing = false;
	}
	
	private function __inputTextAction(fireActOnlyIfChanged:Boolean=false):void{
		var text:String = inputText.getText();
		var value:Number = stepper.getValueParser()(text);
		stepper.setValue(value, false);
		if(!fireActOnlyIfChanged){
			fireActionEvent();
		}else if(value != startEditingValue){
			fireActionEvent();
		}
	}
	
	protected var startEditingValue:Number;
	protected function fireActionEvent():void{
		startEditingValue = stepper.getValue();
		fillInputTextWithCurrentValue();
		stepper.dispatchEvent(new AWEvent(AWEvent.ACT));
	}
	
	private function __onFocusGained(e:AWEvent):void{
		startEditingValue = stepper.getValue();
	}
	
	private function __onFocusLost(e:AWEvent):void{
		__inputTextAction(true);
	}
	
	private function __onInputTextKeyDown(e:FocusKeyEvent):void{
    	var code:uint = e.keyCode;
    	var unit:Number = stepper.getUnitIncrement();
    	var delta:Number = 0;
    	if(code == Keyboard.ENTER){
    		__inputTextAction(false);
    		return;
    	}
    	if(code == Keyboard.HOME){
    		stepper.setValue(stepper.getMinimum(), false);
    		return;
    	}else if(code == Keyboard.END){
    		stepper.setValue(stepper.getMaximum() - stepper.getExtent(), false);
    		return;
    	}
    	if(code == Keyboard.UP){
    		delta = unit;
    	}else if(code == Keyboard.DOWN){
    		delta = -unit;
    	}else if(code == Keyboard.PAGE_UP){
    		delta = unit;
    	}else if(code == Keyboard.PAGE_DOWN){
    		delta = -unit;
    	}
    	makeStepper(delta);
	}
	
	private function makeStepper(step:Number):void{
		stepper.setValue(stepper.getValue() + step, false);
	}
	
	private var timerIncrement:Number;
	private var timerContinued:Number;
	private function __onUpButtonPressed(e:Event):void{
		timerIncrement = stepper.getUnitIncrement();
		makeStepper(timerIncrement);
		continueTimer.restart();
		timerContinued = 0;
	}
	
	private function __onUpButtonReleased(e:Event):void{
		continueTimer.stop();
		fireActionEvent();
	}
	
	private function __onDownButtonPressed(e:Event):void{
		timerIncrement = -stepper.getUnitIncrement();
		makeStepper(timerIncrement);
		continueTimer.restart();
		timerContinued = 0;
	}
	
	private function __onDownButtonReleased(e:Event):void{
		continueTimer.stop();
		fireActionEvent();
	}
	
    private function __continueTimerPerformed(e:AWEvent):void{
    	makeStepper(timerIncrement);
    	timerContinued++;
    	if(timerContinued >= 5){
    		timerContinued = 0;
    		timerIncrement *= 2;
    	}
    }
	
	//---------------------Layout Implementation---------------------------
    protected function layoutStepper():void{
    	var td:IntDimension = stepper.getSize();
		var insets:Insets = stepper.getInsets();
		var top:int = insets.top;
		var left:int = insets.left;
		var right:int = td.width - insets.right;
		
		var height:int = td.height - insets.top - insets.bottom;
    	var buttonSize:IntDimension = upButton.getPreferredSize(); 
    	upButton.setSizeWH(buttonSize.width, height/2);
    	upButton.setLocationXY(right - buttonSize.width, top);
    	downButton.setSizeWH(buttonSize.width, height/2);
    	downButton.setLocationXY(right - buttonSize.width, top+height/2);
    	
    	inputText.setLocationXY(left, top);
    	inputText.setSizeWH(td.width-insets.left-insets.right- buttonSize.width, height);
    }
    
    override public function getPreferredSize(c:Component):IntDimension{
    	var insets:Insets = stepper.getInsets();
    	inputText.setColumns(stepper.getColumns());
    	var inputSize:IntDimension = inputText.getPreferredSize();
    	var buttonSize:IntDimension = upButton.getPreferredSize(); 
    	inputSize.width += buttonSize.width;
    	return insets.getOutsideSize(inputSize);
    }

    override public function getMinimumSize(c:Component):IntDimension{
    	var buttonSize:IntDimension = upButton.getPreferredSize(); 
    	buttonSize.height *= 2;
    	return stepper.getInsets().getOutsideSize(buttonSize);
    }

    override public function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
    }    

}
}