package com.li.minimole.core.utils
{
public class VectorUtils
{
    // Multiplies two 4 component vectors, component wise.
    public static function multiply4(a:Vector.<Number>, b:Vector.<Number>):Vector.<Number>
    {
        return Vector.<Number>([a[0]*b[0], a[1]*b[1], a[2]*b[2], a[3]*b[3]]);
    }

    // Multiplies a 4 component vector by a factor.
    public static function scale4(a:Vector.<Number>, sc:Number):Vector.<Number>
    {
        return Vector.<Number>( [a[0] * sc,  a[1] * sc,  a[2] * sc, a[3] * sc] );
    }
}
}
