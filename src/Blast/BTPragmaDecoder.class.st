"
A BTMessageEncoder is a BTPragmaNode to binary encoder.

"
Class {
	#name : #BTPragmaDecoder,
	#superclass : #BTNodeDecoder,
	#instVars : [
		'selector',
		'arguments',
		'selectorIndex',
		'argumentsIndexes'
	],
	#category : #'Blast-Decoders'
}

{ #category : #'binary format' }
BTPragmaDecoder >> binaryFormatClass [
	^ BTPragmaBinaryFormat detectFormatAt: self
]

{ #category : #decoding }
BTPragmaDecoder >> buildNode [
	^ BTPragmaNode
		selector: self fetchSelector
		arguments: self fetchArguments
]

{ #category : #decoding }
BTPragmaDecoder >> extractParts [
	binaryFormat removeHeader.
	selectorIndex := binaryFormat decodeSelectorIndex.
	argumentsIndexes := binaryFormat decodeArgumentsIndexesFor: self pragmaNumArgs
]

{ #category : #private }
BTPragmaDecoder >> fetchArguments [
	^ self literalStorage objectsAt: argumentsIndexes
]

{ #category : #private }
BTPragmaDecoder >> fetchSelector [
	^ self pragmaSelectorStorage objectAt: selectorIndex
]

{ #category : #private }
BTPragmaDecoder >> pragmaNumArgs [
	^ self fetchSelector numArgs
]
