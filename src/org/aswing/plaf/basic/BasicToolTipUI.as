/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic{
	
import org.aswing.*;
import org.aswing.event.ToolTipEvent;
import org.aswing.geom.IntRectangle;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.BaseComponentUI;

/**
 * @private
 */
public class BasicToolTipUI extends BaseComponentUI{
	
	protected var tooltip:JToolTip;
	protected var label:JLabel;
	
	public function BasicToolTipUI() {
		super();
	}
	
    override public function installUI(c:Component):void{
    	tooltip = JToolTip(c);
        installDefaults();
        initallComponents();
        installListeners();
    }

    protected function getPropertyPrefix():String {
        return "ToolTip.";
    }

	protected function installDefaults():void{
        var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(tooltip, pp);
        LookAndFeel.installBorderAndBFDecorators(tooltip, pp);
        LookAndFeel.installBasicProperties(tooltip, pp);
        var filters:Array = getInstance(getPropertyPrefix()+"filters") as Array;
        tooltip.filters = filters;
	}
	
	protected function initallComponents():void{
		var b:JToolTip = tooltip;
		b.setLayout(new BorderLayout());
		label = new JLabel(b.getTipText());
		label.setOpaque(false);
		label.setFont(null); //make it to use parent(JToolTip) font
		label.setForeground(null); //make it to user parent(JToolTip) foreground
		label.setUIElement(true);
		b.append(label, BorderLayout.CENTER);
	}
	
	protected function installListeners():void{
		tooltip.addEventListener(ToolTipEvent.TIP_TEXT_CHANGED, __tipTextChanged);
	}
	
	override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void{
		//do nothing, let background decorator to do things
	}
	
	private function __tipTextChanged(e:ToolTipEvent):void{
		label.setText(tooltip.getTipText());
	}
	
    override public function uninstallUI(c:Component):void{
        uninstallDefaults();
        uninstallListeners();
        uninstallComponents();
    }
    
    protected function uninstallDefaults():void{
    	LookAndFeel.uninstallBorderAndBFDecorators(tooltip);
        tooltip.filters = [];
    }
    
    protected function uninstallComponents():void{
    	tooltip.remove(label);
    	label = null;
    }    
    
    protected function uninstallListeners():void{
    	tooltip.removeEventListener(ToolTipEvent.TIP_TEXT_CHANGED, __tipTextChanged);
    }

	
}
}