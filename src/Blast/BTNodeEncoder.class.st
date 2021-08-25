"
A NodeEnconder is class that translates a Blast AST node to an encoded representation.

Instance Variables
	decoder:		<Object>
	encoder:		<Object>

decoder
	- xxxxx

encoder
	- xxxxx

"
Class {
	#name : #BTNodeEncoder,
	#superclass : #BTNodeProcessor,
	#instVars : [
		'node'
	],
	#category : #'Blast-Encoders'
}

{ #category : #'instance creation' }
BTNodeEncoder class >> for: aNode using: aStorageDirectory [
	^ (self using: aStorageDirectory)
		node: aNode; 
		yourself
]

{ #category : #encoding }
BTNodeEncoder >> buildResult [
	self subclassResponsibility 
]

{ #category : #encoding }
BTNodeEncoder >> encode [
	self processParts.
	self selectBinaryFormat.
	self buildResult.
	^ binaryFormat bitList
]

{ #category : #accessing }
BTNodeEncoder >> node [
	^ node
]

{ #category : #accessing }
BTNodeEncoder >> node: aNode [
	node := aNode
]

{ #category : #encoding }
BTNodeEncoder >> processParts [
	self subclassResponsibility 
]

{ #category : #'binary format' }
BTNodeEncoder >> selectBinaryFormat [
	binaryFormat := self binaryFormatClass on: BTBitList new
]
