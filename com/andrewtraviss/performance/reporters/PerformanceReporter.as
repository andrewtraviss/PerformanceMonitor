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
	/**
	 * A PerformanceReporter takes the raw metrics from the PerformanceMonitor and presents them to the user in some way.
	 */
	public interface PerformanceReporter
	{
		/**
		 * Records the current values of each metric.
		 * 
		 * @param in_names	The names of the metrics.
		 * @param in_values	The current values of the metrics.
		 * @param in_colors	The colors used to represent the metrics.
		 */
		function reportValues(in_names:Array, in_values:Array, in_colors:Array):void;
	}
}