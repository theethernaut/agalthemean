package com.li.minimole.core.utils
{
import com.li.minimole.core.vo.RGB;

public class ColorUtils
{
    // Returns an RBG with values between 0 and 1.
    public static function hexToRGB(hex:uint):RGB
    {
        var red:uint = ((hex & 0xFF0000) >> 16);
        var green:uint = ((hex & 0x00FF00) >> 8);
        var blue:uint = ((hex & 0x0000FF));
        return new RGB(red, green, blue);
    }
}
}
