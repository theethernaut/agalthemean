package com.li.minimole.camera
{
import com.li.minimole.camera.lens.PerspectiveLens;
import com.li.minimole.core.*;

import com.li.minimole.core.math.Ray;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

/*
    Represents the observer in a 3D scene.
 */
public class Camera3D extends Object3D
{
    private var _viewProjectionMatrix:Matrix3D; // The perspective lens projection matrix combined with the camera's transform.
    private var _lens:PerspectiveLens;
    private var _viewWidth:Number;
    private var _viewHeight:Number;

    public function Camera3D()
    {
        super();

        _lens = new PerspectiveLens();
        _viewProjectionMatrix = new Matrix3D();

        z = -2;
    }

    public function get lens():PerspectiveLens
    {
        return _lens;
    }

    public function get viewProjectionMatrix():Matrix3D
    {
        updateViewProjectionMatrix();
        return _viewProjectionMatrix;
    }

    private function updateViewProjectionMatrix():void
    {
        _viewProjectionMatrix.identity();
        _viewProjectionMatrix.append(inverseTransform);
        _viewProjectionMatrix.append(_lens.projectionMatrix);
    }

    /*
        Converts a point from world space to clip space.
        This is normally done by vertex shaders in GPU, which is much faster.
        However, for specific usages, it can also be done here.
     */
    public function project(v:Vector3D):Vector3D
    {
        // Translate to clip space.
        v = viewProjectionMatrix.transformVector(v);

        // Translate to screen space.
        v.x = 0.5*_viewWidth*(v.x + 1);
        v.y = 0.5*_viewHeight*(-v.y + 1);

        return v;
    }

    /*
        Converts a point in clip space to a ray in world space.
        The ray's p0 value represents the intersection of the ray with the
        view frustum's near plane.
        The ray's p1 value represents the intersection of the way with the
        view frustum's far plane.
     */
    public function unproject(x:Number, y:Number):Ray
    {
        // Transform coords to x/y clip space.
        var clipSpaceX:Number = 2*x/_viewWidth  - 1;
        var clipSpaceY:Number = -(2*y/_viewHeight - 1);

        // Build coords as clip space coords.
        var pointNear:Vector3D = new Vector3D(clipSpaceX, clipSpaceY, 0);
        var pointFar:Vector3D  = new Vector3D(clipSpaceX, clipSpaceY, 1);

        // Translate to view space.
        pointNear = _lens.inverseProjectionMatrix.transformVector(pointNear);
        pointFar  = _lens.inverseProjectionMatrix.transformVector(pointFar);

        return new Ray(pointNear, pointFar);
    }

    public function get viewWidth():Number
    {
        return _viewWidth;
    }

    public function set viewWidth(value:Number):void
    {
        _viewWidth = value;
    }

    public function get viewHeight():Number
    {
        return _viewHeight;
    }

    public function set viewHeight(value:Number):void
    {
        _viewHeight = value;
    }
}
}
