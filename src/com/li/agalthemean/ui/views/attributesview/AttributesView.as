package com.li.agalthemean.ui.views.attributesview
{

	import com.li.agalthemean.ui.components.JRegisterPanel;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.AGALRegister;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;

	public class AttributesView extends JRegisterPanel
	{
		public function AttributesView() {

			super( "attributes", "VERTEX ATTRIBUTES", EditAttributePopUp );
		}

		override public function set material( value:AGALMaterial ):void {

			_material = value;

			removeAllRegisters();

			for( var i:uint; i < _material.numVertexAttributes; ++i )
				addRegister( _material.getVertexAttributeAt( i ) );
		}

		override protected function createRegister():AGALRegister {
			var attribute:VertexAttribute = new VertexAttribute( "myNewVertexAttribute", VertexAttribute.POSITIONS );
			_material.addVertexAttribute( attribute );
			return attribute;
		}

		override protected function removeRegister( register:AGALRegister ):void {
			_material.removeVertexAttribute( register as VertexAttribute );
		}
	}
}
