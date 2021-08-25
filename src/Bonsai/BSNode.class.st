"
Bonsai is an implementation of the flyweight pattern for ASTs.
This class is the root of the expression hierarchy
"
Class {
	#name : #BSNode,
	#superclass : #Object,
	#category : #'Bonsai-Expressions'
}

{ #category : #testing }
BSNode >> isArrayNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isAssignmentNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isBlockNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isCascadeNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isExpressionNode [ 
	^ true
]

{ #category : #testing }
BSNode >> isLiteralNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isMessageNode [
	^ false 
]

{ #category : #testing }
BSNode >> isPragmaNode [ 
	^ false
]

{ #category : #testing }
BSNode >> isSelfNode [
	^ false
]

{ #category : #testing }
BSNode >> isSuperNode [
	^ false
]

{ #category : #testing }
BSNode >> isThisContextNode [
	^ false
]

{ #category : #testing }
BSNode >> isVariableNode [
	^ false
]
