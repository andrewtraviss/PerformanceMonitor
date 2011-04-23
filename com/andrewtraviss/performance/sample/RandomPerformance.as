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
package com.andrewtraviss.performance.sample
{
	import com.andrewtraviss.performance.PerformanceMonitor;
	import com.andrewtraviss.performance.reporters.GraphTimePerUpdate;
	import com.andrewtraviss.performance.reporters.GraphTotalTimeSpent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="600", height="450")]
	public class RandomPerformance extends Sprite
	{
		public function RandomPerformance()
		{
			createPerUpdateGraph();
			createTotalGraph();
			configureMonitor();
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}
		
		/*
		The GraphTimePerUpdate graph is configured with a target time per update,
		which should be chosen depending on your frame rate. The limit specified
		in the next line controls the scale of the graph. In this example, an
		update which uses exactly 99 units of time will fill the whole vertical
		height of the graph. Then we create the display at the desired size and
		add it to the stage.
		*/
		private function createPerUpdateGraph():void
		{
			_perUpdateGraph = new GraphTimePerUpdate();
			_perUpdateGraph.targetTimePerUpdate(33);
			_perUpdateGraph.limitTimeForDisplay(99);
			var graphData:BitmapData = _perUpdateGraph.createDisplay(300,200);
			var graphBitmap:Bitmap = new Bitmap(graphData);
			addChild(graphBitmap);
		}
		
		/*
		Creating the GraphTotalTimeSpent graph is a much simpler process. We only
		need to create the display and add it to the stage.
		*/
		private function createTotalGraph():void
		{
			_totalGraph = new GraphTotalTimeSpent();
			var graphData:BitmapData = _totalGraph.createDisplay(24, 200);
			var graphBitmap:Bitmap = new Bitmap(graphData);
			graphBitmap.x = 300;
			addChild(graphBitmap);
		}
		
		/*
		With our two graphs constructed, we need to configure the
		PerformanceMonitor that drives them. The first three lines declare the
		performance metrics that will be tracked, and what colours to use when
		rendering them. The following lines plug the graphs into the
		PerformanceMonitor to receive updates.
		*/
		private function configureMonitor():void
		{
			var monitor:PerformanceMonitor = PerformanceMonitor.instance;
			monitor.initializePerformanceMetric("rendering", 0, 0xff0000);
			monitor.initializePerformanceMetric("ai", 1, 0x0000ff);
			monitor.initializePerformanceMetric("mouse", 2, 0x00ffff);
			monitor.addReporter(_perUpdateGraph);
			monitor.addReporter(_totalGraph);
		}
		
		/*
		With that configured, the PerformanceMonitor is ready to go. All that
		remains is to report metrics and tell the PerformanceMonitor to update.
		For this example, I am just randomizing the first two metrics and
		basing the second off of mouse movement in order to illustrate how to
		report them. Normally you would use getTimer to determine the time to
		execute some complex functionality and then report the result of that.
		*/
		private function handleEnterFrame(in_event:Event):void
		{
			PerformanceMonitor.instance.recordPerformanceMetric(0, Math.random()*5 + 10);
			PerformanceMonitor.instance.recordPerformanceMetric(1, Math.random()*5);
			PerformanceMonitor.instance.update();
		}
		
		private function handleMouseMove(in_event:MouseEvent):void
		{
			var xDiff:Number = mouseX - _lastX;
			var yDiff:Number = mouseY - _lastY;
			var distance:Number = Math.sqrt((xDiff*xDiff)+(yDiff*yDiff)); 
			PerformanceMonitor.instance.recordPerformanceMetric(2, distance);
			_lastX = mouseX;
			_lastY = mouseY;
		}
		
		private var _lastX:Number = 0;
		private var _lastY:Number = 0;
		
		private var _perUpdateGraph:GraphTimePerUpdate;
		private var _totalGraph:GraphTotalTimeSpent;
	}
}