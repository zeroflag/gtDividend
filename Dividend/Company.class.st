Class {
	#name : #Company,
	#superclass : #Object,
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
		'price',
		'years',
		'dividendHistory',
		'priceHistory'
	],
	#category : #Dividend
}

{ #category : #accessing }
Company >> averageDividentYield5y [
	^ (self dividendYieldHistory5y collect: #value) average
]

{ #category : #accessing }
Company >> chowder1 [

	^ dgrs y1 + yield
]

{ #category : #accessing }
Company >> chowder3 [

	^ dgrs y3 + yield
]

{ #category : #accessing }
Company >> chowder5 [

	^ dgrs y5 + yield
]

{ #category : #accessing }
Company >> chowderGood: aDictionary [
	^ (self chowder1 >= (aDictionary at: #chowder1)) 
		or: [ self chowder3 >= (aDictionary at: #chowder3) 
		or: [ self chowder5 >= (aDictionary at: #chowder5) ] ] "<- ez"
]

{ #category : #accessing }
Company >> dgrs [

	^ dgrs
]

{ #category : #accessing }
Company >> dgrs: anObject [

	dgrs := anObject
]

{ #category : #accessing }
Company >> div [
	^ div
]

{ #category : #accessing }
Company >> div: aNumber [
	div := aNumber
]

{ #category : #accessing }
Company >> dividendHistory [
	^ dividendHistory := dividendHistory ifNil: [ Yahoo new dividendHistory: self ticker ]
	
]

{ #category : #accessing }
Company >> dividendPerYearPerShare [
	^ div * payoutsPerYear
]

{ #category : #accessing }
Company >> dividendYieldHistory5y [
	| divs prices result index date divident |
	prices := self priceHistory.
	result := OrderedCollection new.
	self priceHistory5years do: [ :kw | 
		date := kw key.
		price := kw value.
		index := self dividendHistory findFirst: [ :d | d key <= date ].
		index > 0 ifTrue: [ 
			divident := (self dividendHistory at: index) value * payoutsPerYear. "TODO calculate annual divident"
			result add: date -> (divident / price * 100 round: 1) ] ].
	^ result
]

{ #category : #accessing }
Company >> eps [
	^ eps
]

{ #category : #accessing }
Company >> eps: aNumber [
	eps := aNumber
]

{ #category : #accessing }
Company >> fairPrice [
	"https://www.investopedia.com/terms/g/gordongrowthmodel.asp"
	"Because the model assumes a constant growth rate, it is generally only used for companies with stable growth rates in dividends per share."
	| d |
	d := 0.1 - (dgrs avg / 100).
	^ d > 0 ifTrue: [ self dividendPerYearPerShare / d  ] ifFalse: [ 0 ]
]

{ #category : #accessing }
Company >> fairValue [

	^ fairValue
]

{ #category : #accessing }
Company >> fairValue: anObject [

	fairValue := anObject
]

{ #category : #accessing }
Company >> flawlessDividendHistory [
	^ ((self dividendHistory overlappingPairsCollect: [:a :b | a key > b key ]) includes: false) not
]

{ #category : #accessing }
Company >> gtDividendHistoryPlotOn: aView [	
	<gtView>
	| data sum |
	^ aView explicit
		title: 'Div plot';
		priority: 5;
		stencil: [
			HistoryPlot new
				data: self dividendHistory ;
				x: [:each | each key asSeconds];
				y: #value;
				plot
			].
]

{ #category : #accessing }
Company >> gtPriceHistoryPlotOn: aView [	
	<gtView>
	| data sum |
	^ aView explicit
		title: 'Price plot';
		priority: 3;
		stencil: [
			HistoryPlot new
				data: self priceHistory ;
				x: [:each | each key asSeconds];
				y: #value;
				plot
			].
]

{ #category : #accessing }
Company >> gtViewDividendListOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Div';
		priority: 4;
		items: [ self dividendHistory ];
		column: 'Date' text: #key;
		column: 'Dividend' text: #value.
]

{ #category : #accessing }
Company >> gtViewPriceListOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Price';
		priority: 2;
		items: [ self priceHistory ];
		column: 'Date' text: #key;
		column: 'Price' text: #value.
]

{ #category : #accessing }
Company >> gtViewSummary: aView [

	<gtView>
	^ aView explicit
		  title: 'Summary';
		  priority: 1;
		  stencil: [ 
			  | container verticalContainer detailsTextContainer nameTextContainer details |
			  details := String streamContents: [ :s | 
					             s
						             nextPutAll: industry;
						             cr;
						             nextPutAll: fairValue;
						             cr;
						             nextPutAll: 'Since ';
						             nextPutAll: years asString , ' years';
						             cr;
						             cr;
						             nextPutAll: 'Dividend = ';
						             nextPutAll: yield asString;
						             nextPutAll: '% (';
						             nextPutAll: div asString;
						             nextPutAll: '$ / share)';
						             cr;					           
						             nextPutAll: 'Price = ';
						             nextPutAll: price asString;
						             cr;
						             nextPutAll: 'Gordon Fair price = ';
						             nextPutAll: (self fairPrice round: 2) asString;
						             cr; cr;
						             nextPutAll: 'Chowder Score 1 = ';
						             nextPutAll: (self chowder1 round: 1) asString;
						             cr;
						             nextPutAll: 'Chowder Score 3 = ';
						             nextPutAll: (self chowder3 round: 1) asString;
						             cr;
						             nextPutAll: 'Chowder Score 5 = ';
						             nextPutAll: (self chowder5 round: 1) asString;
						             cr; cr;
						             nextPutAll: 'P/E = ';
						             nextPutAll: ppe asString;
						             cr;
						             cr;
						             nextPutAll: 'EPS 1Y = ';
						             nextPutAll: eps asString;
						             cr;
						             nextPutAll: 'Current Div = ';
						             nextPutAll: div asString;
						             cr;
						             nextPutAll: 'Payouts per year = ';
						             nextPutAll: payoutsPerYear asString;
						             cr;
						             cr;
						             nextPutAll: 'Div/EPS = ';
						             nextPutAll:
							             ([ 
							              (self dividendPerYearPerShare / eps * 100 round:
									               2) asString ]
								              on: ZeroDivide
								              do: [ 'N/A ' ]);
						             nextPut: $%;
						             cr;
						             cr;
						             nextPutAll: 'Avg DGR =';
						             nextPutAll: (dgrs avg round: 2) asString;
						             cr;
						             nextPutAll: dgrs asString ].
			  container := BlElement new
				               layout: BlLinearLayout horizontal;
				               background: Color white;
				               aptitude: BrShadowAptitude;
				               margin: (BlInsets all: 20);
				               constraintsDo: [ :c | 
					               c horizontal fitContent.
					               c vertical fitContent ].
			  nameTextContainer := BlTextElement new
				                       constraintsDo: [ :c | 
					                       c horizontal matchParent ];
				                       margin: (BlInsets
						                        top: 5
						                        right: 0
						                        bottom: 20
						                        left: 5);
				                       text:
					                       ((name , '(' , ticker , ')') asRopedText
						                        glamorousRegularFont
						                        fontSize: 30;
						                        foreground: Color black).
			  detailsTextContainer := BrEditor new
				                          aptitude:
					                          (BrGlamorousRegularEditorAptitude new 
						                           fontSize: 16);
				                          text: details;
				                          constraintsDo: [ :c | 
					                          c horizontal matchParent.
					                          c vertical matchParent ].
			  verticalContainer := BlElement new
				                       layout: BlLinearLayout vertical;
				                       margin: (BlInsets all: 10);
				                       constraintsDo: [ :c | 
					                       c horizontal matchParent.
					                       c vertical matchParent ].
			  verticalContainer addChild: nameTextContainer.
			  verticalContainer addChild: detailsTextContainer.
			  container addChild: verticalContainer.
			  container ];
				  actionButtonIcon: BrGlamorousVectorIcons link
		  tooltip: 'Market watch'
		  action: [ :aToggle :company | 
			  WebBrowser openOn: 'https://www.marketwatch.com/investing/stock/'
				  , (ticker copyReplaceAll: '.' with: ''), '/financials/cash-flow' ];	  
		  actionButtonIcon: BrGlamorousVectorIcons note
		  tooltip: 'Yahoo'
		  action: [ :aToggle :company | 
			  WebBrowser openOn: 'https://finance.yahoo.com/quote/'
				  , (ticker copyReplaceAll: '.' with: '') , '/key-statistics?p='
				  , ticker ];
		  actionButtonIcon: BrGlamorousVectorIcons performance
		  tooltip: 'Dividend %'
		  action: [ :aToggle :company | 
			  WebBrowser openOn: 'http://ycharts.com/companies/'
				  , (ticker copyReplaceAll: '.' with: '') , '/dividend_yield' ];
		  actionButtonIcon: BrGlamorousVectorIcons refresh
		  tooltip: 'Dividend %'
		  action: [ :aToggle :company | 
			  WebBrowser openOn: 'http://ycharts.com/companies/'
				  , (ticker copyReplaceAll: '.' with: '') , '/pe_ratio' ]				  
]

{ #category : #accessing }
Company >> gtViewYieldListOn: aView [
	<gtView>
	^ aView columnedList
		title: '5y-div%';
		priority: 5;
		items: [ self dividendYieldHistory5y ];
		column: 'Date' text: #key;
		column: 'Yield' text: #value.
]

{ #category : #accessing }
Company >> gtYieldHistoryPlotOn: aView [	
	<gtView>
	| data sum plot container details |
	^ aView explicit
		title: '5y-div% plot';
		priority: 7;
		stencil: [
			plot := HistoryPlot new
				data: self dividendYieldHistory5y ;
				x: [ :each | each key asSeconds ];
				y: #value;
				plot.	
			 details := BrEditor new
				 aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 16);
				 	text: 'AVG-Y5 = ',(self averageDividentYield5y round: 1) asString, '% Current = ', yield asString, '%';
				     constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].				
			container := BlElement new
					layout: BlLinearLayout vertical;
					margin: (BlInsets all: 10);
						constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].
			 container addChild: plot asElement.
			 container addChild: details.
			 container
			].
]

{ #category : #accessing }
Company >> industry [

	^ industry
]

{ #category : #accessing }
Company >> industry: anObject [

	industry := anObject
]

{ #category : #accessing }
Company >> isReit [
	^ industry includesSubstring: 'REIT'
]

{ #category : #accessing }
Company >> name [

	^ name
]

{ #category : #accessing }
Company >> name: anObject [

	name := anObject
]

{ #category : #accessing }
Company >> payoutsPerYear [
	^ payoutsPerYear
]

{ #category : #accessing }
Company >> payoutsPerYear: aNumber [
	payoutsPerYear := aNumber
]

{ #category : #accessing }
Company >> ppe [

	^ ppe
]

{ #category : #accessing }
Company >> ppe: anObject [

	ppe := anObject
]

{ #category : #accessing }
Company >> price [
	^ price
]

{ #category : #accessing }
Company >> price: aNumber [
	price := aNumber
]

{ #category : #accessing }
Company >> priceHistory [
	^ priceHistory := priceHistory ifNil: [ Yahoo new priceHistory: self ticker ]
	
]

{ #category : #accessing }
Company >> priceHistory5years [
	^ self priceHistory select: [ :each | 
		  each key year > (Date today year - 5) ]
]

{ #category : #accessing }
Company >> printOn: aStream [
 name printOn: aStream
]

{ #category : #accessing }
Company >> ticker [

	^ ticker
]

{ #category : #accessing }
Company >> ticker: anObject [

	ticker := anObject
]

{ #category : #accessing }
Company >> valueable: aDictionary [
	^ ppe < (aDictionary at: #ppe) and: [ 
		years >= (aDictionary at: #years) and: [
		  (dgrs stable: aDictionary) and: [ 
			  (dgrs above: (aDictionary at: #inflation)) and: [ 
				  (self chowderGood: aDictionary) and: [ 
					  yield
						  between: (aDictionary at: #avgdiv) * 1.5
						  and: (aDictionary at: #avgdiv) * 5 ] ] ] ] ]
]

{ #category : #accessing }
Company >> years [
	^ years
]

{ #category : #accessing }
Company >> years: aNumber [
	years := aNumber
]

{ #category : #accessing }
Company >> yield [

	^ yield
]

{ #category : #accessing }
Company >> yield: anObject [

	yield := anObject
]
