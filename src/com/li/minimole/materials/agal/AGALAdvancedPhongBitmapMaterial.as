package com.li.minimole.materials.agal
{

	import com.li.minimole.materials.agal.data.TextureDimensionType;
	import com.li.minimole.materials.agal.data.TextureFilteringType;
	import com.li.minimole.materials.agal.data.TextureMipMappingType;
	import com.li.minimole.materials.agal.data.TextureRepeatType;
	import com.li.minimole.materials.agal.methods.AGALPhongDiffuseMethod;
	import com.li.minimole.materials.agal.methods.AGALPhongSpecularMethod;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.varyings.Varying;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;
	import com.li.minimole.materials.agal.registers.temporaries.VertexTemporary;

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class AGALAdvancedPhongBitmapMaterial extends AGALMaterial
	{
		public function AGALAdvancedPhongBitmapMaterial( texture:BitmapData, normalMap:BitmapData, specularMap:BitmapData ) {

			super();

			// attributes
			var vertexPositions:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPositions", VertexAttribute.POSITIONS ) ); // va0
			var vertexUvs:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexUvs", VertexAttribute.UVS ) ); // va1

			// samplers
			var texFlags:Array = [ TextureDimensionType.TYPE_2D, TextureMipMappingType.MIP_NEAREST, TextureFilteringType.LINEAR, TextureRepeatType.REPEAT ];
			var textureSampler:FragmentSampler = addFragmentSampler( new FragmentSampler( "textureSampler", texture, texFlags ) ); // fs0
			var normalMapSampler:FragmentSampler = addFragmentSampler( new FragmentSampler( "normalMapSampler", normalMap, texFlags ) ); // fs1
			var specularMapSampler:FragmentSampler = addFragmentSampler( new FragmentSampler( "specularMapSampler", specularMap, texFlags ) ); // fs2

			// vertex constants
			var mvc:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ); // vc0 to vc3
			var transform:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "transform", null, new RegisterMapping( RegisterMapping.TRANSFORM_MAPPING ) ) ); // vc4 to vc7
			var lightPosition:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "lightPosition", 0, 0, 0, 0, new RegisterMapping( RegisterMapping.CAMERA_MAPPING ) ) ) as VectorRegisterConstant; // vc8
			var cameraPosition:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "cameraPosition", 0, 0, 0, 0, new RegisterMapping( RegisterMapping.CAMERA_MAPPING ) ) ) as VectorRegisterConstant; // vc9
			lightPosition.setComponentRanges( new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ) );
			cameraPosition.setComponentRanges( new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ) );

			// fragment constants
			var specularColor:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "specularColor", 1, 1, 1, 1 ) ) as VectorRegisterConstant; // fc0
			specularColor.setComponentNames( "red", "green", "blue", "alpha" );
			var lightProperties:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "lightProperties", 0, 1, 0.5, 50 ) ) as VectorRegisterConstant; // fc1
			lightProperties.setComponentNames( "ambient", "diffuse", "specular", "gloss" );
			lightProperties.compRanges[ 3 ] = new Point( 0, 100 );
			var numericLiterals:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "numericLiterals", 2, 1 ) ) as VectorRegisterConstant; // fc2
			numericLiterals.setComponentNames( "2", "1", "not used", "not used" );
			var reducedTransform:RegisterConstant = addFragmentConstant( new MatrixRegisterConstant( "reducedTransform", null, new RegisterMapping( RegisterMapping.REDUCED_TRANSFORM_MAPPING ) ) ); // fc3

			// varying
			var interpolatedDirToLight:Varying = addVarying( new Varying( "interpolatedDirToLight" ) );
			var interpolatedDirToCamera:Varying = addVarying( new Varying( "interpolatedDirToCamera" ) );
			var interpolatedUvs:Varying = addVarying( new Varying( "interpolatedUvs" ) );

			// vertex agal
			_currentAGAL = "";
			var sceneSpaceVertexPosition:Temporary = addTemporary( new VertexTemporary( "sceneSpaceVertexPosition" ) );
			m44( sceneSpaceVertexPosition, vertexPositions, transform, "calculate vertex positions in scene space" );
			sub( interpolatedDirToLight, lightPosition, sceneSpaceVertexPosition, "interpolate direction to light" );
			sub( interpolatedDirToCamera, cameraPosition, sceneSpaceVertexPosition, "interpolate direction to camera" );
			mov( interpolatedUvs, vertexUvs, "interpolate uvs" );
			m44( op, vertexPositions, mvc, "output position to clip space" );
			vertexAGAL = _currentAGAL;

			// fragment agal
			_currentAGAL = "";
			// normalize input
			var normalizedDirToLight:Temporary = addTemporary( new FragmentTemporary( "normalizedDirToLight" ) );
			nrm( normalizedDirToLight.xyz, interpolatedDirToLight, "normalize dir to light" );
			var normalizedDirToCamera:Temporary = addTemporary( new FragmentTemporary( "normalizedDirToCamera" ) );
			nrm( normalizedDirToCamera.xyz, interpolatedDirToCamera, "normalize dir to camera" );
			// read textureSampler
			var textureSample:Temporary = addTemporary( new FragmentTemporary( "textureSample" ) );
			tex( textureSample, interpolatedUvs, textureSampler );
			var normalSample:Temporary = addTemporary( new FragmentTemporary( "normalSample" ) );
			tex( normalSample, interpolatedUvs, normalMapSampler );
			var specularSample:Temporary = addTemporary( new FragmentTemporary( "specularSample" ) );
			tex( specularSample, interpolatedUvs, specularMapSampler );
		    // adapt normal reading
			mul( normalSample, normalSample, numericLiterals.x, "multiply by 2" );
			sub( normalSample, normalSample, numericLiterals.y, "subtract 1" );
			neg( normalSample.z, normalSample.z, "reverse z" );
			m44( normalSample, normalSample, reducedTransform, "to scene space (ignoring position)" );
			// calculate diffuse term
			var diffuseTerm:Temporary = new AGALPhongDiffuseMethod(
					this,
					normalSample,
					normalizedDirToLight,
					lightProperties,
					textureSample ).diffuseTerm;
			// calculate specular term
			var specularTerm:Temporary = new AGALPhongSpecularMethod(
					this,
					normalSample,
					normalizedDirToLight,
					normalizedDirToCamera,
					lightProperties,
					specularColor
			).specularTerm;
			mul( specularTerm.xyz, specularTerm.xyz, specularSample, "multiply by specular map" );
			// output
			var combinedTerms:Temporary = addTemporary( new FragmentTemporary( "combinedTerms" ) );
			add( combinedTerms.xyz, diffuseTerm.xyz, specularTerm.xyz, "combine diffuse + specular" );
			mov( oc, combinedTerms.xyz );
			fragmentAGAL = _currentAGAL;
		}
	}
}
