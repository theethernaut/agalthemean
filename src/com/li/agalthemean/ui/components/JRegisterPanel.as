package com.li.agalthemean.ui.components
{

	import com.li.agalthemean.ui.components.RegisterListModel;
	import com.li.agalthemean.utils.RegisterPopUpManager;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.vo.registers.AGALRegister;

	import flash.events.Event;

	import org.aswing.JButton;
	import org.aswing.JList;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	import org.aswing.event.ListItemEvent;

	public class JRegisterPanel extends JTitledPanel
	{
		private var _list:JList;
		private var _listData:Array;
		private var _popUpManager:RegisterPopUpManager;
		private var _popUpClass:Class;

		protected var _material:AGALMaterial;

		public function JRegisterPanel( name:String, title:String, popUpClass:Class ) {

			super( title );

			setName( name );

			_listData = [];
			_popUpClass = popUpClass;

			_list = new JList( new RegisterListModel( _listData ) );
			_list.addEventListener( ListItemEvent.ITEM_CLICK, listItemClickedHandler );

			contentPanel.setLayout( new SoftBoxLayout( SoftBoxLayout.Y_AXIS ) );
			contentPanel.append( _list );

			// add sampler btn
			var addBtn:JButton;
			contentPanel.append( addBtn = new JButton( "new" ) );
			addBtn.addEventListener( AWEvent.ACT, addBtnClickHandler );

			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		public function removeAllRegisters():void {
			_listData = [];
			refreshList();
		}

		public function set material( value:AGALMaterial ):void {
			throw new Error( "Method must be overriden." );
		}

		protected function createRegister():AGALRegister {
			throw new Error( "Method must be overriden." );
		}

		protected function removeRegister( register:AGALRegister ):void {
			throw new Error( "Method must be overriden." );
		}

		private function stageInitHandler( event:Event ):void {
			_popUpManager = new RegisterPopUpManager( stage );
		}

		protected function addRegister( register:AGALRegister ):AGALRegister {

			_listData.push( register );
			refreshList();

			return register;
		}

		private function addBtnClickHandler( event:AWEvent ):void {

			showPopUp( addRegister( createRegister() ) );
		}

		private function listItemClickedHandler( event:ListItemEvent ):void {
			var register:AGALRegister = _listData[ _list.getSelectedIndex() ];
			showPopUp( register );
		}

		private function showPopUp( register:AGALRegister ):void {

			var popUp:JRegisterPopUp = _popUpManager.requestPopUp( register, _popUpClass );

			if( popUp ) {
				popUp.deleteBtnClickedSignal.addOnce( onPopUpDeleteBtnClicked );
				popUp.registerRenamedSignal.add( onRegisterRenamed );
			}
		}

		private function onRegisterRenamed():void {
			refreshList();
		}

		private function onPopUpDeleteBtnClicked( popUp:JRegisterPopUp ):void {

			_listData.splice( _listData.indexOf( popUp.register ), 1 );
			refreshList();
			removeRegister( popUp.register );
			popUp.closeReleased();
		}

		protected function refreshList():void {
			RegisterListModel( _list.getModel() ).updateData( _listData );
			_list.updateListView();
		}
	}
}
