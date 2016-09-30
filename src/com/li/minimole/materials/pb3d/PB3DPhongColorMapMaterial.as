package com.li.minimole.materials.pb3d
{
import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.TextureUtils;

import com.li.minimole.core.utils.ColorUtils;
import com.li.minimole.core.utils.VectorUtils;
import com.li.minimole.core.utils.VectorUtils;
import com.li.minimole.core.vo.RGB;
import com.li.minimole.lights.PointLight;
	import com.li.minimole.materials.IColorMaterial;
	import com.li.minimole.materials.pb3d.PB3DMaterialBase;

	import flash.display.BitmapData;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DVertexBufferFormat;

import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;

public class PB3DPhongColorMapMaterial extends PB3DMaterialBase implements IColorMaterial
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/phongcolormap/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/phongcolormap/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _normalMap:Texture;
    private var _normalMapBmd:BitmapData;

    private var _diffuseReflectionColor:Vector.<Number>;
    private var _specularReflectionColor:Vector.<Number>;
    private var _lightProperties:Vector.<Number>;

    public function PB3DPhongColorMapMaterial(color:uint, normalMap:BitmapData)
    {
        super();

        _normalMapBmd = TextureUtils.ensurePowerOf2(normalMap);

        this.color = color;

        // TODO: getters and setters for these...
        _diffuseReflectionColor = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
        _specularReflectionColor = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);
        _lightProperties = Vector.<Number>([1.0, 1.0, 1.0, 1.0]); // ambient, diffuse, specular, specular concentration multiplier
    }

    override protected function buildProgram3d():void
    {
        // Translate PB3D to AGAL and build program3D.
        initPB3D(VertexProgram, MaterialProgram, FragmentProgram);

        // Build texture.
        _normalMap = _context3d.createTexture(_normalMapBmd.width, _normalMapBmd.height, Context3DTextureFormat.BGRA, false);
        _normalMap.uploadFromBitmapData(_normalMapBmd);
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

        // Set vertex params.
        _parameterBufferHelper.setMatrixParameterByName("vertex",   "modelTransform", mesh.transform, true);
        _parameterBufferHelper.setMatrixParameterByName("fragment", "modelReducedTransform", mesh.reducedTransform, true);
        _parameterBufferHelper.setNumberParameterByName("fragment", "lightPosition", light.positionVector);
        _parameterBufferHelper.setNumberParameterByName("fragment", "cameraPosition", Core3D.instance.camera.positionVector);
        var precomputedLightProps:Vector.<Number> = VectorUtils.multiply4(_lightProperties, light.lightProperties); // Shaders reject multiplication between 2 constants.
        var precomputedAmbient:Vector.<Number>;                                                                     // All these need to be precomputed.
        var precomputedDiffuse:Vector.<Number>  = VectorUtils.multiply4(_diffuseReflectionColor, light.colorVector);
        var precomputedSpecular:Vector.<Number> = VectorUtils.multiply4(_specularReflectionColor, light.colorVector);
        precomputedAmbient  = VectorUtils.scale4(_diffuseReflectionColor, precomputedLightProps[0]);
        precomputedDiffuse  = VectorUtils.scale4(precomputedDiffuse,      precomputedLightProps[1]);
        precomputedSpecular = VectorUtils.scale4(precomputedSpecular,     precomputedLightProps[2]);
        _parameterBufferHelper.setNumberParameterByName("fragment", "precomputedAmbient", precomputedAmbient);
        _parameterBufferHelper.setNumberParameterByName("fragment", "precomputedDiffuse", precomputedDiffuse);
        _parameterBufferHelper.setNumberParameterByName("fragment", "precomputedSpecular", precomputedSpecular);
        _parameterBufferHelper.setNumberParameterByName("fragment", "lightProperties", precomputedLightProps);
        _parameterBufferHelper.update();

        // Set textures.
        _context3d.setTextureAt(0, _normalMap);

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer,  0, Context3DVertexBufferFormat.FLOAT_3); // For vertex shader.
        _context3d.setVertexBufferAt(1, mesh.uvBuffer,      0, Context3DVertexBufferFormat.FLOAT_2); // For material shader.
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setTextureAt(0, null);
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
