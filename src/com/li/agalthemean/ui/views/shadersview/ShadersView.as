package com.li.agalthemean.ui.views.shadersview
{

	import org.aswing.AsWingConstants;
	import org.aswing.JSplitPane;

	public class ShadersView extends JSplitPane
	{
		public var vertEditor:AgalEditor;
		public var fragEditor:AgalEditor;

		public function ShadersView() {

			super();

			setName( "shaders" );
			setOrientation( AsWingConstants.VERTICAL );

			append( vertEditor = new AgalEditor( "VERTEX AGAL" ) );
			append( fragEditor = new AgalEditor( "FRAGMENT AGAL" ) );
		}
	}
}
