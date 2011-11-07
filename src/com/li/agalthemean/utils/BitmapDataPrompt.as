package com.li.agalthemean.utils
{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	import org.osflash.signals.Signal;

	public class BitmapDataPrompt
	{
		private var _fileReference:FileReference;
		private var _loader:Loader;

		public var completeSignal:Signal;

		public function BitmapDataPrompt() {

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.INIT, loaderReadyHandler );

			_fileReference = new FileReference();
			_fileReference.addEventListener( Event.SELECT, selectHandler );
			_fileReference.addEventListener( Event.COMPLETE, completeHandler );

			var fileFilter:FileFilter = new FileFilter( "Images", "*.jpg;*.jpeg;*.gif;*.png" );
			_fileReference.browse( [fileFilter] );

			completeSignal = new Signal( BitmapData );
		}

		private function selectHandler( event:Event ):void {
			_fileReference.load();
		}

		private function completeHandler( event:Event ):void {
			_loader.loadBytes( _fileReference.data );
		}

		private function loaderReadyHandler( event:Event ):void {

			var bmd:BitmapData = new BitmapData( _loader.width, _loader.height, false, 0 );
			bmd.draw( _loader );

			completeSignal.dispatch( bmd );
		}
	}
}