package com.li.agalthemean.ui.views.constantsview
{

	import com.li.agalthemean.ui.views.constantsview.ComponentAdjuster;
	import com.li.minimole.materials.agal.registers.RegisterConstant;
	import com.li.minimole.materials.agal.registers.VectorRegisterConstant;

	import flash.geom.Matrix3D;

	import org.aswing.BoxLayout;
	import org.aswing.JLabel;
	import org.aswing.JPanel;

	public class ConstantAdjuster extends JPanel
	{
		public var msgLabel:JLabel;
		public var adjuster:JPanel;

		public var xCompAdjuster:ComponentAdjuster;
		public var yCompAdjuster:ComponentAdjuster;
		public var zCompAdjuster:ComponentAdjuster;
		public var wCompAdjuster:ComponentAdjuster;

		private var _currentVectorConstant:VectorRegisterConstant;

		public function ConstantAdjuster( constant:RegisterConstant ) {
			super();

			append( msgLabel = new JLabel( "no valid selection" ) );

			adjuster = new JPanel( new BoxLayout( BoxLayout.Y_AXIS ) );
			adjuster.append( xCompAdjuster = new ComponentAdjuster( 0 ) );
			adjuster.append( yCompAdjuster = new ComponentAdjuster( 1 ) );
			adjuster.append( zCompAdjuster = new ComponentAdjuster( 2 ) );
			adjuster.append( wCompAdjuster = new ComponentAdjuster( 3 ) );
			adjuster.setVisible( false );
			append( adjuster );

			target = constant;
		}

		public function startListeningToConstant():void {
			xCompAdjuster.startListeningToConstant();
			yCompAdjuster.startListeningToConstant();
			zCompAdjuster.startListeningToConstant();
			wCompAdjuster.startListeningToConstant();
		}

		public function stopListeningToConstant():void {
			xCompAdjuster.stopListeningToConstant();
			yCompAdjuster.stopListeningToConstant();
			zCompAdjuster.stopListeningToConstant();
			wCompAdjuster.stopListeningToConstant();
		}

		public function set target( constant:RegisterConstant ):void {

			if( constant.value != null ) {

				if( constant.value is Matrix3D ) {
					displayMessage( "matrix constants are not adjustable" );
				}
				else {

					adjuster.setVisible( true );
					msgLabel.setVisible( false );

					_currentVectorConstant = constant as VectorRegisterConstant;

					xCompAdjuster.target = _currentVectorConstant;
					yCompAdjuster.target = _currentVectorConstant;
					zCompAdjuster.target = _currentVectorConstant;
					wCompAdjuster.target = _currentVectorConstant;
				}
			}
			else {
				displayMessage( "invalid constant" );
			}

			repaint();
		}

		private function displayMessage( msg:String ):void {
			adjuster.setVisible( false );
			msgLabel.setVisible( true );
			msgLabel.setText( msg );
		}
	}
}
