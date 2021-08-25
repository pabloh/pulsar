Class {
	#name : #BTCommonPragmaBinaryFormat,
	#superclass : #BTPragmaBinaryFormat,
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format testing' }
BTCommonPragmaBinaryFormat class >> appliesFor: aStrategyContext [
	^ aStrategyContext selectorIndex between: 0 and: 31
]

{ #category : #'format testing' }
BTCommonPragmaBinaryFormat class >> formatMatches: aBitList [
	^ aBitList firstBits: 1 equals: 0
]

{ #category : #decoding }
BTCommonPragmaBinaryFormat >> decodeSelectorIndex [
	^ self pragmaSelectorPacker extractThenUnpackFrom: bitList
]

{ #category : #encoding }
BTCommonPragmaBinaryFormat >> encodeHeader [
	bitList appendBits: 1 from: 0
]

{ #category : #encoding }
BTCommonPragmaBinaryFormat >> encodeSelector: selectorIndex [
	self pragmaSelectorPacker pack: selectorIndex into: bitList
]
