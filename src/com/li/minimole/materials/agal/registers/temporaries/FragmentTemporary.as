package com.li.minimole.materials.agal.registers.temporaries
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.registers.temporaries.Temporary;

	public class FragmentTemporary extends Temporary
	{
		public function FragmentTemporary( name:String ) {
			super( name );
			registerPrefix = "ft";
		}
	}
}
