"
Represents the code of an identifier (globals, temporaries, arguments and special variables).

Instance Variables
- name			<Symbol>

"
Class {
	#name : 'FWVariableNode',
	#superclass : 'FWFlyweightNode',
	#instVars : [
		'name'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWVariableNode class >> name: aSymbol [
	self assert: aSymbol isSymbol.
	self assert: aSymbol ~= #self.
	self assert: aSymbol ~= #super.
	self assert: aSymbol ~= #thisContext.
	^ self privateLookup: { aSymbol }
]

{ #category : 'instance creation' }
FWVariableNode class >> privateHash: array [
	"Need to be redefined to distinguish between an identifier and a symbol because both are encoded with symbols (ex: between the variable foo and the symbol #foo)"
	^ (array instVarAt: 1) hash bitXor: 678664627
]

{ #category : 'visitor' }
FWVariableNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitVariablelNode: self
]

{ #category : 'testing' }
FWVariableNode >> isVariableNode [
	^ true

]

{ #category : 'accessing' }
FWVariableNode >> name [
	^ name
]

{ #category : 'transformations' }
FWVariableNode >> name: aSymbol [
	^ self class name: aSymbol
]

{ #category : 'printing' }
FWVariableNode >> printOn: aStream [
	aStream << self name
]
