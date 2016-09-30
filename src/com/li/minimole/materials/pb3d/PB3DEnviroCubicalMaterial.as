package com.li.minimole.materials.pb3d
{

	import com.li.minimole.materials.*;
	import com.li.minimole.core.Core3D;
import com.li.minimole.core.Mesh;

import com.li.minimole.core.utils.VectorUtils;
import com.li.minimole.lights.PointLight;

import flash.display.BitmapData;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.textures.CubeTexture;
import flash.geom.Matrix3D;

// TODO: PB3D doesn’t support cube mapping at the moment, so this material doesn't work.
public class PB3DEnviroCubicalMaterial extends PB3DMaterialBase
{
    [Embed (source="kernels/vertex/default/vertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const VertexProgram:Class;

    [Embed (source="kernels/material/envirocubical/materialVertexProgram.pbasm", mimeType="application/octet-stream")]
    private static const MaterialProgram:Class;

    [Embed (source="kernels/material/envirocubical/fragmentProgram.pbasm", mimeType="application/octet-stream")]
    private static const FragmentProgram:Class;

    private var _bmds:Vector.<BitmapData>;
    private var _cubeTexture:CubeTexture;

    // TODO: Could use a decal bitmap, a specular map, a normal map, and lighting. Lots of options!
    public function PB3DEnviroCubicalMaterial(posX:BitmapData = null, negX:BitmapData = null,
                                   posY:BitmapData = null, negY:BitmapData = null,
                                   posZ:BitmapData = null, negZ:BitmapData = null)
    {
        super();

        _bmds = new Vector.<BitmapData>();
        _bmds.push(posX, negX, posY, negY, posZ, negZ);
    }

    override protected function buildProgram3d():void
    {
        // Translate PB3D to AGAL and build program3D.
        initPB3D(VertexProgram, MaterialProgram, FragmentProgram);

        // Build texture.
        _cubeTexture = _context3d.createCubeTexture(_bmds[0].width, Context3DTextureFormat.BGRA, false);
        for(var i:uint; i < 6; ++i)
            _cubeTexture.uploadFromBitmapData(_bmds[i], i);
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
        _parameterBufferHelper.setMatrixParameterByName("vertex", "modelTransform", mesh.transform, true);
        _parameterBufferHelper.setMatrixParameterByName("vertex", "modelReducedTransform", mesh.reducedTransform, true);
        _parameterBufferHelper.setNumberParameterByName("fragment", "cameraPosition", Core3D.instance.camera.positionVector);
        _parameterBufferHelper.update();

        // Set textures.
        _context3d.setTextureAt(0, _cubeTexture);

        // Set attributes and draw.
        _context3d.setVertexBufferAt(0, mesh.positionsBuffer,  0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.setVertexBufferAt(1, mesh.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
        _context3d.drawTriangles(mesh.indexBuffer);
    }

    override public function deactivate():void
    {
        _context3d.setTextureAt(0, null);
        _context3d.setTextureAt(1, null);
        _context3d.setTextureAt(2, null);
        _context3d.setVertexBufferAt(0, null);
        _context3d.setVertexBufferAt(1, null);
    }
}
}
