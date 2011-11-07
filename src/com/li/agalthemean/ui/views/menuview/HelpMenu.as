package com.li.agalthemean.ui.views.menuview
{

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import org.aswing.JFrame;
	import org.aswing.JMenu;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.JTextArea;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntPoint;

	public class HelpMenu extends JMenu
	{
		public function HelpMenu() {

			super( "Help" );

			var help1:JMenuItem = new JMenuItem( "Program3D Documentation" );
			var help2:JMenuItem = new JMenuItem( "AGAL OpCodes" );
			var help3:JMenuItem = new JMenuItem( "AGAL Limits" );
			var help4:JMenuItem = new JMenuItem( "Useful Links" );

			append( help1 );
			append( help2 );
			append( help3 );
			append( help4 );

			help1.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				navigateToURL( new URLRequest( "http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/display3D/Program3D.html" ) );
			});

			help2.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				showTextPopUp( "AGAL OpCodes", getOpCodesText() );
			});

			help3.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				showTextPopUp( "AGAL Limits", getLimitsText() );
			});

			help4.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				showTextPopUp( "Useful Links", getLinksText() );
			});
		}

		// -----------------------
		// strings
		// -----------------------

		private function getLinksText():String {
			var str:String = "<p><b>Useful Links</b></p>" +
					"<li><a href='http://iflash3d.com/shaders/my-name-is-agal-i-come-from-adobe-1/' target='_blank'>My name is AGAL 1/2</a></li>" +
					"<li><a href='http://iflash3d.com/shaders/my-name-is-agal-i-come-from-adobe-2/' target='_blank'>My name is AGAL 2/2</a></li>" +
					"<li><a href='http://www.adobe.com/devnet/flashplayer/articles/what-is-agal.html' target='_blank'>What is AGAL?</a></li>";
			return str;
		}

		private function getLimitsText():String {
			var str:String = "<p><b>Vertex Shaders</b></p>" +
					"<br>" +
					"<li>Vertex Attributes ( vaN ): 8</li>" +
					"<li>Vertex Constants ( vcN ): 128</li>" +
					"<li>Vertex Temporaries ( vtN ): 8</li>" +
					"<li>Varying ( v ): 8</li>" +
					"<li>Output ( op ): 1</li>" +
					"<br>" +
					"<p><b>Fragment Shaders</b></p>" +
					"<br>" +
					"<li>Fragment Constants ( fcN ): 28</li>" +
					"<li>Fragment Temporaries ( ftN ): 8</li>" +
					"<li>Fragment Samplers ( fsN ): 8</li>" +
					"<li>Varying ( v ): 8</li>" +
					"<li>Output ( oc ): 1</li>" +
					"<br>" +
					"<p><b>Textures</b></p>" +
					"<br>" +
					"<li>Max side pixels: 2048</li>" +
					"<li>Sides must be a power of 2.</li>" +
					"<br>" +
					"<p>Note: This application processes the images you upload" +
					" to ensure the previous 2 points are met.</p>";
			return str;
		}

		private function getOpCodesText():String {
			var str:String = "<p><b>Supported OpCodes</p></b>" +
					"<br>" +
					"<li>mov (move) move data from source1 to destination, componentwise</li>" +
					"<li>add (add) destination = source1 + source2, componentwise</li>" +
					"<li>sub (subtract) destination = source1 - source2, componentwise</li>" +
					"<li>mul (multiply) destination = source1 * source2, componentwise</li>" +
					"<li>div (divide) destination = source1 / source2, componentwise</li>" +
					"<li>rcp (reciprocal) destination = 1/source1, componentwise</li>" +
					"<li>min (minimum) destination = minimum(source1,source2), componentwise</li>" +
					"<li>max (maximum) destination = maximum(source1,source2), componentwise</li>" +
					"<li>frc (fractional) destination = source1 - (float)floor(source1), componentwise</li>" +
					"<li>sqt (square root) destination = sqrt(source1), componentwise</li>" +
					"<li>rsq (reciprocal root) destination = 1/sqrt(source1), componentwise</li>" +
					"<li>pow (power) destination = pow(source1,source2), componentwise</li>" +
					"<li>log (logarithm) destination = log_2(source1), componentwise</li>" +
					"<li>exp (exponential) destination = 2^source1, componentwise</li>" +
					"<li>nrm (normalize) destination = normalize(source1), componentwise " +
					"(produces only a 3 component result, destination must be masked to .xyz or less)</li>" +
					"<li>sin (sine) destination = sin(source1), componentwise</li>" +
					"<li>cos (cosine) destination = cos(source1), componentwise</li>" +
					"<li>crs (cross product) cross product vector operation" +
					"(produces only a 3 component result, destination must be masked to .xyz or less)</li>" +
					"<li>dp3 (dot product) destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z</li>" +
					"<li>dp4 (dot product) destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z + source1.w*source2.w</li>" +
					"<li>abs (absolute) destination = abs(source1), componentwise</li>" +
					"<li>neg (negate) destination = -source1, componentwise</li>" +
					"<li>sat (saturate) destination = maximum(minimum(source1,1),0), componentwise</li>" +
					"<li>sge (set-if-greater-equal) destination = source1 = source2 ? 1 : 0, componentwise</li>" +
					"<li>slt (set-if-less-than) destination = source1 &lt; source2 ? 1 : 0, componentwise</li>" +
					"<li>seq (set-if-equal) destination = source1 == source2 ? 1 : 0, componentwisen</li>" +
					"<li>sne (set-if-not-equal) destination = source1 != source2 ? 1 : 0, componentwise</li>" +
					"<li>m33 (multiply matrix 3x3) 3x3 matrix multiplication" +
					"(produces only a 3 component result, destination must be masked to .xyz or less)</li>" +
					"<li>m44 (multiply matrix 4x4) 4x4 matrix multiplication</li>" +
					"<li>m34 (multiply matrix 3x4) 3x4 matrix multiplication" +
					"(produces only a 3 component result, destination must be masked to .xyz or less)</li>" +
					"<li>kil (kill/discard) -fragment shader only- If single scalar source component is less than zero, fragment is discarded" +
					"and not drawn to the frame buffer. (Destination register must be set to all 0)</li>" +
					"<li>tex (texture sample) -fragment shader only- destination equals load from texture source2 at coordinates source1. " +
					"In this case, source2 must be in sampler format.</li>" +
					"";
			return str;
		}

		// -----------------------
		// pop ups
		// -----------------------

		private function showTextPopUp( title:String, text:String ):void {

			var pop:JFrame = new JFrame( null, title );

			var content:JPanel = new JPanel();
			content.append( wrapText( text ) );

			pop.setContentPane( content );

			pop.setResizable( false );

			pop.pack();
			pop.show();

			centerPopUp( pop );
		}

		private function centerPopUp( popUp:JFrame ):void {
			popUp.setLocation( new IntPoint(
					stage.stageWidth / 2 - popUp.width / 2,
					stage.stageHeight / 2 - popUp.height / 2
			) );
		}

		private function wrapText( text:String ):JTextArea {
			var textArea:JTextArea = new JTextArea();
			textArea.setEditable( false );
			textArea.setHtmlText( text );
			return textArea;
		}
	}
}
