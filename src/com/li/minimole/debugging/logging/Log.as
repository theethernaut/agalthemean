package com.li.minimole.debugging.logging
{

	public class Log
	{
		private static var _instance:Log;

		public function Log() {
		}

		public static function get instance():Log {
			if( !_instance )
				_instance = new Log();
			return _instance;
		}

		public static var infoTraceMethod:Function;

		public static function info( ...args ):void {
			if( infoTraceMethod != null ) infoTraceMethod( args );
			trace( "[minimole] INFO: ", args );
		}

		public static var errorTraceMethod:Function;

		public static function error( ...args ):void {
			if( errorTraceMethod != null ) errorTraceMethod( args );
			trace( "[minimole] ERROR: ", args );
		}

		public static function clearAll():void {
			if( infoTraceMethod != null ) infoTraceMethod();
			if( errorTraceMethod != null ) errorTraceMethod();
		}
	}
}
