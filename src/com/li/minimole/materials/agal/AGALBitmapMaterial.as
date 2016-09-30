package com.li.minimole.materials.agal
{

	import com.li.minimole.materials.agal.data.TextureDimensionType;
	import com.li.minimole.materials.agal.data.TextureFilteringType;
	import com.li.minimole.materials.agal.data.TextureMipMappingType;
	import com.li.minimole.materials.agal.data.TextureRepeatType;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.varyings.Varying;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;

	import flash.display.BitmapData;

	public class AGALBitmapMaterial extends AGALMaterial
	{
		public function AGALBitmapMaterial( bitmap:BitmapData ) {
			super();

			var texFlags:Array = [ TextureDimensionType.TYPE_2D, TextureMipMappingType.MIP_NONE, TextureFilteringType.LINEAR, TextureRepeatType.REPEAT ];
			var texture:FragmentSampler = addFragmentSampler( new FragmentSampler( "texture", bitmap, texFlags ) );

			var vertexPositions:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPositions", VertexAttribute.POSITIONS ) ); // va0
			var vertexUvs:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexUvs", VertexAttribute.UVS ) ); // va1
			var mvc:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ); // vc0
			var interpolatedUvs:Varying = addVarying( new Varying( "interpolatedUvs" ) );

			// vertex
			_currentAGAL = "";
			mov( interpolatedUvs, vertexUvs );
			m44( op, vertexPositions, mvc );
			vertexAGAL = _currentAGAL;

			// fragment
			_currentAGAL = "";
			tex( oc, interpolatedUvs, texture );
			fragmentAGAL = _currentAGAL;
		}
	}
}
