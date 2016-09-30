package com.li.minimole.materials.agal.registers.samplers
{

	import com.li.minimole.materials.agal.registers.*;

	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;

	public class FragmentSampler extends AGALRegister
	{
		public var texture:Texture;
		public var flags:Array;
		public function FragmentSampler( name:String = "", bitmap:BitmapData = null, flags:Array = null ) {
			registerPrefix = "fs";
			this.flags = flags == null ? new Array() : flags;
			super( name, bitmap );
		}
	}
}
