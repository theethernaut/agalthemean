package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	public class Plane extends Mesh
	{
		public function Plane( material:MaterialBase, width:Number = 1, height:Number = 1 ) {
			super( material );

			// Build vertices.
			var halfW:Number = width / 2;
			var halfH:Number = height / 2;
			_rawPositionsBuffer.push( -halfW, -halfH, 0 ); // 0 -  left  bottom front
			_rawPositionsBuffer.push( halfW, -halfH, 0 ); // 1 -  right bottom front
			_rawPositionsBuffer.push( halfW, halfH, 0 ); // 2 -  right top    front
			_rawPositionsBuffer.push( -halfW, halfH, 0 ); // 3 -  left  top    front

			// Build uvs.
			_rawUvBuffer.push( 0, 1 );
			_rawUvBuffer.push( 1, 1 );
			_rawUvBuffer.push( 1, 0 );
			_rawUvBuffer.push( 0, 0 );

			// Build normals.
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );
			_rawNormalsBuffer.push( 0, 0, -1 );

			// Build indices.
			_rawIndexBuffer.push( 0, 2, 1, 0, 3, 2 ); // Front.
		}
	}
}
