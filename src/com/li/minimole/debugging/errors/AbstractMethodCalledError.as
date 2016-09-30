package com.li.minimole.debugging.errors
{
public class AbstractMethodCalledError extends Error
{
    public function AbstractMethodCalledError()
    {
        super("Abstract method called.");
    }
}
}
