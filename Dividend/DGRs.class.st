Class {
	#name : 'DGRs',
	#superclass : 'Object',
	#instVars : [
		'y1',
		'y10',
		'y5',
		'y3'
	],
	#category : 'Dividend-Dividend'
}

{ #category : 'accessing' }
DGRs >> above: aNumber [
	^ y1 isNil or: [ y1 > aNumber
		and: [ y3  isNil or: [ y3 > aNumber
		and: [ y5  isNil or: [ y5 > aNumber
		and: [ y10 isNil or: [ y10 > aNumber ] ] ] ] ] ] ]
]

{ #category : 'accessing' }
DGRs >> avg [
	| dgrs |
	dgrs := OrderedCollection new.
	y10 ifNotNil: [ dgrs add: y10 ].
	y5 ifNotNil: [ dgrs add: y5 ].
	y3 ifNotNil: [ dgrs add: y3 ].	
	y1 ifNotNil: [ dgrs add: y1 ].
	^ dgrs average
]

{ #category : 'accessing' }
DGRs >> printOn: aStream [
 aStream 
 	nextPutAll: y10 asString;
 	nextPutAll: ' => ';
 	nextPutAll: y5 asString;
 	nextPutAll: ' => ';
 	nextPutAll: y3 asString;
 	nextPutAll: ' => ';
 	nextPutAll: y1 asString;
 	nextPutAll: ' m = ';
 	nextPutAll: (self slope round: 2) asString
]

{ #category : 'accessing' }
DGRs >> slope [
    | dgrs sxsy sx sy n sx2 |
	dgrs := OrderedCollection new.
	y10 ifNotNil: [ dgrs add: y10 ].
	y5 ifNotNil: [ dgrs add: y5 ].
	y3 ifNotNil: [ dgrs add: y3 ].	
	y1 ifNotNil: [ dgrs add: y1 ].
	sx := (1 to: dgrs size) sum.
	sy := dgrs sum.
	sxsy := 0. sx2 := 0.
	n := dgrs size.
	dgrs doWithIndex: [ :y :x | 
		sxsy := sxsy + (x * y).
		sx2 := sx2 + (x * x) ].
	^ ((n * sxsy) - (sx * sy)) / ((n * sx2) - (sx * sx))
]

{ #category : 'accessing' }
DGRs >> stable: aDictionary [
	^ aDictionary 
		at: #slope 
		ifPresent: [ :limit | self slope >= limit ]
		ifAbsent: [ true ]
]

{ #category : 'accessing' }
DGRs >> y1 [

	^ y1
]

{ #category : 'accessing' }
DGRs >> y10 [

	^ y10
]

{ #category : 'accessing' }
DGRs >> y10: anObject [

	y10 := anObject
]

{ #category : 'accessing' }
DGRs >> y1: anObject [

	y1 := anObject
]

{ #category : 'accessing' }
DGRs >> y3 [

	^ y3
]

{ #category : 'accessing' }
DGRs >> y3: anObject [

	y3 := anObject
]

{ #category : 'accessing' }
DGRs >> y5 [

	^ y5
]

{ #category : 'accessing' }
DGRs >> y5: anObject [

	y5 := anObject
]
