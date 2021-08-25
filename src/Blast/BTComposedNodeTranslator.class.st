"
A BTComposedNodeTranslator is an object capable of encoding/decoding into(from) binary formats using encoder and decoders classes.
"
Class {
	#name : #BTComposedNodeTranslator,
	#superclass : #BTNodeTranslator,
	#instVars : [
		'storageDirectory',
		'decoderClass',
		'encoderClass'
	],
	#category : #'Blast-Core'
}

{ #category : #'instance creation' }
BTComposedNodeTranslator class >> encoderClass: encoderClass decoderClass: decoderClass directory: anStorageDirectory [
	^ self new
		encoderClass: encoderClass;
		decoderClass: decoderClass;
		storageDirectory: anStorageDirectory
		yourself
]

{ #category : #transcoding }
BTComposedNodeTranslator >> decode: aValue [
	^ (self decoderFor: aValue) decode
]

{ #category : #accessing }
BTComposedNodeTranslator >> decoderClass [
	^ decoderClass
]

{ #category : #accessing }
BTComposedNodeTranslator >> decoderClass: aClass [
	decoderClass := aClass
]

{ #category : #private }
BTComposedNodeTranslator >> decoderFor: aValue [
	^ decoderClass for: aValue using: storageDirectory
]

{ #category : #transcoding }
BTComposedNodeTranslator >> encode: aNode [
	^ (self encoderFor: aNode) encode
]

{ #category : #accessing }
BTComposedNodeTranslator >> encoderClass [
	^ encoderClass
]

{ #category : #accessing }
BTComposedNodeTranslator >> encoderClass: aClass [
	encoderClass := aClass
]

{ #category : #private }
BTComposedNodeTranslator >> encoderFor: aNode [
	^ encoderClass for: aNode using: storageDirectory
]

{ #category : #accessing }
BTComposedNodeTranslator >> storageDirectory [
	^ storageDirectory
]

{ #category : #accessing }
BTComposedNodeTranslator >> storageDirectory: anObject [
	storageDirectory := anObject
]
