package com.li.minimole.materials.pb3d
{

	import com.adobe.pixelBender3D.*;
	import com.adobe.pixelBender3D.utils.*;
	import com.li.minimole.materials.MaterialBase;

	import flash.utils.ByteArray;

	/*
	 Base class for single shader materials.
	 */
	public class PB3DMaterialBase extends MaterialBase
	{
		protected var _vertexRegisterMap:RegisterMap;
		protected var _fragmentRegisterMap:RegisterMap;
		protected var _parameterBufferHelper:ProgramConstantsHelper;

		public function PB3DMaterialBase()
		{
		}

		protected function initPB3D( VertexClass:Class, MaterialClass:Class, FragmentClass:Class ):void
		{
			// Build program.
			_program3d = _context3d.createProgram();
			var vertexProgram:PBASMProgram = new PBASMProgram( readPBASMClass( VertexClass ) );
			var materialProgram:PBASMProgram = new PBASMProgram( readPBASMClass( MaterialClass ) );
			var fragmentProgram:PBASMProgram = new PBASMProgram( readPBASMClass( FragmentClass ) );
			var programs:AGALProgramPair = PBASMCompiler.compile( vertexProgram, materialProgram, fragmentProgram );

			// Set up param utils.
			_vertexRegisterMap = programs.vertexProgram.registers;
			_fragmentRegisterMap = programs.fragmentProgram.registers;
			_parameterBufferHelper = new ProgramConstantsHelper( _context3d, _vertexRegisterMap, _fragmentRegisterMap );

			// build shader.
			_program3d.upload( programs.vertexProgram.byteCode, programs.fragmentProgram.byteCode );

			// Report build.
			_programBuilt = true;
		}

		private function readPBASMClass( f:Class ):String
		{
			var bytes:ByteArray = new f();
			return bytes.readUTFBytes( bytes.bytesAvailable );
		}
	}
}
