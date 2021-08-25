"
A BTMessageEncoder is BTAssigmentNode to binary encoder.


"
Class {
	#name : #BTAssignmentEncoder,
	#superclass : #BTNodeEncoder,
	#instVars : [
		'variableNameCode',
		'assignedExpressionCode'
	],
	#category : #'Blast-Encoders'
}

{ #category : #accesing }
BTAssignmentEncoder >> assignedExpressionCode [
	^ assignedExpressionCode
]

{ #category : #'remaining stuff' }
BTAssignmentEncoder >> encodedAssignedExpression [
	^ BTBitList fromInteger: assignedExpressionCode
]

{ #category : #'remaining stuff' }
BTAssignmentEncoder >> encodedHeader [
	^ self encodedTypePrefixFor: node expression
]

{ #category : #'remaining stuff' }
BTAssignmentEncoder >> encodedVariable [
	^ BTBitList fromInteger: self variableNameCode
]

{ #category : #'encoding - decoding' }
BTAssignmentEncoder >> processParts [
	variableNameCode := self variableStogare store: node variable.
	assignedExpressionCode := (self storageFor: node expression) store: node expression
]

{ #category : #accesing }
BTAssignmentEncoder >> variableNameCode [
	^ variableNameCode
]
