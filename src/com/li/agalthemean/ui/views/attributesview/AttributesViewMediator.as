package com.li.agalthemean.ui.views.attributesview
{

	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.minimole.materials.agal.AGALMaterial;

	import org.robotlegs.mvcs.Mediator;

	public class AttributesViewMediator extends Mediator
	{
		[Inject]
		public var view:AttributesView;

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
