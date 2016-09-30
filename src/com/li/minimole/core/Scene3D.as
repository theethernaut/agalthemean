package com.li.minimole.core
{

	import com.li.minimole.lights.PointLight;

	import flash.display3D.Context3D;

	/*
	 Contains drawable children.
	 */
	public class Scene3D
	{
		private var _children:Vector.<Mesh>;
		private var _context3d:Context3D;
		private var _numChildren:uint;
		private var _light:PointLight;

		public function Scene3D() {
			_children = new Vector.<Mesh>();
			_light = new PointLight();
			_light.z = -10;
		}

		public function set context3d( context3d:Context3D ):void {
			_context3d = context3d;

			// Make sure all children have
			// a reference to context3d.
			for( var i:uint = 0; i < _numChildren; ++i )
				_children[i].context3d = _context3d;
		}

		public function get numChildren():uint {
			return _numChildren;
		}

		public function addChild( child:Mesh ):void {
			_children.push( child );
			_numChildren++;

			if( _context3d )
				child.context3d = _context3d;
		}

		public function removeChild( child:Mesh ):void {

			_children.splice( _children.indexOf( child ), 1 );
			_numChildren--;
		}

		public function getChildAt( index:uint ):Mesh {
			return _children[index];
		}

		public function get light():PointLight {
			return _light;
		}

		public function set light( value:PointLight ):void {
			_light = value;
		}
	}
}
