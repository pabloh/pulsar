"
A BTNode is the base class for AST nodes in Blast.
"
Class {
	#name : #BTNode,
	#superclass : #Object,
	#classInstVars : [
		'storage'
	],
	#category : #'Blast-Nodes'
}

{ #category : #testing }
BTNode >> isAssignmentNode [
	^ false
]

{ #category : #testing }
BTNode >> isLiteralNode [
	^ false
]

{ #category : #testing }
BTNode >> isMessageNode [
	^ false
]

{ #category : #testing }
BTNode >> isVariableNode [
	^ false
]
