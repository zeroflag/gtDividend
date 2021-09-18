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
	  	y1: (line values at: (header at: 'DGR 1Y')) value asNumber;
	  	y3: (line values at: (header at: 'DGR 3Y')) value asNumber;
	  	y5: (line values at: (header at: 'DGR 5Y')) value asNumber;
	  	y10: ([ (line values at: (header at: 'DGR 10Y')) value asNumber ] on: Error do: [ nil ])
	  	yourself.
  	candidates add: (Company new
  			name: (line values at: (header at: 'Company')) value withoutQuoting;
  			ticker: (line values at: (header at: 'Symbol')) value withoutQuoting;
  			industry: (line values at: (header at: 'Industry')) value withoutQuoting;
			  yield: (line values at: (header at: 'Div Yield')) value asNumber;
			  fairValue: (line values at: (header at: 'Fair Value')) value;
			  dgrs: dgrs;
			  ppe: (line values at: (header at: 'P/E')) value asNumber;
  			yourself
  			
 		)
	].
	^ self new setCompanies: candidates
]

{ #category : 'accessing' }
Sheet >> all [ 
	^ Sheet new setCompanies:companies
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
		column: 'Fiar' text: #fairValue;
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
