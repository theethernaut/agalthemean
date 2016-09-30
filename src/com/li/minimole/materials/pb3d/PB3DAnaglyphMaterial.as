package com.li.minimole.materials.pb3d
{

	import com.li.minimole.materials.*;
	import com.li.minimole.core.Mesh;

import com.li.minimole.lights.PointLight;

import flash.display3D.Context3DVertexBufferFormat;

import flash.display3D.textures.Texture;

/*
    Anaglyph material for use with AnaglyphRenderer and 3D glasses.
 */
public class PB3DAnaglyphMaterial extends PB3DMaterialBase
{
    [Embed (source="kernels/vertex/unmodify/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/anaglyph/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/anaglyph/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _leftTexture:Texture;
    private var _rightTexture:Texture;

    private var _props:Vector.<Number>;
    private var _props1:Vector.<Number>;

    public function PB3DAnaglyphMaterial()
    {
        super();

        _props = Vector.<Number>([0.0, 0.0, 0.3, 0.0]); // green factor, blue factor, gamma factor, free
        _props1 = Vector.<Number>([0.0, 0.0, 0.0, 0.0]); // offset x, offset y, free, free
    }

    public function set greenFactor(value:Number):void
    {
        _props[0] = value;
    }
    public function get greenFactor():Number
    {
        return _props[0];
    }

    public function set blueFactor(value:Number):void
    {
        _props[1] = value;
    }
    public function get blueFactor():Number
    {
        return _props[1];
    }

    public function set gammaFactor(value:Number):void
    {
        _props[2] = value;
    }
    public function get gammaFactor():Number
    {
        return _props[2];
    }

    public function set offsetX(value:Number):void
    {
        _props1[0] = value;
    }
    public function get offsetX():Number
    {
        return _props1[0];
    }

    public function set offsetY(value:Number):void
    {
        _props1[1] = value;
    }
    public function get offsetY():Number
    {
        return _props1[1];
    }

    override protected function buildProgram3d():void
    {
        // Translate PB3D to AGAL and build program3D.
        initPB3D(VertexProgram, MaterialProgram, FragmentProgram);
    }

    override public function drawMesh(mesh:Mesh, light:PointLight):void
    {
        // Set program.
        _context3d.setProgram(_program3d);

        // Set params.
        _parameterBufferHelper.setNumberParameterByName("fragment", "props", _props);
        _parameterBufferHelper.setNumberParameterByName("fragment", "props1", _props1);
        _parameterBufferHelper.update();

        // Set texture.
        _context3d.setTextureAt(0, _leftTexture);
        _context3d.setTextureAt(1, _rightTexture);

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(1, mesh.uvBuffer,        0, Context3DVertexBufferFormat.FLOAT_2);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setTextureAt(0, null);
        _context3d.setTextureAt(1, null);
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
    }

    public function set leftTexture(value:Texture):void
    {
        _leftTexture = value;
    }

    public function set rightTexture(value:Texture):void
    {
        _rightTexture = value;
    }
}
}
