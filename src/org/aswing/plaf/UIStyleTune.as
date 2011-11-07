package org.aswing.plaf{

import org.aswing.StyleTune;

/**
 * StyleTune UIResource
 */
public class UIStyleTune extends StyleTune implements UIResource{
	
	/**
	 * Create a StyleTune with specified params
	 * @param cg gradient brightness range of content color
	 * @param bo birightness offset for border color
	 * @param bg gradient brightness range of border color
	 * @param sa shadow alpha
	 * @param ma the adjuster for mideground color, null means use this(StyleTune)
	 */
	public function UIStyleTune(cg:Number=0.2, bo:Number=0.15, bg:Number=0.35, sa:Number=0.2, r:Number=0, ma:UIStyleTune=null){
		super(cg, bo, bg, sa, r, ma);
	}
}
}