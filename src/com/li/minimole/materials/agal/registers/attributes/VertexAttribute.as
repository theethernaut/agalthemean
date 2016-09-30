package com.li.minimole.materials.agal.registers.attributes
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.registers.AGALRegister;

	import flash.display3D.Context3DVertexBufferFormat;

	public class VertexAttribute extends AGALRegister
	{
		public static const POSITIONS:String = "POSITIONS_BUFFER";
		public static const NORMALS:String = "NORMALS_BUFFER";
		public static const UVS:String = "UV_BUFFER";
		public static const VERTEX_COLORS:String = "VERTEX_COLORS";
		public static const VERTEX_AREA_FACTORS:String = "VERTEX_AREA_FACTORS";

		public var format:String;
		public function VertexAttribute( name:String = "", type:String = "" ) {

			super( name, type );
			refreshFormat();
			registerPrefix = "va";
		}

		public function refreshFormat():void {
			switch( value ) {
				case POSITIONS:
				case NORMALS:
				case VERTEX_AREA_FACTORS:
				case VERTEX_COLORS: {
					this.format = Context3DVertexBufferFormat.FLOAT_3;
					break;
				}
				case UVS: {
					this.format = Context3DVertexBufferFormat.FLOAT_2;
					break;
				}
				default: {
					throw new Error( "Unrecognized vertex attribute type." );
				}
			}
		}

		override public function toStringExtended():String {
			return registerPrefix + registerIndex + ", " + name + " - " + value + ", " + format;
		}
	}
}
