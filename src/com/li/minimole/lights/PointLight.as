package com.li.minimole.lights
{
import com.li.minimole.core.Object3D;

/*
    Basic point light.
 */
public class PointLight extends Object3D
{
    private var _color:int            = 0xFFFFFF;
    private var _ambient:Number       = 1;
    private var _diffuse:Number       = 1;
    private var _specular:Number      = 1;
    private var _concentration:Number = 50;

    private var _lightColor:Vector.<Number>;
    private var _lightProperties:Vector.<Number>;

    public function PointLight(color:uint = 0xFFFFFF)
    {
        _color = color;
        updateProps();
    }

    public function get ambient():Number
    {
        return _ambient;
    }
    public function set ambient(value:Number):void
    {
        _ambient = value;
        updateProps();
    }

    public function get diffuse():Number
    {
        return _diffuse;
    }
    public function set diffuse(value:Number):void
    {
        _diffuse = value;
        updateProps();
    }

    public function get specular():Number
    {
        return _specular;
    }
    public function set specular(value:Number):void
    {
        _specular = value;
        updateProps();
    }

    public function get concentration():Number
    {
        return _concentration;
    }
    public function set concentration(value:Number):void
    {
        _concentration = value;
        updateProps();
    }

    private function updateProps():void
    {
        var red:uint = ((_color & 0xFF0000) >> 16);
        var green:uint = ((_color & 0x00FF00) >> 8);
        var blue:uint = ((_color & 0x0000FF));

        _lightColor = Vector.<Number>([red/255, green/255, blue/255, 1.0]);
        _lightProperties = Vector.<Number>([_ambient, _diffuse, _specular, _concentration]);
    }

    public function get color():int
    {
        return _color;
    }
    public function set color(value:int):void
    {
        _color = value;
        updateProps();
    }

    public function get colorVector():Vector.<Number>
    {
        return _lightColor;
    }

    public function get lightProperties():Vector.<Number>
    {
        return _lightProperties;
    }
}
}
