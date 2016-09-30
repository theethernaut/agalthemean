package com.li.minimole.parsers
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.debugging.logging.Log;
	import com.li.minimole.materials.MaterialBase;
	import com.li.minimole.materials.pb3d.PB3DMaterialBase;

	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

// TODO: Shares vertices? I think not.
	public class ObjParser extends Mesh
	{
		private const LINE_FEED:String = String.fromCharCode( 10 );
		private const SPACE:String = String.fromCharCode( 32 );
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX_DATA:String = "f";

		private var _vertices:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _scale:Number;
		private var _faceIndex:uint;

		public function ObjParser( data:*, material:MaterialBase, scale:Number = 1 ) {
			super( material );

			_scale = scale;

//        trace("Parsing obj file. ------------------------------------");

			// Get data as string.
			var bytes:ByteArray;
			if( data is Class ) {
				var clazz:Class = data as Class;
				bytes = new clazz();
			}
			else {
				bytes = data as ByteArray;
			}
			var definition:String = bytes.readUTFBytes( bytes.bytesAvailable );

			// Init raw data containers.
			// NOTE: These are "rawer" than Mesh raw data containers.
			_vertices = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_uvs = new Vector.<Number>();

			// Split data in to lines and parse all lines.
			var lines:Array = definition.split( LINE_FEED );
//        trace("num lines: " + lines.length);
			try {
				var loop:uint = lines.length;
				for( var i:uint = 0; i < loop; ++i )
					parseLine( lines[i] );
			} catch( e:Error ) {
				Log.error( e.message );
			}

//        trace("num verts: " + _vertices.length/3);
//        trace("num norms: " + _normals.length/3);
//        trace("num uvs: " + _uvs.length/2);
		}

		private function parseLine( line:String ):void {
			// Split line into words.
			var words:Array = line.split( SPACE );

			// Prepare the data of the line.
			if( words.length > 0 )
				var data:Array = words.slice( 1 );
			else
				return;

			// Check first word and delegate remainder to proper parser.
			var firstWord:String = words[0];
			if( firstWord == VERTEX )
				parseVertex( data );
			else if( firstWord == NORMAL )
				parseNormal( data );
			else if( firstWord == UV )
				parseUV( data );
			else if( firstWord == INDEX_DATA )
				parseIndex( data );
		}

		private function parseVertex( data:Array ):void {
			// Process elements.
			var loop:uint = data.length;
			for( var i:uint = 0; i < loop; ++i ) {
				var element:String = data[i];
				_vertices.push( Number( element ) * _scale );
			}
		}

		private function parseNormal( data:Array ):void {
			// Process elements.
			var loop:uint = data.length;
			for( var i:uint = 0; i < loop; ++i ) {
				var element:String = data[i];
				_normals.push( Number( element ) );
			}
		}

		private function parseUV( data:Array ):void {
			// Process elements.
			var loop:uint = data.length;
			for( var i:uint = 0; i < loop; ++i ) {
				var element:String = data[i];
				_uvs.push( Number( element ) );
			}
		}

		private function parseIndex( data:Array ):void {
			if( data.length == 4 ) {
				throw new Error( "ObjParser does not support quads. Please triangulate your mesh." );
			}

			// Process elements.
			var i:uint;
			var loop:uint = data.length;
			for( i = 0; i < loop; ++i ) {
				var triplet:String = data[i]; // elements come as vertexIndex/uvIndex/normalIndex
				var subdata:Array = triplet.split( SLASH );
				var vertexIndex:int = int( subdata[0] ) - 1;
				var uvIndex:int = int( subdata[1] ) - 1;
				var normalIndex:int = int( subdata[2] ) - 1;
				if( vertexIndex < 0 ) vertexIndex = 0;
				if( uvIndex < 0 ) uvIndex = 0;
				if( normalIndex < 0 ) normalIndex = 0;

				// Extract from parse raw data to mesh raw data.
				var index:uint;

				// Vertex.
				index = 3 * vertexIndex;
				addVertex( _vertices[index + 0], _vertices[index + 1], _vertices[index + 2] );

				// Color.
				addColor( i == 0 ? 1 : 0, i == 1 ? 1 : 0, i == 2 ? 1 : 0 );

				// Normal.
				index = 3 * normalIndex;
				addNormal( _normals[index + 0], _normals[index + 1], _normals[index + 2] );

				// Uv.
				index = 2 * uvIndex;
				addUv( 1 - _uvs[index + 0], 1 - _uvs[index + 1] );
			}

			// Index.
			_rawIndexBuffer.push( _faceIndex + 0, _faceIndex + 1, _faceIndex + 2 );
			_faceIndex += 3;
		}

		private function addColor( r:Number, g:Number, b:Number ):void {
			_rawColorsBuffer.push( r, g, b );
		}

		private function addVertex( x:Number, y:Number, z:Number ):void {
			_rawPositionsBuffer.push( x, y, z );
		}

		private function addNormal( x:Number, y:Number, z:Number ):void {
			_rawNormalsBuffer.push( x, y, z );
		}

		private function addUv( u:Number, v:Number ):void {
			_rawUvBuffer.push( u, v );
		}
	}
}
