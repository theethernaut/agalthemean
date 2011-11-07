package com.li.agalthemean.models
{

	import com.li.minimole.core.Mesh;

		import com.li.agalthemean.signals.notifications.ModelSetSignal

	public class ModelModel
	{


		private var _model:Mesh;

		[Inject]
		public var modelSetSignal:ModelSetSignal;

		public function ModelModel() {
		}

		public function set model( value:Mesh ):void {
			_model = value;
			modelSetSignal.dispatch( _model );
		}
	}
}
