package org.aswing.skinbuilder{

public class SkinFrameMaximizeIcon extends SkinButtonIcon{
	
	public function SkinFrameMaximizeIcon(){
		super();
	}
	
	override protected function getPropertyPrefix():String{
        return "Frame.maximizeIcon.";
    }
}
}