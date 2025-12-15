"
Represents the pseudo-variable 'thisContext'
"
Class {
	#name : 'BSThisContextNode',
	#superclass : 'BSPseudoVariableNode',
	#category : 'Bonsai-Expressions',
	#package : 'Bonsai',
	#tag : 'Expressions'
}

{ #category : 'testing' }
BSThisContextNode >> isThisContextNode [
	^ true 
]

{ #category : 'printing' }
BSThisContextNode >> printOn: aStream [
	aStream << 'thisContext'
]
