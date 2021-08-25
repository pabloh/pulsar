"
A BTLiteralNode is the AST node for literal values.

"
Class {
	#name : #BTLiteralNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'value'
	],
	#category : #'Blast-Nodes'
}

{ #category : #storages }
BTLiteralNode class >> storageAt: aStorageDirectory [
	^aStorageDirectory literalNodeStorage
]

{ #category : #'instance creation' }
BTLiteralNode class >> value: aValue [

	^self new
		value: aValue;
		yourself.
]

{ #category : #visitor }
BTLiteralNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitLiteralNode: self
]

{ #category : #testing }
BTLiteralNode >> isLiteralNode [
	^true
]

{ #category : #printing }
BTLiteralNode >> printOn: aStream [
	self value printOn: aStream.
]

{ #category : #accessing }
BTLiteralNode >> value [
	^ value
]

{ #category : #accessing }
BTLiteralNode >> value: aValue [
	value := aValue
]
