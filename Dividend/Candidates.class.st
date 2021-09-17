Class {
	#name : 'Candidates',
	#superclass : 'Object',
	#instVars : [
		'candidates'
	],
	#category : 'Dividend-Dividend'
}

{ #category : 'accessing' }
Candidates class >> fromFile: path [
	^ path asFileReference readStreamDo: [:stream | self fromString: stream contents ]
]

{ #category : 'accessing' }
Candidates class >> fromString: aString [ 
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
	^ self new setCandidates: candidates
]

{ #category : 'accessing' }
Candidates >> candidates: keyValues [
	^ candidates select: [:each | each isCandidate: keyValues asDictionary ]
]

{ #category : 'accessing' }
Candidates >> setCandidates: anOrderedCollection [ 
	candidates := anOrderedCollection.
	^ self
]
