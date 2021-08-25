"
A BTMessageEncoder is BTAssigmentNode to binary encoder.


"
Class {
	#name : #BTAssignmentDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'encoding - decoding' }
BTAssignmentDecoder >> appendEncodedVariable [
	result append: (self encodedVariable: node variable)
]

{ #category : #'encoding - decoding' }
BTAssignmentDecoder >> decode: aBitList [
	| leftSidePos rightSidePos typePrefix |
	
	leftSidePos := self extractLeftSidePositionFrom: aBitList.
	typePrefix := self extractTypePrefixFrom: aBitList.
	rightSidePos := self extractRightSidePositionFrom: aBitList.
	
	^ BTAssignmentNode
		variable: (self variableStogare objectAt: leftSidePos)
		expression: ((self storageForTypePrefix: typePrefix) objectAt: rightSidePos)
]

{ #category : #'private - encoding' }
BTAssignmentDecoder >> encodedAssignedExpression:  anExpressionNode [
	^ BTBitList fromInteger:
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTAssignmentDecoder >> encodedVariable: anVariableNode [
	^ BTBitList fromInteger:
		(self variableStogare store: anVariableNode)
]

{ #category : #'private - decoding' }
BTAssignmentDecoder >> extractLeftSidePositionFrom: aBitList [
	^ aBitList removeFirstBits: self leftSideSize
]

{ #category : #'private - decoding' }
BTAssignmentDecoder >> extractRightSidePositionFrom: aBitList [
	^ aBitList removeFirstBits: self rightSideSize
]

{ #category : #'private - decoding' }
BTAssignmentDecoder >> leftSideSize [
	^ self wordBitsSize
]

{ #category : #'private - decoding' }
BTAssignmentDecoder >> rigthSideSize [
	^ self wordBitsSize
]
