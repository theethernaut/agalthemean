package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	public class Triangle extends Mesh
	{
		public function Triangle( material:MaterialBase ) {
			super( material );

			// Build vertices.
			_rawPositionsBuffer.push( -0.5, 0.5, 0 );
			_rawPositionsBuffer.push( 0, -0.5, 0 );
			_rawPositionsBuffer.push( 0.5, 0.5, 0 );

			// Build uvs.
			_rawUvBuffer.push( 0, 0 );
			_rawUvBuffer.push( 0.5, 1 );
			_rawUvBuffer.push( 1, 0 );

			// Build indexes.
			_rawIndexBuffer.push( 0, 1, 2 );
		}
	}
}
