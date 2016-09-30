package com.li.minimole.core.utils
{

	import com.li.minimole.core.Mesh;

	import flash.geom.Vector3D;

	public class MeshUtils
	{
		/*
		 Assuming that the mesh's raw vertex buffer is already populated, calculates the area of each triangle
		 and puts it in a buffer so that each vertex can access it.
		 */
		public static function prepareMeshForWireframe( mesh:Mesh ):void {
			// Make sure vertices are colored as RGB.
			// TODO.

			// Compute areas.
			var i:uint, index:uint;
			var loop:uint = mesh.rawPositionsBuffer.length / 3 - 3;
			mesh.rawExtraBuffer0 = new Vector.<Number>();
			var _p0:Vector3D, _p1:Vector3D, _p2:Vector3D, _v0:Vector3D, _v1:Vector3D, _v2:Vector3D, _cross:Vector3D;
			var area:Number, rf:Number, gf:Number, bf:Number;
			for( i = 0; i <= loop; i += 3 ) {
				index = i * 3;
				_p0 = new Vector3D( mesh.rawPositionsBuffer[index + 0], mesh.rawPositionsBuffer[index + 1], mesh.rawPositionsBuffer[index + 2] );
				_p1 = new Vector3D( mesh.rawPositionsBuffer[index + 3], mesh.rawPositionsBuffer[index + 4], mesh.rawPositionsBuffer[index + 5] );
				_p2 = new Vector3D( mesh.rawPositionsBuffer[index + 6], mesh.rawPositionsBuffer[index + 7], mesh.rawPositionsBuffer[index + 8] );
				_v0 = _p2.subtract( _p1 );
				_v1 = _p2.subtract( _p0 );
				_v2 = _p1.subtract( _p0 );
				_cross = _v2.crossProduct( _v1 );
				area = Math.abs( _cross.length ) / 2;
				rf = area / _v0.length;
				gf = area / _v1.length;
				bf = area / _v2.length;
				mesh.rawExtraBuffer0.push( rf, 1.0, 1.0,   1.0, gf, 1.0,   1.0, 1.0, bf );
			}
		}
	}
}
