package com.li.agalthemean.ui.components
{

	import com.li.minimole.materials.agal.vo.registers.AGALRegister;

	import flash.events.Event;

	import org.aswing.BorderLayout;
	import org.aswing.Component;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;
	import org.aswing.event.FrameEvent;
	import org.osflash.signals.Signal;

	public class JRegisterPopUp extends JFrame
	{
		private var _register:AGALRegister;

		public var nameField:JLabeledInputText;
		public var packs:Boolean = true;

		public var registerRenamedSignal:Signal;
		public var deleteBtnClickedSignal:Signal;

		public function JRegisterPopUp( register:AGALRegister, content:Component ) {

			// TODO: ensure closed pop ups are garbage collected...

			super( null, register.toStringExtended() );

			_register = register;

			deleteBtnClickedSignal = new Signal( JRegisterPopUp );
			registerRenamedSignal = new Signal();

			nameField = new JLabeledInputText( "register name", register.name );
			nameField.input.getTextField().addEventListener( Event.CHANGE, onNameChanged );

			var deleteBtn:JButton = new JButton( "delete" );
			deleteBtn.addEventListener( AWEvent.ACT, deleteBtnClickedHandler );

			var topHolder:JPanel = new JPanel( new BorderLayout() );
			topHolder.append( nameField, BorderLayout.CENTER );
			topHolder.append( deleteBtn, BorderLayout.EAST );

			var allHolder:JPanel = new JPanel( new BorderLayout() );
			allHolder.append( topHolder, BorderLayout.NORTH );
			allHolder.append( content, BorderLayout.CENTER );
			setContentPane( allHolder );

			// TODO - reach into resizer and disable it partially? (not completely as in setResizable() )
			setResizable( false );

			this.addEventListener( FrameEvent.FRAME_CLOSING, onFrameClosing );
		}

		protected function onClose():void {

		}

		private function onFrameClosing( event:FrameEvent ):void {
			onClose();
		}

		private function onNameChanged( event:Event ):void {
			_register.name = nameField.input.getText();
			refreshTitle();
			registerRenamedSignal.dispatch();
			// TODO: restrict or validate new names
		}

		protected function refreshTitle():void {
			setTitle( _register.toStringExtended() );
		}

		private function deleteBtnClickedHandler( event:AWEvent ):void {
			deleteBtnClickedSignal.dispatch( this );
		}

		public function get register():AGALRegister {
			return _register;
		}
	}
}
