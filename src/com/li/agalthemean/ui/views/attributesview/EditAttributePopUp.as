package com.li.agalthemean.ui.views.attributesview
{

	import com.li.agalthemean.ui.components.JRegisterPopUp;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;

	import org.aswing.JComboBox;

	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;

	public class EditAttributePopUp extends JRegisterPopUp
	{
		private var _typeCombo:JComboBox;
		private var _attributeTypes:Array = [
				VertexAttribute.POSITIONS,
				VertexAttribute.NORMALS,
				VertexAttribute.UVS,
				VertexAttribute.VERTEX_COLORS,
				VertexAttribute.VERTEX_AREA_FACTORS
			];

		public function EditAttributePopUp( attribute:VertexAttribute ) {

			_typeCombo = new JComboBox( _attributeTypes );
			_typeCombo.setSelectedIndex( _attributeTypes.indexOf( attribute.value ) );
			_typeCombo.addEventListener( AWEvent.ACT, typeChangedHandler );

			super( attribute, _typeCombo );

			packs = false;
			setSize( new IntDimension( 300, 80 ) );
		}

		private function typeChangedHandler( event:AWEvent ):void {
			var selected:String = _attributeTypes[ _typeCombo.getSelectedIndex() ];
			VertexAttribute( register ).value = selected;
			VertexAttribute( register ).refreshFormat();
			registerRenamedSignal.dispatch();
			refreshTitle();
		}
	}
}
