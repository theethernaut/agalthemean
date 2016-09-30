package com.li.minimole.core.math
{
import flash.geom.Vector3D;

public class Ray
{
    public var direction:Vector3D;
    public var p0:Vector3D;
    public var p1:Vector3D;

    public function Ray(p0:Vector3D = null, p1:Vector3D = null, direction:Vector3D = null)
    {
        if(p0 && direction)
            fromPointAndDirection(p0, direction);
//
        if(p0 && p1)
            fromTwoPoints(p0, p1);
    }

    public function fromPointAndDirection(point:Vector3D, direction:Vector3D):void
    {
        direction.normalize();
        p0 = point;
        this.direction = direction;
    }

    public function fromTwoPoints(p0:Vector3D, p1:Vector3D):void
    {
        this.p0 = p0;
        this.p1 = p1;
    }
}
}
