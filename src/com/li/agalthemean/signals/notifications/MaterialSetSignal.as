package com.li.agalthemean.signals.notifications
{

	import com.li.minimole.materials.agal.AGALMaterial;

	import org.osflash.signals.Signal;

	public class MaterialSetSignal extends Signal
	{
		public function MaterialSetSignal() {
			super( AGALMaterial );
		}
	}
}
