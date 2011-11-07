package br.hellokeita.utils{
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	public class TextFieldColor {
		
		private static const byteToPerc:Number = 1 / 0xff;

		private var $textField:TextField;
		private var $textColor:uint;
		private var $selectedColor:uint;
		private var $selectionColor:uint;
		private var colorMatrixFilter:ColorMatrixFilter;
		
		public function TextFieldColor(textField:TextField, textColor:uint = 0x000000, selectionColor:uint = 0x000000, selectedColor: uint = 0x000000) {
			
			$textField = textField;
			
			colorMatrixFilter = new ColorMatrixFilter();
			$textColor = textColor;
			$selectionColor = selectionColor;
			$selectedColor = selectedColor;
			updateFilter();
		}
		
		public function set textField(tf:TextField):void {
			$textField = tf;
		}
		public function get textField():TextField {
			return $textField;
		}
		public function set textColor(c:uint):void {
			$textColor = c;
			updateFilter();
		}
		public function get textColor():uint {
			return $textColor;
		}
		public function set selectionColor(c:uint):void {
			$selectionColor = c;
			updateFilter();
		}
		public function get selectionColor():uint {
			return $selectionColor;
		}
		public function set selectedColor(c:uint):void {
			$selectedColor = c;
			updateFilter();
		}
		public function get selectedColor():uint {
			return $selectedColor;
		}
		
		private function updateFilter():void {
			
			$textField.textColor = 0xff0000;

			var o:Array = splitRGB($selectionColor);
			var r:Array = splitRGB($textColor);
			var g:Array = splitRGB($selectedColor);
			
			var ro:int = o[0];
			var go:int = o[1];
			var bo:int = o[2];
			
			var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
			var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
			var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;

			var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
			var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
			var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
			
			colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
			
			$textField.filters = [colorMatrixFilter];
			
		}
		
		private static function splitRGB(color:uint):Array {
			
			return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
		}
	}
}