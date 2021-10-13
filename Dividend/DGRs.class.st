Class {
	#name : #DGRs,
	#superclass : #Object,
	#instVars : [
		'y1',
		'y10',
		'y5',
		'y3'
	],
	#category : #'Dividend-Dividend'
}

{ #category : #accessing }
DGRs >> above: aNumber [
	^ self asOrderedCollection allSatisfy: [:each | each > aNumber ]
]

{ #category : #accessing }
DGRs >> asOrderedCollection [
	| o |
	o := OrderedCollection new.
	y10 ifNotNil: [ o add: y10 ].
	y5 ifNotNil: [ o add: y5 ].
	y3 ifNotNil: [ o add: y3 ].	
	y1 ifNotNil: [ o add: y1 ].
	^ o
]

{ #category : #accessing }
DGRs >> avg [
	^ self asOrderedCollection average
]

{ #category : #accessing }
DGRs >> gtPlotOn: aView [
	<gtView>
	| data sum |
	^ aView explicit
		title: 'Plot';
		priority: 5;
		stencil: [
			HistoryPlot new
				data: (self asOrderedCollection collectWithIndex: [:each :i | i -> each]) ;
				xLabel: [:each | ''];
				plot
			].
]

{ #category : #accessing }
DGRs >> printOn: aStream [
 aStream 
 	nextPutAll: 'DGRs = ';
 	nextPutAll: y10 asString;
 	nextPutAll: '%   ';
 	nextPutAll: y5 asString;
 	nextPutAll: '%   ';
 	nextPutAll: y3 asString;
 	nextPutAll: '%   ';
 	nextPutAll: y1 asString;
 	nextPutAll: '%   m = ';
 	nextPutAll: (self slope round: 2) asString
]

{ #category : #accessing }
DGRs >> slope [
    | dgrs sxsy sx sy n sx2 |
	dgrs := self asOrderedCollection.
	sx := (1 to: dgrs size) sum.
	sy := dgrs sum.
	sxsy := 0. sx2 := 0.
	n := dgrs size.
	dgrs doWithIndex: [ :y :x | 
		sxsy := sxsy + (x * y).
		sx2 := sx2 + (x * x) ].
	^ ((n * sxsy) - (sx * sy)) / ((n * sx2) - (sx * sx))
]

{ #category : #accessing }
DGRs >> stable: aDictionary [
	(self asOrderedCollection anySatisfy: [:each | each > (aDictionary at: #dgrhi) ]) ifTrue: [ ^ true ].
	^ aDictionary 
		at: #slope 
		ifPresent: [ :limit | self slope >= limit ]
		ifAbsent: [ true ]
]

{ #category : #accessing }
DGRs >> y1 [

	^ y1
]

{ #category : #accessing }
DGRs >> y10 [

	^ y10
]

{ #category : #accessing }
DGRs >> y10: anObject [

	y10 := anObject
]

{ #category : #accessing }
DGRs >> y1: anObject [

	y1 := anObject
]

{ #category : #accessing }
DGRs >> y3 [

	^ y3
]

{ #category : #accessing }
DGRs >> y3: anObject [

	y3 := anObject
]

{ #category : #accessing }
DGRs >> y5 [

	^ y5
]

{ #category : #accessing }
DGRs >> y5: anObject [

	y5 := anObject
]
