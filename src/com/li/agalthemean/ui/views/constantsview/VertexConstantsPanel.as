package com.li.agalthemean.ui.views.constantsview
{

	import com.li.agalthemean.ui.components.JRegisterPanel;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.AGALRegister;
	import com.li.minimole.materials.agal.registers.RegisterConstant;
	import com.li.minimole.materials.agal.registers.VectorRegisterConstant;

	public class VertexConstantsPanel extends JRegisterPanel
	{
		public function VertexConstantsPanel() {

			super( "vertex constants", "VERTEX CONSTANTS", EditConstantPopUp );
		}

		override public function set material( value:AGALMaterial ):void {

			_material = value;

			removeAllRegisters();

			var i:uint, len:uint;

			len = _material.numVertexConstants;
			for( i = 0; i < len; ++i )
				addRegister( _material.getVertexConstantAt( i ) );
		}

		override protected function createRegister():AGALRegister {
			var register:VectorRegisterConstant = new VectorRegisterConstant( "myNewVertexConstant" );
			_material.addVertexConstant( register );
			return register;
		}

		override protected function removeRegister( register:AGALRegister ):void {
			_material.removeVertexConstant( register as RegisterConstant );
		}
	}
}
