package com.li.agalthemean.ui.views.samplersview
{

	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.minimole.materials.agal.AGALMaterial;

	import org.robotlegs.mvcs.Mediator;

	public class SamplersViewMediator extends Mediator
	{
		[Inject]
		public var view:SamplersView;

		[Inject]
		public var materialSetSignal:MaterialSetSignal;

		override public function onRegister():void
		{
			// incoming
			materialSetSignal.add( onMaterialSet );
		}

		private function onMaterialSet( material:AGALMaterial ):void {
			view.material = material;
		}
	}
}
