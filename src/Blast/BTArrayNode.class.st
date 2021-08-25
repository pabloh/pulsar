"
A BTArrayNode is the AST node for dynamic arrays.

Instance Variables
	expressions:		<Object>

expressions
	- xxxxx

"
Class {
	#name : #BTArrayNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'expressions'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTArrayNode class >> expressions: anExpressionList [

	^self new
		expressions: anExpressionList;
		yourself
]

{ #category : #storages }
BTArrayNode class >> storageAt: aStorageDirectory [
	^ aStorageDirectory arrayNodeStorage
]

{ #category : #visitor }
BTArrayNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitArrayNode: self
]

{ #category : #accessing }
BTArrayNode >> expressions [
	^ expressions
]

{ #category : #accessing }
BTArrayNode >> expressions: anExpressionList [
	expressions := anExpressionList
]

{ #category : #printing }
BTArrayNode >> printOn: aStream [
	aStream << '{ '.
	self expressions
		do: [ :expression | 
			expression isSymbol 
				ifTrue: [ aStream << expression ]
				ifFalse: [ aStream print: expression ] ]
		separatedBy: [ aStream << '. ' ].
	aStream << ' }'.
]
