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
		'ppe',
		'eps',
		'div',
		'payoutsPerYear',
		'price'
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
Company >> div [
	^ div
]

{ #category : 'accessing' }
Company >> div: aNumber [
	div := aNumber
]

{ #category : 'accessing' }
Company >> eps [
	^ eps
]

{ #category : 'accessing' }
Company >> eps: aNumber [
	eps := aNumber
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
					cr;
					nextPutAll: fairValue;
					cr; cr;
					nextPutAll: 'Dividend = ';
					nextPutAll: yield asString;
					nextPutAll: '% (';
					nextPutAll: div asString;
					nextPutAll: '$ / share)';
					cr;
					nextPutAll: 'Price = ';
					nextPutAll: price asString;
					cr;
					nextPutAll: 'Expected price = '; "TODO:https://www.investopedia.com/terms/g/gordongrowthmodel.asp "
					nextPutAll: ((div / (0.1 - (dgrs y1 / 100))) round: 2) asString;
					cr;					
					nextPutAll: 'P/E = '; 
					nextPutAll: ppe asString;
					cr; cr;
					nextPutAll: 'EPS 1Y = ';
					nextPutAll: eps asString;
					cr;
					nextPutAll: 'Current Div = ';
					nextPutAll: div asString;
					cr;
					nextPutAll: 'Payouts per year = ';
					nextPutAll: payoutsPerYear asString;					
					cr; cr;
					nextPutAll: 'Div/EPS = ';
					nextPutAll: ([ ((div * payoutsPerYear / eps) * 100 round: 2) asString ] on: ZeroDivide do: [ 'N/A ' ]);
					nextPut: $%;
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
		actionButtonIcon: BrGlamorousVectorIcons note 
			tooltip: 'Yahoo' 
			action: [ :aToggle :company | WebBrowser openOn: 'https://finance.yahoo.com/quote/BEN/key-statistics?p=', ticker ];
		actionButtonIcon: BrGlamorousVectorIcons performance 
			tooltip: 'Dividend %' 
			action: [ :aToggle :company | WebBrowser openOn: ('http://ycharts.com/companies/' , (ticker copyReplaceAll: '.' with: '') , '/dividend_yield') ];			
		actionButtonIcon: BrGlamorousVectorIcons up 
			tooltip: 'Total Annual Dividend' 
			action: [ :aToggle :company | WebBrowser openOn: ('http://ycharts.com/companies/' , (ticker copyReplaceAll: '.' with: '') , '/total_stock_dividends_paid_annual') ];
		actionButtonIcon: BrGlamorousVectorIcons down 
			tooltip: 'FCF Annual' 
			action: [ :aToggle :company | WebBrowser openOn: ('http://ycharts.com/companies/' , (ticker copyReplaceAll: '.' with: '') , '/free_cash_flow_annual') ].			
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
			  	dgrs y3 + yield >= 9 and: [
				  	yield
					  	between: (aDictionary at: #yield) * 1.5
					  	and: (aDictionary at: #yield) * 5 ] ] ] ]
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
Company >> payoutsPerYear [
	^ payoutsPerYear
]

{ #category : 'accessing' }
Company >> payoutsPerYear: aNumber [
	payoutsPerYear := aNumber
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
Company >> price [
	^ price
]

{ #category : 'accessing' }
Company >> price: aNumber [
	price := aNumber
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
