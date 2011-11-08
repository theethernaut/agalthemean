package com.li.agalthemean.ui.views.modelview
{

	import com.li.agalthemean.ui.components.JTitledPanel;
	import com.li.agalthemean.ui.views.modelview.XYZSetterPopUp;
	import com.li.agalthemean.ui.views.renderview.DefaultAssetStore;
	import com.li.agalthemean.utils.ObjPrompt;
	import com.li.minimole.core.Core3D;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.Scene3D;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.primitives.Cube;
	import com.li.minimole.primitives.CubeR;

	import flash.utils.ByteArray;

	import org.aswing.JButton;
	import org.aswing.JComboBox;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.AWEvent;
	import org.aswing.event.FrameEvent;
	import org.aswing.geom.IntPoint;

	public class ModelView extends JTitledPanel
	{
		private var _model:Mesh;
		private var _positionBtn:JButton;
		private var _rotationBtn:JButton;
		private var _scaleBtn:JButton;
		private var _modelCombo:JComboBox;

		public function ModelView() {

			super( "MODEL" );

			setName( "model" );

			_modelCombo = new JComboBox( _models );
			_modelCombo.setSelectedIndex( 0 );

			_positionBtn = new JButton( "Position" );
			_rotationBtn = new JButton( "Rotation" );
			_scaleBtn = new JButton( "Scale" );

			var geometry:JPanel = new JPanel( new SoftBoxLayout( SoftBoxLayout.Y_AXIS ) );
			geometry.setBorder( new TitledBorder( null, "Geometry" ) );
			geometry.append( _modelCombo );

			var transform:JPanel = new JPanel( new SoftBoxLayout( SoftBoxLayout.Y_AXIS ) );
			transform.setBorder( new TitledBorder( null, "Transform" ) );
			transform.append( _positionBtn );
			transform.append( _rotationBtn );
			transform.append( _scaleBtn );

			contentPanel.setLayout( new SoftBoxLayout( SoftBoxLayout.Y_AXIS ) );
			contentPanel.append( geometry );
			contentPanel.append( transform );

			_modelCombo.addEventListener( AWEvent.ACT, modelComboChangedHandler );

			_positionBtn.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				var pop:XYZSetterPopUp = new XYZSetterPopUp( XYZSetterPopUp.POSITION, _model );
				pop.addEventListener( FrameEvent.FRAME_CLOSING, popUpClosedHandler );
				_positionBtn.setEnabled( false );
				centerPopUp( pop );
			});

			_rotationBtn.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				var pop:XYZSetterPopUp = new XYZSetterPopUp( XYZSetterPopUp.ROTATION, _model );
				pop.addEventListener( FrameEvent.FRAME_CLOSING, popUpClosedHandler );
				_rotationBtn.setEnabled( false );
				centerPopUp( pop );
			});

			_scaleBtn.addEventListener( AWEvent.ACT, function( event:AWEvent ):void {
				var pop:XYZSetterPopUp = new XYZSetterPopUp( XYZSetterPopUp.SCALE, _model );
				pop.addEventListener( FrameEvent.FRAME_CLOSING, popUpClosedHandler );
				_scaleBtn.setEnabled( false );
				centerPopUp( pop );
			});
		}

		private function popUpClosedHandler( event:FrameEvent ):void {
			var target:XYZSetterPopUp = event.target as XYZSetterPopUp;
			switch( target.type ) {
				case XYZSetterPopUp.POSITION: {
					_positionBtn.setEnabled( true );
					break;
				}
				case XYZSetterPopUp.ROTATION: {
					_rotationBtn.setEnabled( true );
					break;
				}
				case XYZSetterPopUp.SCALE: {
					_scaleBtn.setEnabled( true );
					break;
				}
			}
		}

		private function centerPopUp( popUp:JFrame ):void {
			popUp.setLocation( new IntPoint(
					stage.stageWidth / 2 - popUp.width / 2,
					stage.stageHeight / 2 - popUp.height / 2
			) );
		}

		private var _models:Array = [ "Head", "Hard Head", "Cube", "Sphere", "Hard Torus", "Plane", "Load Obj" ];

		private function modelComboChangedHandler( event:AWEvent ):void {

			Core3D.instance.scene.removeChild( _model );

			switch( _modelCombo.getSelectedIndex() ) {
				case 0: {
					_model = DefaultAssetStore.instance.getHeadModel();
					break;
				}
				case 1: {
					_model = DefaultAssetStore.instance.getHeadModel();
					_model.forceVertexNormalsToTriangleNormals();
					break;
				}
				case 2: {
					_model = DefaultAssetStore.instance.getCubeModel();
					break;
				}
				case 3: {
					_model = DefaultAssetStore.instance.getSphereModel();
					break;
				}
				case 4: {
					_model = DefaultAssetStore.instance.getTorusModel();
					break;
				}
				case 5: {
					_model = DefaultAssetStore.instance.getPlaneModel();
					break;
				}
				case 6: {
					var prompt:ObjPrompt = new ObjPrompt();
					prompt.completeSignal.addOnce( onObjDataFetched );
				}
			}
		}

		private function onObjDataFetched( data:ByteArray ):void {
			_model = DefaultAssetStore.instance.getLoadedModel( data );
		}

		public function set model( model:Mesh ):void {
			_model = model;
		}
	}
}
