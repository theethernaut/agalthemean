package com.li.agalthemean.signals.requests
{

	import com.li.agalthemean.models.vos.AgalVO;

	import org.osflash.signals.Signal;

	public class RequestAgalUpdateSignal extends Signal
	{
		public function RequestAgalUpdateSignal() {
			super( AgalVO );
		}
	}
}
