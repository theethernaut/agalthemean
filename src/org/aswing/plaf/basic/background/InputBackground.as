/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background{

/**
 * @private
 */
public class InputBackground extends TextComponentBackBround{
	
	public function InputBackground(){
		super();
	}
	
	override protected function getChangeSharpen(enabled:Boolean, editable:Boolean):Number{
		if(!enabled){
			return 0.2;
		}else if(!editable){
			return 1;
		}else{
			return 1;
		}
	}
	
	override protected function getChangeAlpha(enabled:Boolean, editable:Boolean):Number{
		if(!enabled){
			return 0.2;
		}else if(!editable){
			return 0.5;
		}else{
			return 1;
		}
	}	
}
}