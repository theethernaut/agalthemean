package com.li.minimole.materials.agal
{

	import com.adobe.utils.AGALMiniAssembler;
	import com.li.minimole.core.Core3D;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.utils.MeshUtils;
	import com.li.minimole.core.utils.TextureUtils;
	import com.li.minimole.debugging.logging.Log;
	import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.MaterialBase;
	import com.li.minimole.materials.agal.data.TextureMipMappingType;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.AGALRegister;
	import com.li.minimole.materials.agal.registers.temporaries.FragmentTemporary;
	import com.li.minimole.materials.agal.registers.temporaries.Temporary;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;
	import com.li.minimole.materials.agal.registers.constants.MatrixRegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;
	import com.li.minimole.materials.agal.registers.varyings.Varying;
	import com.li.minimole.materials.agal.registers.temporaries.VertexTemporary;

	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;

	// TODO: Upload all mip-levels for bitmaps

	public class AGALMaterial extends MaterialBase
	{
		protected var _vertexAGAL:String;
		protected var _fragmentAGAL:String;

		protected var _currentAGAL:String;

		private var _vertexConstants:Vector.<RegisterConstant>;
		private var _fragmentConstants:Vector.<RegisterConstant>;
		private var _vertexAttributes:Vector.<VertexAttribute>;
		private var _fragmentSamplers:Vector.<FragmentSampler>;
		private var _agalDirty:Boolean;
		private var _samplersDirty:Boolean;

		// -----------------------
		// AGAL utils
		// -----------------------

		private const C:String = ", ";

		// 1 term

		public function mov( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "mov " + target + C + source1 + end( comment );
		}

		public function nrm( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "nrm " + target + C + source1 + end( comment );
		}

		public function sat( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "sat " + target + C + source1 + end( comment );
		}

		public function neg( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "neg " + target + C + source1 + end( comment );
		}

		public function sqt( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "sqt " + target + C + source1 + end( comment );
		}

		public function exp( target:AGALRegister, source1:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "exp " + target + C + source1 + end( comment );
		}

		// 2 terms

		public function min( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "min " + target + C + source1 + C + source2 + end( comment );
		}

		public function pow( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "pow " + target + C + source1 + C + source2 + end( comment );
		}

		public function add( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "add " + target + C + source1 + C + source2 + end( comment );
		}

		public function mul( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "mul " + target + C + source1 + C + source2 + end( comment );
		}

		public function div( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "div " + target + C + source1 + C + source2 + end( comment );
		}

		public function m44( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "m44 " + target + C + source1 + C + source2 + end( comment );
		}

		public function sub( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "sub " + target + C + source1 + C + source2 + end( comment );
		}

		public function dp3( target:AGALRegister, source1:AGALRegister, source2:AGALRegister, comment:String = "" ):void {
			_currentAGAL += "dp3 " + target + C + source1 + C + source2 + end( comment );
		}

		public function tex( target:AGALRegister, source1:AGALRegister, source2:FragmentSampler, comment:String = "" ):void {
			_currentAGAL += "tex " + target + C + source1 + C + source2 + processSamplerFlags( source2 ) + end( comment );
		}

		// utils

		public function comment( msg:String ):void {
			_currentAGAL += end( msg );
		}

		private function processSamplerFlags( sampler:FragmentSampler ):String {
			var flagsStr:String = "<";
			var len:uint = sampler.flags.length;
			for( var i:uint; i < len; ++i ) {
				flagsStr += sampler.flags[ i ];
				if( i != len - 1 ) {
					flagsStr += ", ";
				}
			}
			flagsStr += ">";
			return flagsStr;
		}

		private function end( comment:String ):String {
			if( comment == "" ) {
				return "\n";
			}
			else {
				return " // " + comment + "\n";
			}
		}

		protected function get op():AGALRegister {
			var register:AGALRegister = new AGALRegister( "vertexOutput" );
			register.registerPrefix = "op";
			return register;
		}

		protected function get oc():AGALRegister {
			var register:AGALRegister = new AGALRegister( "vertexOutput" );
			register.registerPrefix = "oc";
			return register;
		}

		// -----------------------
		// Stage3D management
		// -----------------------

		private var _varyings:Vector.<Varying>;
		private var _vertTemps:Vector.<VertexTemporary>;
		private var _fragTemps:Vector.<FragmentTemporary>;

		public function addVarying( varying:Varying ):Varying {
			varying.registerIndex = _varyings.length;
			_varyings.push( varying );
			return varying;
		}

		public function addTemporary( temp:Temporary ):Temporary {

			if( temp is VertexTemporary ) {
				temp.registerIndex = _vertTemps.length;
				_vertTemps.push( temp );
			}
			else {
				temp.registerIndex = _fragTemps.length;
				_fragTemps.push( temp );
			}

			return temp;
		}

		public function releaseTemporary( temp:Temporary ):void { // TODO
			if( temp is VertexTemporary ) {
				_vertTemps.splice( temp.registerIndex, 1 );
			}
			else {
				_fragTemps.splice( temp.registerIndex, 1 );
			}
			temp = null;
		}

		public function AGALMaterial() {
			super();

			_fragmentConstants = new Vector.<RegisterConstant>();
			_vertexConstants = new Vector.<RegisterConstant>();
			_vertexAttributes = new Vector.<VertexAttribute>();
			_fragmentSamplers = new Vector.<FragmentSampler>();
			_varyings = new Vector.<Varying>();
			_vertTemps = new Vector.<VertexTemporary>();
			_fragTemps = new Vector.<FragmentTemporary>();

			_vertexAGAL = "";
			_fragmentAGAL = "";

			_agalDirty = true;
		}

		override protected function buildProgram3d():void {

			if( _agalDirty ) {
				buildAGALProgram( _vertexAGAL, _fragmentAGAL );
			}

		}

		override public function drawMesh( mesh:Mesh, light:PointLight ):void {

//			trace( "custom mat render ----------------------------------" );

			var i:uint, len:uint;
			var registerIndex:uint;
			var attribute:VertexAttribute;
			var sampler:FragmentSampler;
			var constant:RegisterConstant;
			var buffer:VertexBuffer3D;

			// update textures
			registerIndex = 0;
			len = _fragmentSamplers.length;
			for( i = 0; i < len; ++i ) {

				sampler = _fragmentSamplers[ i ];
				sampler.registerIndex = registerIndex;
				var textureValid:Boolean = true;

				if( sampler.value != null ) {
					if( sampler.texture == null || _samplersDirty ) {
						sampler.texture = _context3d.createTexture( sampler.value.width, sampler.value.height, Context3DTextureFormat.BGRA, false );
						if( sampler.flags.indexOf( TextureMipMappingType.MIP_NEAREST ) != -1 ) {
							TextureUtils.generateMipMaps( sampler.texture, sampler.value );
						}
						else
							sampler.texture.uploadFromBitmapData( sampler.value );
					}
				}
				else {
					textureValid = false;
				}

				if( textureValid ) {
					_context3d.setTextureAt( registerIndex, sampler.texture ); // TODO: need to set all the time if model/material wont change? same for va's...
					registerIndex++;
				}

				_samplersDirty = false;
			}

//			trace("textures ok");

			// update program
			if( _agalDirty ) {
				if( !buildAGALProgram( _vertexAGAL, _fragmentAGAL ) ) {
					return;
				}
				_agalDirty = false;
			}
			if( !_isProgramValid ) {
				return;
			}
			_context3d.setProgram( _program3d );

//			trace("program ok");

			// update vertex constants
			registerIndex = 0;
			len = _vertexConstants.length;
			for( i = 0; i < len; ++i ) {
				constant = _vertexConstants[ i ];
				constant.registerIndex = registerIndex;
				updateConstantMapping( constant, mesh );
				if( constant is VectorRegisterConstant ) {
					_context3d.setProgramConstantsFromVector( Context3DProgramType.VERTEX, registerIndex, constant.value );
					registerIndex++;
				}
				else if( constant is MatrixRegisterConstant ) {
					_context3d.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, registerIndex, constant.value, true );
					registerIndex += 4;
				}
				else {
					throw new Error( "Vertex constants of type " + constant + " are not yet supported." );
				}
			}

//			trace("vcN ok");

			// update fragment constants
			registerIndex = 0;
			len = _fragmentConstants.length;
			for( i = 0; i < len; ++i ) {
				constant = _fragmentConstants[ i ];
				constant.registerIndex = registerIndex;
				updateConstantMapping( constant, mesh );
				if( constant is VectorRegisterConstant ) {
					_context3d.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, registerIndex, constant.value );
					registerIndex++;
				}
				else {
					_context3d.setProgramConstantsFromMatrix( Context3DProgramType.FRAGMENT, registerIndex, constant.value, true );
					registerIndex += 4;
				}
			}

//			trace( "fcN ok" );

			// update vertex attributes
			registerIndex = 0;
			len = _vertexAttributes.length;
			for( i = 0; i < len; ++i ) {
				attribute = _vertexAttributes[ i ];
				attribute.registerIndex = registerIndex;
				if( attribute.value == VertexAttribute.POSITIONS ) buffer = mesh.positionsBuffer;
				else if( attribute.value == VertexAttribute.NORMALS ) buffer = mesh.normalsBuffer;
				else if( attribute.value == VertexAttribute.UVS ) buffer = mesh.uvBuffer;
				else if( attribute.value == VertexAttribute.VERTEX_COLORS ) buffer = mesh.colorsBuffer;
				else if( attribute.value == VertexAttribute.VERTEX_AREA_FACTORS ) {

					if( !mesh.extraBuffer0Initialized ) {
						MeshUtils.prepareMeshForWireframe( mesh );
					}

					buffer = mesh.extraBuffer0;
				}
				else throw new Error( "Vertex attribute of type " + attribute.value + " are not yet supported." );
				_context3d.setVertexBufferAt( registerIndex, buffer, 0, attribute.format );
				registerIndex++;
			}

//			trace( "vaN ok" );

			// draw
			try {
				_context3d.drawTriangles( mesh.indexBuffer );
				Log.clearAll();
			}
			catch( e:Error ) {
				Log.error( e.message );
			}

//			trace( "all ok *&*&*&" );
		}

		private function updateConstantMapping( constant:RegisterConstant, mesh:Mesh ):void {
			if( constant.mapping != null ) {
				if( constant.mapping.type == RegisterMapping.MVC_MAPPING ) {
					var modelViewProjectionMatrix:Matrix3D = new Matrix3D();
					modelViewProjectionMatrix.append( mesh.transform );
					modelViewProjectionMatrix.append( Core3D.instance.camera.viewProjectionMatrix );
					constant.value = modelViewProjectionMatrix;
				}
				else if( constant.mapping.type == RegisterMapping.TRANSFORM_MAPPING ) {
					constant.value = mesh.transform;
				}
				else if( constant.mapping.type == RegisterMapping.REDUCED_TRANSFORM_MAPPING ) {
					constant.value = mesh.reducedTransform;
				}
				else if( constant.mapping.type == RegisterMapping.POSITION_MAPPING ) {
					constant.value = constant.mapping.target.positionVector;
				}
				else if( constant.mapping.type == RegisterMapping.CAMERA_MAPPING ) {
					constant.value = Core3D.instance.camera.positionVector;
				}
				else if( constant.mapping.type == RegisterMapping.FUNCTION_MAPPING ) {
					constant.mapping.target();
				}
				else if( constant.mapping.type == RegisterMapping.OSCILLATOR_MAPPING ) {
					var vec:VectorRegisterConstant = VectorRegisterConstant( constant );
					var rangeX:Number = vec.compRanges[ 0 ].y - vec.compRanges[ 0 ].x;
					var rangeY:Number = vec.compRanges[ 1 ].y - vec.compRanges[ 1 ].x;
					var rangeZ:Number = vec.compRanges[ 2 ].y - vec.compRanges[ 2 ].x;
					var rangeW:Number = vec.compRanges[ 3 ].y - vec.compRanges[ 3 ].x;
					var values:Vector.<Number> = constant.mapping.target();
					constant.value[ 0 ] = vec.compRanges[ 0 ].x + rangeX * 0.5 + 0.5 * values[ 0 ] * rangeX;
					constant.value[ 1 ] = vec.compRanges[ 1 ].x + rangeY * 0.5 + 0.5 * values[ 1 ] * rangeY;
					constant.value[ 2 ] = vec.compRanges[ 2 ].x + rangeZ * 0.5 + 0.5 * values[ 2 ] * rangeZ;
					constant.value[ 3 ] = vec.compRanges[ 3 ].x + rangeW * 0.5 + 0.5 * values[ 3 ] * rangeW;
				}
				else {
					throw new Error( "Register mappings of type " + constant.mapping.type + " are not yet supported." );
				}
			}
		}

		private function buildAGALProgram( vertexAGAL:String, fragmentAGAL:String, debugging:Boolean = false ):Boolean {
			// build shader
			_isProgramValid = true;

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler( debugging );
			try {
				vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, vertexAGAL );
			} catch( e:Error ) {
				_isProgramValid = false;
				Log.error( "Program3D compilation error: " + e.message );
			}

			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler( debugging );
			try {
				fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT, fragmentAGAL );
			} catch( e:Error ) {
				_isProgramValid = false;
				Log.error( "Program3D compilation error: " + e.message );
			}

			if( _isProgramValid )
				_program3d = _context3d.createProgram();

			try {
				_program3d.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode );
				Log.clearAll();
			}
			catch( e:Error ) {
				_isProgramValid = false;
				if( e.message != "" ) {
					Log.error( "Program3D upload error: " + e.message );
				}
			}

			return _isProgramValid;
		}

		override public function deactivate():void {

			var i:uint, len:uint;

			// clear vertex attributes
			len = _vertexAttributes.length;
			for( i = 0; i < len; ++i ) {
				_context3d.setVertexBufferAt( i, null );
			}

			// clear textures
			len = _fragmentSamplers.length;
			for( i = 0; i < len; ++i ) {
				_context3d.setTextureAt( i, null );
			}
		}

		// -----------------------
		// textures
		// -----------------------

		public function setAGAL( vertexAGAL:String, fragmentAGAL:String ):void {
			_vertexAGAL = vertexAGAL;
			_fragmentAGAL = fragmentAGAL;
			_agalDirty = true;
		}

		public function set vertexAGAL( value:String ):void {
			_vertexAGAL = value;
			_agalDirty = true;
		}

		public function get vertexAGAL():String {
			return _vertexAGAL;
		}

		public function set fragmentAGAL( value:String ):void {
			_fragmentAGAL = value;
			_agalDirty = true;
		}

		public function get fragmentAGAL():String {
			return _fragmentAGAL;
		}

		// -----------------------
		// vcN
		// -----------------------

		private var _vertexConstantRegisterOffset:uint;

		public function addVertexConstant( constant:RegisterConstant ):RegisterConstant {
			constant.registerPrefix = "vc";
			constant.registerIndex = _vertexConstantRegisterOffset;
			_vertexConstants.push( constant );
			_vertexConstantRegisterOffset += constant is VectorRegisterConstant ? 1 : 4;
			return constant;
		}

		public function removeVertexConstant( constant:RegisterConstant ):void {
			_vertexConstants.splice( _vertexConstants.indexOf( constant ), 1 );
		}

		public function getVertexConstantAt( index:uint ):RegisterConstant {
			return _vertexConstants[ index ];
		}

		public function get numVertexConstants():uint {
			return _vertexConstants.length;
		}

		// -----------------------
		// fcN
		// -----------------------

		private var _fragmentConstantsRegisterOffset:uint;

		public function addFragmentConstant( constant:RegisterConstant ):RegisterConstant {
			constant.registerPrefix = "fc";
			constant.registerIndex = _fragmentConstantsRegisterOffset;
			_fragmentConstants.push( constant );
			_fragmentConstantsRegisterOffset += constant is VectorRegisterConstant ? 1 : 4;
			return constant;
		}

		public function removeFragmentConstant( constant:RegisterConstant ):void {
			_fragmentConstants.splice( _vertexConstants.indexOf( constant ), 1 );
		}

		public function getFragmentConstantAt( index:uint ):RegisterConstant {
			return _fragmentConstants[ index ];
		}

		public function get numFragmentConstants():uint {
			return _fragmentConstants.length;
		}

		// -----------------------
		// vaN
		// -----------------------

		public function addVertexAttribute( attribute:VertexAttribute ):VertexAttribute {
			attribute.registerIndex = _vertexAttributes.length;
			_vertexAttributes.push( attribute );
			return attribute;
		}

		public function removeVertexAttribute( attribute:VertexAttribute ):void {
			deactivate();
			_vertexAttributes.splice( _vertexAttributes.indexOf( attribute ), 1 );
		}

		public function getVertexAttributeAt( index:uint ):VertexAttribute {
			return _vertexAttributes[ index ];
		}

		public function get numVertexAttributes():uint {
			return _vertexAttributes.length;
		}

		// -----------------------
		// fsN
		// -----------------------

		public function addFragmentSampler( sampler:FragmentSampler ):FragmentSampler {
			sampler.registerIndex = _fragmentSamplers.length;
			_fragmentSamplers.push( sampler );
			_samplersDirty = true;
			return sampler;
		}

		public function removeFragmentSampler( sampler:FragmentSampler ):void {

			_fragmentSamplers.splice( _fragmentSamplers.indexOf( sampler ), 1 );
			_context3d.setTextureAt( sampler.registerIndex, null );
			_samplersDirty = true;
		}

		public function getFragmentSamplerAt( index:uint ):FragmentSampler {
			return _fragmentSamplers[ index ];
		}

		public function get numFragmentSamplers():uint {
			return _fragmentSamplers.length;
		}
	}
}
