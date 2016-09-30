package com.li.minimole.core.render
{
import com.li.minimole.core.View3D;
import com.li.minimole.core.vo.RGB;
import com.li.minimole.debugging.errors.AbstractMethodCalledError;

public class RenderBase
{
    protected var _view:View3D;

    public function RenderBase()
    {
    }

    public function render():void
    {
        throw new AbstractMethodCalledError();
    }

    public function clear():void
    {
        if(!_view.context3d)
            return;

        var color:RGB = _view.clearColor;
        _view.context3d.clear(color.r, color.g, color.b, color.a);
    }

    public function set view(value:View3D):void
    {
        _view = value;
    }

    public function get view():View3D
    {
        return _view;
    }
}
}
