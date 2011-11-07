package com.li.agalthemean.ui.components
{

	import org.aswing.BorderLayout;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;

	public class JLabeledInputText extends JPanel
	{
		public var label:JLabel;
		public var input:JTextField;

		public function JLabeledInputText( labelMsg:String, inputMsg:String ) {
			super();

			setLayout( new BorderLayout() );
			append( label = new JLabel( labelMsg ), BorderLayout.WEST );
			append( input = new JTextField( inputMsg ), BorderLayout.CENTER );
		}
	}
}
