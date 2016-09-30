package com.li.minimole.camera.lens
{

import flash.geom.Matrix3D;

/*
    Wraps a perspective projection matrix.
 */
public class PerspectiveLens
{
    private var _verticalFieldOfViewDegrees:Number; // Represents the angle from the camera to the top and bottom of the projection plane.
    private var _projectionMatrix:Matrix3D; // Perspective projection matrix derived from the view frustum.
    private var _invProjectionMatrix:Matrix3D; // Inverse of projection matrix.
    private var _aspectRatio:Number = 1; // Should always be set to viewWidth/viewHeight.
    private var _zNear:Number = 0.1; // Distance to near frustum plane.
    private var _zFar:Number = 50; // Distance to far frustum plane.
    private var _projectionMatrixDirty:Boolean;
    private var _inverseSuccesful:Boolean;

    private const DEG_TO_RAD:Number = Math.PI/180;

    public function PerspectiveLens(verticalFieldOfViewDegrees:Number = 60)
    {
        _verticalFieldOfViewDegrees = verticalFieldOfViewDegrees;
        _projectionMatrix = new Matrix3D();
    }

    public function set aspectRatio(value:Number):void
    {
        if(_aspectRatio == value)
            return;

        _aspectRatio = value;
        _projectionMatrixDirty = true;
    }
    public function get aspectRatio():Number
    {
        return _aspectRatio;
    }

    public function set verticalFieldOfViewDegrees(value:Number):void
    {
        if(_verticalFieldOfViewDegrees == value)
            return;

        _verticalFieldOfViewDegrees = value;
        _projectionMatrixDirty = true;
    }
    public function get verticalFieldOfViewDegrees():Number
    {
        return _verticalFieldOfViewDegrees;
    }

    public function get projectionMatrix():Matrix3D
    {
        if(_projectionMatrixDirty)
            updateProjectionMatrix();

        return _projectionMatrix;
    }

    public function get inverseProjectionMatrix():Matrix3D
    {
        if(_projectionMatrixDirty)
            updateProjectionMatrix();
        return _invProjectionMatrix;
    }

    private function updateInverseProjectionMatrix():void
    {
        _invProjectionMatrix = _projectionMatrix.clone();
        _inverseSuccesful = _invProjectionMatrix.invert();
    }

    // Recalculates the projection matrix.
    // See Mathematics for 3D Game Programming and Computer Graphics
    // by Eric Lengyel, page 124 for theory.
    // Implemented here as in Molehill examples.
    private function updateProjectionMatrix():void
    {
        // Not optimized for clarity.

        // Calculate frustum x and y ranges.
        // Derived from the fact that tan(_verticalFieldOfViewDegrees/2) = projectionPlaneHalfHeight/_zNear.
        var projectionPlaneHalfHeight:Number = _zNear*Math.tan(_verticalFieldOfViewDegrees*DEG_TO_RAD/2);
        // Instead of using an additional horizontal fov, we derive hw from
        // the aspect ratio of the view plane.
        var projectionPlaneHalfWidth:Number = projectionPlaneHalfHeight*_aspectRatio;

        // Calculate frustum edges.
        var left:Number = -projectionPlaneHalfWidth;
        var right:Number = projectionPlaneHalfWidth;
        var top:Number = projectionPlaneHalfHeight;
        var bottom:Number = -projectionPlaneHalfHeight;

        // Build raw vector of 16 numbers to construct 4x4 matrix.
        // Indices of the vector will be mapped to the matrix
        // like this:
        // 0  1  2  3
        // 4  5  6  7
        // 8  9  10 11
        // 12 13 14 15
        // When using matrix.copyRawDataFrom(), indices are expected in that order.
        var raw:Vector.<Number> = Vector.<Number>([

                (2*_zNear)/(right - left), 0,                          (right + left)/(right - left),    0,
                0,                         (2*_zNear)/(top - bottom),  (top + bottom)/(top - bottom),    0,
                0,                         0,                         -_zFar/(_zNear - _zFar),           1,
                0,                         0,                          (_zNear*_zFar)/(_zNear - _zFar),  0

        ]);

        // Move the raw data to the actual matrix.
        _projectionMatrix.copyRawDataFrom(raw);

        // Flag.
        _projectionMatrixDirty = false;

        // Update inverse also.
        updateInverseProjectionMatrix();
    }

    public function get zFar():Number
    {
        return _zFar;
    }

    public function set zFar(value:Number):void
    {
        _zFar = value;
    }

    public function get zNear():Number
    {
        return _zNear;
    }

    public function set zNear(value:Number):void
    {
        _zNear = value;
    }
}
}
