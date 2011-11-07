package com.li.agalthemean.ui.components
{

	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.JLabel;
	import org.aswing.JPanel;

	public class JTitledPanel extends JPanel
	{
		public var headerPanel:JPanel;
		public var contentPanel:JPanel;

		public function JTitledPanel( name:String ) {

			super( new BorderLayout() );

			headerPanel = new JPanel( new BorderLayout() );
			headerPanel.setConstraints( BorderLayout.NORTH );
			var title:JLabel = new JLabel( name );
			title.setConstraints( BorderLayout.WEST );
			headerPanel.append( title );

			contentPanel = new JPanel( new BoxLayout( BoxLayout.Y_AXIS ) );
			contentPanel.setConstraints( BorderLayout.CENTER );

			append( headerPanel );
			append( contentPanel );
		}
	}
}
