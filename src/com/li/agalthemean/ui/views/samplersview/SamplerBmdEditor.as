package com.li.agalthemean.ui.views.samplersview
{

	import com.li.agalthemean.utils.BitmapDataPrompt;
	import com.li.minimole.core.utils.TextureUtils;
	import com.li.minimole.materials.agal.registers.samplers.FragmentSampler;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import org.aswing.BorderLayout;

	import org.aswing.JButton;

	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;
	import org.osflash.signals.Signal;

	public class SamplerBmdEditor extends JPanel
	{
		public var sampler:FragmentSampler;
		public var imageChangedSignal:Signal;

		private var _bitmap:Bitmap;

		public function SamplerBmdEditor( sampler:FragmentSampler ) {

			this.sampler = sampler;

			imageChangedSignal = new Signal( Number );

			// change btn
			var changeBtn:JButton = new JButton( "change image" );
			changeBtn.addEventListener( AWEvent.ACT, changeBtnClickedHandler );

			// image
			// display bitmap
			var bmd:BitmapData;
			if( sampler.value != null ) {
				bmd = sampler.value;
			}
			else {
				bmd = new BitmapData( 1024, 1024, false, 0 );
				bmd.perlinNoise( 256, 256, 8, 0, false, true, 7, true );
				sampler.value = bmd;
			}
			var bmdHolder:JPanel = new JPanel();
			bmdHolder.setSize( new IntDimension( 400, 400 ) );
			_bitmap = new Bitmap( bmd );
			fitBitmap();
			bmdHolder.addChild( _bitmap );

			setLayout( new BorderLayout() );
			append( changeBtn, BorderLayout.NORTH );
			append( bmdHolder, BorderLayout.CENTER );
		}

		private function changeBtnClickedHandler( event:AWEvent ):void {

			var prompt:BitmapDataPrompt = new BitmapDataPrompt();
			prompt.completeSignal.addOnce( onBitmapDataFetched );

		}

		private function onBitmapDataFetched( bmd:BitmapData ):void {

			bmd = TextureUtils.ensurePowerOf2( bmd );

			_bitmap.bitmapData = null;
			_bitmap.scaleY = _bitmap.scaleX = 1;
			_bitmap.bitmapData = bmd;
			fitBitmap();
			trace( "www " + _bitmap.width, bmd.width );

			sampler.value = bmd;
			sampler.texture = null; // TODO: context3D loses a texture resource here?
		}

		private function fitBitmap():void {
			_bitmap.width = 400;
			_bitmap.scaleY = _bitmap.scaleX;
			imageChangedSignal.dispatch( _bitmap.height );
		}
	}
}
