package com.li.agalthemean.ui.views.constantsview
{

	import org.aswing.AsWingConstants;
	import org.aswing.JSplitPane;

	public class ConstantsView extends JSplitPane
	{
		public var vertConstants:VertexConstantsPanel;
		public var fragConstants:FragmentConstantsPanel;

		public function ConstantsView() {

			super();

			setName( "constants" );
			setOrientation( AsWingConstants.VERTICAL );

			append( vertConstants = new VertexConstantsPanel() );
			append( fragConstants = new FragmentConstantsPanel() );
		}
	}
}
