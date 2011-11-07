package com.li.agalthemean.ui.views.constantsview
{

	import com.li.agalthemean.ui.components.JRegisterPopUp;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.RegisterConstant;
	import com.li.minimole.materials.agal.registers.VectorRegisterConstant;

	import org.aswing.BorderLayout;
	import org.aswing.JComboBox;
	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;

	public class EditConstantPopUp extends JRegisterPopUp
	{
		private var _adjuster:ConstantAdjuster;
		private var _mappingsCombo:JComboBox;
		private var _vectorMappingTypes:Array = [
				"no mapping",
				RegisterMapping.CAMERA_MAPPING,
				RegisterMapping.OSCILLATOR_MAPPING
			];
		private var _matrixMappingTypes:Array = [
				"no mapping",
				RegisterMapping.MVC_MAPPING,
				RegisterMapping.TRANSFORM_MAPPING,
				RegisterMapping.REDUCED_TRANSFORM_MAPPING
			];
		private var _targetData:Array;

		public function EditConstantPopUp( constant:RegisterConstant ) {

			// adjusters
			_adjuster = new ConstantAdjuster( constant );

			// mappings combo
			_targetData = constant is VectorRegisterConstant ? _vectorMappingTypes : _matrixMappingTypes;
			_mappingsCombo = new JComboBox( _targetData );
			if( constant.mapping != null ) {
				_mappingsCombo.setSelectedIndex( _targetData.indexOf( constant.mapping.type ) );
			}
			else {
				_mappingsCombo.setSelectedIndex( 0 );
			}
			_mappingsCombo.addEventListener( AWEvent.ACT, typeChangedHandler );

			var content:JPanel = new JPanel( new BorderLayout() );
			content.append( _adjuster, BorderLayout.CENTER );
			content.append( _mappingsCombo, BorderLayout.SOUTH );

			super( constant, content );

			refreshAdjusterState();
		}

		override protected function onClose():void {
			_adjuster.stopListeningToConstant();
		}

		private function refreshAdjusterState():void {
			if( RegisterConstant( register ).mapping != null && register is VectorRegisterConstant ) {
				_adjuster.startListeningToConstant();
			}
			else {
				_adjuster.stopListeningToConstant();
			}
		}

		private function typeChangedHandler( event:AWEvent ):void {

			var index:uint = _mappingsCombo.getSelectedIndex();

			var constant:RegisterConstant = RegisterConstant( register );

			if( index == 0 ) {
				constant.mapping = null;
			}
			else {
				constant.mapping = new RegisterMapping( _targetData[ index ] );
			}

			refreshAdjusterState();
		}
	}
}
