package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	/*
	 Basic cube primitive with 8 vertices (shares vertices between sides).
	 */
	public class Cube extends Mesh
	{
		public function Cube( material:MaterialBase, width:Number = 1, height:Number = 1, depth:Number = 1 ) {
			super( material );

			// Build vertices.
			var halfW:Number = width / 2;
			var halfH:Number = height / 2;
			var halfD:Number = depth / 2;
			_rawPositionsBuffer.push( -halfW, -halfH, -halfD ); // 0 -  left  bottom front
			_rawPositionsBuffer.push( halfW, -halfH, -halfD ); // 1 -  right bottom front
			_rawPositionsBuffer.push( halfW, halfH, -halfD ); // 2 -  right top    front
			_rawPositionsBuffer.push( -halfW, halfH, -halfD ); // 3 -  left  top    front
			_rawPositionsBuffer.push( -halfW, -halfH, halfD ); // 4 -  left  bottom back
			_rawPositionsBuffer.push( halfW, -halfH, halfD ); // 5 -  right bottom back
			_rawPositionsBuffer.push( halfW, halfH, halfD ); // 6 -  right top    back
			_rawPositionsBuffer.push( -halfW, halfH, halfD ); // 7 -  left  top    back

			// Build uvs.
			_rawUvBuffer.push( 0, 1 );
			_rawUvBuffer.push( 1, 1 );
			_rawUvBuffer.push( 1, 0 );
			_rawUvBuffer.push( 0, 0 );
			_rawUvBuffer.push( 0, 0 );
			_rawUvBuffer.push( 1, 0 );
			_rawUvBuffer.push( 1, 1 );
			_rawUvBuffer.push( 0, 1 );

			// Build indices.
			_rawIndexBuffer.push( 0, 2, 1, 0, 3, 2 ); // Front.
			_rawIndexBuffer.push( 5, 7, 4, 5, 6, 7 ); // Back.
			_rawIndexBuffer.push( 1, 6, 5, 1, 2, 6 ); // Right.
			_rawIndexBuffer.push( 4, 3, 0, 4, 7, 3 ); // Left.
			_rawIndexBuffer.push( 3, 6, 2, 3, 7, 6 ); // Top.
			_rawIndexBuffer.push( 4, 1, 5, 4, 0, 1 ); // Bottom.
		}
	}
}
