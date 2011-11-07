package com.li.agalthemean.ui.views.samplersview
{

	import com.li.agalthemean.ui.components.JRegisterPopUp;
	import com.li.minimole.materials.agal.data.TextureMipMappingType;
	import com.li.minimole.materials.agal.registers.FragmentSampler;

	import org.aswing.JCheckBox;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;

	public class EditSamplerPopUp extends JRegisterPopUp
	{
		var mipChk:JCheckBox;

		public function EditSamplerPopUp( sampler:FragmentSampler ) {

			var editor:SamplerBmdEditor = new SamplerBmdEditor( sampler );
			super( sampler, editor );

			packs = false;

			setSize( new IntDimension( 400, 500 ) );
			editor.imageChangedSignal.add( onEditorImageChanged );

			mipChk = new JCheckBox( "create mip maps" );
			mipChk.setSelected( sampler.flags.indexOf( TextureMipMappingType.MIP_NEAREST ) != -1 );

			topHolder.append( mipChk );

			mipChk.addEventListener( AWEvent.ACT, mipChkChangedHandler )
		}

		private function mipChkChangedHandler( event:AWEvent ):void {

			var sampler:FragmentSampler = FragmentSampler( register );

			var index:int = sampler.flags.indexOf( TextureMipMappingType.MIP_NEAREST );
			var selected:Boolean = mipChk.isSelected();

			if( selected ) {
				if( index == -1 ) {
					sampler.flags.push( TextureMipMappingType.MIP_NEAREST );
				}
			}
			else {
				if( index != -1 ) {
					sampler.flags.splice( index, 1 );
				}
			}

			sampler.texture = null;
		}

		private function onEditorImageChanged( imageHeight:Number ):void {
			setSize( new IntDimension( 400, imageHeight + 100 ) );
		}
	}
}
