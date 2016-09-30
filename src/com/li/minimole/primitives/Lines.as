package com.li.minimole.primitives
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.pb3d.PB3DMaterialBase;

	import flash.geom.Vector3D;

	public class Lines extends Mesh
	{
		private var _indexOffset:uint;

		public function Lines( material:PB3DMaterialBase ) {
			super( material );

			// Geometry needs to be created using createLine().
			// Will cause errors if createLine() is not called at least once.
		}

		public function createLine( start:Vector3D, end:Vector3D ):void {
			// Logic:
			// A line is represented by 4 vertices ABCD, AB matching in 3D position and CD matching in 3D position.
			// The vertex shader will pass these to clip space.
			// The vertex shader will spread A and B apart from the direction of the line, as well as C and D.
			// How much they are spread apart depends on line thickness and camera distance.
			// The result is 2 triangles forming a quad, which will contain a solid fill, always face the camera
			// and composite the line.
			// Line thickness will be controlled by a LineMaterial.

			// Create 4 vertices.
			// A and B correspond to start position, C and D correspond to end position.
			_rawPositionsBuffer.push( start.x, start.y, start.z );
			_rawPositionsBuffer.push( start.x, start.y, start.z );
			_rawPositionsBuffer.push( end.x, end.y, end.z );
			_rawPositionsBuffer.push( end.x, end.y, end.z );

			// Extra data 0 will provide each vertex knowledge of the opposite end of the line.
			_rawExtraBuffer0.push( end.x, end.y, end.z );
			_rawExtraBuffer0.push( end.x, end.y, end.z );
			_rawExtraBuffer0.push( start.x, start.y, start.z );
			_rawExtraBuffer0.push( start.x, start.y, start.z );

			// Extra data 1 will provide info on the direction on which to offset each vertex.
			_rawExtraBuffer1.push( 1, 0, 0 );
			_rawExtraBuffer1.push( -1, 0, 0 );
			_rawExtraBuffer1.push( -1, 0, 0 );
			_rawExtraBuffer1.push( 1, 0, 0 );

			// Color data for tracing.
			_rawColorsBuffer.push( 1, 0, 0 );
			_rawColorsBuffer.push( 0, 1, 0 );
			_rawColorsBuffer.push( 0, 0, 1 );
			_rawColorsBuffer.push( 1, 1, 1 );

			// Indices.
			_rawIndexBuffer.push( _indexOffset + 0, _indexOffset + 1, _indexOffset + 2 );
			_rawIndexBuffer.push( _indexOffset + 1, _indexOffset + 3, _indexOffset + 2 );
			_indexOffset += 4;
		}

		public function modifyLine( lineIndex:uint, start:Vector3D = null, end:Vector3D = null ):void {
			var vertexIndex:uint = lineIndex * 3 * 4;

			if( start ) {
				_rawPositionsBuffer[vertexIndex] = start.x; // A.
				_rawPositionsBuffer[vertexIndex + 1] = start.y;
				_rawPositionsBuffer[vertexIndex + 2] = start.z;
				_rawPositionsBuffer[vertexIndex + 3] = start.x; // B.
				_rawPositionsBuffer[vertexIndex + 4] = start.y;
				_rawPositionsBuffer[vertexIndex + 5] = start.z;

				_rawExtraBuffer0[vertexIndex + 6] = start.x; // C.
				_rawExtraBuffer0[vertexIndex + 7] = start.y;
				_rawExtraBuffer0[vertexIndex + 8] = start.z;
				_rawExtraBuffer0[vertexIndex + 9] = start.x; // D.
				_rawExtraBuffer0[vertexIndex + 10] = start.y;
				_rawExtraBuffer0[vertexIndex + 11] = start.z;
			}

			if( end ) {
				_rawPositionsBuffer[vertexIndex + 6] = end.x; // C.
				_rawPositionsBuffer[vertexIndex + 7] = end.y;
				_rawPositionsBuffer[vertexIndex + 8] = end.z;
				_rawPositionsBuffer[vertexIndex + 9] = end.x; // D.
				_rawPositionsBuffer[vertexIndex + 10] = end.y;
				_rawPositionsBuffer[vertexIndex + 11] = end.z;

				_rawExtraBuffer0[vertexIndex] = end.x; // A.
				_rawExtraBuffer0[vertexIndex + 1] = end.y;
				_rawExtraBuffer0[vertexIndex + 2] = end.z;
				_rawExtraBuffer0[vertexIndex + 3] = end.x; // B.
				_rawExtraBuffer0[vertexIndex + 4] = end.y;
				_rawExtraBuffer0[vertexIndex + 5] = end.z;
			}

			if( (start || end) && _context3d ) {
				updatePositionsBuffer();
				updateExtraBuffer0();
			}
		}
	}
}
