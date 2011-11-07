package com.li.agalthemean.signals.requests
{

	import com.li.minimole.materials.agal.AGALMaterial;

	import org.osflash.signals.Signal;

	public class RequestMaterialRegistrationSignal extends Signal
	{
		public function RequestMaterialRegistrationSignal() {
			super( AGALMaterial );
		}
	}
}