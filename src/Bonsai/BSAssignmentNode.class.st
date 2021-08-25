"
Represents the code of an assignment.

Instance Variables		
	variable: 			<BSIdentifierFlyweight>
	expression:		<BSExpressionFlyweight>

"
Class {
	#name : #BSAssignmentNode,
	#superclass : #BSFlyweightNode,
	#instVars : [
		'variable',
		'expression'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSAssignmentNode class >> variable: aVariableNode expression: anExpressionNode [
	self assert: aVariableNode isVariableNode.
	self assert: anExpressionNode isExpressionNode.
	^ self privateLookup: { aVariableNode. anExpressionNode }
]

{ #category : #visitor }
BSAssignmentNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitAssignmentNode: self
]

{ #category : #accessing }
BSAssignmentNode >> expression [
	^ expression
]

{ #category : #transformations }
BSAssignmentNode >> expression: anExpressionValue [
	^ self class variable: self variable expression: anExpressionValue
]

{ #category : #testing }
BSAssignmentNode >> isAssignmentNode [
	^ true
]

{ #category : #printing }
BSAssignmentNode >> printOn: aStream [
	aStream 
		print: self variable;
		nextPutAll: ' := ';
		print: self expression
]

{ #category : #accessing }
BSAssignmentNode >> variable [
	^ variable
]

{ #category : #transformations }
BSAssignmentNode >> variable: anIdentifierValue [
	^ self class variable: anIdentifierValue expression: self expression
]
