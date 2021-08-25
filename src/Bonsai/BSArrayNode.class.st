"
Represents the code of a dynamic array.

Variable Part			<BSExpressionFlyweight*>

"
Class {
	#name : #BSArrayNode,
	#superclass : #BSFlyweightNode,
	#type : #variable,
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSArrayNode class >> expressions: anExpressionNodeArray [
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: anExpressionNodeArray
]

{ #category : #visitor }
BSArrayNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitArrayNode: self
]

{ #category : #accessing }
BSArrayNode >> expressions [
	^ self variablePart
]

{ #category : #transformations }
BSArrayNode >> expressions: expressionArray [
	^ self class expressions: expressionArray
]

{ #category : #testing }
BSArrayNode >> isArrayNode [
	^ true
]

{ #category : #printing }
BSArrayNode >> printOn: aStream [
	aStream << '{ '.
	self expressions
		do: [ :expression | 
			expression isSymbol 
				ifTrue: [ aStream << expression ]
				ifFalse: [ aStream print: expression ] ]
		separatedBy: [ aStream << '. ' ].
	aStream << ' }'.
]
