Class {
	#name : 'Company',
	#superclass : 'Object',
	#instVars : [
		'yield',
		'dgrs',
		'fairValue',
		'industry',
		'ticker',
		'name',
		'ppe'
	],
	#category : 'Dividend'
}

{ #category : 'accessing' }
Company >> dgrs [

	^ dgrs
]

{ #category : 'accessing' }
Company >> dgrs: anObject [

	dgrs := anObject
]

{ #category : 'accessing' }
Company >> fairValue [

	^ fairValue
]

{ #category : 'accessing' }
Company >> fairValue: anObject [

	fairValue := anObject
]

{ #category : 'accessing' }
Company >> industry [

	^ industry
]

{ #category : 'accessing' }
Company >> industry: anObject [

	industry := anObject
]

{ #category : 'accessing' }
Company >> isCandidate: aDictionary [

	^ ppe < (aDictionary at: #ppe) and: [ 
		  (dgrs stable: aDictionary) and: [ 
			  (dgrs above: (aDictionary at: #inflation)) and: [ 
				  yield
					  between: (aDictionary at: #yield) * 1.5
					  and: (aDictionary at: #yield) * 5 ] ] ]
]

{ #category : 'accessing' }
Company >> name [

	^ name
]

{ #category : 'accessing' }
Company >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
Company >> ppe [

	^ ppe
]

{ #category : 'accessing' }
Company >> ppe: anObject [

	ppe := anObject
]

{ #category : 'accessing' }
Company >> printOn: aStream [
 name printOn: aStream
]

{ #category : 'accessing' }
Company >> ticker [

	^ ticker
]

{ #category : 'accessing' }
Company >> ticker: anObject [

	ticker := anObject
]

{ #category : 'accessing' }
Company >> yield [

	^ yield
]

{ #category : 'accessing' }
Company >> yield: anObject [

	yield := anObject
]
