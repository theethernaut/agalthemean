package com.li.agalthemean.ui.views.constantsview
{

	import com.li.agalthemean.ui.components.JRegisterPanel;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.vo.registers.AGALRegister;
	import com.li.minimole.materials.agal.vo.registers.RegisterConstant;
	import com.li.minimole.materials.agal.vo.registers.VectorRegisterConstant;

	public class FragmentConstantsPanel extends JRegisterPanel
	{
		public function FragmentConstantsPanel() {

			super( "fragment constants", "FRAGMENT CONSTANTS", EditConstantPopUp );
		}

		override public function set material( value:AGALMaterial ):void {

			_material = value;

			removeAllRegisters();

			var i:uint, len:uint;

			len = _material.numFragmentConstants;
			for( i = 0; i < len; ++i )
				addRegister( _material.getFragmentConstantAt( i ) );
		}

		override protected function createRegister():AGALRegister {
			var register:VectorRegisterConstant = new VectorRegisterConstant( "myNewFragmentConstant" );
			_material.addFragmentConstant( register );
			return register;
		}

		override protected function removeRegister( register:AGALRegister ):void {
			_material.removeFragmentConstant( register as RegisterConstant );
		}
	}
}
