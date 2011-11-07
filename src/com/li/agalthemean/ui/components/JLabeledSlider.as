package com.li.agalthemean.ui.components
{

	import com.li.minimole.core.Mesh;

	import flash.geom.Point;

	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JSlider;
	import org.aswing.JStepper;
	import org.aswing.event.InteractiveEvent;

	public class JLabeledSlider extends JPanel
	{
		private var _range:Number;
		private var _min:Number;
		private var _model:Mesh;
		private var _target:String;
		private var _slider:JSlider;

		public function JLabeledSlider( title:String, target:String, model:Mesh, range:Point ) {

			super();

			_target = target;
			_model = model;

			_range = range.y - range.x;
			_min = range.x;

			_slider = new JSlider();

			append( new JLabel( title ) );
			append( _slider );

			updateSliderFromValue();

			_slider.addEventListener( InteractiveEvent.STATE_CHANGED, sliderStateChangedHandler );
		}

		private function sliderStateChangedHandler( event:InteractiveEvent ):void {
			updateValueFromSlider();
		}

		private function updateSliderFromValue():void {
			var real:Number = _model[ _target ];
			var percent:int = ( 100 / _range ) * ( real - _min );
			_slider.setValue( percent );
		}

		private function updateValueFromSlider():void {
			var real:Number = ( _slider.getValue() / 100 ) * _range + _min;
			_model[ _target ] = real;
		}
	}
}
