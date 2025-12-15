"
Represents the pseudo-variable 'super'
"
Class {
	#name : 'BSSuperNode',
	#superclass : 'BSPseudoVariableNode',
	#category : 'Bonsai-Expressions',
	#package : 'Bonsai',
	#tag : 'Expressions'
}

{ #category : 'testing' }
BSSuperNode >> isSuperNode [
	^ true 
]

{ #category : 'printing' }
BSSuperNode >> printOn: aStream [
	aStream << 'super'
]
