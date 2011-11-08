package com.li.agalthemean.utils
{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;

	import org.osflash.signals.Signal;

	public class ObjPrompt
	{
		private var _fileReference:FileReference;

		public var completeSignal:Signal;

		public function ObjPrompt() {

			_fileReference = new FileReference();
			_fileReference.addEventListener( Event.SELECT, selectHandler );
			_fileReference.addEventListener( Event.COMPLETE, completeHandler );

			var fileFilter:FileFilter = new FileFilter( "Obj Files", "*.obj;" );
			_fileReference.browse( [fileFilter] );

			completeSignal = new Signal( ByteArray );
		}

		private function selectHandler( event:Event ):void {
			_fileReference.load();
		}

		private function completeHandler( event:Event ):void {
			completeSignal.dispatch( _fileReference.data );
		}
	}
}