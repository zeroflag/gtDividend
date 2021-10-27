Class {
	#name : #Yahoo,
	#superclass : #Object,
	#category : #'Dividend-Dividend'
}

{ #category : #accessing }
Yahoo >> baseUrl [
	^ 'https://query1.finance.yahoo.com/v7/finance/download' asUrl
]

{ #category : #accessing }
Yahoo >> dividendHistory: ticker [
	| response |
	response := ZnClient new get:(
		self baseUrl / (self encode: ticker) 
			? ('period1' -> '221097600')
			? ('period2' -> DateAndTime now asUnixTime)
			? ('interval' -> '1mo')
			? ('events' -> 'div')
			? ('includeAdjustedClose' -> 'true')).
					
	^ self parseDividendHistory: response
	
]

{ #category : #accessing }
Yahoo >> encode: ticker [ 
	^ ticker copyReplaceAll: '.' with: '-'
]

{ #category : #accessing }
Yahoo >> parseDividendHistory: aString [
	| csv date price history |
	csv := CSVParser parse: aString.
	history := csv lines allButFirst collect: [:line | 
	  date := Date fromString: (line values at: 1) value.
	  price := (line values at: 2) value asNumber.
	  date -> price ].
	history sort: [:a :b | a key > b key ].
	^ history
]

{ #category : #accessing }
Yahoo >> parsePriceHistory: aString [
	| csv date price history |
	csv := CSVParser parse: aString.
	history := csv lines allButFirst collect: [:line | 
	  date := Date fromString: (line values at: 1) value.
	  price := (line values at: 5) value asNumber.
	  date -> price ].
	history sort: [:a :b | a key > b key ].
	^ history
]

{ #category : #accessing }
Yahoo >> priceHistory: ticker [
	| response |
	response := ZnClient new get:(
		self baseUrl / (self encode: ticker)
			? ('period1' -> '221097600')
			? ('period2' -> DateAndTime now asUnixTime)
			? ('interval' -> '1d')
			? ('events' -> 'history')
			? ('includeAdjustedClose' -> 'true')).
					
	^ self parsePriceHistory: response
	
]
