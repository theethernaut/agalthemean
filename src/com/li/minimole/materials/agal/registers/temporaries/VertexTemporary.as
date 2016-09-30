package com.li.minimole.materials.agal.registers.temporaries
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.registers.temporaries.Temporary;

	public class VertexTemporary extends Temporary
	{
		public function VertexTemporary( name:String ) {
			super( name );
			registerPrefix = "vt";
		}
	}
}
