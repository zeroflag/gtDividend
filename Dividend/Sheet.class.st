Class {
	#name : 'Sheet',
	#superclass : 'Object',
	#instVars : [
		'companies'
	],
	#category : 'Dividend-Dividend'
}

{ #category : 'accessing' }
Sheet class >> fromFile: path [
	^ path asFileReference readStreamDo: [:stream | self fromString: stream contents ]
]

{ #category : 'accessing' }
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
			  payoutsPerYear: (line values at: (header at: 'Payouts/ Year')) value asNumber;
			  price:  (line values at: (header at: 'Price')) value asNumber;
			  dgrs: dgrs;
			  ppe: (line values at: (header at: 'P/E')) value asNumber;
  			yourself).
  	] on: Error do: [ :ex | Transcript show: 'Error loading company: ', ex asString ].
	].
	^ self new setCompanies: candidates
]

{ #category : 'accessing' }
Sheet >> all [ 
	^ Sheet new setCompanies:companies
]

{ #category : 'accessing' }
Sheet >> example [
	<gtExample>
	| sheet |
	sheet := Sheet fromFile: '/Users/amagyar/Downloads/champs.csv'.
	sheet findValue: {
		#ppe -> 38 . 
		#inflation -> 1.28. 
		#yield -> 2.  "Avg SNP500 dividends https://www.multpl.com/s-p-500-dividend-yield"
		#slope -> -0.15 .
	}.
	
	"Additional checks:
		* Starting dividends yield is above average (in 5 years)
		* Annual total dividends paid / Annual free casheflow < 75%
				https://ycharts.com/companies/beta/PG/total_stock_dividends_paid_annual
				https://ycharts.com/companies/beta/PG/free_cash_flow_annual
	"
	
]

{ #category : 'accessing' }
Sheet >> findValue: keyValues [
	^ Sheet new setCompanies:(companies select: [:each | each interesting: keyValues asDictionary ] )
]

{ #category : 'accessing' }
Sheet >> gtListOn: aView [
	<gtView>
	^ aView columnedList
		title: 'List';
		priority: 1;
		items: [ companies ];
		column: 'Name' text: #name;
		column: 'Industry' text: #industry;
		column: 'Yield' text: #yield;
		column: 'P/E' text: #ppe;
		column: 'Fair' text: #fairValue;
		column: 'Avg DGR' text: [:c | c dgrs avg round: 1 ]
]

{ #category : 'accessing' }
Sheet >> select: aBlock [
	^ Sheet new setCompanies: (companies select: aBlock)
]

{ #category : 'accessing' }
Sheet >> setCompanies: anOrderedCollection [ 
	companies := anOrderedCollection.
	^ self
]
