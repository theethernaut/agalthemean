package com.li.minimole.materials.agal.methods
{

	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.AGALRegister;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;

	public class AGALPhongDiffuseMethod extends AGALMethod
	{
		public var diffuseTerm:Temporary;

		public function AGALPhongDiffuseMethod(
				material:AGALMaterial,
				normalizedNormal:Temporary,
				normalizedDirToLight:Temporary,
				lightProperties:VectorRegisterConstant,
				diffuseColor:AGALRegister ) {

			super( material );

			diffuseTerm = material.addTemporary( new FragmentTemporary( "diffuseTerm" ) );

			material.dp3( diffuseTerm.x, normalizedNormal.xyz, normalizedDirToLight.xyz, "find projection of direction to light on normal" );
			material.sat( diffuseTerm.x, diffuseTerm.x, "ignore negative values" );
			material.mul( diffuseTerm.x, diffuseTerm.x, lightProperties.y, "multiply projection of direction to light on normal with light's diffuse amoun" );
			material.add( diffuseTerm.x, diffuseTerm.x, lightProperties.x, "add light's ambient amount" );
			material.mul( diffuseTerm.xyz, diffuseTerm.xxx, diffuseColor.xyz, "multiply by material's diffuse color" );

		}
	}
}
