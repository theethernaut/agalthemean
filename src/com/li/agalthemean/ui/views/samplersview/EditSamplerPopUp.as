package com.li.agalthemean.ui.views.samplersview
{

	import com.li.agalthemean.ui.components.JRegisterPopUp;
	import com.li.minimole.materials.agal.vo.registers.FragmentSampler;

	import org.aswing.geom.IntDimension;

	public class EditSamplerPopUp extends JRegisterPopUp
	{
		public function EditSamplerPopUp( sampler:FragmentSampler ) {

			var editor:SamplerBmdEditor = new SamplerBmdEditor( sampler );
			super( sampler, editor );

			packs = false;

			setSize( new IntDimension( 400, 500 ) );
			editor.imageChangedSignal.add( onEditorImageChanged );
		}

		private function onEditorImageChanged( imageHeight:Number ):void {
			setSize( new IntDimension( 400, imageHeight + 100 ) );
		}
	}
}
