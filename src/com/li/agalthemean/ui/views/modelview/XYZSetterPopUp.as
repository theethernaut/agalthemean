package com.li.agalthemean.ui.views.modelview
{

	import com.li.agalthemean.ui.components.JLabeledSlider;
	import com.li.minimole.core.Mesh;

	import flash.geom.Point;

	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;

	public class XYZSetterPopUp extends JFrame
	{
		public static const POSITION:String = "Position";
		public static const ROTATION:String = "Rotation";
		public static const SCALE:String = "Scale";

		public var type:String;

		public function XYZSetterPopUp( type:String, model:Mesh ) {

			super( null, type );

			this.type = type;

			var xTarget:String;
			var yTarget:String;
			var zTarget:String;
			var range:Point;
			switch( type ) {
				case XYZSetterPopUp.POSITION: {
					xTarget = "x";
					yTarget = "y";
					zTarget = "z";
					range = new Point( -4, 4 );
					break;
				}
				case XYZSetterPopUp.ROTATION: {
					xTarget = "rotationDegreesX";
					yTarget = "rotationDegreesY";
					zTarget = "rotationDegreesZ";
					range = new Point( -180, 180 );
					break;
				}
				case XYZSetterPopUp.SCALE: {
					xTarget = "scaleX";
					yTarget = "scaleY";
					zTarget = "scaleZ";
					range = new Point( 0, 2 );
					break;
				}
			}

			var content:JPanel = new JPanel( new SoftBoxLayout( SoftBoxLayout.Y_AXIS ) );
			content.append( new JLabeledSlider( "X", xTarget, model, range ) );
			content.append( new JLabeledSlider( "Y", yTarget, model, range ) );
			content.append( new JLabeledSlider( "Z", zTarget, model, range ) );

			setContentPane( content );

			setResizable( false );

			pack();
			show();
		}
	}
}
