"
Represents the pseudo-variable 'thisContext'
"
Class {
	#name : 'FWThisContextNode',
	#superclass : 'FWPseudoVariableNode',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'testing' }
FWThisContextNode >> isThisContextNode [
	^ true 
]

{ #category : 'printing' }
FWThisContextNode >> printOn: aStream [
	aStream << 'thisContext'
]
