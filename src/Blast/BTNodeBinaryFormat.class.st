"
A BTNodeBinaryFormat is an object that is able to write or interpret an specific and optimized binary format for representing Blast AST Nodes with BitLists
"
Class {
	#name : #BTNodeBinaryFormat,
	#superclass : #Object,
	#instVars : [
		'bitList'
	],
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format testing' }
BTNodeBinaryFormat class >> appliesFor: aStrategyContext [
	^ self subclassResponsibility
]

{ #category : #private }
BTNodeBinaryFormat class >> chooseFormatOrDefaultBy: aBlock [

		^ self specializedFormats detect: aBlock ifNone: self defaultFormat
]

{ #category : #'format selection' }
BTNodeBinaryFormat class >> defaultFormat [
	^ self
]

{ #category : #'format selection' }
BTNodeBinaryFormat class >> detectFormatAt: aNodeDecoder [
	^ self chooseFormatOrDefaultBy: [ :strategy | strategy formatMatches: aNodeDecoder encodedNode ]
]

{ #category : #'format testing' }
BTNodeBinaryFormat class >> formatMatches: aBitList [
	^ self subclassResponsibility
]

{ #category : #'format testing' }
BTNodeBinaryFormat class >> isDefault [
	^ self == self defaultFormat
]

{ #category : #'integer encoding' }
BTNodeBinaryFormat class >> literalsPacker [ 
	^ literalsPacker ifNil: [ 
		literalsPacker := (self flag: #TODO) ]
]

{ #category : #'instance creation' }
BTNodeBinaryFormat class >> on: aBitList [
	^ self new;
		bitList: aBitList;
		yourself
]

{ #category : #'integer encoding' }
BTNodeBinaryFormat class >> pragmaSelectorPacker [
	^ pragmaSelectorPacker ifNil: [ 
		pragmaSelectorPacker := (self flag: #TODO) ]
]

{ #category : #'format selection' }
BTNodeBinaryFormat class >> selectFormatFor: aNodeEncoder [
	^ self chooseFormatOrDefaultBy: [ :strategy | strategy appliesFor: aNodeEncoder ]
]

{ #category : #'format selection' }
BTNodeBinaryFormat class >> specializedFormats [
	^ self subclasses reject: #isDefault
]

{ #category : #accessing }
BTNodeBinaryFormat >> bitList [
	^ bitList
]

{ #category : #accessing }
BTNodeBinaryFormat >> bitList: anObject [
	bitList := anObject
]

{ #category : #'integer encoding' }
BTNodeBinaryFormat >> literalsPacker [ 
	^ self class literalsPacker 
]

{ #category : #'integer encoding' }
BTNodeBinaryFormat >> pragmaSelectorPacker [
	^ self class pragmaSelectorPacker
]
