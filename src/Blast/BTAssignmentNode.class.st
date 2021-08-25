"
A BTAssignmentNode is the AST node representing assignments.

Instance Variables
	expression:		<Object>
	variable:		<Object>

expression
	- xxxxx

variable
	- xxxxx

"
Class {
	#name : #BTAssignmentNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'variable',
		'expression'
	],
	#category : #'Blast-Nodes'
}

{ #category : #storages }
BTAssignmentNode class >> storageAt: aStorageDirectory [
	^ aStorageDirectory assignmentNodeStorage
]

{ #category : #'instance creation' }
BTAssignmentNode class >> variable: aVariableNode expression: anExpression [

	^self new
		variable: aVariableNode;
		expression: anExpression;
		yourself
]

{ #category : #visitor }
BTAssignmentNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitAssignmentNode: self
]

{ #category : #accessing }
BTAssignmentNode >> expression [
	^ expression
]

{ #category : #accessing }
BTAssignmentNode >> expression: anExpression [
	expression := anExpression
]

{ #category : #testing }
BTAssignmentNode >> isAssignmentNode [
	^true
]

{ #category : #printing }
BTAssignmentNode >> printOn: aStream [
	self variable printOn: aStream.
	aStream << ' := '.
	self expression printOn: aStream
]

{ #category : #accessing }
BTAssignmentNode >> variable [
	^ variable
]

{ #category : #accessing }
BTAssignmentNode >> variable: aVariableNode [
	variable := aVariableNode
]
