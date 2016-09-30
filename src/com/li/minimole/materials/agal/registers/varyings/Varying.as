package com.li.minimole.materials.agal.registers.varyings
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.registers.AGALRegister;

	public class Varying extends AGALRegister
	{
		public function Varying( name:String ) {
			super( name );
			registerPrefix = "v";
		}
	}
}
