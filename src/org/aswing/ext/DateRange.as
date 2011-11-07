package org.aswing.ext{


/**
 * The definition of a date range.
 * For a single day, you can set rangeStart and rangeEnd to be a same date, 
 * If rangeStart == null, means all date before rangeEnd(included) is in range,  
 * If rangeEnd == null, means all date after rangeStart(included) is in range.
 * @author iiley (Burstyx Studio)
 */
public class DateRange{
	
	private var rangeStart:Date;
	private var rangeEnd:Date;
	
	public function DateRange(rangeStart:Date, rangeEnd:Date){
		this.rangeStart = rangeStart;
		this.rangeEnd = rangeEnd;
		resetInDay(this.rangeStart);
		resetInDay(this.rangeEnd);
		if(rangeStart && rangeEnd){
			if(rangeStart.time > rangeEnd.time){
				throw new Error("rangeStart can not be later than rangeEnd.");
			}
		}
	}
	
	public static function singleDay(day:Date):DateRange{
		return new DateRange(day, day);
	} 
	
	public function getStart():Date{
		return rangeStart;
	}
	
	public function getStartMonth():Date{
		return resetInMonth(new Date(rangeStart.time));
	}
	
	public function getEnd():Date{
		return rangeEnd;
	}
	
	public function getEndMonth():Date{
		return resetInMonth(new Date(rangeEnd.time));
	}
	
	public function isInRange(date:Date):Boolean{
		resetInDay(date); //reset the day
		if(rangeStart && rangeEnd){
			return date.getTime() >= rangeStart.getTime() && date.getTime() <= rangeEnd.getTime();
		}else if(null == rangeStart){
			return date.getTime() <= rangeEnd.getTime();
		}else if(null == rangeEnd){
			return date.getTime() >= rangeStart.getTime();
		}
		return true;
	}
	
	public static function resetInMonth(date:Date):Date{
		date.setDate(1);
		resetInDay(date);
		return date;
	}
	
	public static function resetInDay(date:Date):Date{
		if(date){
			date.setHours(0, 0, 0, 0);
		}
		return date;
	}
}
}