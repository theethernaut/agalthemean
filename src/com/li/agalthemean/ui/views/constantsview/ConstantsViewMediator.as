package com.li.agalthemean.ui.views.constantsview
{

	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.minimole.materials.agal.AGALMaterial;

	import org.robotlegs.mvcs.Mediator;

	public class ConstantsViewMediator extends Mediator
	{
		[Inject]
		public var view:ConstantsView;

		[Inject]
		public var materialSetSignal:MaterialSetSignal;

		override public function onRegister():void
		{
			// incoming
			materialSetSignal.add( onMaterialSet );
		}

		private function onMaterialSet( material:AGALMaterial ):void {
			view.vertConstants.material = material;
			view.fragConstants.material = material;
		}
	}
}
