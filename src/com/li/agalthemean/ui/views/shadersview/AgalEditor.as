package com.li.agalthemean.ui.views.shadersview
{

	import com.li.agalthemean.ui.components.JTitledPanel;

	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.aswing.ASFont;
	import org.aswing.BorderLayout;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.event.ResizedEvent;
	import org.osflash.signals.Signal;

	public class AgalEditor extends JTitledPanel
	{
		private var _textArea:JTextArea;
		private var _lineNumbersArea:JTextArea;
		private var _textsContainer:JPanel;
		private var _areaScroll:JScrollPane;

		public var textChangedSignal:Signal;

		public function AgalEditor( name:String ) {

			super( name );

			textChangedSignal = new Signal( String );

			// TODO: text stays skinny whn expanding panel a lo to the left, is fixed when text changes

			// text
			_textArea = new JTextArea();
//			var fontOptions:ASFontAdvProperties = new ASFontAdvProperties( true, AntiAliasType.ADVANCED, GridFitType.PIXEL, 0, 200 );
			var inconsolata:ASFont = new ASFont( "Inconsolata", 14/*, true, false, false, fontOptions*/ );
			_textArea.setFont( inconsolata );
//			_textArea.setOpaque( true ); // TODO: not working with paling laf
//			_textArea.setBackground( new ASColor( 0x0D1622 ) );
//			var agalAreaColor:TextFieldColor = new TextFieldColor( _textArea.getTextField() );
//			agalAreaColor.selectedColor = 0xFFFFFF;
//			agalAreaColor.selectionColor = 0x1E39F6;
//			agalAreaColor.textColor = 0xFFFFFF;
			_textArea.setWidth( 1000 );

			// TODO: line numbers dont show for short shaders

			// line numbers
			_lineNumbersArea = new JTextArea();
			_lineNumbersArea.setFont( inconsolata );
			_lineNumbersArea.setEditable( false );
			_lineNumbersArea.mouseEnabled = _lineNumbersArea.mouseChildren = false;
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.RIGHT;
			_lineNumbersArea.setDefaultTextFormat( format );

			_textsContainer = new JPanel( new BorderLayout() );
			_textsContainer.append( _lineNumbersArea, BorderLayout.WEST );
			_textsContainer.append( _textArea, BorderLayout.CENTER );
			_areaScroll = new JScrollPane( _textsContainer, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER );

			contentPanel.append( _areaScroll, BorderLayout.CENTER );

			_textArea.getTextField().addEventListener( Event.CHANGE, onTextChanged );

			contentPanel.addEventListener( ResizedEvent.RESIZED, resizedHandler );
		}

		private function resizedHandler( event:ResizedEvent ):void {
			updateDims();
		}

		public function set agalText( value:String ):void {

			_textArea.getTextField().text = lineBreaksToReturns( value );
			updateLineNumbers();
			updateDims();
		}

		private function updateDims():void {
			// ensure text fits the panel
			var w:Number = contentPanel.getWidth() - _lineNumbersArea.getWidth() - 15;
			if( _textArea.getWidth() < w ) {
				_textArea.setPreferredWidth( w );
			}
			if( _textArea.getHeight() < contentPanel.getHeight() ) {
				_textArea.setPreferredHeight( contentPanel.getHeight()  );
			}
		}

		private function onTextChanged( event:Event ):void {

			var parsedAGALText:String = returnsToLineBreaks( _textArea.getTextField().text );
			textChangedSignal.dispatch( parsedAGALText );
			updateLineNumbers();

		}

		private function updateLineNumbers():void {

			_lineNumbersArea.setText( getLineNumbersString( _textArea.getTextField().numLines ) );

		}

		// -----------------------
		// string utils
		// -----------------------

		private function getLineNumbersString( maxLine:uint ):String {
			var str:String = "";
			for( var i:uint = 1; i < maxLine; ++i ) {
				str += i + "\n";
			}
			return str;
		}

		private function returnsToLineBreaks( value:String ):String {
			return value.replace( /\r/g, "\n" );
		}

		private function lineBreaksToReturns( value:String ):String {
			return value.replace( /\n/g, "\r" );
		}
	}
}
