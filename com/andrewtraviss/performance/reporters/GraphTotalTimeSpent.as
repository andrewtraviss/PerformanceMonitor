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
package com.andrewtraviss.performance.reporters
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * Renders a bar chart showing the percentage of total processing time used by each performance metric being tracked.
	 */
	public class GraphTotalTimeSpent implements PerformanceReporter
	{
		/**
		 * Constructor.
		 */
		public function GraphTotalTimeSpent()
		{
			_barRect = new Rectangle();
		}
		
		/**
		 * Creates and returns the display for the graph.
		 * 
		 * @param in_width	The width of the display in pixels
		 * @param in_height	The height of the display in pixels
		 * 
		 * @return The display BitmapData.
		 */
		public function createDisplay(in_width:int, in_height:int):BitmapData
		{
			if(_graphData)
			{
				throw(new Error("Display already created."));
			}
			_graphData = new BitmapData(in_width, in_height, false, 0x000000);
			return _graphData;
		}
		
		/**
		 * Records the current values of each metric.
		 * 
		 * @param in_names	The names of the metrics.
		 * @param in_values	The current values of the metrics.
		 * @param in_colors	The colors used to represent the metrics.
		 */
		public function reportValues(in_names:Array, in_values:Array, in_colors:Array):void
		{
			incrementTotals(in_values);
			renderTotals(_totals, in_colors);
		}
		
		private function incrementTotals(in_values:Array):void
		{
			for(var i:int=0; i<in_values.length; i++)
			{
				if(!_totals[i])
				{
					_totals[i] = 0;
				}
				_totals[i] += in_values[i];
				_total += in_values[i];
			}
		}
		
		private function renderTotals(in_totals:Array, in_colors:Array):void
		{
			_graphData.lock();
			_barRect.y = 0;
			_barRect.width = _graphData.width;
			for(var i:int=0; i<in_totals.length; i++)
			{
				_barRect.height = Math.round(in_totals[i]/_total * _graphData.height);
				_graphData.fillRect(_barRect, in_colors[i]);
				_barRect.y += _barRect.height;
			}
			_graphData.unlock();
		}
		
		private var _graphData:BitmapData;
		private var _barRect:Rectangle;
		private var _total:int;
		private var _totals:Array = [];
	}
}