"
Represents the code of an assignment.

Instance Variables		
	variable: 			<BSIdentifierFlyweight>
	expression:		<BSExpressionFlyweight>

"
Class {
	#name : 'FWAssignmentNode',
	#superclass : 'FWFlyweightNode',
	#instVars : [
		'variable',
		'expression'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWAssignmentNode class >> variable: aVariableNode expression: anExpressionNode [
	self assert: aVariableNode isVariableNode.
	self assert: anExpressionNode isExpressionNode.
	^ self privateLookup: { aVariableNode. anExpressionNode }
]

{ #category : 'visitor' }
FWAssignmentNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitAssignmentNode: self
]

{ #category : 'accessing' }
FWAssignmentNode >> expression [
	^ expression
]

{ #category : 'transformations' }
FWAssignmentNode >> expression: anExpressionValue [
	^ self class variable: self variable expression: anExpressionValue
]

{ #category : 'testing' }
FWAssignmentNode >> isAssignmentNode [
	^ true
]

{ #category : 'printing' }
FWAssignmentNode >> printOn: aStream [
	aStream 
		print: self variable;
		nextPutAll: ' := ';
		print: self expression
]

{ #category : 'accessing' }
FWAssignmentNode >> variable [
	^ variable
]

{ #category : 'transformations' }
FWAssignmentNode >> variable: anIdentifierValue [
	^ self class variable: anIdentifierValue expression: self expression
]
