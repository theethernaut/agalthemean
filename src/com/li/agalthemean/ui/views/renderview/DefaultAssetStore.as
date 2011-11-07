package com.li.agalthemean.ui.views.renderview
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.agal.AGALAdvancedPhongBitmapMaterial;
	import com.li.minimole.materials.agal.AGALBitmapMaterial;
	import com.li.minimole.materials.agal.AGALColorMaterial;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.AGALPhongBitmapMaterial;
	import com.li.minimole.materials.agal.AGALPhongColorMaterial;
	import com.li.minimole.parsers.ObjParser;
	import com.li.minimole.primitives.CubeR;
	import com.li.minimole.primitives.Plane;
	import com.li.minimole.primitives.Sphere;
	import com.li.minimole.primitives.Torus;

	import flash.display.BitmapData;
	import flash.utils.setTimeout;

	import org.osflash.signals.Signal;

	public class DefaultAssetStore
	{
		// Texture.
		[Embed(source="../../../../../../../assets/head/Map-COL.jpg")]
//		[Embed(source="../../../../../../../assets/head/explode.png")]
		private var HeadTexture:Class;

		// Texture.
		[Embed(source="../../../../../../../assets/head/Infinite-Level_02_World_SmoothUV.jpg")]
		private var HeadNormals:Class;

		// Texture.
		[Embed(source="../../../../../../../assets/head/Map-spec.jpg")]
		private var HeadSpecular:Class;

		// Model.
		[Embed (source="../../../../../../../assets/head/head.obj", mimeType="application/octet-stream")]
		private var HeadModel:Class;

		public var headTexture:BitmapData;
		public var headNormals:BitmapData;
		public var headSpecular:BitmapData;

		private var _material:AGALMaterial;
		private var _model:Mesh;

		private static var _instance:DefaultAssetStore;

		public var materialRequestedSignal:Signal;
		public var modelRequestedSignal:Signal;

		public function DefaultAssetStore() {

			headTexture = new HeadTexture().bitmapData;
			headNormals = new HeadNormals().bitmapData;
			headSpecular = new HeadSpecular().bitmapData;

			materialRequestedSignal = new Signal( AGALMaterial );
			modelRequestedSignal = new Signal( Mesh );

			_model = new CubeR( null );

			// -----------------------
			//
			// -----------------------
			setTimeout( function():void {

//				getAdvancedPhongBitmapMaterial();
				getPhongColorMaterial();

				getHeadModel();

			}, 200 );
			// -----------------------
			//
			// -----------------------
		}

		public static function get instance():DefaultAssetStore {
			if( !_instance )
				_instance = new DefaultAssetStore();
			return _instance;
		}

		// ---------------------------------------------------------------------
		// Models
		// ---------------------------------------------------------------------

		public function getHeadModel():Mesh {
			_material.bothsides = false;
			_model = new ObjParser( HeadModel, _material, 0.2 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getCubeModel():Mesh {
			_material.bothsides = false;
			_model = new CubeR( _material );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getSphereModel():Mesh {
			_material.bothsides = false;
			_model = new Sphere( _material, 1, 32, 24 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getTorusModel():Mesh {
			_material.bothsides = false;
			_model = new Torus( _material, 0.8, 0.3 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getPlaneModel():Mesh {
			_material.bothsides = true;
			_model = new Plane( _material );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		// ---------------------------------------------------------------------
		// Shaders
		// ---------------------------------------------------------------------

		public function getSimplestMaterial():AGALMaterial {
			_material = new AGALColorMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getPhongColorMaterial():AGALMaterial {
			_material = new AGALPhongColorMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getAdvancedPhongBitmapMaterial():AGALMaterial {
			_material = new AGALAdvancedPhongBitmapMaterial( headTexture, headNormals, headSpecular );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getBasicPhongBitmapMaterial():AGALMaterial {
			_material = new AGALPhongBitmapMaterial( headTexture );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getBitmapMaterial():AGALMaterial {
			_material = new AGALBitmapMaterial( headTexture );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getEmptyMaterial():AGALMaterial {
			_material = new AGALMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}
	}
}
