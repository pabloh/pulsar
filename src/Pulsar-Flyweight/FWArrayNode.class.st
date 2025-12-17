"
Represents the code of a dynamic array.

Variable Part			<BSExpressionFlyweight*>

"
Class {
	#name : 'FWArrayNode',
	#superclass : 'FWFlyweightNode',
	#type : 'variable',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWArrayNode class >> expressions: anExpressionNodeArray [
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: anExpressionNodeArray
]

{ #category : 'visitor' }
FWArrayNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitArrayNode: self
]

{ #category : 'accessing' }
FWArrayNode >> expressions [
	^ self variablePart
]

{ #category : 'transformations' }
FWArrayNode >> expressions: expressionArray [
	^ self class expressions: expressionArray
]

{ #category : 'testing' }
FWArrayNode >> isArrayNode [
	^ true
]

{ #category : 'printing' }
FWArrayNode >> printOn: aStream [
	aStream << '{ '.
	self expressions
		do: [ :expression | 
			expression isSymbol 
				ifTrue: [ aStream << expression ]
				ifFalse: [ aStream print: expression ] ]
		separatedBy: [ aStream << '. ' ].
	aStream << ' }'.
]
