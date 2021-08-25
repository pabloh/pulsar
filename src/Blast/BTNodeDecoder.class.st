"
A BTNodeDecoder is a class that generates a Blast AST node from an encoded representation.

Instance Variables
	encodedNode:		<Object>

encodedNode
	- xxxxx

"
Class {
	#name : #BTNodeDecoder,
	#superclass : #BTNodeProcessor,
	#instVars : [
		'encodedNode'
	],
	#category : #'Blast-Decoders'
}

{ #category : #'instance creation' }
BTNodeDecoder class >> for: anEncodedNode using: aStorageDirectory [
	^ (self using: aStorageDirectory)
		encodedNode: anEncodedNode; 
		yourself
]

{ #category : #decoding }
BTNodeDecoder >> buildNode [
	^ self subclassResponsibility 
]

{ #category : #decoding }
BTNodeDecoder >> decode [
	self detectBinaryFormat.
	self extractParts.
	^ self buildNode
]

{ #category : #'binary format' }
BTNodeDecoder >> detectBinaryFormat [
	binaryFormat := self binaryFormatClass on: encodedNode
]

{ #category : #accessing }
BTNodeDecoder >> encodedNode [
	^ encodedNode
]

{ #category : #accessing }
BTNodeDecoder >> encodedNode: aNode [
	encodedNode := aNode
]

{ #category : #decoding }
BTNodeDecoder >> extractParts [
	^ self subclassResponsibility 
]
