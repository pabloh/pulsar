"
A BTIntegerEncodingFormat is a class that encodes and decodes integers optimizing their size for the smaller ones.

Instance Variables
	headers:		<Object>
	ranges:		<Object>

headers
	- xxxxx

ranges
	- xxxxx

"
Class {
	#name : #BTIntegerPacker,
	#superclass : #Object,
	#instVars : [
		'rangesToHeaders'
	],
	#category : #'Blast-Misc'
}

{ #category : #private }
BTIntegerPacker >> cannotPackNumber [
	^ self error: 'Imposible to pack number'
]

{ #category : #private }
BTIntegerPacker >> checkDoesNotBreakPrefixCode: aHeader [
	(self headers allSatisfy: [ :each | each isPrefixCodeCompatible: aHeader ])
		ifFalse: [ self error: 'Overlaping with existing range' ]
]

{ #category : #private }
BTIntegerPacker >> checkRangesNotOverlap: aRange [
	(self ranges allSatisfy: [ :each | (each intersection: aRange) isEmpty ])
		ifFalse: [ self error: 'Overlaping with existing range' ]
]

{ #category : #private }
BTIntegerPacker >> detectHeaderAt: aBitList [
	^ self headers detect: [ :each | aBitList beginsWith: each ]
]

{ #category : #'packing - unpacking' }
BTIntegerPacker >> extractThenUnpackFrom: aBitList [
	| header range |
	header := self detectHeaderAt: aBitList.
	range := self rangeForHeader: header.
	
	aBitList removeFirstBits: header width.
	^ aBitList removeFirstBits: range last
	
]

{ #category : #setup }
BTIntegerPacker >> for: aRange use: aHeader [
	self checkRangesNotOverlap: aRange.
	self checkDoesNotBreakPrefixCode: aHeader.
	
	rangesToHeaders at: aRange put: aHeader.
]

{ #category : #private }
BTIntegerPacker >> headerFor: anInteger [
	^ rangesToHeaders at: (self rangeFor: anInteger)
]

{ #category : #private }
BTIntegerPacker >> headers [
	 ^ rangesToHeaders values
]

{ #category : #initialization }
BTIntegerPacker >> initialize [
	rangesToHeaders := SmallDictionary new.
]

{ #category : #'packing - unpacking' }
BTIntegerPacker >> pack: anInteger [
	^ self pack: anInteger into: BTBitList new
]

{ #category : #'packing - unpacking' }
BTIntegerPacker >> pack: anInteger into: aBitList [
	^ aBitList append: (self headerFor: anInteger);
				  appendBits: (self valueWidthFor: anInteger) from: anInteger
]

{ #category : #private }
BTIntegerPacker >> rangeFor: anInteger [
	| higherBit |
	higherBit := anInteger highBitOfPositiveReceiver.
	
	^ self ranges
		detect: [ :each | each rangeIncludes: higherBit ]
		ifNone: [ self cannotPackNumber ]
]

{ #category : #private }
BTIntegerPacker >> rangeForHeader: aBitList [
	^ rangesToHeaders keyAtValue: aBitList.
]

{ #category : #private }
BTIntegerPacker >> ranges [
	^ rangesToHeaders keys
]

{ #category : #'packing - unpacking' }
BTIntegerPacker >> unpack: aBitList [
	| header range |
	header := self detectHeaderAt: aBitList.
	range := self rangeForHeader: header.
	
	^ aBitList bitsFrom: header width + 1 to: header width + range last
]

{ #category : #private }
BTIntegerPacker >> valueWidthFor: anInteger [
	^ (self rangeFor: anInteger) last
	
]
