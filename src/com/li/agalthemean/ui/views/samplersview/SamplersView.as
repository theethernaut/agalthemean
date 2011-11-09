package com.li.agalthemean.ui.views.samplersview
{

	import com.li.agalthemean.ui.components.JRegisterPanel;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.registers.AGALRegister;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;

	public class SamplersView extends JRegisterPanel
	{
		public function SamplersView() {

			super( "samplers", "FRAGMENT SAMPLERS", EditSamplerPopUp );
		}

		override public function set material( value:AGALMaterial ):void {

			_material = value;

			removeAllRegisters();

			var i:uint, len:uint;

			len = _material.numFragmentSamplers;
			for( i = 0; i < len; ++i ) {
				addRegister( _material.getFragmentSamplerAt( i ) );
			}
		}

		override protected function createRegister():AGALRegister {
			var sampler:FragmentSampler = new FragmentSampler( "myNewSampler", null );
			_material.addFragmentSampler( sampler );
			return sampler;
		}

		override protected function removeRegister( register:AGALRegister ):void {
			_material.removeFragmentSampler( register as FragmentSampler );
		}
	}
}
