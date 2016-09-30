package com.li.minimole.materials.pb3d
{
import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.TextureUtils;

import com.li.minimole.core.utils.VectorUtils;
import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.pb3d.PB3DMaterialBase;

	import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DVertexBufferFormat;

import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;

/*
    Bitmap material with phong shading.
    Uses vertex normals.
 */
public class PB3DPhongBitmapMaterial extends PB3DMaterialBase
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/phongbitmap/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/phongbitmap/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _texture:Texture;
    private var _textureBmd:BitmapData;

    private var _specularReflectionColor:Vector.<Number>;
    private var _lightProperties:Vector.<Number>;

    public function PB3DPhongBitmapMaterial(texture:BitmapData)
    {
        super();

        _textureBmd = TextureUtils.ensurePowerOf2(texture);

        // TODO: getters and setters for these...
        _specularReflectionColor = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);

		_lightProperties = Vector.<Number>([1.0, 1.0, 1.0, 1.0]); // ambient, diffuse, specular, specular concentration multiplier
		ambient = 0.1;
		diffuse = 1.0;
		specular = 0.25;
    }

	public function set ambient( value:Number ):void
	{
		_lightProperties[0] = value;
	}
	public function get ambient():Number
	{
		return _lightProperties[0];
	}

	public function set diffuse( value:Number ):void
	{
		_lightProperties[1] = value;
	}
	public function get diffuse():Number
	{
		return _lightProperties[1];
	}

	public function set specular( value:Number ):void
	{
		_lightProperties[2] = value;
	}
	public function get specular():Number
	{
		return _lightProperties[2];
	}

    override protected function buildProgram3d():void
    {
        // Translate PB3D to AGAL and build program3D.
        initPB3D(VertexProgram, MaterialProgram, FragmentProgram);

        // Build texture.
        _texture = _context3d.createTexture(_textureBmd.width, _textureBmd.height, Context3DTextureFormat.BGRA, false);
        _texture.uploadFromBitmapData(_textureBmd);
    }

    override public function drawMesh(mesh:Mesh, light:PointLight):void
    {
        // Set program.
        _context3d.setProgram(_program3d);

        // Update modelViewProjectionMatrix.
        // Could be moved up in the pipeline.
        var modelViewProjectionMatrix:Matrix3D = new Matrix3D();
        modelViewProjectionMatrix.append(mesh.transform);
        modelViewProjectionMatrix.append(Core3D.instance.camera.viewProjectionMatrix);

        // Set vertex params.
        _parameterBufferHelper.setMatrixParameterByName("vertex", "objectToClipSpaceTransform", modelViewProjectionMatrix, true);

        // Set vertex params.
        _parameterBufferHelper.setMatrixParameterByName("vertex",   "modelTransform", mesh.transform, true);
        _parameterBufferHelper.setMatrixParameterByName("vertex",   "modelReducedTransform", mesh.reducedTransform, true);
        _parameterBufferHelper.setNumberParameterByName("fragment", "lightPosition", light.positionVector);
        _parameterBufferHelper.setNumberParameterByName("fragment", "cameraPosition", Core3D.instance.camera.positionVector);
        var precomputedSpecular:Vector.<Number> = VectorUtils.multiply4(_specularReflectionColor, light.colorVector);
        precomputedSpecular = VectorUtils.scale4(precomputedSpecular, _lightProperties[2]);
        _parameterBufferHelper.setNumberParameterByName("fragment", "precomputedSpecular", precomputedSpecular);
        var props:Vector.<Number> = VectorUtils.multiply4(_lightProperties, light.lightProperties);
        _parameterBufferHelper.setNumberParameterByName("fragment", "lightProperties", props);
        _parameterBufferHelper.update();

        // Set textures.
        _context3d.setTextureAt(0, _texture);

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer,  0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(1, mesh.normalsBuffer,  0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(2, mesh.uvBuffer,      0, Context3DVertexBufferFormat.FLOAT_2);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setTextureAt(0, null);
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
        _context3d.setVertexBufferAt(2, null);
    }
}
}
