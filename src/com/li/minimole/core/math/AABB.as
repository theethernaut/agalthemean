package com.li.minimole.core.math
{
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

/*
    Axis aligned bounding box mathematical entity.
 */
public class AABB
{
    private var _minX:Number;
    private var _minY:Number;
    private var _minZ:Number;
    private var _maxX:Number;
    private var _maxY:Number;
    private var _maxZ:Number;

    public function AABB()
    {
    }

	public function toString():String {
		return "bounds: " + _minX + ", " + _maxX + ", " + _minY + ", " + _maxY + ", " + _minZ + ", " + _maxZ;
	}

    public function updateFromPositions(positions:Vector.<Number>, transform:Matrix3D = null):void
    {
        _minX = Number.MAX_VALUE;
        _minY = Number.MAX_VALUE;
        _minZ = Number.MAX_VALUE;
        _maxX = -Number.MAX_VALUE;
        _maxY = -Number.MAX_VALUE;
        _maxZ = -Number.MAX_VALUE;

        var i:uint, index:uint;
        var p:Vector3D = new Vector3D();
        var loop:uint = positions.length/3;
        for(i = 0; i < loop; ++i)
        {
            index = 3*i;

            p.x = positions[index];
            p.y = positions[index + 1];
            p.z = positions[index + 2];
            p = transform.transformVector(p);

            if(p.x < _minX)
                _minX = p.x;
            else if(p.x > _maxX)
                _maxX = p.x;

            if(p.y < _minY)
                _minY = p.y;
            else if(p.y > _maxY)
                _maxY = p.y;

            if(p.z < _minZ)
                _minZ = p.z;
            else if(p.z > _maxZ)
                _maxZ = p.z;
        }
    }

    public function get minY():Number
    {
        return _minY;
    }

    public function get minX():Number
    {
        return _minX;
    }

    public function get maxY():Number
    {
        return _maxY;
    }

    public function get maxZ():Number
    {
        return _maxZ;
    }

    public function get maxX():Number
    {
        return _maxX;
    }

    public function get minZ():Number
    {
        return _minZ;
    }
}
}
