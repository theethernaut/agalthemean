package com.li.agalthemean.commands
{

	import com.li.minimole.core.Mesh;

	import org.robotlegs.mvcs.SignalCommand;

		import com.li.agalthemean.models.ModelModel

	public class RegisterModelCommand extends SignalCommand
	{
		[Inject]
		public var model:Mesh;


		[Inject]
		public var modelModel:ModelModel;

		public function RegisterModelCommand() {
			super();
		}

		override public function execute():void
		{
			modelModel.model = model;
		}
	}
}
