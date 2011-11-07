package com.li.agalthemean.utils
{

	import com.li.agalthemean.ui.components.JRegisterPopUp;
	import com.li.minimole.materials.agal.vo.registers.AGALRegister;

	import flash.display.Stage;
	import flash.utils.Dictionary;

	import org.aswing.event.FrameEvent;
	import org.aswing.geom.IntPoint;

	public class RegisterPopUpManager
	{
		private var _popUps:Dictionary;
		private var _stage:Stage;

		public function RegisterPopUpManager( stage:Stage ) {

			_popUps = new Dictionary();
			_stage = stage;
		}

		public function requestPopUp( register:AGALRegister, popUpClass:Class ):JRegisterPopUp {

			if( !_popUps[ register ] ) {

				var popUp:JRegisterPopUp = new popUpClass( register );
				popUp.addEventListener( FrameEvent.FRAME_CLOSING, popUpClosedHandler, false, 0, true );

				if( popUp.packs )
					popUp.pack();

				popUp.setLocation( new IntPoint( _stage.stageWidth / 2 - popUp.width / 2, _stage.stageHeight / 2 - popUp.height / 2 ) );

				popUp.show();

				_popUps[ register ] = popUp;

				return popUp;
			}
			return null;
		}

		private function popUpClosedHandler( event:FrameEvent ):void {
			_popUps[ JRegisterPopUp( event.target ).register ] = null;
		}
	}
}
