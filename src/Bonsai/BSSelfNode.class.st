"
Represents the pseudo-variable 'self'
"
Class {
	#name : #BSSelfNode,
	#superclass : #BSPseudoVariableNode,
	#category : #'Bonsai-Expressions'
}

{ #category : #testing }
BSSelfNode >> isSelfNode [
	^ true 
]

{ #category : #printing }
BSSelfNode >> printOn: aStream [
	aStream << 'self'
]
