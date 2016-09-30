package com.li.minimole.materials.agal.methods
{

	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;

	public class AGALPhongSpecularMethod extends AGALMethod
	{
		public var specularTerm:Temporary;

		public function AGALPhongSpecularMethod(
				material:AGALMaterial,
				normalizedNormal:Temporary,
				normalizedDirToLight:Temporary,
				normalizedDirToCamera:Temporary,
				lightProperties:VectorRegisterConstant,
				specularColor:VectorRegisterConstant ) {

			super( material );

			specularTerm = material.addTemporary( new FragmentTemporary( "specularTerm" ) );

			material.add( specularTerm.xyz, normalizedDirToLight.xyz, normalizedDirToCamera.xyz, "evaluate half vector" );
			material.nrm( specularTerm.xyz, specularTerm.xyz, "normalize half vector" );
			material.dp3( specularTerm.x, normalizedNormal.xyz, specularTerm.xyz, "find projection of half vector on normal" );
			material.sat( specularTerm.x, specularTerm.x, "ignore negative values" );
			material.pow( specularTerm.x, specularTerm.x, lightProperties.w, "apply gloss" );
			material.mul( specularTerm.x, specularTerm.x, lightProperties.z, "multiply with specular amount" );
			material.mul( specularTerm.xyz, specularTerm.xxx, specularColor, "multiply with specular color" );
		}
	}
}
