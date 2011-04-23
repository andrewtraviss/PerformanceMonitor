/*
Copyright (C) 2011 by Andrew Traviss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*/
package com.andrewtraviss.performance
{
	import com.andrewtraviss.performance.reporters.PerformanceReporter;

	/**
	 * Provides a central reporting mechanism for tracking performance of several parts of the applications seperately.
	 */
	public class PerformanceMonitor
	{
		/**
		 * Singleton.
		 */
		public static function get instance():PerformanceMonitor
		{
			if(!_instance)
			{
				_instance = new PerformanceMonitor(new SINGLETON_TOKEN());
			}
			return _instance;
		}
		
		/**
		 * Constructor. PerformanceMonitor cannot be directly instantiated.
		 */
		public function PerformanceMonitor(in_token:SINGLETON_TOKEN)
		{
			
		}
		
		/**
		 * Registers a value to be graphed.
		 * 
		 * @param in_name	A string name for the metric.
		 * @param in_id		The numeric id used to refer to this metric. Also used for sorting the different metrics in the graph.
		 * @param in_color	The colour used to represent this metric in the graph.
		 */
		public function initializePerformanceMetric(in_name:String, in_id:int, in_color:uint):void
		{
			_values[in_id] = 0;
			_colors[in_id] = in_color;
			_names[in_id] = in_name;
		}
		
		public function addReporter(in_reporter:PerformanceReporter):void
		{
			_reporters[_reporters.length] = in_reporter;
		}
		
		/**
		 * Sets the current value of a particular performance metric.
		 * 
		 * @param in_id		The numeric id used to refer to this metric as specified in initializePerformanceMetric.
		 * @param in_value	The current value of the metric.
		 */
		public function recordPerformanceMetric(in_id:int, in_value:Number):void
		{
			if(_colors[in_id] == undefined)
			{
				throw(new Error("Cannot monitor value " + in_id + ". Must call initializeValue first."))
			}
			_values[in_id] = in_value;
		}
		
		/**
		 * Adds to the current value of a particular performance metric.
		 * 
		 * @param in_id		The numeric id used to refer to this metric as specified in initializePerformanceMetric.
		 * @param in_value	The amount of additional time to add to the metric's current value.
		 */
		public function addToPerformanceMetric(in_id:int, in_value:Number):void
		{
			if(_colors[in_value] == undefined)
			{
				throw(new Error("Cannot monitor value " + in_value + ". Must call initializeValue first."))
			}
			_values[in_id] += in_value;
		}
		
		/**
		 * Renders the current values of all metrics and resets them to zero.
		 */
		public function update():void
		{
			reportValues();
			resetValues();
		}
		
		private function reportValues():void
		{
			var reporter:PerformanceReporter;
			for(var i:int=0; i<_reporters.length; i++)
			{
				reporter = _reporters[i];
				reporter.reportValues(_names, _values, _colors);
			}
		}
		
		private function resetValues():void
		{
			for(var i:int=0; i<_values.length; i++)
			{
				_values[i] = 0;
			}
		}
		
		private var _values:Array = [];
		private var _colors:Array = [];
		private var _names:Array = [];
		private var _reporters:Array = [];
		
		private static var _instance:PerformanceMonitor;
	}
}

internal class SINGLETON_TOKEN
{
	
}