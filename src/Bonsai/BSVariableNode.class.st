"
Represents the code of an identifier (globals, temporaries, arguments and special variables).

Instance Variables
- name			<Symbol>

"
Class {
	#name : #BSVariableNode,
	#superclass : #BSFlyweightNode,
	#instVars : [
		'name'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSVariableNode class >> name: aSymbol [
	self assert: aSymbol isSymbol.
	self assert: aSymbol ~= #self.
	self assert: aSymbol ~= #super.
	self assert: aSymbol ~= #thisContext.
	^ self privateLookup: { aSymbol }
]

{ #category : #'instance creation' }
BSVariableNode class >> privateHash: array [
	"Need to be redefined to distinguish between an identifier and a symbol because both are encoded with symbols (ex: between the variable foo and the symbol #foo)"
	^ (array instVarAt: 1) hash bitXor: 678664627
]

{ #category : #visitor }
BSVariableNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitVariablelNode: self
]

{ #category : #testing }
BSVariableNode >> isVariableNode [
	^ true

]

{ #category : #accessing }
BSVariableNode >> name [
	^ name
]

{ #category : #transformations }
BSVariableNode >> name: aSymbol [
	^ self class name: aSymbol
]

{ #category : #printing }
BSVariableNode >> printOn: aStream [
	aStream << self name
]
