package com.li.minimole.core
{
import com.li.minimole.camera.Camera3D;

/*
    A singleton class that holds global elements of the engine.
 */
public class Core3D
{
    private static var _instance:Core3D;

    private var _view:View3D;

    private var _debugShaders:Boolean = false;

    public var antiAlias:Number = 4;

    public function Core3D()
    {
    }

    public static function get instance():Core3D
    {
        if(!_instance)
            _instance = new Core3D();
        return _instance;
    }

    public function set view(value:View3D):void
    {
        _view = value;
    }
    public function get view():View3D
    {
        return _view;
    }

    public function get camera():Camera3D
    {
        return _view.camera;
    }

    public function get scene():Scene3D
    {
        return _view.scene;
    }
}
}
