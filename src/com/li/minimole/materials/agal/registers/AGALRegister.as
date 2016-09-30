package com.li.minimole.materials.agal.registers
{

	public class AGALRegister
	{
		public var name:String;
		public var value:*;
		public var registerPrefix:String;
		public var registerIndex:int = -1;
		public var registerComps:String = "";

		public function AGALRegister( name:String = "", value:* = null ) {
			this.name = name;
			this.value = value;
		}

		public function toString():String {
			return registerIndex != -1 ? registerPrefix + registerIndex + registerComps : registerPrefix;
		}

		public function toStringExtended():String {
			return registerPrefix + registerIndex + ", " + name;
		}

		public function cloneRegister():AGALRegister {
			var clone:AGALRegister = new AGALRegister( name, value );
			clone.registerPrefix = registerPrefix;
			clone.registerIndex = registerIndex;
			clone.registerComps = registerComps;
			return clone;
		}

		// -----------------------
		// components
		// -----------------------

		public function get w():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".w";
			return clone;
		}

		public function get z():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".z";
			return clone;
		}

		public function get xxx():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".xxx";
			return clone;
		}

		public function get y():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".y";
			return clone;
		}

		public function get xy():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".xy";
			return clone;
		}

		public function get x():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".x";
			return clone;
		}

		public function get xyz():AGALRegister {
			var clone:AGALRegister = cloneRegister();
			clone.registerComps = ".xyz";
			return clone;
		}
	}
}
