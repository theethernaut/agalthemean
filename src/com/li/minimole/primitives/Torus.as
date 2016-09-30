package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.utils.Vector3dUtils;
	import com.li.minimole.materials.MaterialBase;

	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Torus extends Mesh
	{
		private var _index:uint;

		public function Torus( material:MaterialBase, radius:Number = 1, tube:Number = 0.4, segmentsR:uint = 64, segmentsT:Number = 48 ) {
			super( material );

			var i:int;
			var j:int;

			var grid:Array = new Array( segmentsR );
			for( i = 0; i < segmentsR; ++i ) {
				grid[i] = new Array( segmentsT );
				for( j = 0; j < segmentsT; ++j ) {
					var u:Number = i / segmentsR * 2 * Math.PI;
					var v:Number = j / segmentsT * 2 * Math.PI;
					grid[i][j] = new Vector3D( (radius + tube * Math.cos( v )) * Math.cos( u ), tube * Math.sin( v ), (radius + tube * Math.cos( v )) * Math.sin( u ) );
				}
			}

			for( i = 0; i < segmentsR; ++i ) {
				for( j = 0; j < segmentsT; ++j ) {
					var ip:int = (i + 1) % segmentsR;
					var jp:int = (j + 1) % segmentsT;
					var a:Vector3D = grid[i ][j];
					var b:Vector3D = grid[ip][j];
					var c:Vector3D = grid[i ][jp];
					var d:Vector3D = grid[ip][jp];

					var uva:Point = new Point( i / segmentsR, j / segmentsT );
					var uvb:Point = new Point( (i + 1) / segmentsR, j / segmentsT );
					var uvc:Point = new Point( i / segmentsR, (j + 1) / segmentsT );
					var uvd:Point = new Point( (i + 1) / segmentsR, (j + 1) / segmentsT );

					createFace( a, b, c, uva, uvb, uvc );
					createFace( d, c, b, uvd, uvc, uvb );
				}
			}
		}

		private function createFace( v0:Vector3D, v1:Vector3D, v2:Vector3D, uv0:Point = null, uv1:Point = null, uv2:Point = null ):void {
			_rawPositionsBuffer.push( v0.x, v0.y, v0.z );
			_rawPositionsBuffer.push( v1.x, v1.y, v1.z );
			_rawPositionsBuffer.push( v2.x, v2.y, v2.z );

			var normal:Vector3D = Vector3dUtils.get3PointNormal( v0, v1, v2 );
			normal.negate();
			_rawNormalsBuffer.push( normal.x, normal.y, normal.z );
			_rawNormalsBuffer.push( normal.x, normal.y, normal.z );
			_rawNormalsBuffer.push( normal.x, normal.y, normal.z );

			_rawIndexBuffer.push( _index + 2, _index + 1, _index + 0 );
			_index += 3;

			_rawUvBuffer.push( uv0.x, uv0.y );
			_rawUvBuffer.push( uv1.x, uv1.y );
			_rawUvBuffer.push( uv2.x, uv2.y );
		}
	}
}
