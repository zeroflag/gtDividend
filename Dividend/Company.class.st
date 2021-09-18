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
Company >> dividendChartUrl [
	^ 'http://ycharts.com/companies/' , ticker , '/dividend_yield'
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
Company >> gtView: aView [
	<gtView>
	^ aView explicit
		title: name;
		priority: 1;
		stencil: [
			| container verticalContainer detailsTextContainer nameTextContainer details |
			details := String streamContents: [:s |
				s 
					nextPutAll: industry;
					nextPutAll: ' / ';
					nextPutAll: fairValue;
					cr; cr;
					nextPutAll: 'Dividend = ';
					nextPutAll: yield asString;
					nextPut: $%;
					cr;
					nextPutAll: 'P/E = '; 
					nextPutAll: ppe asString;
					cr; cr;
					nextPutAll: dgrs asString.
			].
			container := BlElement new
				layout: BlLinearLayout horizontal;
				background: Color white;
				aptitude: BrShadowAptitude;
				margin: (BlInsets all: 20);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent].
			nameTextContainer := BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				margin: (BlInsets top: 5 right: 0 bottom: 20 left: 5);
				text: ((name, '(', ticker, ')' ) asRopedText glamorousRegularFont
					fontSize: 30;
					foreground: Color black).
			detailsTextContainer := BrEditor new
				aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 16);
				text: details;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			verticalContainer := BlElement new
				layout: BlLinearLayout vertical;
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent].
			verticalContainer addChild: nameTextContainer.
			verticalContainer addChild: detailsTextContainer.
			container addChild: verticalContainer.
			container
		
		];
		actionButtonIcon: BrGlamorousVectorIcons browse 
			tooltip: 'YCharts' 
			action: [ :aToggle :company | WebBrowser openOn: self dividendChartUrl ].
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
Company >> interesting: aDictionary [
	^ ppe < (aDictionary at: #ppe) and: [ 
		  (dgrs stable: aDictionary) and: [ 
			  (dgrs above: (aDictionary at: #inflation)) and: [ 
				  yield
					  between: (aDictionary at: #yield) * 1.5
					  and: (aDictionary at: #yield) * 5 ] ] ]
]

{ #category : 'accessing' }
Company >> isReit [
	^ industry includesSubstring: 'REIT'
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
