package com.li.minimole.core.render
{
import com.li.minimole.core.Mesh;
import com.li.minimole.core.View3D;
	import com.li.minimole.materials.MaterialBase;

	import com.li.minimole.materials.pb3d.PB3DAnaglyphMaterial;
import com.li.minimole.materials.pb3d.PB3DMaterialBase;
import com.li.minimole.primitives.Plane;

import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.textures.Texture;
import flash.geom.Vector3D;

public class AnaglyphRenderer extends RenderBase
{
    private var _leftTexture:Texture;
    private var _rightTexture:Texture;
    private var _renderPlane:Plane;
    private var _anaglyphMaterial:PB3DAnaglyphMaterial;
    private var _cameraOriginalPosition:Vector3D;
    private var _lastMaterialRendered:MaterialBase;

    private var _cameraOffset:Number = 0.015;

    public var convergent:Boolean = false;
    public var center:Vector3D = new Vector3D();

    public function AnaglyphRenderer()
    {
        // Init render mat.
        _anaglyphMaterial = new PB3DAnaglyphMaterial();
    }

    override public function set view(value:View3D):void
    {
        _view = value;
        var sc:Number = 1;
        _renderPlane = new Plane(_anaglyphMaterial, _view.aspectRatio*sc, _view.aspectRatio*sc);
    }

    override public function render():void
    {
        if(!_view.context3d)
            return;

        // Clear buffers.
        clear();

        // Remember camera init position.
        _cameraOriginalPosition = _view.camera.position.clone();

        // Render in 3 steps.
        renderLeft();
        renderRight();

        // Return camera to center.
        _view.camera.position = _cameraOriginalPosition;
        _view.camera.lookAt(center);

        renderCenter();

        // Expose output.
        _view.context3d.present();
    }

    private function renderLeft():void
    {
        // Offset camera to the left.
        var left:Vector3D = _view.camera.left;
        left.scaleBy(_cameraOffset);
        _view.camera.position = _cameraOriginalPosition.add(left);
        if(convergent)
            _view.camera.lookAt(center);

        // Set rendering to left texture.
        if(!_leftTexture)
        {
            _leftTexture = _view.context3d.createTexture(2048, 2048, Context3DTextureFormat.BGRA, true);
            _anaglyphMaterial.leftTexture = _leftTexture;
        }
        _view.context3d.setRenderToTexture(_leftTexture, true, 2);

        // Render scene.
        renderScene();
    }

    private function renderRight():void
    {
        // Offset camera to the right.
        var right:Vector3D = _view.camera.right;
        right.scaleBy(_cameraOffset);
        _view.camera.position = _cameraOriginalPosition.add(right);
        if(convergent)
            _view.camera.lookAt(center);

        // Set rendering to left texture.
        if(!_rightTexture)
        {
            _rightTexture = _view.context3d.createTexture(2048, 2048, Context3DTextureFormat.BGRA, true);
            _anaglyphMaterial.rightTexture = _rightTexture;
        }
        _view.context3d.setRenderToTexture(_rightTexture, true, 2);

        // Render scene.
        renderScene();
    }

    private function renderCenter():void
    {
        // Release any previous materials.
        if(_lastMaterialRendered)
            _lastMaterialRendered.deactivate();

        // Set render to screen.
        _view.context3d.setRenderToBackBuffer();

        // Since the render plane is not actually in the scene,
        // we need to make sure it has a reference to context3d anyway.
        if(!_renderPlane.context3d)
            _renderPlane.context3d = _view.context3d;
        if(!_anaglyphMaterial.context3d) // Likewise for its material.
            _anaglyphMaterial.context3d = _view.context3d;

        // Choose culling.
        _view.context3d.setCulling(Context3DTriangleFace.NONE);

        // Chose blend.
        _view.context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

        // Draw.
        _anaglyphMaterial.drawMesh(_renderPlane, _view.scene.light);

        // Refer anaglyph material as last rendered.
        _lastMaterialRendered = _anaglyphMaterial;
    }

    private function renderScene():void
    {
        // Clear buffers.
        clear();

        // Sweep scene children and draw them one at a time.
        var loop:uint = _view.scene.numChildren;
        var mesh:Mesh;
        for(var i:uint = 0; i < loop; ++i)
        {
            // Id mesh to be rendered.
            mesh = _view.scene.getChildAt(i) as Mesh;

            if(!mesh.visible)
                continue;

            // Deactivate previous materials.
            // Disables data prepared for its shaders.
            if(_lastMaterialRendered && mesh.material != _lastMaterialRendered)
                _lastMaterialRendered.deactivate();

            // Choose blend mode.
            if(mesh.material.transparent)
                _view.context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            else
                _view.context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

            // Choose culling.
            if(mesh.material.bothsides)
                _view.context3d.setCulling(Context3DTriangleFace.NONE);
            else
                _view.context3d.setCulling(Context3DTriangleFace.BACK);

            // Draw mesh.
            mesh.material.drawMesh(mesh, _view.scene.light);

            // Remember last material used.
            _lastMaterialRendered = mesh.material;
        }
    }

    public function get anaglyphMaterial():PB3DAnaglyphMaterial
    {
        return _anaglyphMaterial;
    }

    public function get cameraOffset():Number
    {
        return _cameraOffset;
    }
    public function set cameraOffset(value:Number):void
    {
        _cameraOffset = value;
    }
}
}
