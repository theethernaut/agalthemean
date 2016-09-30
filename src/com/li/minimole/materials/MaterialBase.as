package com.li.minimole.materials
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.debugging.errors.AbstractMethodCalledError;
	import com.li.minimole.lights.PointLight;

	import flash.display3D.Context3D;
	import flash.display3D.Program3D;

	public class MaterialBase
	{
		public var transparent:Boolean = false;
		public var bothsides:Boolean = false;
		public var textureBased:Boolean = false;

		protected var _context3d:Context3D;
		protected var _program3d:Program3D;
		protected var _programBuilt:Boolean;
		protected var _isProgramValid:Boolean;

		public function MaterialBase()
		{
			_isProgramValid = true;
		}

		public function set context3d( context3d:Context3D ):void
		{
			_context3d = context3d;

			if( !_programBuilt )
				buildProgram3d();
		}

		public function get context3d():Context3D
		{
			return _context3d;
		}

		protected function buildProgram3d():void
		{
			throw new AbstractMethodCalledError();
		}

		public function drawMesh( mesh:Mesh, light:PointLight ):void
		{
			throw new AbstractMethodCalledError();
		}

		public function deactivate():void
		{
			throw new AbstractMethodCalledError();
		}
	}
}
