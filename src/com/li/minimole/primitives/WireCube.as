package com.li.minimole.primitives
{
import com.li.minimole.materials.pb3d.PB3DLineMaterial;

import flash.geom.Vector3D;

// TODO: Continue set up.
public class WireCube extends Lines
{
    // Corners.
    private var _lbf:Vector3D; // left,  bottom, front - 0
    private var _rbf:Vector3D; // right, bottom, front - 1
    private var _rtf:Vector3D; // right, top,    front - 2
    private var _ltf:Vector3D; // left,  top,    front - 3
    private var _lbb:Vector3D; // left,  bottom, back  - 4
    private var _rbb:Vector3D; // right, bottom, back  - 5
    private var _rtb:Vector3D; // right, top,    back  - 6
    private var _ltb:Vector3D; // left,  top,    back  - 7

    public function WireCube()
    {
        // Init material.
        var material:PB3DLineMaterial = new PB3DLineMaterial();
        super(material);

        // Init lines.
        var dummy:Vector3D = new Vector3D();
        for(var i:uint; i < 12; ++i)
            createLine(dummy, dummy);

        // Init corners.
        var sc:Number = 0.25;
        lbf = new Vector3D(-sc, -sc, -sc);
        rbf = new Vector3D( sc, -sc, -sc);
        rtf = new Vector3D( sc,  sc, -sc);
        ltf = new Vector3D(-sc,  sc, -sc);
        lbb = new Vector3D(-sc, -sc,  sc);
        rbb = new Vector3D( sc, -sc,  sc);
        rtb = new Vector3D( sc,  sc,  sc);
        ltb = new Vector3D(-sc,  sc,  sc);
    }

    // ---------------------------------------------------------------------
    // Corners getters/setters.
    // ---------------------------------------------------------------------

    // LTF.
    public function get ltf():Vector3D
    {
        return _ltf;
    }
    public function set ltf(value:Vector3D):void
    {
        _ltf = value;
        modifyLine(3,  _ltf, null);
        modifyLine(10, _ltf, null);
        modifyLine(2,  null, _ltf);
    }

    // RTF.
    public function get rtf():Vector3D
    {
        return _rtf;
    }
    public function set rtf(value:Vector3D):void
    {
        _rtf = value;
        modifyLine(1, null, _rtf);
        modifyLine(2, _rtf, null);
        modifyLine(9, _rtf, null);
    }

    // LBF.
    public function get lbf():Vector3D
    {
        return _lbf;
    }
    public function set lbf(value:Vector3D):void
    {
        _lbf = value;
        modifyLine(0,  _lbf, null);
        modifyLine(3,  null, _lbf);
        modifyLine(11, _lbf, null);
    }

    // RBF.
    public function get rbf():Vector3D
    {
        return _rbf;
    }
    public function set rbf(value:Vector3D):void
    {
        _rbf = value;
        modifyLine(0, null, _rbf);
        modifyLine(8, _rbf, null);
        modifyLine(1, _rbf, null);
    }

    // RBB.
    public function get rbb():Vector3D
    {
        return _rbb;
    }
    public function set rbb(value:Vector3D):void
    {
        _rbb = value;
        modifyLine(8, null, _rbb);
        modifyLine(4, null, _rbb);
        modifyLine(5, _rbb, null);
    }

    // LBB.
    public function get lbb():Vector3D
    {
        return _lbb;
    }
    public function set lbb(value:Vector3D):void
    {
        _lbb = value;
        modifyLine(11, null, _lbb);
        modifyLine(4,  _lbb, null);
        modifyLine(7,  null, _lbb);
    }

    // LTB.
    public function get ltb():Vector3D
    {
        return _ltb;
    }
    public function set ltb(value:Vector3D):void
    {
        _ltb = value;
        modifyLine(6,  null, _ltb);
        modifyLine(10, null, _ltb);
        modifyLine(7,  _ltb, null);
    }

    // RTB.
    public function get rtb():Vector3D
    {
        return _rtb;
    }
    public function set rtb(value:Vector3D):void
    {
        _rtb = value;
        modifyLine(5, null, _rtb);
        modifyLine(9, null, _rtb);
        modifyLine(6, _rtb, null);
    }
}
}
