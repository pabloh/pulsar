"
Represents the pseudo-variable 'self'
"
Class {
	#name : 'FWSelfNode',
	#superclass : 'FWPseudoVariableNode',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'testing' }
FWSelfNode >> isSelfNode [
	^ true 
]

{ #category : 'printing' }
FWSelfNode >> printOn: aStream [
	aStream << 'self'
]
