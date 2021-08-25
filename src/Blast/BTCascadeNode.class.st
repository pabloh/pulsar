"
A BTCascadeNode is an AST node representing cascade message send.

Instance Variables
	messages:		<Object>
	receiver:		<Object>

messages
	- xxxxx

receiver
	- xxxxx

"
Class {
	#name : #BTCascadeNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'receiver',
		'parts'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTCascadeNode class >> receiver: anExpressionNode parts: aCascadePartList [

	^self new
		receiver: anExpressionNode;
		parts: aCascadePartList;
		yourself 
]

{ #category : #'as yet unclassified' }
BTCascadeNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitCascadeNode: self
]

{ #category : #accessing }
BTCascadeNode >> parts [
	^ parts
]

{ #category : #accessing }
BTCascadeNode >> parts: aCascadePartList [
	parts := aCascadePartList
]

{ #category : #'as yet unclassified' }
BTCascadeNode >> printOn: aStream [
	aStream print: self receiver; space.
	self parts  
		do: [ :part | part printOn: aStream ]
		separatedBy: [ aStream < ';' ]
]

{ #category : #accessing }
BTCascadeNode >> receiver [
	^ receiver.
]

{ #category : #accessing }
BTCascadeNode >> receiver: anExpression [
	receiver := anExpression
]
