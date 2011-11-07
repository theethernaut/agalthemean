package com.li.agalthemean.ui
{

	import com.li.agalthemean.ui.views.attributesview.AttributesView;
	import com.li.agalthemean.ui.views.constantsview.ConstantsView;
	import com.li.agalthemean.ui.views.logview.LogView;
	import com.li.agalthemean.ui.views.menuview.MenuView;
	import com.li.agalthemean.ui.views.modelview.ModelView;
	import com.li.agalthemean.ui.views.renderview.RenderView;
	import com.li.agalthemean.ui.views.samplersview.SamplersView;
	import com.li.agalthemean.ui.views.shadersview.ShadersView;

	import flash.events.Event;
	import flash.utils.setTimeout;

	import org.aswing.AsWingConstants;
	import org.aswing.AsWingManager;
	import org.aswing.BorderLayout;
	import org.aswing.JPanel;
	import org.aswing.JSplitPane;
	import org.aswing.JTabbedPane;
	import org.aswing.LookAndFeel;
	import org.aswing.UIManager;
	import org.aswing.geom.IntDimension;
	import org.aswing.paling.PalingLAF;

	public class MainView extends JPanel
	{
		public var shadersView:ShadersView;
		public var renderView:RenderView;
		public var attributesView:AttributesView;
		public var samplersView:SamplersView;
		public var logView:LogView;
		public var modelView:ModelView;
		public var constantsView:ConstantsView;

		// fonts
		[Embed(source="../../../../../assets/fonts/inconsolata.ttf", embedAsCFF="false", fontName="Inconsolata", mimeType="application/x-font")]
		public var InconsolataFont:Class;

		public function MainView() {

			super();
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( event:Event ):void {

			AsWingManager.setRoot( this );

			// TODO: mouse exit locks drag

			var lookAndFeel:LookAndFeel = new PalingLAF();
			UIManager.setLookAndFeel( lookAndFeel );

			setLayout( new BorderLayout() );
			setSize( new IntDimension( stage.stageWidth, stage.stageHeight ) );

			// menu
			append( new MenuView(), BorderLayout.NORTH );

			// wrap left/right
			var mainSplitter:JSplitPane = new JSplitPane();
			mainSplitter.setConstraints( BorderLayout.CENTER );
			mainSplitter.setDividerLocation( stage.stageWidth / 2 - 500, true );
			append( mainSplitter, BorderLayout.CENTER );

			// left
			var leftPanel:JSplitPane = new JSplitPane();
			leftPanel.setConstraints( BorderLayout.CENTER );
			leftPanel.setOrientation( AsWingConstants.VERTICAL );
			mainSplitter.append( leftPanel );
			leftPanel.append( renderView = new RenderView() );
			leftPanel.append( logView = new LogView() );
			setTimeout( function():void {
				leftPanel.setDividerLocation( stage.stageHeight - 100, true );
				logView.visible = true;
			}, 50); // TODO: left panel's divider position doesn't seem to be updated otherwise

			// right
			var rightPanel:JTabbedPane = new JTabbedPane();
			mainSplitter.append( rightPanel );
			rightPanel.append( shadersView = new ShadersView() );
			rightPanel.append( constantsView = new ConstantsView() );
			rightPanel.append( attributesView = new AttributesView() );
			rightPanel.append( samplersView = new SamplersView() );
			rightPanel.append( modelView = new ModelView() );

			stage.addEventListener( Event.RESIZE, stageResizeHandler );
		}

		private function stageResizeHandler( event:Event ):void {

			setSize( new IntDimension( stage.stageWidth, stage.stageHeight ) );
			validate();
		}
	}
}
