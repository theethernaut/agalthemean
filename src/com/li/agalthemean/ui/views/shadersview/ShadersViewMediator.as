package com.li.agalthemean.ui.views.shadersview
{

	import com.li.agalthemean.models.vos.AgalVO;
	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.agalthemean.signals.requests.RequestAgalUpdateSignal;
	import com.li.minimole.materials.agal.AGALMaterial;

	import flash.display3D.Context3DProgramType;

	import org.robotlegs.mvcs.Mediator;

	public class ShadersViewMediator extends Mediator
	{
		[Inject]
		public var view:ShadersView;

		[Inject]
		public var materialSetSignal:MaterialSetSignal;

		[Inject]
		public var requestAgalUpdateSignal:RequestAgalUpdateSignal;

		override public function onRegister():void {
			// incoming
			materialSetSignal.add( onMaterialSet );
			// outgoing
			view.vertEditor.textChangedSignal.add( onVertexTextChanged );
			view.fragEditor.textChangedSignal.add( onFragmentTextChanged );
		}

		private function onMaterialSet( material:AGALMaterial ):void {
			view.vertEditor.agalText = material.vertexAGAL;
			view.fragEditor.agalText = material.fragmentAGAL;
		}

		private function onVertexTextChanged( agalText:String ):void {
			requestAgalUpdateSignal.dispatch( new AgalVO( agalText, Context3DProgramType.VERTEX ) );
		}

		private function onFragmentTextChanged( agalText:String ):void {
			requestAgalUpdateSignal.dispatch( new AgalVO( agalText, Context3DProgramType.FRAGMENT ) );
		}
	}
}
