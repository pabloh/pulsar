"
A BTSimpleNodeTranslator is an object capable of encoding/decoding by the use of code blocks.
"
Class {
	#name : #BTSimpleNodeTranslator,
	#superclass : #BTNodeTranslator,
	#instVars : [
		'decoderBlock',
		'encoderBlock'
	],
	#category : #'Blast-Core'
}

{ #category : #'instance creation' }
BTSimpleNodeTranslator class >> encoderBlock: encoderBlock decoderBlock: decoderBlock [
	^ self new
		encoderBlock: encoderBlock;
		decoderBlock: decoderBlock;
		yourself
]

{ #category : #transcoding }
BTSimpleNodeTranslator >> decode: aValue [
	^ decoderBlock value: aValue
]

{ #category : #accessing }
BTSimpleNodeTranslator >> decoderBlock [
	^ decoderBlock
]

{ #category : #accessing }
BTSimpleNodeTranslator >> decoderBlock: anObject [
	decoderBlock := anObject
]

{ #category : #transcoding }
BTSimpleNodeTranslator >> encode: aNode [
	^ encoderBlock value: aNode
]

{ #category : #accessing }
BTSimpleNodeTranslator >> encoderBlock [
	^ encoderBlock
]

{ #category : #accessing }
BTSimpleNodeTranslator >> encoderBlock: anObject [
	encoderBlock := anObject
]
