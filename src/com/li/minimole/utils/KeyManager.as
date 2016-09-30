package com.li.minimole.utils
{
import flash.utils.Dictionary;

public class KeyManager
{
    // ---------------------------------------------------------------------------------------------------------
    // Private variables.
    // ---------------------------------------------------------------------------------------------------------

    public const LEFT:uint = 37;
    public const RIGHT:uint = 39;
    public const UP:uint = 38;
    public const DOWN:uint = 40;
    public const W:uint = 87;
    public const A:uint = 65;
    public const S:uint = 83;
    public const D:uint = 68;
    public const Z:uint = 90;
    public const X:uint = 88;
    public const SPACEBAR:uint = 32;
    public const SHIFT:uint = 16;

    private var _keysDown:Dictionary;

    public function KeyManager()
    {
        _keysDown = new Dictionary();
    }

    public function keyDown(keyCode:uint):void
    {
        _keysDown[keyCode] = true;
    }

    public function keyUp(keyCode:uint):void
    {
        _keysDown[keyCode] = false;
    }

    public function keyIsDown(keyCode:uint):Boolean
    {
        return _keysDown[keyCode] ? _keysDown[keyCode] : false;
    }
}
}