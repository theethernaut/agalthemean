package com.li.minimole.materials.agal.methods
{

	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.varyings.Varying;

	public class AGALWireframeMethod extends AGALMethod
	{
		public var diffuseLineFactor:Temporary;
		public var wireTerm:Temporary;

		public function AGALWireframeMethod( material:AGALMaterial,
				interpolatedVertColor:Varying,
				fragNumericLiterals:RegisterConstant,
				wireColor:RegisterConstant
				) {
			super( material );

			// find min color
			diffuseLineFactor = material.addTemporary( new FragmentTemporary( "diffuseLineFactor" ) );
			material.min( diffuseLineFactor.x, interpolatedVertColor.x, interpolatedVertColor.y, "find min color step 1" );
			material.min( diffuseLineFactor.x, diffuseLineFactor.x, interpolatedVertColor.z, "find min color step 2" );
			material.mul( diffuseLineFactor.x, diffuseLineFactor.x, diffuseLineFactor.x, "square min color" );
			material.mul( diffuseLineFactor.x, diffuseLineFactor.x, fragNumericLiterals.x, "times -2" );
			material.exp( diffuseLineFactor.x, diffuseLineFactor.x, "2 to the power of..." );
			wireTerm = material.addTemporary( new FragmentTemporary( "wireTerm" ) );
			material.mul( wireTerm.xyz, diffuseLineFactor.x, wireColor.xyz, "apply to wireColor" );
			material.sub( diffuseLineFactor.x, fragNumericLiterals.y, diffuseLineFactor.x );
		}
	}
}
