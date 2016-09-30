package com.li.minimole.materials.agal
{

	import com.li.minimole.core.utils.ColorUtils;
	import com.li.minimole.core.vo.RGB;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;

	public class AGALColorMaterial extends AGALMaterial
	{
		public function AGALColorMaterial( color:uint = 0xFFFFFF ) {

			super();

			var rgb:RGB = ColorUtils.hexToRGB( color );
			
			var vertexPositions:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPositions", VertexAttribute.POSITIONS ) ); // va0
			var mvc:MatrixRegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ) as MatrixRegisterConstant; // vc0
			var fragmentColor:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "fragmentColor", rgb.r / 255, rgb.g / 255, rgb.b / 255, rgb.a ) ) as VectorRegisterConstant; // fc0
			fragmentColor.setColorComponentNames();

			// vertex
			_currentAGAL = "";
			m44( op, vertexPositions, mvc );
			vertexAGAL = _currentAGAL;

			// fragment
			_currentAGAL = "";
			mov( oc, fragmentColor );
			fragmentAGAL = _currentAGAL;

			setAGAL( _vertexAGAL, _fragmentAGAL );
		}
	}
}
