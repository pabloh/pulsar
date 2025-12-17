"
Bonsai is an implementation of the flyweight pattern for ASTs.
This class is the root of the expression hierarchy
"
Class {
	#name : 'FWNode',
	#superclass : 'Object',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'testing' }
FWNode >> isArrayNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isAssignmentNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isBlockNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isCascadeNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isExpressionNode [ 
	^ true
]

{ #category : 'testing' }
FWNode >> isLiteralNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isMessageNode [
	^ false 
]

{ #category : 'testing' }
FWNode >> isPragmaNode [ 
	^ false
]

{ #category : 'testing' }
FWNode >> isSelfNode [
	^ false
]

{ #category : 'testing' }
FWNode >> isSuperNode [
	^ false
]

{ #category : 'testing' }
FWNode >> isThisContextNode [
	^ false
]

{ #category : 'testing' }
FWNode >> isVariableNode [
	^ false
]
