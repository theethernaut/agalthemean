package com.li.minimole.core.utils
{

	import flash.display.BitmapData;
	import flash.display.BitmapData;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class TextureUtils
	{
		private static var _matrix:Matrix = new Matrix();
		private static var _rect:Rectangle = new Rectangle();

		public static function generateMipMaps( texture:TextureBase, bitmap:BitmapData ):void {
			var w:uint = bitmap.width;
			var h:uint = bitmap.height;
			var i:uint;

			_rect.width = w;
			_rect.height = h;

			var mipmap:BitmapData = new BitmapData( w, h, false );

			while( w >= 1 || h >= 1 ) {

//				trace( "creating mipMap: " + w + ", " + h );

				_matrix.a = _rect.width / bitmap.width;
				_matrix.d = _rect.height / bitmap.height;

				mipmap.draw( bitmap, _matrix, null, null, null, true );

				if( texture is Texture )
					Texture( texture ).uploadFromBitmapData( mipmap, i++ );

				w >>= 1;
				h >>= 1;

				_rect.width = w > 1 ? w : 1;
				_rect.height = h > 1 ? h : 1;
			}
		}

		public static function ensurePowerOf2( bmd:BitmapData ):BitmapData {
			var lowerWidth:uint = nearestInferiorPowerOf2( bmd.width );
			var lowerHeight:uint = nearestInferiorPowerOf2( bmd.height );

			var adjustedBmd:BitmapData = new BitmapData( lowerWidth, lowerHeight, false, 0 );
			adjustedBmd.draw( bmd );

			return adjustedBmd;
		}

		public static function nearestInferiorPowerOf2( value:uint ):uint {
			var result:uint = 0;
			var power:uint = 0;

			while(result <= value) {
				power++;
				result = Math.pow( 2, power );
			}

			power--;
			result = Math.pow( 2, power );

			return result;
		}

		public static function flipBmd( bmd:BitmapData, flipX:Boolean = true, flipY:Boolean = false ):BitmapData {
			var flipBmd:BitmapData = new BitmapData( bmd.width, bmd.height, false, 0xFF0000 );
			var matrix:Matrix = new Matrix();
			matrix.scale( flipX ? -1 : 1, flipY ? -1 : 1 );
			matrix.translate( flipX ? bmd.width : 0, flipY ? bmd.height : 0 );
			flipBmd.draw( bmd, matrix );
			return flipBmd;
		}
	}
}
