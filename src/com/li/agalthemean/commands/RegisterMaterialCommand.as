package com.li.agalthemean.commands
{

	import com.junkbyte.console.Cc;
	import com.li.agalthemean.models.MaterialModel;
	import com.li.minimole.materials.agal.AGALMaterial;

	import org.robotlegs.mvcs.SignalCommand;

	public class RegisterMaterialCommand extends SignalCommand
	{
		[Inject]
		public var material:AGALMaterial;

		[Inject]
		public var materialModel:MaterialModel;

		public function RegisterMaterialCommand() {
			super();
		}

		override public function execute():void {
			Cc.info( "RegisterMaterialCommand" );
			materialModel.material = material;
		}
	}
}