"
An abstract class for the three pseudo-variables: 'self', 'super' and 'thisContext'.
Implements the singleton pattern (with class-side instance variable 'uniqueInstance).
"
Class {
	#name : #BSPseudoVariableNode,
	#superclass : #BSNode,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSPseudoVariableNode class >> basicNew [
	self error: 'I have only one instance. You can obtain it with #uniqueInstance'
]

{ #category : #accessing }
BSPseudoVariableNode class >> self [
	^ BSSelfNode uniqueInstance
]

{ #category : #accessing }
BSPseudoVariableNode class >> super [
	^ BSSuperNode uniqueInstance
]

{ #category : #accessing }
BSPseudoVariableNode class >> thisContext [
	^ BSThisContextNode uniqueInstance
]

{ #category : #accessing }
BSPseudoVariableNode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super basicNew ]
]

{ #category : #visitor }
BSPseudoVariableNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitPseudoVariablelNode: self
]
