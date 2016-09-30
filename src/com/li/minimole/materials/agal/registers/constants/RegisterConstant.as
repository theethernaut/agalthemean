package com.li.minimole.materials.agal.registers.constants
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.mappings.RegisterMapping;

	public class RegisterConstant extends AGALRegister
	{
		public var mapping:RegisterMapping;
		public function RegisterConstant( name:String, value:*, mapping:* = null ) {
			this.mapping = mapping;
			super( name, value );
		}
	}
}
