package com.li.agalthemean.commands
{

	import com.junkbyte.console.Cc;
	import com.li.agalthemean.models.vos.AgalVO;

	import org.robotlegs.mvcs.SignalCommand;

		import com.li.agalthemean.models.MaterialModel

	public class UpdateAGALCommand extends SignalCommand
	{
		[Inject]
		public var agalVO:AgalVO;

		[Inject]
		public var materialModel:MaterialModel;

		public function UpdateAGALCommand() {
			super();
		}

		override public function execute():void
		{
			Cc.info( "UpdateProgram3DCommand" );

			materialModel.updateAGAL( agalVO );
		}
	}
}
