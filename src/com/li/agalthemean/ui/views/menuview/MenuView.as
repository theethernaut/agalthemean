package com.li.agalthemean.ui.views.menuview
{

	import com.li.agalthemean.AGALtheMEaNConstants;
	import com.li.agalthemean.ui.views.renderview.DefaultAssetStore;

	import org.aswing.ASColor;

	import org.aswing.BorderLayout;
	import org.aswing.JLabel;
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;

	public class MenuView extends JPanel
	{
		public function MenuView() {

			super();

			// TODO: add shortcuts or "accelerators" - other parts of the IDE could have shortcuts as well

			setLayout( new BorderLayout() );

			setOpaque( true );
			setBackground( new ASColor( 0xFFFFFF ) );

			var menuBar:JMenuBar = new JMenuBar();
			menuBar.append( createFileMenu() );
			menuBar.append( new HelpMenu() );

			append( menuBar, BorderLayout.WEST );
			append( new JLabel( AGALtheMEaNConstants.appNameAndVersion ), BorderLayout.EAST );
		}

		private function createFileMenu():JMenu {

			var menu:JMenu = new JMenu( "File" );

			var file1:JMenu = new JMenu( "New Shader" );

			var file1_1:JMenuItem = new JMenuItem( "Empty Shader" );
			var file1_2:JMenuItem = new JMenuItem( "Basic Shader" );
			var file1_3:JMenuItem = new JMenuItem( "Bitmap Shader" );
			var file1_4:JMenuItem = new JMenuItem( "Color Phong Shader" );
			var file1_5:JMenuItem = new JMenuItem( "Bitmap Phong Shader" );
			var file1_6:JMenuItem = new JMenuItem( "Advanced Bitmap Phong Shader" );
			var file1_7:JMenuItem = new JMenuItem( "Enviro Spherical Shader" );

			file1_1.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getEmptyMaterial();
			});

			file1_2.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getSimplestMaterial();
			});

			file1_3.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getBitmapMaterial();
			});

			file1_4.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getPhongColorMaterial();
			});

			file1_5.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getBasicPhongBitmapMaterial();
			});

			file1_6.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getAdvancedPhongBitmapMaterial();
			});

			file1_7.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				DefaultAssetStore.instance.getEnviroSphericalMaterial();
			});

			file1.append( file1_1 );
			file1.append( file1_2 );
			file1.append( file1_3 );
			file1.append( file1_4 );
			file1.append( file1_5 );
			file1.append( file1_6 );
			file1.append( file1_7 );

			menu.append( file1 );

			return menu;
		}
	}
}
