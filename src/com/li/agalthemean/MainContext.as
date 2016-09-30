package com.li.agalthemean {

	import com.junkbyte.console.Cc;
	import com.li.agalthemean.commands.RegisterMaterialCommand;
	import com.li.agalthemean.commands.RegisterModelCommand;
	import com.li.agalthemean.commands.UpdateAGALCommand;
	import com.li.agalthemean.commands.UpdateConstantCommand;
	import com.li.agalthemean.models.MaterialModel;
	import com.li.agalthemean.models.ModelModel;
	import com.li.agalthemean.signals.notifications.MaterialSetSignal;
	import com.li.agalthemean.signals.notifications.ModelSetSignal;
	import com.li.agalthemean.signals.requests.RequestAgalUpdateSignal;
	import com.li.agalthemean.signals.requests.RequestMaterialRegistrationSignal;
	import com.li.agalthemean.signals.requests.RequestConstantUpdateSignal;
	import com.li.agalthemean.signals.requests.RequestModelRegistrationSignal;
	import com.li.agalthemean.ui.MainView;
	import com.li.agalthemean.ui.views.attributesview.AttributesView;
	import com.li.agalthemean.ui.views.attributesview.AttributesViewMediator;
	import com.li.agalthemean.ui.views.modelview.ModelView;
	import com.li.agalthemean.ui.views.modelview.ModelViewMediator;
	import com.li.agalthemean.ui.views.renderview.DefaultAssetStore;
	import com.li.agalthemean.ui.views.samplersview.SamplersView;
	import com.li.agalthemean.ui.views.samplersview.SamplersViewMediator;
	import com.li.agalthemean.ui.views.shadersview.ShadersView;
	import com.li.agalthemean.ui.views.shadersview.ShadersViewMediator;
	import com.li.agalthemean.ui.views.constantsview.ConstantsView;
	import com.li.agalthemean.ui.views.constantsview.ConstantsViewMediator;
	import com.li.agalthemean.ui.views.renderview.RenderView;
	import com.li.agalthemean.ui.views.renderview.RenderViewMediator;

	import flash.display.Sprite;
	import flash.events.Event;
import flash.utils.setTimeout;

import org.robotlegs.mvcs.SignalContext;

	public class MainContext extends SignalContext {

		public function MainContext( contextView:Sprite ) {
			super( contextView, true );
		}

		override public function startup():void {

			// init debugging console
			if( AGALtheMEaNConstants.debugModeActive )
			{
				var stageResizeHandler:Function = function( event:Event ):void
				{
					Cc.width = contextView.stage.stageWidth;
					Cc.height = contextView.stage.stageHeight;
				};
				contextView.stage.addEventListener( Event.RESIZE, stageResizeHandler );
				Cc.config.style.backgroundAlpha = 0.75;
				Cc.config.tracing = true;
				Cc.config.showLineNumber = true;
				Cc.config.showTimestamp = true;
				Cc.startOnStage( contextView, "`" );
				stageResizeHandler( null );
			}
			Cc.info( "MainContext: " + AGALtheMEaNConstants.appNameAndVersion );

			// bootstrap
			mapMediators();
			mapModels();
			mapSignals();
			mapCommands();

			// init UI
			setTimeout(function() {
				var mainView = new MainView();
				contextView.addChild( mainView );
			}, 1000);
		}

		private function mapCommands(  ):void {
			signalCommandMap.mapSignalClass( RequestMaterialRegistrationSignal, RegisterMaterialCommand );
			signalCommandMap.mapSignalClass( RequestAgalUpdateSignal, UpdateAGALCommand );
			signalCommandMap.mapSignalClass( RequestConstantUpdateSignal, UpdateConstantCommand );
			signalCommandMap.mapSignalClass( RequestModelRegistrationSignal, RegisterModelCommand );
		}

		private function mapMediators():void {
			mediatorMap.mapView( RenderView, RenderViewMediator );
			mediatorMap.mapView( ShadersView, ShadersViewMediator );
			mediatorMap.mapView( ConstantsView, ConstantsViewMediator );
			mediatorMap.mapView( AttributesView, AttributesViewMediator );
			mediatorMap.mapView( SamplersView, SamplersViewMediator );
			mediatorMap.mapView( ModelView, ModelViewMediator );
		}

		private function mapModels(  ):void {
			injector.mapSingleton( MaterialModel );
			injector.mapSingleton( ModelModel );
		}

		private function mapSignals(  ):void {
			injector.mapSingleton( MaterialSetSignal );
			injector.mapSingleton( ModelSetSignal );
		}
	}
}
