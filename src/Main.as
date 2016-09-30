/**
 * Created by palebluedot on 9/30/16.
 */
package {
import com.li.agalthemean.MainContext;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

public class Main extends Sprite {

    private var context:MainContext;

    public function Main() {

        trace("Main.as - AGALTheMean");

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        context = new MainContext(this);
    }
}
}
