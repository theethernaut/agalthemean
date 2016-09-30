package com.li.minimole.materials.agal
{

	import com.li.minimole.materials.agal.methods.AGALWireframeMethod;

	public class AGALWireframeMaterial extends AGALMaterial
	{
		import com.li.minimole.core.utils.ColorUtils;
		import com.li.minimole.core.vo.RGB;
		import com.li.minimole.materials.agal.methods.AGALPhongDiffuseMethod;
		import com.li.minimole.materials.agal.methods.AGALPhongSpecularMethod;
		import com.li.minimole.materials.agal.mappings.RegisterMapping;
		import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
		import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
		import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
		import com.li.minimole.materials.agal.registers.temporaries.Temporary;
		import com.li.minimole.materials.agal.registers.varyings.Varying;
		import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;
		import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;
		import com.li.minimole.materials.agal.registers.temporaries.VertexTemporary;

		import flash.geom.Point;

		public function AGALWireframeMaterial( lineColor:uint, bgColor:uint ) {

			super();

			var wireRGB:RGB = ColorUtils.hexToRGB( lineColor );
			var bgRGB:RGB = ColorUtils.hexToRGB( bgColor );

			// attributes
			var vertexPositions:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexPositions", VertexAttribute.POSITIONS ) ); // va0
			var vertexNormals:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexNormals", VertexAttribute.NORMALS ) ); // va1
			var vertexColors:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexColors", VertexAttribute.VERTEX_COLORS ) ); // va2
			var vertexAreas:VertexAttribute = addVertexAttribute( new VertexAttribute( "vertexAreas", VertexAttribute.VERTEX_AREA_FACTORS ) ); // va3

			// vertex constants
			var mvc:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "modelViewProjection", null, new RegisterMapping( RegisterMapping.MVC_MAPPING ) ) ); // vc0 to vc3
			var transform:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "transform", null, new RegisterMapping( RegisterMapping.TRANSFORM_MAPPING ) ) ); // vc4 to vc7
			var reducedTransform:RegisterConstant = addVertexConstant( new MatrixRegisterConstant( "reducedTransform", null, new RegisterMapping( RegisterMapping.REDUCED_TRANSFORM_MAPPING ) ) ); // vc8 to vc11
			var lightPosition:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "lightPosition", 0, 0, 0, 0, new RegisterMapping( RegisterMapping.CAMERA_MAPPING ) ) ) as VectorRegisterConstant; // vc12
			var cameraPosition:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "cameraPosition", 0, 0, 0, 0, new RegisterMapping( RegisterMapping.CAMERA_MAPPING ) ) ) as VectorRegisterConstant; // vc13
			var lineProperties:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "lineProperties", 125, 0, 0, 0 ) ) as VectorRegisterConstant; // vc14
			var vertNumericLiterals:VectorRegisterConstant = addVertexConstant( new VectorRegisterConstant( "vertNumericLiterals", 10, 0, 0, 0 ) ) as VectorRegisterConstant; // vc15
			lightPosition.setComponentRanges( new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ) );
			cameraPosition.setComponentRanges( new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ), new Point( -5, 5 ) );
			lineProperties.setComponentNames( "lineFactor" );
			lineProperties.setComponentRanges( new Point( 0, 1000 ), new Point(), new Point(), new Point() );

			// fragment constants
			var diffuseColor:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "diffuseColor", bgRGB.r / 255, bgRGB.g / 255, bgRGB.b / 255, bgRGB.a ) ) as VectorRegisterConstant; // fc0
			var wireColor:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "wireColor", wireRGB.r / 255, wireRGB.g / 255, wireRGB.b / 255, wireRGB.a ) ) as VectorRegisterConstant; // fc1
			var lightProperties:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "lightProperties", 0, 1, 0.5, 50 ) ) as VectorRegisterConstant; // fc3
			var fragNumericLiterals:VectorRegisterConstant = addFragmentConstant( new VectorRegisterConstant( "fragNumericLiterals", -2, 1, 0, 0 ) ) as VectorRegisterConstant; // vc13
			wireColor.setComponentNames( "red", "green", "blue", "alpha" );
			diffuseColor.setComponentNames( "red", "green", "blue", "alpha" );
			lightProperties.setComponentNames( "ambient", "diffuse", "specular", "gloss" );
			lightProperties.compRanges[ 3 ] = new Point( 0, 100 );

			// varying
			var interpolatedDirToLight:Varying = addVarying( new Varying( "interpolatedDirToLight" ) );
			var interpolatedDirToCamera:Varying = addVarying( new Varying( "interpolatedDirToCamera" ) );
			var interpolatedNormals:Varying = addVarying( new Varying( "interpolatedNormals" ) );
			var interpolatedVertColor:Varying = addVarying( new Varying( "interpolatedVertColor" ) );

			// vertex agal
			_currentAGAL = "";
			var sceneSpaceVertexPosition:Temporary = addTemporary( new VertexTemporary( "sceneSpaceVertexPosition" ) );
			m44( sceneSpaceVertexPosition, vertexPositions, transform, "calculate vertex positions in scene space" );
			sub( interpolatedDirToLight, lightPosition, sceneSpaceVertexPosition, "interpolate direction to light" );
			var viewDir:Temporary = addTemporary( new VertexTemporary( "viewDir" ) );
			sub( viewDir, cameraPosition, sceneSpaceVertexPosition, "direction to camera" );
			mov( interpolatedDirToCamera, viewDir, "interpolate view dir" );
			var resFactor:Temporary = addTemporary( new VertexTemporary( "resFactor" ) );
			dp3( resFactor.x, viewDir.xyz, viewDir.xyz, "distance to camera squared" );
			sqt( resFactor.x, resFactor.x, "dist to cam" );
			div( resFactor.x, vertNumericLiterals.x, resFactor.x, "10 / dist to cam" );
			mul( resFactor.x, resFactor.x, lineProperties.x, "times lineFactor" );
			mul( resFactor.xyz, resFactor.x, vertexAreas.xyz, "apply factor to vertexAreas" );
			mul( interpolatedVertColor, vertexColors.xyz, resFactor.xyz, "interpolate vertex color times vertexAreas" );
			m44( interpolatedNormals, vertexNormals, reducedTransform, "interpolate normal positions in scene space (ignoring position)" );
			m44( op, vertexPositions, mvc, "output position to clip space" );
			vertexAGAL = _currentAGAL;

			// fragment agal
			_currentAGAL = "";
			// normalize input
			var normalizedDirToLight:Temporary = addTemporary( new FragmentTemporary( "normalizedDirToLight" ) );
			nrm( normalizedDirToLight.xyz, interpolatedDirToLight, "normalize dir to light" );
			var normalizedDirToCamera:Temporary = addTemporary( new FragmentTemporary( "normalizedDirToCamera" ) );
			nrm( normalizedDirToCamera.xyz, interpolatedDirToCamera, "normalize dir to camera" );
			var normalizedNormal:Temporary = addTemporary( new FragmentTemporary( "normalizedNormal" ) );
			nrm( normalizedNormal.xyz, interpolatedNormals, "normalize normals" );
			// calculate wireframe term
			var wireframeTerm:AGALWireframeMethod = new AGALWireframeMethod(
					this,
					interpolatedVertColor,
					fragNumericLiterals,
					wireColor
			);
			// calculate diffuse term
			var diffuseTerm:Temporary = new AGALPhongDiffuseMethod(
					this,
					normalizedNormal,
					normalizedDirToLight,
					lightProperties,
					diffuseColor
			).diffuseTerm;
			mul( diffuseTerm.xyz, diffuseTerm.xyz, wireframeTerm.diffuseLineFactor.x, "apply to diffuse" );
			// output
			var combinedTerms:Temporary = addTemporary( new FragmentTemporary( "combinedTerms" ) );
			add( combinedTerms.xyz, diffuseTerm.xyz, wireframeTerm.wireTerm.xyz, "combine" );
			mov( oc, combinedTerms.xyz );
			fragmentAGAL = _currentAGAL;
		}
	}
}
