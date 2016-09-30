package com.li.minimole.core.render
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.MaterialBase;

	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;

	public class DefaultRenderer extends RenderBase
{
    private var _lastRenderedMaterial:MaterialBase;

    public function DefaultRenderer()
    {
    }

    override public function render():void
    {
        if(!_view.context3d)
            return;

        // Clear.
        clear();

        // Sweep scene children and draw them one at a time.
        var loop:uint = _view.scene.numChildren;
        var mesh:Mesh;
        for(var i:uint = 0; i < loop; ++i)
        {
            mesh = _view.scene.getChildAt(i) as Mesh;
            renderMesh(mesh);

            if(mesh.showBoundingBox)
                renderMesh(mesh.boundingBoxWire);
        }

        // Update.
        _view.context3d.present();
    }

    private function renderMesh(mesh:Mesh):void
    {
        // Skip invisible meshes.
        if(!mesh.visible)
            return;

        // Deactivate previous materials.
        // Disables data prepared for its shaders.
        if(_lastRenderedMaterial && mesh.material != _lastRenderedMaterial)
            _lastRenderedMaterial.deactivate();

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
        _lastRenderedMaterial = mesh.material;
    }
}
}
