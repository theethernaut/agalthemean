package com.li.minimole.materials.agal.registers.constants
{

	import com.li.minimole.materials.agal.registers.*;

	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;

	import flash.geom.Point;


	public class VectorRegisterConstant extends RegisterConstant
	{
		public var compNames:Vector.<String>;
		public var compRanges:Vector.<Point>;

		public function VectorRegisterConstant( name:String = "", x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0, mapping:* = null ) {
			super( name, Vector.<Number>( [ x, y, z, w ] ), mapping );
			compNames = Vector.<String>( [ "x", "y", "z", "w" ] );
			compRanges = Vector.<Point>( [ new Point( 0, 1 ), new Point( 0, 1 ), new Point( 0, 1 ), new Point( 0, 1 ) ] );
		}

		public function setComponentNames( xName:String = "x", yName:String = "y", zName:String = "z", wName:String = "w" ):void {
			compNames[ 0 ] = xName;
			compNames[ 1 ] = yName;
			compNames[ 2 ] = zName;
			compNames[ 3 ] = wName;
		}

		public function setComponentRanges( xRange:Point, yRange:Point, zRange:Point, wRange:Point ):void {
			compRanges[ 0 ] = xRange;
			compRanges[ 1 ] = yRange;
			compRanges[ 2 ] = zRange;
			compRanges[ 3 ] = wRange;
		}

		public function setColorComponentNames():void {
			setComponentNames( "r", "g", "b", "a" );
		}
	}
}
