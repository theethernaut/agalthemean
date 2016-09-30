package com.li.minimole.materials.pb3d
{

	import com.li.minimole.materials.*;
	import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.ColorUtils;
import com.li.minimole.core.vo.RGB;
import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.IColorMaterial;

	import flash.display3D.Context3DVertexBufferFormat;

import flash.geom.Matrix3D;

/*
    Solid color material to be used only with Lines primitives.
    Not resolution independent for now, but does the trick for basic needs.
 */
public class PB3DLineDepthMaterial extends PB3DMaterialBase implements IColorMaterial
{
    [Embed (source="kernels/vertex/line/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/depthcolor/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialVertexProgram:Class;

    [Embed (source="kernels/material/depthcolor/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _color:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
    private var _props:Vector.<Number> = Vector.<Number>([0.0001, 0.0, 0.0, 0.0]); // line thickness, free, free, free

    public function PB3DLineDepthMaterial(color:uint = 0xFFFFFF, thickness:Number = 0.02)
    {
        super();

        this.color = color;
        _props[0] = thickness;

        bothsides = true;
    }

    override protected function buildProgram3d():void
    {
        // Translate PB3D to AGAL and build program3D.
        initPB3D(VertexProgram, MaterialVertexProgram, FragmentProgram);
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
        _parameterBufferHelper.setNumberParameterByName("vertex", "props", _props);
        _parameterBufferHelper.setMatrixParameterByName("vertex", "worldTransform", mesh.transform, true);
        _parameterBufferHelper.setNumberParameterByName("vertex", "cameraPosition", Core3D.instance.camera.positionVector);
        _parameterBufferHelper.setNumberParameterByName("vertex", "materialColor", _color);
        _parameterBufferHelper.setNumberParameterByName("vertex", "minZ", Vector.<Number>([1.0]));
        _parameterBufferHelper.setNumberParameterByName("vertex", "maxZ", Vector.<Number>([5.0]));
        
        // Set material params.
//        _parameterBufferHelper.setNumberParameterByName("fragment", "colorParam", _color);
        _parameterBufferHelper.update();
        
        // Set attributes and draw.
        _context3d.setVertexBufferAt(2, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // See Lines primitive.
        _context3d.setVertexBufferAt(1, mesh.extraBuffer0,    0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(0, mesh.extraBuffer1,    0, Context3DVertexBufferFormat.FLOAT_3);
//        _context3d.setVertexBufferAt(3, mesh.colorsBuffer,    0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
        _context3d.setVertexBufferAt(2, null);
//        _context3d.setVertexBufferAt(3, null);
    }

    public function set thickness(value:Number):void
    {
        _props[0] = value;
    }
    public function get thickness():Number
    {
        return _props[0];
    }

    public function get color():uint
    {
        return _color[0] * 255 << 16 | _color[1] * 255 << 8 | _color[2] * 255;
    }
    public function set color(value:uint):void
    {
        var rgb:RGB = ColorUtils.hexToRGB(value);
        _color = Vector.<Number>([rgb.r/255, rgb.g/255, rgb.b/255, 1.0]);
    }
}
}
