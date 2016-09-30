package com.li.minimole.materials.pb3d
{

	import com.li.minimole.materials.*;
	import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.ColorUtils;
import com.li.minimole.core.vo.RGB;
import com.li.minimole.lights.PointLight;

import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;

import flash.geom.Matrix3D;

/*
    Color material that darkens as it gets further from the camera.
 */
public class PB3DDepthColorMaterial extends PB3DMaterialBase implements IColorMaterial
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/depthcolor/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/depthcolor/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _color:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);

    public function PB3DDepthColorMaterial(color:uint = 0xFFFFFF)
    {
        super();
        this.color = color;
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
        var zDelta:Number = 1;
        var tt:Matrix3D = mesh.transform.clone();
        tt.appendScale(zDelta, zDelta, zDelta);
        _parameterBufferHelper.setMatrixParameterByName(Context3DProgramType.VERTEX, "worldTransform", tt, true);
        _parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "cameraPosition", Core3D.instance.camera.positionVector);
        _parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "materialColor", _color);
        _parameterBufferHelper.update();

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setVertexBufferAt(0, null);
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
