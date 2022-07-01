Class {
	#name : #Sheet,
	#superclass : #Object,
	#instVars : [
		'companies'
	],
	#category : #'Dividend-Dividend'
}

{ #category : #accessing }
Sheet class >> fromFile: path [
	^ path asFileReference readStreamDo: [:stream | self fromString: stream contents ]
]

{ #category : #accessing }
Sheet class >> fromString: aString [ 
	| csv header candidates |
	csv := CSVParser parse: aString.
	header := Dictionary new.
	csv lines third values doWithIndex: [:each :index | 
		header at: each value withoutQuoting put: index
	].
	candidates := OrderedCollection new.
	(csv lines allButFirst: 3) do: [:line | | dgrs  |  
	  dgrs := DGRs new
	  	y1: ([ (line values at: (header at: 'DGR 1Y')) value asNumber ] on: Error do: [ nil ]);
	  	y3: ([ (line values at: (header at: 'DGR 3Y')) value asNumber ] on: Error do: [ nil ]);
	  	y5: ([ (line values at: (header at: 'DGR 5Y')) value asNumber ] on: Error do: [ nil ]);
	  	y10: ([ (line values at: (header at: 'DGR 10Y')) value asNumber ] on: Error do: [ nil ]);
	  	yourself.
	  [
  	candidates add: (Company new
  			name: (line values at: (header at: 'Company')) value withoutQuoting;
  			ticker: (line values at: (header at: 'Symbol')) value withoutQuoting;
  			industry: (line values at: (header at: 'Industry')) value withoutQuoting;
			  yield: (line values at: (header at: 'Div Yield')) value asNumber;
			  fairValue: (line values at: (header at: 'Fair Value')) value;
			  eps: (line values at: (header at: 'EPS 1Y')) value asNumber;
			  div: (line values at: (header at: 'Current Div')) value asNumber;
			  years: (line values at: (header at: 'No Years')) value asNumber;
			  payoutsPerYear: (line values at: (header at: 'Payouts/ Year')) value asNumber;
			  price:  (line values at: (header at: 'Price')) value asNumber;
			  dgrs: dgrs;
			  ppe: (line values at: (header at: 'P/E')) value asNumber;
  			yourself).
  	] on: Error do: [ :ex | Transcript show: 'Error loading company: ', ex asString ].
	].
	^ self new setCompanies: candidates
]

{ #category : #accessing }
Sheet >> all [ 
	^ Sheet new setCompanies:companies
]

{ #category : #accessing }
Sheet >> companies [
	^ companies
]

{ #category : #accessing }
Sheet >> example [
	<gtExample>
	| sheet |
	sheet := Sheet fromFile: '/Users/amagyar/Downloads/champs.csv'.
	sheet findValueable: {
		#ppe -> 25. 
		#inflation -> 2. 
		#avgdiv -> 2.6.  "s&p500 average"
		#slope -> -0.5.
		#chowder1 -> 9. 
		#chowder3 -> 9. 
		#chowder5 -> 12. 		
		#dgrhi -> 12.
		#years -> ((Date today year - 2008)).
	}.
	"Additional checks:
		* Starting dividends yield is above average (in 5 years)
		* Annual total dividends paid / Annual free casheflow < 75%
				https://ycharts.com/companies/beta/PG/total_stock_dividends_paid_annual
				https://ycharts.com/companies/beta/PG/free_cash_flow_annual
	"
	
]

{ #category : #accessing }
Sheet >> findByTicker: aString [ 
	^ companies detect: [:each | each ticker = aString] ifNone: [ nil ]
]

{ #category : #accessing }
Sheet >> findValueable: keyValues [
	| sheet candidates params |
	params := keyValues asDictionary.
	candidates := companies select: [:each | each valueable: params ].
	candidates := candidates reject: [:each | (params at: #exclude ifAbsent: #()) anySatisfy: [:name | each industry includesSubstring: name caseSensitive: false ]  ].
	params at: #include ifPresent: [ :lst | 
		candidates := candidates select: [:each | lst anySatisfy: [:name | each industry includesSubstring: name caseSensitive: false ]  ].
	].
	sheet :=  Sheet new setCompanies:candidates.
	sheet sortByYield.
	^ sheet
]

{ #category : #accessing }
Sheet >> gtListOn: aView [
	<gtView>
	^ aView columnedList
		title: 'List';
		priority: 1;
		items: [ companies ];
		column: 'Name' text: #name;
		column: 'Industry' text: #industry;
		column: 'Years' text: #years;
		column: 'Dividend %' text: #yield;
		column: 'P/E' text: #ppe;
		column: 'Fair' text: #fairValue;
		column: 'Avg DGR' text: [:c | c dgrs avg round: 1 ]
]

{ #category : #accessing }
Sheet >> select: aBlock [
	^ Sheet new setCompanies: (companies select: aBlock)
]

{ #category : #accessing }
Sheet >> setCompanies: anOrderedCollection [ 
	companies := anOrderedCollection sort: [:a :b | a name < b name ].
	^ self
]

{ #category : #accessing }
Sheet >> sort: aBlock [
	companies sort: aBlock
]

{ #category : #accessing }
Sheet >> sortByYears [
	self sort:[:a :b | a years > b years ].
]

{ #category : #accessing }
Sheet >> sortByYield [
	self sort:[:a :b| a yield > b yield ].
]
