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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Renders a stacked area chart depicting the total processing time between an arbitrary number of performance metrics defined by the user.
	 */
	public class GraphTimePerUpdate implements PerformanceReporter
	{
		/**
		 * Constructor.
		 */
		public function GraphTimePerUpdate()
		{
			_movePoint = new Point(-1,0);
			_barRect = new Rectangle(0,0,1,1);
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
			_barRect.x = in_width-1;
			return _graphData;
		}
		
		/**
		 * Sets the target time for completing an entire update.
		 * 
		 * @param The time in milliseconds.
		 */
		public function targetTimePerUpdate(in_time:int):void
		{
			_target = in_time;
		}
		
		/**
		 * The maximum amount of time per update to display per update.
		 * 
		 * @param The time in milliseconds.
		 */
		public function limitTimeForDisplay(in_time:int):void
		{
			_maximum = in_time;
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
			_graphData.copyPixels(_graphData, _graphData.rect, _movePoint);
			var targetTime:int = calculateTargetTimeRemaining(in_values);
			var overTime:int = calculateOverTimeRemaining(in_values);
			var allBars:Array = [overTime, targetTime].concat(in_values);
			var allColors:Array = [OVER_COLOR, TARGET_COLOR].concat(in_colors);
			renderBars(allBars, allColors);
		}
		
		private function calculateTargetTimeRemaining(in_values:Array):int
		{
			var usedTime:int = calculateUsedTime(in_values);
			var targetTime:int;
			if(usedTime <_target)
			{
				targetTime = _target - usedTime;
			}
			else
			{
				targetTime = 0;
			}
			return targetTime;
		}
		
		private function calculateOverTimeRemaining(in_values:Array):int
		{
			return _maximum - calculateTargetTimeRemaining(in_values) - calculateUsedTime(in_values);
		}
		
		private function renderBars(in_bars:Array, in_colors:Array):void
		{
			var totalHeight:int = 0;
			var height:int;
			for(var i:int=0; i<in_bars.length; i++)
			{
				height = int((in_bars[i]/_maximum)*_graphData.height);
				_barRect.height = height;
				_barRect.y = totalHeight;
				_graphData.fillRect(_barRect, in_colors[i]);
				totalHeight += height;
			}
		}
		
		private function calculateUsedTime(in_values:Array):int
		{
			var total:int = 0;
			for(var i:int=0; i<in_values.length; i++)
			{
				if(in_values[i])
				{
					total += in_values[i];
				}
			}
			return total;
		}
		
		private var _maximum:int;
		private var _target:int;
		
		private var _graphData:BitmapData;
		private var _movePoint:Point;
		private var _barRect:Rectangle;
		
		private const TARGET_COLOR:uint = 0x00ff00;
		private const OVER_COLOR:uint = 0x000000;
	}
}