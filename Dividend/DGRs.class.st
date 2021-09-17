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
	^ y1 > aNumber and: [ y3 > aNumber and: [ y5 > aNumber and: [ y10 isNil or: [ y10 > aNumber ] ] ] ]
]

{ #category : 'accessing' }
DGRs >> growing [
	^ self recentlyGrowing and: [ y10 isNil or: [ y5 >= y10 or: [ (y5 - y10) abs < 0.1 ] ] ]
]

{ #category : 'accessing' }
DGRs >> printOn: aStream [
 aStream 
 	nextPutAll: '1Y=';
 	nextPutAll: y1 asString;
 	nextPutAll: ' 3Y=';
 	nextPutAll: y3 asString;
 	nextPutAll: ' 5Y=';
 	nextPutAll: y5 asString;
 	nextPutAll: ' 10Y=';
 	nextPutAll: y10 asString.
]

{ #category : 'accessing' }
DGRs >> recentlyGrowing [
	^ self veryRecentlyGrowing and: [ y3 >= y5 or: [ (y3 - y5) abs < 0.1 ] ]
]

{ #category : 'accessing' }
DGRs >> veryRecentlyGrowing [
	^ y1 >= y3 or: [ (y1 - y3) abs < 0.3 ]
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
