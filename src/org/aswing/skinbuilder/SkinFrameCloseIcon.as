package org.aswing.skinbuilder{

public class SkinFrameCloseIcon extends SkinButtonIcon{
	
	public function SkinFrameCloseIcon(){
		super();
	}
	
	override protected function getPropertyPrefix():String{
        return "Frame.closeIcon.";
    }
}
}