package org.mousebomb.utils
{
	/**
	 * @author Mousebomb
	 */
	public function btrace(...args) : void
	{
		var d : Date = new Date();
		var ms :String = d.milliseconds.toString();
		if(ms.length==1) ms="00"+ms;
		else if(ms.length==2) ms="0"+ms;
		var now : String = d.hours + ":" + (d.minutes<10?"0":"")+d.minutes + ":" +(d.seconds<10?"0":"")+ d.seconds + "." + ms;
		trace.apply(null, [now].concat(args));
	}
}
