"
A BTEncodedObjectStorage is an adapter for the BTBinaryStorage that allows storing regular objects using an encoded binary format from an ad-hoc encoder.

Instance Variables
	encoderClass:		<Object>

encoderClass
	- xxxxx

"
Class {
	#name : #BTEncodedObjectStorage,
	#superclass : #BTStorageWrapper,
	#instVars : [
		'translator'
	],
	#category : #'Blast-Storage'
}

{ #category : #'instance creation' }
BTEncodedObjectStorage class >> for: aStorage using: aTranslator [.
	^ (self for: aStorage)
		translator: aTranslator;
		yourself
]

{ #category : #accessing }
BTEncodedObjectStorage >> objectAt: anIndex [
	^ translator decode: (storage objectAt: anIndex)
]

{ #category : #storing }
BTEncodedObjectStorage >> store: anObject [ 
	^ storage store: (translator encode: anObject)
	
]

{ #category : #accessing }
BTEncodedObjectStorage >> translator [
	^ translator
]

{ #category : #accessing }
BTEncodedObjectStorage >> translator: aTranslator [
	translator := aTranslator 
]
