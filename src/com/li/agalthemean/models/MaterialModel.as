package com.li.agalthemean.models
{

	import com.li.agalthemean.models.vos.AgalVO;
	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.minimole.materials.agal.AGALMaterial;

	import flash.display3D.Context3DProgramType;

	import flash.display3D.Program3D;

	public class MaterialModel
	{
		[Inject]
		public var materialRegisteredSignal:MaterialSetSignal;

		private var _material:AGALMaterial;

		public function MaterialModel() {
		}

		public function updateAGAL( agalVO:AgalVO ):void {
			if( agalVO.programType == Context3DProgramType.VERTEX )
				_material.vertexAGAL = agalVO.agalCode;
			else
				_material.fragmentAGAL = agalVO.agalCode;
		}

		public function set material( value:AGALMaterial ):void {

			_material = value;
			materialRegisteredSignal.dispatch( _material );
		}
	}
}
