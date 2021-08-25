"
Represents a literal. 
It should maybe have a subclass for numbers in order to store the source since one number can have various representations.

Instance Variables
	value:	<Object>

"
Class {
	#name : #BSLiteralNode,
	#superclass : #BSFlyweightNode,
	#instVars : [
		'value'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSLiteralNode class >> value: aLiteral [
	^  self privateLookup: { aLiteral }
]

{ #category : #visitor }
BSLiteralNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitLiteralNode: self
]

{ #category : #testing }
BSLiteralNode >> isLiteralNode [
	^ true
]

{ #category : #printing }
BSLiteralNode >> printOn: aStream [
	self value printOn: aStream
]

{ #category : #accessing }
BSLiteralNode >> value [
	^ value
]

{ #category : #transformations }
BSLiteralNode >> value: aSymbol [
	^ self class value: aSymbol
]
