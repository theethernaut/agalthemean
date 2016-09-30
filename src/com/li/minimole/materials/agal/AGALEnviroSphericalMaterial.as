package com.li.minimole.materials.agal
{

	import com.li.minimole.materials.agal.data.TextureMipMappingType;
	import com.li.minimole.materials.agal.data.TextureRepeatType;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;
	import com.li.minimole.materials.agal.registers.temporaries.VertexTemporary;

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class AGALEnviroSphericalMaterial extends AGALMaterial
	{
		import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.varyings.Varying;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;

		public function AGALEnviroSphericalMaterial( bitmap:BitmapData ) {
			super();

			// attributes
			var vertexPosition:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPosition", VertexAttribute.POSITIONS ) ); // va0
			var vertexNormal:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexNormal", VertexAttribute.NORMALS ) ); // va1

			// vertex constants
			var mvc:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ); // vc0
			var transform:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "transform", null, new RegisterMapping( RegisterMapping.TRANSFORM_MAPPING ) ) ); // vc4
			var rTransform:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "rTransform", null, new RegisterMapping( RegisterMapping.REDUCED_TRANSFORM_MAPPING ) ) ); // vc8
			var cameraPosition:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "cameraPosition",
					0, 0, 0, 0, new RegisterMapping( RegisterMapping.CAMERA_MAPPING ) ) ) as VectorRegisterConstant; // vc12
			cameraPosition.setComponentRanges( new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ) );

			// fragment constants
			var numericLiterals:RegisterConstant = addFragmentConstant( new VectorRegisterConstant( "numericLiterals", 2, 0, 0.5 ) );
			var xUnit:RegisterConstant = addFragmentConstant( new VectorRegisterConstant( "xUnit", 1, 0, 0, 1 ) );
			var yUnit:RegisterConstant = addFragmentConstant( new VectorRegisterConstant( "yUnit", 0, 1, 0, 1 ) );

			// textures
			var textureSampler:FragmentSampler = addFragmentSampler( new FragmentSampler( "textureSampler", bitmap, [ TextureMipMappingType.MIP_NEAREST, TextureRepeatType.CLAMP ] ) );

			// varying
			var interpolatedNormal:Varying = addVarying( new Varying( "interpolatedNormal" ) );
			var interpolatedDirToCam:Varying = addVarying( new Varying( "interpolatedDirToCam" ) );

			// vertex
			_currentAGAL = "";
			var sceneSpaceVertexPos:Temporary = addTemporary( new VertexTemporary( "sceneSpaceVertexPos" ) );
			m44( sceneSpaceVertexPos, vertexPosition, transform, "scene space vertex position" );
			m44( interpolatedNormal, vertexNormal, rTransform, "interpolate scene space vertex normal" );
			sub( interpolatedDirToCam, cameraPosition, sceneSpaceVertexPos, "interpolate dir to cam" );
			m44( op, vertexPosition, mvc, "vertex position to clip space" );
			vertexAGAL = _currentAGAL;

			// fragment
			_currentAGAL = "";
			var normalizedNormal:Temporary = addTemporary( new FragmentTemporary( "normalizedNormal" ) );
			nrm( normalizedNormal.xyz, interpolatedNormal.xyz, "normalize normal" );
			var normalizedDirToCam:Temporary = addTemporary( new FragmentTemporary( "normalizedDirToCam" ) );
			nrm( normalizedDirToCam.xyz, interpolatedDirToCam.xyz, "normalize dir to cam" );
//			comment( "evaluate reflection direction" );
			var reflectionDirection:Temporary = addTemporary( new FragmentTemporary( "reflectionDirection" ) );
			dp3( reflectionDirection.x, normalizedDirToCam.xyz, normalizedNormal.xyz, "proj view dir on normal" );
			mul( reflectionDirection.x, reflectionDirection.x, numericLiterals.x, "multiply by 2" );
			mul( reflectionDirection.xyz, reflectionDirection.xxx, normalizedNormal.xyz, "multiply by normal" );
			sub( reflectionDirection.xyz, normalizedDirToCam.xyz, reflectionDirection.xyz, "substract from view dir" );
			nrm( reflectionDirection.xyz, reflectionDirection.xyz, "normalize" );
//			comment( "determine uv's using spherical coordinates" );
			var uv:Temporary = addTemporary( new FragmentTemporary( "uv" ) );
			dp3( uv.y, reflectionDirection.xyz, yUnit.xyz, "uv.y as y component on refl dir" );
			mov( reflectionDirection.y, numericLiterals.y, "set refl dir y comp to zero" );
			nrm( reflectionDirection.xyz, reflectionDirection.xyz, "normalize" );
			dp3( uv.x, reflectionDirection.xyz, xUnit.xyz, "uv.x as x component on refl dir" );
			mul( uv.x, uv.x, numericLiterals.z, "divide uv.x by 2" );
			var texSample:Temporary = addTemporary( new FragmentTemporary( "texSample" ) );
			tex( texSample, uv.xy, textureSampler, "read texture" ); // TODO: need to contain values
			mov( oc, texSample.xyz );
			fragmentAGAL = _currentAGAL;
		}
	}
}
