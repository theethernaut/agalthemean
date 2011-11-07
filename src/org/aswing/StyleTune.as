package org.aswing{

/**
 * The style tune include factors to generate colors for gradient content and border, 
 * and include the round property and shaow alpha property.<p>
 * This is used to affect the component's UI style.
 * </p>
 */
public class StyleTune{

	/**
	 * Gradient brightness range of content color [-1, 1]
	 */
	public var cGradient:Number;
	/**
	 * The birightness offset for border color [-1, 1]
	 */	
	public var bOffset:Number;
	/**
	 * Gradient brightness range of border color [-1, 1]
	 */		
	public var bGradient:Number;
	/**
	 * Shadow alpha value [0, 1]
	 */
	public var shadowAlpha:Number;
	
	/**
	 * The round rect radius, 0 means not round [0, +]
	 */
	public var round:Number;
	
	private var mideAdjuster:StyleTune;
	
	/**
	 * Create a UIColorAdjuster with specified params
	 * @param cg gradient brightness range of content color
	 * @param bo birightness offset for border color
	 * @param bg gradient brightness range of border color
	 * @param sa shadow alpha
	 * @param r the round rect radius, 0 means not round
	 * @param ma the adjuster for mideground color, null means use this(UIColorAdjuster)
	 */
	public function StyleTune(cg:Number=0.2, bo:Number=0.15, bg:Number=0.35, sa:Number=0.2, r:Number=0, ma:StyleTune=null){
		cGradient = cg;
		bOffset = bo;
		bGradient = bg;
		shadowAlpha = sa;
		round = r;
		if(ma == null){
			mideAdjuster = this;
		}else{
			mideAdjuster = ma;
		}
	}
	
	public function get mide():StyleTune{
		return mideAdjuster;
	}
	
	public function set mide(adjuster:StyleTune):void{
		mideAdjuster = adjuster;
	}
	
	/**
	 * A factor bigger than 1 make it sharper, smaller than 1 make it flattener.
	 * factor 0 make it most flatten, all same color. This method just affect the colors.
	 * @param factor the sharpen/flatten factor
	 * @return a new <code>StyleTune</code> sharpened/flattened
	 */
	public function sharpen(factor:Number):StyleTune{
		return new StyleTune(
			cGradient*factor, 
			bOffset*factor, 
			bGradient*factor, 
			shadowAlpha*factor,
			round, mide
		);
	}
	
	public function changeRound(newRound:Number):StyleTune{
		return new StyleTune(cGradient, bOffset, bGradient, shadowAlpha, newRound, mide);
	}
	
	public function clone():StyleTune{
		return new StyleTune(cGradient, bOffset, bGradient, shadowAlpha, round, mide);
	}
	
	/**
	 * Returns the content light color
	 */
	public function getCLight(c:ASColor):ASColor{
		return c.changeLuminance(c.getLuminance() + (cGradient/2));
	}
	
	/**
	 * Returns the content dark color
	 */	
	public function getCDark(c:ASColor):ASColor{
		return c.changeLuminance(c.getLuminance() - (cGradient/2));
	}
	
	/**
	 * Returns the border light color
	 */	
	public function getBLight(c:ASColor):ASColor{
		return c.changeLuminance(c.getLuminance() + (bGradient/2) + bOffset);
	}
	
	/**
	 * Returns the border dark color
	 */	
	public function getBDark(c:ASColor):ASColor{
		return c.changeLuminance(c.getLuminance() - (bGradient/2) + bOffset);
	}
	
	/**
	 * Returns the shadow alpha value
	 */	
	public function getShadowAlpha():Number{
		return shadowAlpha
	}
	
	/**
	 * Returns the round rect radius, 0 means not round
	 */
	public function getRound():Number{
		return round;
	}
	
	public function toString():String{
		return "StyleTune{cGradient:" + cGradient 
			+", bOffset:" + bOffset 
			+", bGradient:" + bGradient 
			+", shadowAlpha:" + shadowAlpha 
			+", round:" + round
			+ (mideAdjuster != this ? "mide:" + mideAdjuster.toString() : "")  
			+ "}";
	}

}
}