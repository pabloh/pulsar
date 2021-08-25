"
A BTNodeTranslator is an object capable of encoding/decoding Blast AST nodes into/from an alternative representation.
"
Class {
	#name : #BTNodeTranslator,
	#superclass : #Object,
	#category : #'Blast-Core'
}

{ #category : #'instance creation' }
BTNodeTranslator class >> encoderBlock: encoderBlock decoderBlock: decoderBlock [ 
	^ BTSimpleNodeTranslator
		encoderBlock: encoderBlock
		decoderBlock: decoderBlock
]

{ #category : #'instance creation' }
BTNodeTranslator class >> encoderClass: encoderClass decoderClass: decoderClass directory: anStorageDirectory [
	^ BTComposedNodeTranslator
		encoderClass: encoderClass
		decoderClass: decoderClass
		directory: anStorageDirectory
]

{ #category : #translating }
BTNodeTranslator >> decode: aValue [
	self subclassResponsibility
]

{ #category : #translating }
BTNodeTranslator >> encode: aValue [
	self subclassResponsibility
]
