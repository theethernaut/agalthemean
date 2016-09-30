package com.li.minimole.core.utils
{
import flash.geom.Vector3D;

public class Vector3dUtils
{
    public static function get3PointNormal(p0:Vector3D, p1:Vector3D, p2:Vector3D):Vector3D
    {
        var p0p1:Vector3D = p1.subtract(p0);
        var p0p2:Vector3D = p2.subtract(p0);
        var normal:Vector3D = p0p1.crossProduct(p0p2);
        normal.normalize();
        return normal;
    }
}
}
