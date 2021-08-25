"
A BTLiteralNode is the AST node for variables.
"
Class {
	#name : #BTVariableNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'name'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTVariableNode class >> name: aName [

	^self new
		name: aName;
		yourself.
]

{ #category : #storages }
BTVariableNode class >> storageAt: aStorageDirectory [
	^aStorageDirectory variableNodeStorage
	
]

{ #category : #visitor }
BTVariableNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitVariablelNode: self
]

{ #category : #testing }
BTVariableNode >> isVariableNode [
	^true
]

{ #category : #accessing }
BTVariableNode >> name [
	^ name
]

{ #category : #accessing }
BTVariableNode >> name: aName [
	name := aName
]

{ #category : #printing }
BTVariableNode >> printOn: aStream [
	aStream << name.
]
