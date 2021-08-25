Class {
	#name : #BTDefaultPragmaBinaryFormat,
	#superclass : #BTPragmaBinaryFormat,
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format testing' }
BTDefaultPragmaBinaryFormat class >> appliesFor: aStrategyContext [
	^ true
]

{ #category : #'format testing' }
BTDefaultPragmaBinaryFormat class >> formatMatches: aBitList [
	^ aBitList firstBits: 1 equals: 1
]

{ #category : #decoding }
BTDefaultPragmaBinaryFormat >> decodeSelectorIndex [
	^ self pragmaSelectorPacker extractThenUnpackFrom: bitList
]

{ #category : #encoding }
BTDefaultPragmaBinaryFormat >> encodeHeader [
	bitList appendBits: 1 from: 1
]

{ #category : #encoding }
BTDefaultPragmaBinaryFormat >> encodeSelector: selectorIndex [
	self pragmaSelectorPacker pack: selectorIndex into: bitList
]
