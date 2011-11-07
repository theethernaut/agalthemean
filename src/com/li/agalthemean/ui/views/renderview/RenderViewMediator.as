package com.li.agalthemean.ui.views.renderview
{

	import com.li.agalthemean.signals.requests.RequestMaterialRegistrationSignal;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.agal.AGALMaterial;

	import org.robotlegs.mvcs.Mediator;

		import com.li.agalthemean.signals.requests.RequestModelRegistrationSignal

	public class RenderViewMediator extends Mediator
	{
		[Inject]
		public var view:RenderView;

		[Inject]
		public var requestMaterialRegisterSignal:RequestMaterialRegistrationSignal;


		[Inject]
		public var requestModelRegistrationSignal:RequestModelRegistrationSignal;

		override public function onRegister():void {

			// incoming

			// outgoing
			DefaultAssetStore.instance.materialRequestedSignal.add( onMaterialInitialized );
			DefaultAssetStore.instance.modelRequestedSignal.add( onModelInitialized );
		}

		private function onModelInitialized( model:Mesh ):void {
			trace( "model: " + model );
			requestModelRegistrationSignal.dispatch( model );
		}

		private function onMaterialInitialized( material:AGALMaterial ):void {
			trace( "material: " + material );
			requestMaterialRegisterSignal.dispatch( material );
		}
	}
}
