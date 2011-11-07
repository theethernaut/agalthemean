package com.li.agalthemean.ui.views.modelview
{

	import com.li.minimole.core.Mesh;

	import org.robotlegs.mvcs.Mediator;

		import com.li.agalthemean.signals.notifications.ModelSetSignal

	public class ModelViewMediator extends Mediator
	{
		[Inject]
		public var view:ModelView;

		[Inject]
		public var modelSetSignal:ModelSetSignal;

		override public function onRegister():void
		{
			// incoming
			modelSetSignal.add( onModelSet );
		}

		private function onModelSet( model:Mesh ):void {
			view.model = model;
		}
	}
}
