"
An abstract class for the three pseudo-variables: 'self', 'super' and 'thisContext'.
Implements the singleton pattern (with class-side instance variable 'uniqueInstance).
"
Class {
	#name : 'FWPseudoVariableNode',
	#superclass : 'FWNode',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWPseudoVariableNode class >> basicNew [
	self error: 'I have only one instance. You can obtain it with #uniqueInstance'
]

{ #category : 'accessing' }
FWPseudoVariableNode class >> self [
	^ FWSelfNode uniqueInstance
]

{ #category : 'accessing' }
FWPseudoVariableNode class >> super [
	^ FWSuperNode uniqueInstance
]

{ #category : 'accessing' }
FWPseudoVariableNode class >> thisContext [
	^ FWThisContextNode uniqueInstance
]

{ #category : 'accessing' }
FWPseudoVariableNode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super basicNew ]
]

{ #category : 'visitor' }
FWPseudoVariableNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitPseudoVariablelNode: self
]
