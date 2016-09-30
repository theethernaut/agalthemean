package com.li.minimole.materials.pb3d
{

	import com.li.minimole.core.Core3D;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.utils.TextureUtils;
	import com.li.minimole.lights.PointLight;

	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;

	/*
	 Bitmap material (no shading).
	 */
	public class PB3DBitmapMaterial extends PB3DMaterialBase
	{
		[Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
		private static const VertexProgram:Class;

		[Embed (source="kernels/material/basicbitmap/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
		private static const MaterialProgram:Class;

		[Embed (source="kernels/material/basicbitmap/fragmentProgram.pbasm", mimeType="application/octet-stream")]
		private static const FragmentProgram:Class;

		private var _bmd:BitmapData;
		private var _texture:Texture;

		public function PB3DBitmapMaterial( bitmapData:BitmapData )
		{
			super();

			_bmd = TextureUtils.ensurePowerOf2( bitmapData );
		}

		override protected function buildProgram3d():void
		{
			// Translate PB3D to AGAL and build program3D.
			initPB3D( VertexProgram, MaterialProgram, FragmentProgram );

			// Build texture.
			_texture = _context3d.createTexture( _bmd.width, _bmd.height, Context3DTextureFormat.BGRA, false );
			_texture.uploadFromBitmapData( _bmd );
		}

		override public function drawMesh( mesh:Mesh, light:PointLight ):void
		{
			// Set program.
			_context3d.setProgram( _program3d );

			// Set params.
			var modelViewProjectionMatrix:Matrix3D = new Matrix3D();
			modelViewProjectionMatrix.append( mesh.transform );
			modelViewProjectionMatrix.append( Core3D.instance.camera.viewProjectionMatrix );
			_parameterBufferHelper.setMatrixParameterByName( Context3DProgramType.VERTEX, "objectToClipSpaceTransform", modelViewProjectionMatrix, true );
			_parameterBufferHelper.update();

			// Set texture.
			_context3d.setTextureAt( 0, _texture );

			// Set attributes and draw.
			_context3d.setVertexBufferAt( 0, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );
			_context3d.setVertexBufferAt( 1, mesh.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2 );
			_context3d.drawTriangles( mesh.indexBuffer );
		}

		override public function deactivate():void
		{
			_context3d.setTextureAt( 0, null );
			_context3d.setVertexBufferAt( 0, null );
			_context3d.setVertexBufferAt( 1, null );
		}
	}
}
