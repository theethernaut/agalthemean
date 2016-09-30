package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	public class Sphere extends Mesh
	{
		public function Sphere( material:MaterialBase, radius:Number = 1, segmentsW:uint = 16, segmentsH:uint = 12 ) {
			super( material );

			var i:uint, j:uint, triIndex:uint;

			var numVerts:uint = 0;
			for( j = 0; j <= segmentsH; ++j ) {
				var horangle:Number = Math.PI * j / segmentsH;
				var z:Number = -radius * Math.cos( horangle );
				var ringradius:Number = radius * Math.sin( horangle );

				for( i = 0; i <= segmentsW; ++i ) {
					var verangle:Number = 2 * Math.PI * i / segmentsW;
					var x:Number = ringradius * Math.cos( verangle );
					var y:Number = ringradius * Math.sin( verangle );
					var normLen:Number = 1 / Math.sqrt( x * x + y * y + z * z );
					var tanLen:Number = Math.sqrt( y * y + x * x );

					_rawNormalsBuffer[numVerts] = x * normLen;
					_rawPositionsBuffer[numVerts++] = x;
					_rawNormalsBuffer[numVerts] = -z * normLen;
					_rawPositionsBuffer[numVerts++] = -z;
					_rawNormalsBuffer[numVerts] = y * normLen;
					_rawPositionsBuffer[numVerts++] = y;

					if( i > 0 && j > 0 ) {
						var a:int = (segmentsW + 1) * j + i;
						var b:int = (segmentsW + 1) * j + i - 1;
						var c:int = (segmentsW + 1) * (j - 1) + i - 1;
						var d:int = (segmentsW + 1) * (j - 1) + i;

						if( j == segmentsH ) {
							_rawIndexBuffer[triIndex++] = a;
							_rawIndexBuffer[triIndex++] = c;
							_rawIndexBuffer[triIndex++] = d;
						}
						else if( j == 1 ) {
							_rawIndexBuffer[triIndex++] = a;
							_rawIndexBuffer[triIndex++] = b;
							_rawIndexBuffer[triIndex++] = c;
						}
						else {
							_rawIndexBuffer[triIndex++] = a;
							_rawIndexBuffer[triIndex++] = b;
							_rawIndexBuffer[triIndex++] = c;
							_rawIndexBuffer[triIndex++] = a;
							_rawIndexBuffer[triIndex++] = c;
							_rawIndexBuffer[triIndex++] = d;
						}
					}
				}
			}

			var numUvs:uint = 0;
			for( j = 0; j <= segmentsH; ++j ) {
				for( i = 0; i <= segmentsW; ++i ) {
					_rawUvBuffer[numUvs++] = i / segmentsW;
					_rawUvBuffer[numUvs++] = j / segmentsH;
				}
			}
		}
	}
}
