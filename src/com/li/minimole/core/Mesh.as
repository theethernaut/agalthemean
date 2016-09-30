package com.li.minimole.core
{

	import com.li.minimole.core.math.AABB;
	import com.li.minimole.core.utils.Vector3dUtils;
	import com.li.minimole.debugging.errors.RawBufferEmptyError;
	import com.li.minimole.debugging.logging.Log;
	import com.li.minimole.materials.MaterialBase;
	import com.li.minimole.primitives.WireCube;

	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;

	/*
	 Wraps the vertex data of a 3D object.
	 */
	public class Mesh extends Object3D
	{
		protected var _rawIndexBuffer:Vector.<uint>;
		protected var _rawPositionsBuffer:Vector.<Number>; // x, y, z
		protected var _rawUvBuffer:Vector.<Number>; // u, v
		protected var _rawNormalsBuffer:Vector.<Number>; // nx, ny, nz
		protected var _rawColorsBuffer:Vector.<Number>; // r, g, b
		protected var _rawExtraBuffer0:Vector.<Number>;
		protected var _rawExtraBuffer1:Vector.<Number>;

		protected var _indexBuffer:IndexBuffer3D;
		protected var _positionsBuffer:VertexBuffer3D;
		protected var _uvBuffer:VertexBuffer3D;
		protected var _normalsBuffer:VertexBuffer3D;
		protected var _colorsBuffer:VertexBuffer3D;
		protected var _extraBuffer0:VertexBuffer3D;
		protected var _extraBuffer1:VertexBuffer3D;

		protected var _context3d:Context3D;
		private var _material:MaterialBase;

		private var _cachedRawNormalsBuffer:Vector.<Number>;

		public var visible:Boolean = true;

		public var showBoundingBox:Boolean = false;
		private var _boundingBoxWire:WireCube;

		private var _aabb:AABB;
		private var _boundsDirty:Boolean;

		public function Mesh( material:MaterialBase )
		{
			super();

			_material = material;

			_rawColorsBuffer = new Vector.<Number>();
			_rawIndexBuffer = new Vector.<uint>();
			_rawPositionsBuffer = new Vector.<Number>();
			_rawUvBuffer = new Vector.<Number>();
			_rawNormalsBuffer = new Vector.<Number>();
			_rawExtraBuffer0 = new Vector.<Number>();
			_rawExtraBuffer1 = new Vector.<Number>();

			_aabb = new AABB();
		}

		public function get boundingBoxWire():WireCube
		{
			if( !_boundingBoxWire )
			{
				_boundingBoxWire = new WireCube();
				_boundingBoxWire.context3d = _context3d;
			}

			updateBounds();

			return _boundingBoxWire;
		}

		public function clone():Mesh
		{
			var clone:Mesh = new Mesh( _material );
			clone.rawColorsBuffer = rawColorsBuffer.concat();
			clone.rawIndexBuffer = rawIndexBuffer.concat();
			clone.rawNormalsBuffer = rawNormalsBuffer.concat();
			clone.rawPositionsBuffer = rawPositionsBuffer.concat();
			clone.rawUvBuffer = rawUvBuffer.concat();
			return clone;
		}

		public function get material():MaterialBase
		{
			return _material;
		}

		public function set material( value:MaterialBase ):void
		{
			if( _context3d && _material )
				_material.deactivate();

			_material = value;
			if( _context3d )
			{
				_material.context3d = _context3d;
			}
		}

		public function set context3d( context3d:Context3D ):void
		{
			_context3d = context3d;
			_material.context3d = _context3d;
		}

		public function get context3d():Context3D
		{
			return _context3d;
		}

		// ------------------------------------------------------------------
		// Get/set raw buffers.
		// ------------------------------------------------------------------

		public function get rawColorsBuffer():Vector.<Number>
		{
			return _rawColorsBuffer;
		}

		public function set rawColorsBuffer( value:Vector.<Number> ):void
		{
			_rawColorsBuffer = value;
		}

		public function get rawNormalsBuffer():Vector.<Number>
		{
			return _rawNormalsBuffer;
		}

		public function set rawNormalsBuffer( value:Vector.<Number> ):void
		{
			_rawNormalsBuffer = value;
		}

		public function get rawUvBuffer():Vector.<Number>
		{
			return _rawUvBuffer;
		}

		public function set rawUvBuffer( value:Vector.<Number> ):void
		{
			_rawUvBuffer = value;
		}

		public function get rawPositionsBuffer():Vector.<Number>
		{
			return _rawPositionsBuffer;
		}

		public function set rawPositionsBuffer( value:Vector.<Number> ):void
		{
			_rawPositionsBuffer = value;
			_boundsDirty = true;
		}

		public function get rawIndexBuffer():Vector.<uint>
		{
			return _rawIndexBuffer;
		}

		public function set rawIndexBuffer( value:Vector.<uint> ):void
		{
			_rawIndexBuffer = value;
		}

		public function get rawExtraBuffer0():Vector.<Number>
		{
			return _rawExtraBuffer0;
		}

		public function set rawExtraBuffer0( value:Vector.<Number> ):void
		{
			_rawExtraBuffer0 = value;
		}

		public function get rawExtraBuffer1():Vector.<Number>
		{
			return _rawExtraBuffer1;
		}

		public function set rawExtraBuffer1( value:Vector.<Number> ):void
		{
			_rawExtraBuffer1 = value;
		}

		// ------------------------------------------------------------------
		// Get real buffers.
		// ------------------------------------------------------------------

		public function get colorsBuffer():VertexBuffer3D
		{
			if( !_colorsBuffer )
				updateColorsBuffer();

			return _colorsBuffer;
		}

		public function get positionsBuffer():VertexBuffer3D
		{
			if( !_positionsBuffer )
				updatePositionsBuffer();

			return _positionsBuffer;
		}

		public function get indexBuffer():IndexBuffer3D
		{
			if( !_indexBuffer )
				updateIndexBuffer();

			return _indexBuffer;
		}

		public function get uvBuffer():VertexBuffer3D
		{
			if( !_uvBuffer )
				updateUvBuffer();

			return _uvBuffer;
		}

		public function get normalsBuffer():VertexBuffer3D
		{
			if( !_normalsBuffer )
				updateNormalsBuffer();

			return _normalsBuffer;
		}

		public function get extraBuffer0():VertexBuffer3D
		{
			if( !_extraBuffer0 )
				updateExtraBuffer0();

			return _extraBuffer0;
		}

		public function get extraBuffer0Initialized():Boolean {
			return _extraBuffer0 != null;
		}

		public function get extraBuffer1():VertexBuffer3D
		{
			if( !_extraBuffer1 )
				updateExtraBuffer1();

			return _extraBuffer1;
		}

		public function get extraBuffer1Initialized():Boolean {
			return _extraBuffer1 != null;
		}

		// ------------------------------------------------------------------
		// RAW buffers -> REAL buffers.
		// ------------------------------------------------------------------

		public function updateExtraBuffer0():void
		{
			if( _rawExtraBuffer0.length == 0 )
				throw new RawBufferEmptyError();

			var nCount:uint = _rawExtraBuffer0.length / 3;
			try {
				_extraBuffer0 = _context3d.createVertexBuffer( nCount, 3 );
				_extraBuffer0.uploadFromVector( _rawExtraBuffer0, 0, nCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updateExtraBuffer1():void
		{
			if( _rawExtraBuffer1.length == 0 )
				throw new RawBufferEmptyError();

			var nCount:uint = _rawExtraBuffer1.length / 3;
			try {
				_extraBuffer1 = _context3d.createVertexBuffer( nCount, 3 );
				_extraBuffer1.uploadFromVector( _rawExtraBuffer1, 0, nCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updateColorsBuffer():void
		{
			if( _rawColorsBuffer.length == 0 )
				throw new RawBufferEmptyError();

			var colorsCount:uint = _rawColorsBuffer.length / 3;
			try {
				_colorsBuffer = _context3d.createVertexBuffer( colorsCount, 3 );
				_colorsBuffer.uploadFromVector( _rawColorsBuffer, 0, colorsCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updateNormalsBuffer():void
		{
			if( _rawNormalsBuffer.length == 0 )
				throw new RawBufferEmptyError();

			var normalsCount:uint = _rawNormalsBuffer.length / 3;
			try {
				_normalsBuffer = _context3d.createVertexBuffer( normalsCount, 3 );
				_normalsBuffer.uploadFromVector( _rawNormalsBuffer, 0, normalsCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updatePositionsBuffer():void
		{
			if( _rawPositionsBuffer.length == 0 )
				throw new RawBufferEmptyError();

			if( _boundsDirty )
				updateBounds();

			var vertexCount:uint = _rawPositionsBuffer.length / 3;

			try {
				_positionsBuffer = _context3d.createVertexBuffer( vertexCount, 3 );
				_positionsBuffer.uploadFromVector( _rawPositionsBuffer, 0, vertexCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updateUvBuffer():void
		{
			if( _rawUvBuffer.length == 0 )
				throw new RawBufferEmptyError();

			var uvsCount:uint = _rawUvBuffer.length / 2;
			try {
				_uvBuffer = _context3d.createVertexBuffer( uvsCount, 2 );
				_uvBuffer.uploadFromVector( _rawUvBuffer, 0, uvsCount );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		public function updateIndexBuffer():void
		{
			if( _rawIndexBuffer.length == 0 )
				throw new RawBufferEmptyError();

			try {
				_indexBuffer = _context3d.createIndexBuffer( _rawIndexBuffer.length );
				_indexBuffer.uploadFromVector( _rawIndexBuffer, 0, _rawIndexBuffer.length );
			} catch( e:Error ) {
				Log.error(e.message);
			}
		}

		// ------------------------------------------------------------------
		// Utils.
		// ------------------------------------------------------------------

		public function updateBounds():void
		{
			_aabb.updateFromPositions( _rawPositionsBuffer, transform );

			if( _boundingBoxWire )
			{
				_boundingBoxWire.lbf = new Vector3D( _aabb.minX, _aabb.minY, _aabb.minZ );
				_boundingBoxWire.rbf = new Vector3D( _aabb.maxX, _aabb.minY, _aabb.minZ );
				_boundingBoxWire.rtf = new Vector3D( _aabb.maxX, _aabb.maxY, _aabb.minZ );
				_boundingBoxWire.ltf = new Vector3D( _aabb.minX, _aabb.maxY, _aabb.minZ );
				_boundingBoxWire.lbb = new Vector3D( _aabb.minX, _aabb.minY, _aabb.maxZ );
				_boundingBoxWire.rbb = new Vector3D( _aabb.maxX, _aabb.minY, _aabb.maxZ );
				_boundingBoxWire.rtb = new Vector3D( _aabb.maxX, _aabb.maxY, _aabb.maxZ );
				_boundingBoxWire.ltb = new Vector3D( _aabb.minX, _aabb.maxY, _aabb.maxZ );
			}

			_boundsDirty = false;
		}

		public function restoreNormals():void
		{
			_rawNormalsBuffer = _cachedRawNormalsBuffer.concat();
		}

		public function forceVertexNormalsToTriangleNormals():void
		{
			_cachedRawNormalsBuffer = _rawNormalsBuffer.concat();

			var i:uint, index:uint;

			// Translate vertices to vector3d array.
			var loop:uint = _rawPositionsBuffer.length / 3;
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			var vertex:Vector3D;
			for( i = 0; i < loop; ++i )
			{
				index = 3 * i;
				vertex = new Vector3D( _rawPositionsBuffer[index], _rawPositionsBuffer[index + 1], _rawPositionsBuffer[index + 2] );
				vertices.push( vertex );
			}

			// Calculate normals.
			loop = vertices.length;
			var p0:Vector3D, p1:Vector3D, p2:Vector3D, normal:Vector3D;
			_rawNormalsBuffer = new Vector.<Number>();
			for( i = 0; i < loop; i += 3 )
			{
				p0 = vertices[i];
				p1 = vertices[i + 1];
				p2 = vertices[i + 2];
				normal = Vector3dUtils.get3PointNormal( p0, p1, p2 );
				_rawNormalsBuffer.push( normal.x, normal.y, normal.z );
				_rawNormalsBuffer.push( normal.x, normal.y, normal.z );
				_rawNormalsBuffer.push( normal.x, normal.y, normal.z );
			}
		}

		public function get aabb():AABB {
			_aabb.updateFromPositions( _rawPositionsBuffer, transform );
			return _aabb;
		}
	}
}
