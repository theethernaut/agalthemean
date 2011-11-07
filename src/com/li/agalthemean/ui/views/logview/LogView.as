package com.li.agalthemean.ui.views.logview
{

	import com.li.minimole.debugging.logging.Log;

	import org.aswing.JTextArea;

	import com.li.agalthemean.ui.components.JTitledPanel;

	public class LogView extends JTitledPanel
	{
		private var _textArea:JTextArea;
		private var _oldMessage:String = "";

		private const NO_PROBLEM_MESSAGE:String = "No problems found.";

		public function LogView() {

			super( "log" );

			_textArea = new JTextArea();
			_textArea.setText( "log empty" );
			_textArea.setEditable( false );

			contentPanel.append( _textArea );

			// map minimole log entries to textfield
			Log.errorTraceMethod = updateLog;
		}

		private function updateLog( ...args ):void {

			var msg:String = "";

			if( args.length == 0 ) {
				msg = NO_PROBLEM_MESSAGE;
			}
			else {
				for each( var obj:Object in args ) {
					msg += String( obj );
				}
			}

			if( _oldMessage !== msg ) {
				_textArea.getTextField().text = msg;
			}

			_oldMessage = msg;
		}
	}
}
