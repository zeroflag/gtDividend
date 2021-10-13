Class {
	#name : #HistoryPlot,
	#superclass : #Object,
	#instVars : [
		'data',
		'xBlock',
		'yBlock',
		'lineColor',
		'x0',
		'y0',
		'canvas',
		'axisColor',
		'totalWidth',
		'totalHeight',
		'width',
		'height',
		'xmin',
		'xmax',
		'ymax',
		'yTick',
		'xTick',
		'xs',
		'ys',
		'font',
		'xLabelBlock',
		'yLabelBlock'
	],
	#category : #Dividend
}

{ #category : #private }
HistoryPlot >> connect: point1 to: point2 [
	canvas stroke
		path: (canvas path moveTo: point1; lineTo: point2; finish);
		paint: lineColor;
		width: 2;
		draw.

]

{ #category : #accessing }
HistoryPlot >> data: aCollection [
	data := aCollection
]

{ #category : #private }
HistoryPlot >> drawAxis [
	| axis text metrics |
	axis := canvas path
		moveTo: x0@(y0 + height);
		lineTo: (x0+width)@(y0+height);
		moveTo: x0@y0;
		lineTo: x0@(y0+height);				
		close;
		finish.		
	canvas stroke
		path: axis;
		paint: axisColor;
		width: 2;
		draw.
		
	0 to: ymax by: (ymax / yTick) do: [:i |
		| tick |
		tick := canvas path
			moveTo: (x0-3)@(self translateY: i);
			lineTo: (x0+3)@(self translateY: i);			
			close;
			finish.
		canvas stroke
			path: tick;
			paint: axisColor;
			width: 1;
			draw.						
		text := canvas text
			paint: axisColor;
  		  string: (yLabelBlock value: i);
  		  font: font.
  	  metrics := text measure textMetrics.
  	  text 
		    baseline: (x0 - metrics width)@(self translateY: i) - 3;
			draw.
	].
	
	xmin to: xmax by: (xmax - xmin / xTick) do: [:i |
		| tick |
		tick := canvas path
			moveTo: (self translateX: i)@(height + y0-3);
			lineTo: (self translateX: i)@(height + y0+3);		
			close;
			finish.
		canvas stroke
			path: tick;
			paint: axisColor;
			width: 1;
			draw
	].
	xmin to: xmax by: (xmax - xmin / xTick) do: [:i |
		| tick |
		tick := canvas path
			moveTo: (self translateX: i)@(height + y0-3);
			lineTo: (self translateX: i)@(height + y0+3);		
			close;
			finish.
		canvas stroke
			path: tick;
			paint: axisColor;
			width: 1;
			draw.
		text := canvas text
			paint: axisColor;
  		  string: (xLabelBlock value: i);
  		  font: font.
  	  metrics := text measure textMetrics.
  	  text 
		    baseline: ((self translateX: i) - (metrics width / 2))@(height + y0 + metrics height  + 3);
			draw.			
	].	
			
]

{ #category : #private }
HistoryPlot >> drawBackground [
	canvas fill
		path: (0@0 extent: (width+2*x0)@(height + 2*y0));
		paint: (Color fromHexString: '#FEFEFF');
		draw.
	canvas fill
		path: (x0@y0 extent: width@height);
		paint: (Color fromHexString: '#FDFDFD');
		draw.	
]

{ #category : #private }
HistoryPlot >> drawPoints [
	| prior |
	1 to: data size do: [:i |
		| x y |
		x := self translateX: (xs at: i).
		y := self translateY: (ys at: i).
		prior ifNotNil: [ self connect: prior to: x@y ].
		prior := x@y.
	].
]

{ #category : #accessing }
HistoryPlot >> height: aNumber [
	totalHeight := aNumber.
]

{ #category : #initialization }
HistoryPlot >> initialize [
	super initialize.
	totalWidth := 750 asFloat.
	totalHeight := 450 asFloat.
	x0 := 50.
	y0 := 50.
	lineColor := Color fromHexString: '#459394'.
	axisColor := Color fromHexString: '#606060'.
	xTick := 10.	
	yTick := 10.
	xLabelBlock := #asString.
	yLabelBlock := [:i | (i round: 2) asString ].
	xBlock := #key.
	yBlock := #value.

]

{ #category : #private }
HistoryPlot >> lastDate [
	^ Date fromSeconds: xs last
]

{ #category : #plot }
HistoryPlot >> plot [
	data ifEmpty: [ ^ (SkiaCanvas extent:0@0) asForm ].
	
	width := totalWidth - x0.
	height := totalHeight - y0.
	
	xs := data collect: xBlock.
	ys := data collect: yBlock.
	xmin := xs min.
	xmax := xs max.
	ymax := ys max.			
			
	canvas := SkiaCanvas extent: (width + (2*x0))@(height+(2*y0)).
	font := canvas font size: 12; weightNormal; build.						
	self drawBackground.
	self drawAxis.
	self drawPoints.
	
	^ canvas 
		flush;
		asForm

]

{ #category : #private }
HistoryPlot >> translateX: x [ 
	^ ([ (x - xmin) * width / (xmax - xmin) + x0 ] on: ZeroDivide do: [ x0 ]) rounded
]

{ #category : #private }
HistoryPlot >> translateY: y [
	^ (y0 + height - (y * height / ymax)) rounded
]

{ #category : #accessing }
HistoryPlot >> width: aNumber [
	totalWidth := aNumber
]

{ #category : #accessing }
HistoryPlot >> x: aBlock [
	xBlock := aBlock
]

{ #category : #accessing }
HistoryPlot >> xLabel: aBlock [
	xLabelBlock := aBlock
]

{ #category : #accessing }
HistoryPlot >> xTick: aNumber [
	xTick := aNumber
]

{ #category : #accessing }
HistoryPlot >> y: aBlock [
	yBlock := aBlock
]

{ #category : #accessing }
HistoryPlot >> yLabel: aBlock [
	yLabelBlock := aBlock
]

{ #category : #accessing }
HistoryPlot >> yTick: aNumber [
	yTick := aNumber.
]
