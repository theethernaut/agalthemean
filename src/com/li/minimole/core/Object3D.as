package com.li.minimole.core
{
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

/*
    Wraps the transformation matrix of a 3D object. Contains no vertices.

    Unlike Object3D in Away3D:
    - Does not avoid reconstructing the transform each time it is asked for (no dirty flags).
    - Uses basic matrix operations.
 */
public class Object3D
{
    private var _transform:Matrix3D;
    private var _inverseTransform:Matrix3D;
    private var _transformNeedsUpdate:Boolean;
    private var _valuesNeedUpdate:Boolean;

    private var _x:Number = 0;
    private var _y:Number = 0;
    private var _z:Number = 0;
    private var _rotationDegreesX:Number = 0;
    private var _rotationDegreesY:Number = 0;
    private var _rotationDegreesZ:Number = 0;
    private var _scaleX:Number = 1;
    private var _scaleY:Number = 1;
    private var _scaleZ:Number = 1;

    private const RAD_TO_DEG:Number = 180/Math.PI;

    public function Object3D()
    {
        _transform = new Matrix3D();
    }

    public function get transform():Matrix3D
    {
        if(_transformNeedsUpdate)
            updateTransformFromValues();

        return _transform;
    }
    public function set transform(value:Matrix3D):void
    {
        _transform = value;

        _transformNeedsUpdate = false;
        _valuesNeedUpdate = true;
    }

    public function get front():Vector3D
    {
        var vector:Vector3D = new Vector3D(0, 0, 1);
        return transform.deltaTransformVector(vector);
    }
    public function get left():Vector3D
    {
        var vector:Vector3D = new Vector3D(-1, 0, 0);
        return transform.deltaTransformVector(vector);
    }
    public function get right():Vector3D
    {
        var vector:Vector3D = new Vector3D(1, 0, 0);
        return transform.deltaTransformVector(vector);
    }
    // TODO: Do the same for top, bottom, back...

    public function get rotationTransform():Matrix3D
    {
        var d:Vector.<Vector3D> = transform.decompose();
        d[0] = new Vector3D();
        d[1] = new Vector3D(1, 1, 1);
        var t:Matrix3D = new Matrix3D();
        t.recompose(d);
        return t;
    }

    public function get reducedTransform():Matrix3D
    {
        var raw:Vector.<Number> = transform.rawData;
        raw[3] = 0; // Remove translation.
        raw[7] = 0;
        raw[11] = 0;
        raw[15] = 1;
        raw[12] = 0;
        raw[13] = 0;
        raw[14] = 0;
        var reducedTransform:Matrix3D = new Matrix3D();
        reducedTransform.copyRawDataFrom(raw);
        return reducedTransform;
    }

    public function get invRotationTransform():Matrix3D
    {
        var t:Matrix3D = rotationTransform;
        t.invert();
        return t;
    }

    public function set position(value:Vector3D):void
    {
        _x = value.x;
        _y = value.y;
        _z = value.z;

        _transformNeedsUpdate = true;
    }

    public function get position():Vector3D
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return new Vector3D(_x, _y, _z);
    }

    public function get positionVector():Vector.<Number>
    {
        return Vector.<Number>([_x, _y, _z, 1.0]);
    }

    public function get inverseTransform():Matrix3D
    {
        _inverseTransform = transform.clone();
        _inverseTransform.invert();

        return _inverseTransform;
    }

    // ------------------------------------------------------------------------
    // Position.
    // ------------------------------------------------------------------------

    public function set x(value:Number):void
    {
        _x = value;
        _transformNeedsUpdate = true;
    }
    public function get x():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _x;
    }

    public function set y(value:Number):void
    {
        _y = value;
        _transformNeedsUpdate = true;
    }
    public function get y():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _y;
    }

    public function set z(value:Number):void
    {
        _z = value;
        _transformNeedsUpdate = true;
    }
    public function get z():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _z;
    }

    // ------------------------------------------------------------------------
    // Rotation.
    // ------------------------------------------------------------------------

    public function set rotationDegreesX(value:Number):void
    {
        _rotationDegreesX = value;
        _transformNeedsUpdate = true;
    }
    public function get rotationDegreesX():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _rotationDegreesX;
    }

    public function set rotationDegreesY(value:Number):void
    {
        _rotationDegreesY = value;
        _transformNeedsUpdate = true;
    }
    public function get rotationDegreesY():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _rotationDegreesY;
    }

    public function set rotationDegreesZ(value:Number):void
    {
        _rotationDegreesZ = value;
        _transformNeedsUpdate = true;
    }
    public function get rotationDegreesZ():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _rotationDegreesZ;
    }

    // ------------------------------------------------------------------------
    // Scale.
    // ------------------------------------------------------------------------

    public function set scaleX(value:Number):void
    {
        _scaleX = value != 0 ? value : 0.0001;
        _transformNeedsUpdate = true;
    }
    public function get scaleX():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _scaleX;
    }

    public function set scaleY(value:Number):void
    {
        _scaleY = value != 0 ? value : 0.0001;
        _transformNeedsUpdate = true;
    }
    public function get scaleY():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _scaleY;
    }

    public function set scaleZ(value:Number):void
    {
        _scaleZ = value != 0 ? value : 0.0001;
        _transformNeedsUpdate = true;
    }
    public function get scaleZ():Number
    {
        if(_valuesNeedUpdate)
            updateValuesFromTransform();

        return _scaleZ;
    }

    // ------------------------------------------------------------------------
    // Update.
    // ------------------------------------------------------------------------

    private function updateTransformFromValues():void
    {
        _transform.identity();

        _transform.appendRotation(_rotationDegreesX, Vector3D.X_AXIS);
        _transform.appendRotation(_rotationDegreesY, Vector3D.Y_AXIS);
        _transform.appendRotation(_rotationDegreesZ, Vector3D.Z_AXIS);

        _transform.appendScale( _scaleX, _scaleY, _scaleZ );

        _transform.appendTranslation(_x, _y, _z);

        _transformNeedsUpdate = false;
    }

    private function updateValuesFromTransform():void
    {
        var d:Vector.<Vector3D> = _transform.decompose();

        var position:Vector3D = d[0];
        _x = position.x;
        _y = position.y;
        _z = position.z;

        var rotation:Vector3D = d[1];
        _rotationDegreesX = rotation.x*RAD_TO_DEG;
        _rotationDegreesY = rotation.y*RAD_TO_DEG;
        _rotationDegreesZ = rotation.z*RAD_TO_DEG;

        var scale:Vector3D = d[2];
        _scaleX = scale.x;
        _scaleY = scale.y;
        _scaleZ = scale.z;

        _valuesNeedUpdate = false;
    }

    // ------------------------------------------------------------------------
    // Utils.
    // ------------------------------------------------------------------------

    public function lookAt(target:Vector3D):void
    {
        var position:Vector3D = new Vector3D(_x, _y, _z);

        var yAxis:Vector3D, zAxis:Vector3D, xAxis:Vector3D;
        var upAxis:Vector3D = Vector3D.Y_AXIS;
        zAxis = target.subtract(position);
        zAxis.normalize();
        xAxis = upAxis.crossProduct(zAxis);
        xAxis.normalize();
        yAxis = zAxis.crossProduct(xAxis);

        var raw:Vector.<Number> = new Vector.<Number>(16);
        _transform.copyRawDataTo(raw);

        raw[uint(0)]  = _scaleX*xAxis.x;
        raw[uint(1)]  = _scaleX*xAxis.y;
        raw[uint(2)]  = _scaleX*xAxis.z;

        raw[uint(4)]  = _scaleY*yAxis.x;
        raw[uint(5)]  = _scaleY*yAxis.y;
        raw[uint(6)]  = _scaleY*yAxis.z;

        raw[uint(8)]  = _scaleZ*zAxis.x;
        raw[uint(9)]  = _scaleZ*zAxis.y;
        raw[uint(10)] = _scaleZ*zAxis.z;

        _transform.copyRawDataFrom(raw);

        var d:Vector.<Vector3D> = _transform.decompose();
        var rotation:Vector3D = d[1];
        _rotationDegreesX = rotation.x*RAD_TO_DEG;
        _rotationDegreesY = rotation.y*RAD_TO_DEG;
        _rotationDegreesZ = rotation.z*RAD_TO_DEG;
    }
}
}
