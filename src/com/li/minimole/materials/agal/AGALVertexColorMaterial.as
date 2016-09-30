package com.li.minimole.materials.agal
{

	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.varyings.Varying;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;

	public class AGALVertexColorMaterial extends AGALMaterial
	{
		public function AGALVertexColorMaterial() {

			super();

			var vertexPositions:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPositions", VertexAttribute.POSITIONS ) );
			var vertexColors:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexColors", VertexAttribute.VERTEX_COLORS ) );

			var mvc:MatrixRegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ) as MatrixRegisterConstant; // vc0

			var interpolatedVertCols:Varying = new Varying( "interpolatedVertCols" );

			// vertex
			_currentAGAL = "";
			mov( interpolatedVertCols, vertexColors );
			m44( op, vertexPositions, mvc );
			vertexAGAL = _currentAGAL;

			// fragment
			_currentAGAL = "";
			mov( oc, interpolatedVertCols );
			fragmentAGAL = _currentAGAL;

			setAGAL( _vertexAGAL, _fragmentAGAL );
		}
	}
}
