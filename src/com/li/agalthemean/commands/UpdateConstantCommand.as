package com.li.agalthemean.commands
{

	import com.junkbyte.console.Cc;
	import com.li.agalthemean.models.MaterialModel;

	public class UpdateConstantCommand
	{
		[Inject]
		public var materialModel:MaterialModel;

		public function execute():void {
			Cc.info( "UpdateConstantCommand" );

		}
	}
}