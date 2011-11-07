package org.aswing.ext{

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.DateChooser;

import org.aswing.ASColor;
import org.aswing.BorderLayout;
import org.aswing.BoxLayout;
import org.aswing.Container;
import org.aswing.JButton;
import org.aswing.JComboBox;
import org.aswing.JLabel;
import org.aswing.JLabelButton;
import org.aswing.JPanel;
import org.aswing.LayoutManager;
import org.aswing.SoftBoxLayout;
import org.aswing.WeightBoxLayout;
import org.aswing.event.InteractiveEvent;
import org.aswing.event.SelectionEvent;
import org.aswing.util.ArrayList;
import org.aswing.util.HashSet;

/**
 * Dispatched when the datechooser's display page changed etc. 
 * @eventType org.aswing.event.InteractiveEvent.STATE_CHANGED
 */
[Event(name="stateChanged", type="org.aswing.event.InteractiveEvent")]

/**
 *  Dispatched when the datechooser's selection changed.
 * 
 *  @eventType org.aswing.event.InteractiveEvent.SELECTION_CHANGED
 */
[Event(name="selectionChanged", type="org.aswing.event.InteractiveEvent")]

/**
 * A Date Chooser for multipule or single date selection.<br/>
 * The language can be changed by defaultDayNames, defaultMonthNames static members.
 * @author iiley (Burstyx Studio)
 */
public class DateChooser extends JPanel{
	
	public static var defaultDayNames:Array = [" Su ", " Mo ", " Tu ", " We ", " Th ", " Fr ", " Sa "];
	public static var defaultMonthNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	
	protected var allowMultipleSelection:Boolean = false;
	protected var dayNames:Array;
	protected var monthNames:Array;
	protected var disabledDays:HashSet;
	protected var disabledRanges:Array;
	protected var displayedMonth:int;
	protected var displayedYear:int;
	protected var selectableRange:DateRange;
	protected var selectedDate:Date;
	protected var selectedDates:Array;
	protected var displayDate:Date;
	protected var displayMonthDays:int;//the day count of displaying month
	
	protected var monthCombo:JComboBox;
	protected var yearCombo:JComboBox;
	protected var leftButton:JButton;
	protected var rightButton:JButton;
	
	protected var datePane:Container;
	protected var headerLabels:Array; //7
	protected var tileLabels:Array; //31
	protected var dateGridLayout:DateGridLayout;
	
	public function DateChooser(){
		super();
		dayNames = defaultDayNames.concat();
		monthNames = defaultMonthNames.concat();
		var today:Date = new Date();
		disabledDays = new HashSet();
		selectedDates = [];
		selectableRange = new DateRange(
			new Date(today.getFullYear()-100, 0), 
			new Date(today.getFullYear()+50, 0));
		createComponents();
		setDisplayDate(today.getFullYear(), today.getMonth());
	}
		
	protected function createComponents():void{
		monthCombo  = new JComboBox(monthNames);
		yearCombo   = new JComboBox(getYearLabels());
		leftButton  = new JButton(" < ");
		rightButton = new JButton(" > ");
		
		var headerBar:JPanel = new JPanel(new BoxLayout(BoxLayout.X_AXIS, 2));
		var dayPane:JPanel = new JPanel(dateGridLayout = new DateGridLayout(6, 7, 2, 2));
		datePane = dayPane;
		
		var i:int = 0;
		headerLabels = [];
		tileLabels   = [];
		for(i=0; i<7; i++){
			var label:JLabel = createHeaderLabel(dayNames[i]);
			headerLabels.push(label);
			headerBar.append(label);
		}
		for(i=1; i<=31; i++){
			var labelB:DateLabel = createDateLabel(i);
			labelB.addEventListener(MouseEvent.MOUSE_DOWN, __dateLabelPress);
			tileLabels.push(labelB);
			dayPane.append(labelB);
		}
		
		var topBar:JPanel = new JPanel(new BorderLayout(4, 4));
		topBar.append(leftButton, BorderLayout.WEST);
		topBar.append(rightButton, BorderLayout.EAST);
		var topCenter:JPanel = new JPanel(new WeightBoxLayout(WeightBoxLayout.X_AXIS, 4));
		topCenter.append(monthCombo, 0.6);
		topCenter.append(yearCombo, 0.4);
		var tcSoft:Container = new Container();
		tcSoft.setLayout(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 0, SoftBoxLayout.CENTER));
		tcSoft.append(topCenter);
		topBar.append(tcSoft, BorderLayout.CENTER);
		
		setLayout(new BorderLayout(4, 4));
		var topPart:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 4));
		topPart.appendAll(topBar, headerBar);
		append(topPart, BorderLayout.NORTH);
		append(dayPane, BorderLayout.CENTER);
		
		initHandlers();
	}
	
	protected function initHandlers():void{
		leftButton.addActionListener(__left);
		rightButton.addActionListener(__right);
		yearCombo.addSelectionListener(__yearChanged);
		monthCombo.addSelectionListener(__monthChanged);
	}
	
	private function __left(e:Event):void{
		var month:int = displayDate.getMonth();
		var year:int = displayDate.getFullYear();
		if(isCanPageLeft()){
			month--;
			if(month < 0){
				month = 11;
				year--;
			}
			setDisplayDate(year, month, false);
		}
	}
	
	private function __right(e:Event):void{
		var month:int = displayDate.getMonth();
		var year:int = displayDate.getFullYear();
		if(isCanPageRight()){
			month++;
			if(month > 11){
				month = 0;
				year++;
			}
			setDisplayDate(year, month, false);
		}
	}
	
	private function __yearChanged(e:InteractiveEvent):void{
		if(!e.isProgrammatic()){
			setDisplayDate(displayStartYear+yearCombo.getSelectedIndex(), displayedMonth, false);
		}
	}
	
	private function __monthChanged(e:InteractiveEvent):void{
		if(!e.isProgrammatic()){
			setDisplayDate(displayedYear, displayStartMonth+monthCombo.getSelectedIndex(), false);
		}
	}
	
	private function __dateLabelPress(e:MouseEvent):void{
		var label:DateLabel = e.currentTarget as DateLabel;
		var labelDate:Date = getDisplayLabelDate(label);
		if(allowMultipleSelection){
			if(!addSelection(labelDate, false)){
				removeSelection(labelDate, false);
			}
		}else{
			setSelectedDate(labelDate, false);
		}
	}
	
	public function addSelection(date:Date, programmatic:Boolean=true):Boolean{
		if(null == date || isDateSelected(date)){
			return false;
		}
		selectedDates.push(new Date(date.time));
		selectedDate = date;
		updateDateLabels();
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED, programmatic));
		return true;
	}
	
	public function removeSelection(date:Date, programmatic:Boolean=true):Boolean{
		if(null == date){
			return false;
		}
		var n:int = selectedDates.length;
		for(var i:int=0; i<n; i++){
			var d:Date = selectedDates[i];
			if(d.time == date.time){
				selectedDates.splice(i, 1);
				if(n > 1){
					selectedDate = selectedDates[0];
				}else{
					selectedDate = null;
				}
				updateDateLabels();
				dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED, programmatic));
				return true;
			}
		}
		return false;
	}
	
	public function setSelectedDate(date:Date, programmatic:Boolean=true):void{
		if(selectedDate){
			if(date != null && selectedDate.time == date.time){
				return;
			}
		}else{
			if(date == null){
				return;
			}
		}
		if(date){
			selectedDate = new Date(date.time);
			selectedDates = [selectedDate];
		}else{
			selectedDate = null;
			selectedDates = [];
		}
		updateDateLabels();
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED, programmatic));
	}
	
	public function setSelectedDates(dates:Array, programmatic:Boolean=true):void{
		var arr:Array = [];
		for each(var date:Date in dates){
			arr.push(DateRange.resetInDay(date));
		}
		selectedDates = arr;
		updateDateLabels();
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED, programmatic));
	}
	
	/**
	 * Return the selected date, null if there is no date selected
	 */
	public function getSelectedDate():Date{
		if(selectedDate){
			return new Date(selectedDate.time);
		}else{
			return null;
		}
	}
	
	/**
	 * Return the selected date array, empty arry [] will be returned if there is no date selected
	 */	
	public function getSelectedDates():Array{
		return selectedDates.concat();
	}
	
	protected function getDisplayLabelDate(label:DateLabel):Date{
		var date:Date = new Date(displayDate.time);
		date.setDate(label.getDate());
		return date;
	}
	
	protected function updateDateLabels():void{
		var days:int = displayMonthDays;
		var i:int = 0;
		var label:DateLabel;
		var date:Date = new Date(displayDate.time);
		for(i=0; i<days; i++){
			label = tileLabels[i];
			label.setVisible(true);
			date.setDate(i+1);
			label.setDateEnabled(isDateEnabled(date));
			label.setSelected(isDateSelected(date));
		}
		//hide no exists dates
		for(; i<tileLabels.length; i++){
			label = tileLabels[i];
			label.setVisible(false);
		}
	}
	
	/**
	 * @param date a date, time must be 00:00
	 */
	public function isDateSelected(date:Date):Boolean{
		if(null == date){
			return false;
		}
		if(allowMultipleSelection){
			for each(var i:Date in selectedDates){
				if(i.time == date.time){
					return true;
				}
			}
		}else{
			if(selectedDate){
				return selectedDate.time == date.time;
			}
		}
		return false;
	}
	
	public function isDateEnabled(date:Date):Boolean{
		if(disabledDays.contains(date.getDay())){
			return false;
		}
		for each(var r:DateRange in disabledRanges){
			if(r.isInRange(date)){
				return false;
			}
		}
		return selectableRange.isInRange(date);
	}
	
	protected function createHeaderLabel(text:String):JLabel{
		var label:JLabel = new JLabel(text+"");
		label.setOpaque(true);
		label.setBackground(this.getBackground().brighter());
		return label;
	}
	
	protected function createDateLabel(date:int):DateLabel{
		return new DateLabel(date);
	}
	
	protected function getMonthLabels():Array{
		var arr:Array = monthNames.concat();
		arr.length = 12;
		if(displayEndMonth < 11){
			arr = arr.splice(displayEndMonth, 11-displayEndMonth);
		}
		if(displayStartMonth > 0){
			arr = arr.splice(displayStartMonth, displayStartMonth);
		}
		return arr;
	}
	
	protected function getYearLabels():Array{
		var start:int = selectableRange.getStart().getFullYear();
		var end:int = selectableRange.getEnd().getFullYear();
		var labels:Array = [];
		var n:int = end - start + 1;
		for(var i:int=0; i<=n; i++){
			labels[i] = (start+i) + "";
		}
		return labels;
	}
		
	public function highlightToday():void{
		//TODO imp
	}
	
	public function setDisplayDate(year:int, month:int, programmatic:Boolean=true):void{
		if(year < selectableRange.getStart().getFullYear()){
			year = selectableRange.getStart().getFullYear();
		}
		if(year > selectableRange.getEnd().getFullYear()){
			year = selectableRange.getEnd().getFullYear();
		}
		if(year == selectableRange.getStart().getFullYear()){
			if(month < selectableRange.getStart().getMonth()){
				month = selectableRange.getStart().getMonth();
			}
		}
		if(year == selectableRange.getEnd().getFullYear()){
			if(month > selectableRange.getEnd().getMonth()){
				month = selectableRange.getEnd().getMonth();
			}
		}
		if(year != displayedYear || month != displayedMonth){
			displayedYear = year;
			displayedMonth = month;
			displayPage();
			dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED, programmatic));
		}
	}
	
	protected function isCanPageLeft():Boolean{
		var date:Date = DateRange.resetInMonth(new Date(displayDate.time));
		return date.time > selectableRange.getStartMonth().time;
	}
	
	protected function isCanPageRight():Boolean{
		var date:Date = DateRange.resetInMonth(new Date(displayDate.time));
		return date.time < selectableRange.getEndMonth().time;
	}
	
	private var displayStartMonth:int = 0;
	private var displayEndMonth:int = 11;
	private var displayStartYear:int = 0;
	
	protected function displayPage():void{
		displayDate = new Date(displayedYear, displayedMonth, 1);
		displayStartYear = selectableRange.getStart().getFullYear();
		var indent:int = displayDate.getDay();
		var days:int = getDayCount(displayDate);
		displayMonthDays = days;
		dateGridLayout.setMonth(indent, days);
		
		var displayMonthStart:Date = new Date(displayedYear, 0, 1);
		var displayMonthEnd:Date = new Date(displayedYear, 11, 1);
		var selMonthStart:Date = selectableRange.getStartMonth();
		var selMonthEnd:Date = selectableRange.getEndMonth();
		displayStartMonth = 0;
		if(selMonthStart.time > displayMonthStart.time){
			displayStartMonth = selMonthStart.getMonth();
		}
		displayEndMonth = 11;
		if(selMonthEnd.time < displayMonthEnd.time){
			displayEndMonth = selMonthEnd.getMonth();
		}
		
		yearCombo.setSelectedIndex(displayedYear-displayStartYear);
		
		monthCombo.setListData(getMonthLabels());
		monthCombo.setSelectedIndex(displayedMonth-displayStartMonth);
		
		updateDateLabels();
		
		leftButton.setEnabled(isCanPageLeft());
		rightButton.setEnabled(isCanPageRight());
		datePane.revalidate();
	}
	
	//count the days of the month
	protected function getDayCount(d:Date):int{
		var date:Date = new Date(d.time);
		var month:int = date.getMonth();
		date.setDate(29);
		if(date.getMonth() != month){
			return 28;
		}
		date.setDate(30);
		if(date.getMonth() != month){
			return 29;
		}
		date.setDate(31);
		if(date.getMonth() != month){
			return 30;
		}
		return 31;
	}
	
	/**
	 * @param m, 0-January, 11-November
	 */
	public function setDisplayedMonth(m:int):void{
		if(m != displayedMonth){
			displayedMonth = m;
			displayPage();
		}
	}
	
	/**
	 * @return m, 0-January, 11-November
	 */	
	public function getDisplayedMonth():int{
		return displayedMonth;
	}
	
	public function setDisplayedYear(year:int):void{
		if(year != displayedYear){
			displayedYear = year;
		}
	}
	
	public function getDisplayedYear():int{
		return displayedYear;
	}
	
	public function setSelectableRange(r:DateRange):void{
		if(r.getEnd() == null || r.getStart() == null){
			throw new Error("Selectable range must have start and end date both.");
		}
		selectableRange = r;
		yearCombo.setListData(getYearLabels());
		if(!r.isInRange(displayDate)){
			setDisplayDate(r.getStart().getFullYear(), r.getStart().getMonth());
		}else{
			displayPage();
		}
	}
	
	public function getSelectableRange():DateRange{
		return selectableRange;
	}
	
	public function setDayNames(names:Array):void{
		dayNames = names.concat();
		for(var i:int=0; i<headerLabels.length; i++){
			var label:JLabel = headerLabels[i];
			label.setText(names[i]+"");
		}
		revalidate();
	}
	
	public function getDayNames():Array{
		return dayNames.concat();
	}
	
	public function setMonthNames(names:Array):void{
		monthNames = names.concat();
		displayPage();
	}
	
	public function getMonthNames():Array{
		return monthNames.concat();
	}
	
	public function setDisabledDays(days:Array):void{
		disabledDays.clear();
		if(days){
			disabledDays.addAll(days);
		}
		updateDateLabels();
	}
	
	public function getDisabledDays():Array{
		return disabledDays.toArray();
	}
	
	public function setDisabledRanges(rs:Array):void{
		if(rs){
			disabledRanges = rs.concat();
		}else{
			disabledRanges = [];
		}
		updateDateLabels();
	}
	
	public function getDisabledRanges():Array{
		return disabledRanges;
	}
	
	public function setAllowMultipleSelection(b:Boolean):void{
		allowMultipleSelection = b;
	}
	
	public function isAllowMultipleSelection():Boolean{
		return allowMultipleSelection;
	}
}
}