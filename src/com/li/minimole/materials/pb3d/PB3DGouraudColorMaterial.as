package com.li.minimole.materials.pb3d
{

	import com.li.minimole.core.Core3D;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.utils.ColorUtils;
	import com.li.minimole.core.utils.VectorUtils;
	import com.li.minimole.core.vo.RGB;
	import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.*;

	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;

	/*
    Color material with gouraud shading.
 */
public class PB3DGouraudColorMaterial extends PB3DMaterialBase implements IColorMaterial
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/gouraudcolor/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/gouraudcolor/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _diffuseReflectionColor:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
    private var _specularReflectionColor:Vector.<Number>;
    private var _lightProperties:Vector.<Number>;

    public function PB3DGouraudColorMaterial(color:uint = 0xFFFFFF)
    {
        super();

        this.color = color;

        // TODO: getters and setters for these...
        _specularReflectionColor = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
        _lightProperties = Vector.<Number>([1.0, 1.0, 1.0, 1.0]); // ambient, diffuse, specular, specular concentration multiplier
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
        // TODO: reduced transforms could be calculated in the shader using casting "mul((float3x3)modelToWorld, normal);"
        // TODO: this could increase performance and reduce the number of registers used in the shader by 16!
        _parameterBufferHelper.setMatrixParameterByName("vertex", "modelTransform", mesh.transform, true);
        _parameterBufferHelper.setMatrixParameterByName("vertex", "modelReducedTransform", mesh.reducedTransform, true);
        _parameterBufferHelper.setNumberParameterByName("vertex", "lightPosition", light.positionVector);
        _parameterBufferHelper.setNumberParameterByName("vertex", "cameraPosition", Core3D.instance.camera.positionVector);
        _parameterBufferHelper.setNumberParameterByName("vertex", "diffuseReflectionColor", VectorUtils.multiply4(_diffuseReflectionColor, light.colorVector));
        _parameterBufferHelper.setNumberParameterByName("vertex", "specularReflectionColor", VectorUtils.multiply4(_specularReflectionColor, light.colorVector));
        _parameterBufferHelper.setNumberParameterByName("vertex", "lightProperties", VectorUtils.multiply4(_lightProperties, light.lightProperties));
        _parameterBufferHelper.update();

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(1, mesh.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
    }

    public function get color():uint
    {
        return _diffuseReflectionColor[0] * 255 << 16 | _diffuseReflectionColor[1] * 255 << 8 | _diffuseReflectionColor[2] * 255;
    }
    public function set color(value:uint):void
    {
        var rgb:RGB = ColorUtils.hexToRGB(value);
        _diffuseReflectionColor = Vector.<Number>([rgb.r/255, rgb.g/255, rgb.b/255, 1.0]);
    }
}
}
