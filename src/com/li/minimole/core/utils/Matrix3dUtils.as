package com.li.minimole.core.utils
{
import flash.geom.Matrix3D;

public class Matrix3dUtils
{
    public static function matrix3dToString(matrix:Matrix3D):String
    {
        var str:String = String(matrix) + "\n";

        var raw:Vector.<Number> = new Vector.<Number>(16);
        matrix.copyRawDataTo(raw);

        str += "Matrix3D: [\n";
        str += raw[0]  + ", " + raw[1]  + ", " + raw[2]  + ", " + raw[3]  + "\n";
        str += raw[4]  + ", " + raw[5]  + ", " + raw[6]  + ", " + raw[7]  + "\n";
        str += raw[8]  + ", " + raw[9]  + ", " + raw[10] + ", " + raw[11] + "\n";
        str += raw[12] + ", " + raw[13] + ", " + raw[14] + ", " + raw[15] + "\n";
        str += "]";

        return str;
    }
}
}
