"
Represents a literal. 
It should maybe have a subclass for numbers in order to store the source since one number can have various representations.

Instance Variables
	value:	<Object>

"
Class {
	#name : 'FWLiteralNode',
	#superclass : 'FWFlyweightNode',
	#instVars : [
		'value'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWLiteralNode class >> value: aLiteral [
	^  self privateLookup: { aLiteral }
]

{ #category : 'visitor' }
FWLiteralNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitLiteralNode: self
]

{ #category : 'testing' }
FWLiteralNode >> isLiteralNode [
	^ true
]

{ #category : 'printing' }
FWLiteralNode >> printOn: aStream [
	self value printOn: aStream
]

{ #category : 'accessing' }
FWLiteralNode >> value [
	^ value
]

{ #category : 'transformations' }
FWLiteralNode >> value: aSymbol [
	^ self class value: aSymbol
]
