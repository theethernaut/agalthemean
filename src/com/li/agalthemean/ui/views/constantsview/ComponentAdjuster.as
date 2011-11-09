package com.li.agalthemean.ui.views.constantsview
{

	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;

	import flash.events.Event;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	import flash.geom.Point;
	import flash.utils.Timer;

	import org.aswing.BorderLayout;
	import org.aswing.Component;

	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JSlider;
	import org.aswing.JStepper;
	import org.aswing.event.AWEvent;
	import org.aswing.event.InteractiveEvent;

	public class ComponentAdjuster extends JPanel
	{
		private var _compNameLabel:JLabel;
		private var _slider:JSlider;
		private var _valueStepper:JStepper;
		private var _minStepper:JStepper;
		private var _maxStepper:JStepper;
		private var _targetComponentIndex:uint;
		private var _constant:VectorRegisterConstant;
		private var _range:Number;
		private var _min:Number;
		private var _mouseOverTarget:Component;
		private var _listeningToConstant:Boolean;
		private var _listenTimer:Timer;

		public function ComponentAdjuster( targetComponentIndex:uint ) {

			super();

			_targetComponentIndex = targetComponentIndex;

			setLayout( new BorderLayout() );

			append( _compNameLabel = new JLabel(), BorderLayout.WEST );

			var rPanel:JPanel = new JPanel();
			append( rPanel, BorderLayout.EAST );
			rPanel.append( _valueStepper = new JStepper() );
			rPanel.append( _slider = new JSlider() );
			rPanel.append( new JLabel( "min" ) );
			rPanel.append( _minStepper = new JStepper() );
			rPanel.append( new JLabel( "max" ) );
			rPanel.append( _maxStepper = new JStepper() );

			_minStepper.setMinimum( -1000 );
			_minStepper.setMaximum( 1000 );

			_maxStepper.setMinimum( -1000 );
			_maxStepper.setMaximum( 1000 );

			_minStepper.addEventListener( AWEvent.ACT, minStepperChangedHandler );
			_maxStepper.addEventListener( AWEvent.ACT, maxStepperChangedHandler );

			_slider.addEventListener( InteractiveEvent.STATE_CHANGED, sliderStateChangedHandler );

			_valueStepper.addEventListener( InteractiveEvent.STATE_CHANGED, valueStepperStateChangedHandler );

			_slider.addEventListener( MouseEvent.ROLL_OVER, mouseOverHandler );
			_valueStepper.addEventListener( MouseEvent.ROLL_OVER, mouseOverHandler );

			_listenTimer = new Timer( 50 );
			_listenTimer.addEventListener( TimerEvent.TIMER, timerUpdateHandler );
		}

		public function startListeningToConstant():void {

			if( _listeningToConstant )
				return;

			_listeningToConstant = true;

			enable( false );

			_listenTimer.start();

		}

		public function stopListeningToConstant():void {

			if( !_listeningToConstant )
				return;

			_listeningToConstant = false;

			enable();

			_listenTimer.reset();

		}

		private function enable( enabled:Boolean = true ):void {

			_slider.setEnabled( enabled );
			_minStepper.setEnabled( enabled );
			_maxStepper.setEnabled( enabled );
			_valueStepper.setEnabled( enabled );
		}

		private function timerUpdateHandler( event:Event ):void {
			updateSliderFromConstant();
			updateValueStepperFromConstant();
		}

		public function set target( constant:VectorRegisterConstant ):void {

			_constant = constant;
			_compNameLabel.setText( constant.compNames[ _targetComponentIndex ] );

			// TODO: re-ranging behaves freakish-ly?

			var range:Point = _constant.compRanges[ _targetComponentIndex ];
			_minStepper.setValue( range.x );
			_maxStepper.setValue( range.y );

			updateRangeFromPoint( range );
			updateSliderFromConstant();
			updateValueStepperFromConstant();
		}

		private function updateRangeFromPoint( value:Point ):void {
			_range = value.y - value.x;
			_min = value.x;
			_slider.setEnabled( _range != 0 );
		}

		private function updateSliderFromConstant():void {
			var real:Number = _constant.value[ _targetComponentIndex ];
			var percent:int = ( 100 / _range ) * ( real - _min );
			_slider.setValue( percent );
		}

		private function updateConstantValueFromSlider():void {
			var real:Number = ( _slider.getValue() / 100 ) * _range + _min;
			_constant.value[ _targetComponentIndex ] = real;
		}

		private function updateValueStepperFromConstant():void {
			_valueStepper.setValue( _constant.value[ _targetComponentIndex ] );
		}

		// -----------------------
		// events
		// -----------------------

		private function mouseOverHandler( event:MouseEvent ):void {
			_mouseOverTarget = event.target as Component;
		}

		private function minStepperChangedHandler( event:AWEvent ):void {
			var range:Point = _constant.compRanges[ _targetComponentIndex ];
			range.x = _minStepper.getValue();
			updateRangeFromPoint( range );
			updateSliderFromConstant();
		}

		private function maxStepperChangedHandler( event:AWEvent ):void {
			var range:Point = _constant.compRanges[ _targetComponentIndex ];
			range.y = _maxStepper.getValue();
			updateRangeFromPoint( range );
			updateSliderFromConstant();
		}

		private function sliderStateChangedHandler( event:InteractiveEvent ):void {
			if( _mouseOverTarget == _slider ) {
				updateConstantValueFromSlider();
				updateValueStepperFromConstant();
			}
		}

		private function valueStepperStateChangedHandler( event:InteractiveEvent ):void {
			if( _mouseOverTarget == _valueStepper ) {
				updateSliderFromConstant();
				updateConstantValueFromSlider();
			}
		}
	}
}
