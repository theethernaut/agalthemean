package org.aswing.skinbuilder{
	
import org.aswing.plaf.basic.BasicSplitPaneUI;
import org.aswing.plaf.basic.splitpane.Divider;

public class SkinSplitPaneUI extends BasicSplitPaneUI{

	override protected function createDivider():Divider{
		return new SkinSplitPaneDivider(sp);
	}
}
}