"
Represents the pseudo-variable 'super'
"
Class {
	#name : 'FWSuperNode',
	#superclass : 'FWPseudoVariableNode',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'testing' }
FWSuperNode >> isSuperNode [
	^ true 
]

{ #category : 'printing' }
FWSuperNode >> printOn: aStream [
	aStream << 'super'
]
