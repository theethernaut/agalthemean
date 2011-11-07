package com.li.agalthemean.ui.views.renderview
{

	import com.li.minimole.camera.controller.OrbitCameraController;
	import com.li.minimole.core.Mesh;
	import com.li.minimole.core.View3D;
	import com.li.minimole.materials.agal.AGALMaterial;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	import net.hires.debug.Stats;

	import org.aswing.JPanel;
	import org.aswing.event.MovedEvent;
	import org.aswing.event.ResizedEvent;
	import org.aswing.geom.IntPoint;

	public class RenderView extends JPanel
	{
		public var view:View3D;
		public var cameraController:OrbitCameraController;
		public var stats:Stats;

		public function RenderView() {

			super();

			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( event:Event ):void {

			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );

			var loc:IntPoint = getGlobalLocation();
			view = new View3D( 800, 600, loc.x, loc.y );
//			view.clearColor = new RGB( 0, 0, 0, 1 );
			view.y = y;
			view.visible = false;
			addChild( view );

			stats = new Stats();
			addChild( stats );

			cameraController = new OrbitCameraController( view.camera );

			view.addEventListener( MouseEvent.MOUSE_DOWN, viewMouseDownHandler );
			view.addEventListener( MouseEvent.MOUSE_UP, viewMouseUpHandler );
			view.addEventListener( MouseEvent.MOUSE_OUT, viewMouseUpHandler );
			view.addEventListener( Event.MOUSE_LEAVE, viewMouseUpHandler );
			view.addEventListener( MouseEvent.MOUSE_MOVE, viewMouseMoveHandler );
			view.addEventListener( MouseEvent.MOUSE_WHEEL, viewMouseWheelHandler );

			addEventListener( Event.ENTER_FRAME, enterframeHandler );

			DefaultAssetStore.instance.modelRequestedSignal.add( onModelRequested );

			addEventListener( MovedEvent.MOVED, contentPanelMovedHandler );
			addEventListener( ResizedEvent.RESIZED, contentResizedHandler );
		}

		private function onModelRequested( model:Mesh ):void {
			view.scene.addChild( model );
		}

		private function contentPanelMovedHandler( event:MovedEvent ):void {

			var loc:IntPoint = getGlobalLocation();
			view.canvasX = loc.x;
			view.canvasY = loc.y;
		}

		private function contentResizedHandler( event:ResizedEvent ):void {

			if( width > 0 && height > 0 ) {
				view.visible = true; // TODO: visible not doing anything?
				stats.x = width - 70;
				view.canvasWidth = width;
				view.canvasHeight = height;
				redrawCapture( width, height );
			}

			contentPanelMovedHandler( null );

		}

		private function redrawCapture( width:Number, height:Number ):void {
			view.graphics.clear();
			view.graphics.beginFill( 0x00FF00, 0.001 );
			view.graphics.drawRect( 0, 0, width, height );
			view.graphics.endFill();
		}

		private function enterframeHandler( evt:Event ):void {
			cameraController.update();
			view.scene.light.position = view.camera.position;
			view.render();
		}

		private function viewMouseWheelHandler( evt:MouseEvent ):void {
			cameraController.mouseWheel( evt.delta );
		}

		private function viewMouseMoveHandler( evt:MouseEvent ):void {
			cameraController.mouseMove( mouseX, mouseY );
		}

		private function viewMouseDownHandler( evt:MouseEvent ):void {
			cameraController.mouseDown();
		}

		private function viewMouseUpHandler( evt:Event ):void {
			cameraController.mouseUp();
		}
	}
}
