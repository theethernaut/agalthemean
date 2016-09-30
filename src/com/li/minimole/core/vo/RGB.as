package com.li.minimole.core.vo
{
public class RGB
{
    public var r:Number;
    public var g:Number;
    public var b:Number;
    public var a:Number;

    public function RGB(r:Number, g:Number, b:Number, a:Number = 1.0)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    public function toString():String
    {
        return "RGB: " + r + ", " + g + ", " + b + ", " + a;
    }
}
}
