package com.li.minimole.materials.pb3d
{
import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.ColorUtils;
import com.li.minimole.core.vo.RGB;
import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.IColorMaterial;
	import com.li.minimole.materials.pb3d.PB3DMaterialBase;

	import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;

import flash.geom.Matrix3D;

/*
    Wireframe material. Requires vertices to be colored as RGB.
    Does not render gouraud lighting underneath the lines.
    Does not produce resolution independent lines.
 */
// TODO: Shader should use mesh transform.
public class PB3DWireframeMaterialSimple extends PB3DMaterialBase implements IColorMaterial
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/wireframe1/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/wireframe1/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _lineColor:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
    private var _props:Vector.<Number>;

    public function PB3DWireframeMaterialSimple(color:uint = 0xFFFFFF)
    {
        super();
//        transparent = true;
//        bothsides = true;
        this.color = color;
        _props = Vector.<Number>([2.5, 0.0, 0.0, 0.0]); // line thickness exponent, free, free, free

        textureBased = true;
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

        // Update modelViewProjectionMatrix.
        // Could be moved up in the pipeline.
        var modelViewProjectionMatrix:Matrix3D = new Matrix3D();
        modelViewProjectionMatrix.append(mesh.transform);
        modelViewProjectionMatrix.append(Core3D.instance.camera.viewProjectionMatrix);

        // Set vertex params.
        _parameterBufferHelper.setMatrixParameterByName(Context3DProgramType.VERTEX, "objectToClipSpaceTransform", modelViewProjectionMatrix, true);

        // Set material params.
        _parameterBufferHelper.setNumberParameterByName("fragment", "lineColor", _lineColor);
        _parameterBufferHelper.setNumberParameterByName("vertex", "props", _props);
        _parameterBufferHelper.update();

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(1, mesh.colorsBuffer,    0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
        _context3d.setRenderToBackBuffer();
    }

    public function get color():uint
    {
        return _lineColor[0] * 255 << 16 | _lineColor[1] * 255 << 8 | _lineColor[2] * 255;
    }
    public function set color(value:uint):void
    {
        var rgb:RGB = ColorUtils.hexToRGB(value);
        _lineColor = Vector.<Number>([rgb.r/255, rgb.g/255, rgb.b/255, 1.0]);
    }

    public function get lineFactor():Number
    {
        return _props[0];
    }
    public function set lineFactor(value:Number):void
    {
        _props[0] = value;
    }
}
}
