package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	/*
	 Basic cube with 24 vertices (does not share vertices between sides).
	 */
	public class CubeR extends Mesh
	{
		public function CubeR( material:MaterialBase, width:Number = 1, height:Number = 1, depth:Number = 1 ) {
			super( material );

			// Build vertices.
			var halfW:Number = width / 2;
			var halfH:Number = height / 2;
			var halfD:Number = depth / 2;
			_rawPositionsBuffer.push( -halfW, -halfH, -halfD ); // 0 -  left  bottom front // 0
			_rawPositionsBuffer.push( halfW, -halfH, -halfD ); // 1 -  right bottom front
			_rawPositionsBuffer.push( halfW, halfH, -halfD ); // 2 -  right top    front
			_rawPositionsBuffer.push( -halfW, halfH, -halfD ); // 3 -  left  top    front
			_rawPositionsBuffer.push( -halfW, -halfH, halfD ); // 4 -  left  bottom back
			_rawPositionsBuffer.push( halfW, -halfH, halfD ); // 5 -  right bottom back
			_rawPositionsBuffer.push( halfW, halfH, halfD ); // 6 -  right top    back
			_rawPositionsBuffer.push( -halfW, halfH, halfD ); // 7 -  left  top    back
			_rawPositionsBuffer.push( -halfW, -halfH, -halfD ); // 0 -  left  bottom front // + 8
			_rawPositionsBuffer.push( halfW, -halfH, -halfD ); // 1 -  right bottom front
			_rawPositionsBuffer.push( halfW, halfH, -halfD ); // 2 -  right top    front
			_rawPositionsBuffer.push( -halfW, halfH, -halfD ); // 3 -  left  top    front
			_rawPositionsBuffer.push( -halfW, -halfH, halfD ); // 4 -  left  bottom back
			_rawPositionsBuffer.push( halfW, -halfH, halfD ); // 5 -  right bottom back
			_rawPositionsBuffer.push( halfW, halfH, halfD ); // 6 -  right top    back
			_rawPositionsBuffer.push( -halfW, halfH, halfD ); // 7 -  left  top    back
			_rawPositionsBuffer.push( -halfW, -halfH, -halfD ); // 0 -  left  bottom front // + 16
			_rawPositionsBuffer.push( halfW, -halfH, -halfD ); // 1 -  right bottom front
			_rawPositionsBuffer.push( halfW, halfH, -halfD ); // 2 -  right top    front
			_rawPositionsBuffer.push( -halfW, halfH, -halfD ); // 3 -  left  top    front
			_rawPositionsBuffer.push( -halfW, -halfH, halfD ); // 4 -  left  bottom back
			_rawPositionsBuffer.push( halfW, -halfH, halfD ); // 5 -  right bottom back
			_rawPositionsBuffer.push( halfW, halfH, halfD ); // 6 -  right top    back
			_rawPositionsBuffer.push( -halfW, halfH, halfD ); // 7 -  left  top    back

			// Build uvs.
			_rawUvBuffer.push( 0, 1, 1, 1, 1, 0, 0, 0 ); // front 4 for front side
			_rawUvBuffer.push( 1, 1, 0, 1, 0, 0, 1, 0 ); // back 4 for back side
			_rawUvBuffer.push( 1, 1, 0, 1, 0, 0, 1, 0 ); // front 4 for left/right
			_rawUvBuffer.push( 0, 1, 1, 1, 1, 0, 0, 0 ); // back 4 for left/right
			_rawUvBuffer.push( 0, 0, 1, 0, 1, 1, 0, 1 ); // front 4 for top/bottom
			_rawUvBuffer.push( 0, 1, 1, 1, 1, 0, 0, 0 ); // back 4 for top/bottom

			// Build normals.
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, 1 );
			_rawNormalsBuffer.push( 0, 0, 1 );
			_rawNormalsBuffer.push( 0, 0, 1 );
			_rawNormalsBuffer.push( 0, 0, 1 );

			_rawNormalsBuffer.push( -1, 0, 0 );
			_rawNormalsBuffer.push( 1, 0, 0 );
			_rawNormalsBuffer.push( 1, 0, 0 );
			_rawNormalsBuffer.push( -1, 0, 0 );
			_rawNormalsBuffer.push( -1, 0, 0 );
			_rawNormalsBuffer.push( 1, 0, 0 );
			_rawNormalsBuffer.push( 1, 0, 0 );
			_rawNormalsBuffer.push( -1, 0, 0 );

			_rawNormalsBuffer.push( 0, -1, 0 );
			_rawNormalsBuffer.push( 0, -1, 0 );
			_rawNormalsBuffer.push( 0, 1, 0 );
			_rawNormalsBuffer.push( 0, 1, 0 );
			_rawNormalsBuffer.push( 0, -1, 0 );
			_rawNormalsBuffer.push( 0, -1, 0 );
			_rawNormalsBuffer.push( 0, 1, 0 );
			_rawNormalsBuffer.push( 0, 1, 0 );

			// Build indices.
			_rawIndexBuffer.push( 0, 2, 1, 0, 3, 2 ); // Front.
			_rawIndexBuffer.push( 5, 7, 4, 5, 6, 7 ); // Back.
			var off:uint = 8;
			_rawIndexBuffer.push( off + 1, off + 6, off + 5, off + 1, off + 2, off + 6 ); // Right.
			_rawIndexBuffer.push( off + 4, off + 3, off + 0, off + 4, off + 7, off + 3 ); // Left.
			off = 16;
			_rawIndexBuffer.push( off + 3, off + 6, off + 2, off + 3, off + 7, off + 6 ); // Top.
			_rawIndexBuffer.push( off + 4, off + 1, off + 5, off + 4, off + 0, off + 1 ); // Bottom.
		}
	}
}
