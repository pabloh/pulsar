"
A BTMessageEncoder is a BTPragmaNode to binary encoder.

"
Class {
	#name : #BTPragmaEncoder,
	#superclass : #BTNodeEncoder,
	#instVars : [
		'selectorIndex',
		'argumentsIndexes'
	],
	#category : #'Blast-Encoders'
}

{ #category : #'binary format' }
BTPragmaEncoder >> binaryFormatClass [
	^ BTPragmaBinaryFormat selectFormatFor: self
]

{ #category : #encoding }
BTPragmaEncoder >> buildResult [
	binaryFormat encodeHeader.
	binaryFormat encodeSelector: selectorIndex.
	binaryFormat encodeArguments: argumentsIndexes
]

{ #category : #encoding }
BTPragmaEncoder >> processParts [
	selectorIndex := self pragmaSelectorStorage store: node selector.
	argumentsIndexes := self literalStorage storeAll: node arguments
]

{ #category : #accesing }
BTPragmaEncoder >> selectorArity [
	^ node selector numArgs
]
