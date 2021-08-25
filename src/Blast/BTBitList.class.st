"
A BitSet represents convenient mutable bitset for easing general purpose bitwise operations.
"
Class {
	#name : #BTBitList,
	#superclass : #Object,
	#instVars : [
		'value',
		'width'
	],
	#category : #'Blast-Misc'
}

{ #category : #'instance creation' }
BTBitList class >> fromInteger: anInteger [

	^ self	value: anInteger
			width: (anInteger isLarge ifTrue: [ anInteger basicSize * 8 ] ifFalse: [ Smalltalk wordSize * 8 ]).
]

{ #category : #'instance creation' }
BTBitList class >> value: anInteger width: aSize [.

	^self new 
		value: anInteger width: aSize.
]

{ #category : #comparing }
BTBitList >> = aBitList [

	^value = aBitList asInteger and: [ self width = aBitList width ]
]

{ #category : #adding }
BTBitList >> append: aBitList [
	self appendBits: aBitList width from: aBitList asInteger
]

{ #category : #adding }
BTBitList >> appendBits: n from: anInteger [
	value := value bitOr: (anInteger bitAnd: (self bitMaskFor: n)) << width.
	width := width + n.
]

{ #category : #converting }
BTBitList >> as31BitSmallInt [
	^ value as31BitSmallInt 
]

{ #category : #converting }
BTBitList >> asInteger [
	^ value
]

{ #category : #testing }
BTBitList >> beginsWith: aBitList [
	^ self firstBits: aBitList width equals: aBitList asInteger
]

{ #category : #accessing }
BTBitList >> bitAt: anInteger [
	self checkBoundsFor: anInteger.

	^value bitAt: anInteger 
]

{ #category : #accessing }
BTBitList >> bitAt: anInteger put: aValue [
	self checkBoundsFor: anInteger.

	value := value bitAt: anInteger put: aValue
]

{ #category : #accessing }
BTBitList >> bitListFrom: start to: end [
	
	^ BTBitList value: (self bitsFrom: start to: end) width: end - start + 1
	
]

{ #category : #helpers }
BTBitList >> bitMaskFor: bits [
	^ (1 << bits) - 1
]

{ #category : #accessing }
BTBitList >> bitsFrom: start to: end [
	| mask |
	self checkBoundsFor: start and: end.
	
	mask := self bitMaskFor:  (end - start + 1).
	
	^ value >> (start - 1) bitAnd: mask
	
]

{ #category : #testing }
BTBitList >> bitsFrom: start to: end equals: anInteger [
	^ end <= width and: [ (self bitsFrom: start to: end) = anInteger ]
]

{ #category : #private }
BTBitList >> checkBoundsFor: anInteger [

	(anInteger between: 1 and: width) ifFalse: [ SubscriptOutOfBounds signalFor: anInteger ]
]

{ #category : #private }
BTBitList >> checkBoundsFor: start and: end [

	self checkBoundsFor: start;
		 checkBoundsFor: end.
]

{ #category : #private }
BTBitList >> checkSize: anInteger [
	anInteger <= width ifFalse: [ SubscriptOutOfBounds signalFor: anInteger ]
]

{ #category : #accessing }
BTBitList >> firstBits: n [
	^ self bitsFrom: 1 to: n

]

{ #category : #testing }
BTBitList >> firstBits: n equals: anInteger [
	^ self bitsFrom: 1 to: n equals: anInteger
]

{ #category : #comparing }
BTBitList >> hash [

	^(value hash hashMultiply + width hash) hashMultiply
]

{ #category : #initialization }
BTBitList >> initialize [

	self value: 0 width: 0.
]

{ #category : #testing }
BTBitList >> isPrefixCodeCompatible: aBitList [
	^ (self beginsWith: aBitList) not and: [ (aBitList beginsWith: self) not ]
]

{ #category : #accessing }
BTBitList >> isSetBitAt: anInteger [

	^(self bitAt: anInteger) ~= 0
]

{ #category : #printing }
BTBitList >> printOn: aStream [
	aStream << 'a BitList(' << ((value printStringBase: 2) asString padLeftTo: width with: $0) << ')'
]

{ #category : #removing }
BTBitList >> removeFirstBitList: n [
	"Remove the first n elements and return BitSet with them"

	^self class value: (self removeFirstBits: n) width: n
]

{ #category : #removing }
BTBitList >> removeFirstBits: n [
	"Remove the first n elements and return an Integer with them"
	| result |
	self checkSize: n.
	
	result := self firstBits:  n. 
	width := width - n.
	value := value >> n.
	
	^ result
]

{ #category : #'instance creation' }
BTBitList >> value: anInteger width: aSize [.

	value := anInteger asInteger bitAnd: (self bitMaskFor: aSize).
	width  := aSize
]

{ #category : #accessing }
BTBitList >> width [
	^ width
]
