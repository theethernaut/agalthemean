/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.graphics{
		
import flash.display.Graphics;
import flash.geom.Matrix;

/**
 * GradientPen to draw Gradient lines.
 * @see org.aswing.graphics.Graphics2D
 * @see org.aswing.graphics.IPen
 * @see org.aswing.graphics.Pen
 * @see http://livedocs.macromedia.com/flex/2/langref/flash/display/Graphics.html#lineGradientStyle()
 * @author n0rthwood
 */		
public class GradientPen implements IPen{
	
	private var pen:Pen;
	private var fillType:String;
	private var colors:Array;
	private var alphas:Array;
	private var ratios:Array;
	private var matrix:Matrix;
	private var spreadMethod:String;
	private var interpolationMethod:String;
	private var focalPointRatio:Number;

	public function GradientPen(pen:Pen,fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0){
		this.pen = pen;
		this.fillType = fillType;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		this.spreadMethod = spreadMethod;
		this.interpolationMethod = interpolationMethod;
		this.focalPointRatio = focalPointRatio;
	}
	
	public function getSpreadMethod():String{
		return this.spreadMethod;
	}
	
	/**
	 * 
	 */
	public function setSpreadMethod(spreadMethod:String):void{
		this.spreadMethod=spreadMethod;
	}
	
	public function getInterpolationMethod():String{
		return this.interpolationMethod;
	}
	
	/**
	 * 
	 */
	public function setInterpolationMethod(interpolationMethod:String):void{
		this.interpolationMethod=interpolationMethod;
	}
	
	public function getFocalPointRatio():Number{
		return this.focalPointRatio;
	}
	
	/**
	 * 
	 */
	public function setFocalPointRatio(focalPointRatio:Number):void{
		this.focalPointRatio=focalPointRatio;
	}
	
	public function getFillType():String{
		return fillType;
	}
	
	/**
	 * 
	 */
	public function setFillType(t:String):void{
		fillType = t;
	}
		
	public function getColors():Array{
		return colors;
	}
	
	/**
	 * 
	 */
	public function setColors(cs:Array):void{
		colors = cs;
	}
	
	public function getAlphas():Array{
		return alphas;
	}
	
	/**
	 * 
	 */
	public function setAlphas(alphas:Array):void{
		this.alphas = alphas;
	}
	
	public function getRatios():Array{
		return ratios;
	}
	
	/**
	 * 
	 */
	public function setRatios(rs:Array):void{
		ratios = rs;		
	}
	
	public function getMatrix():Object{
		return matrix;
	}
	
	/**
	 * 
	 */
	public function setMatrix(m:Matrix):void{
		matrix = m;
	}
	
	/**
	 * 
	 */
	public function setTo(target:Graphics):void{
		pen.setTo(target);
		target.lineGradientStyle(fillType,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio);
	}
}

}