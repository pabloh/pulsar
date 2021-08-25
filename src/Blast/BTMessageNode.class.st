"
A BTMessageNode is the AST node for message send.

Instance Variables
	arguments:		<Object>
	receiver:		<Object>
	selector:		<Object>

arguments
	- xxxxx

receiver
	- xxxxx

selector
	- xxxxx

"
Class {
	#name : #BTMessageNode,
	#superclass : #BTEncodedNode,
	#traits : 'TKeywordedNode',
	#classTraits : 'TKeywordedNode classTrait',
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTMessageNode class >> receiver: anExpression selector: aSelector arguments: anArgumentList [
	
	^self new
		receiver: anExpression;
		selector: aSelector;
		arguments: anArgumentList ;
		yourself 
]

{ #category : #visitor }
BTMessageNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitMessageNode: self
]

{ #category : #accessing }
BTMessageNode >> arguments [
	^ arguments
]

{ #category : #accessing }
BTMessageNode >> arguments: anArgumentList [
	arguments := anArgumentList
]

{ #category : #testing }
BTMessageNode >> isMessageNode [
	^ true
]

{ #category : #printing }
BTMessageNode >> printOn: aStream [
	aStream print: self receiver; space.
	self printKeywordsAndArgumentsOn: aStream
]

{ #category : #accessing }
BTMessageNode >> receiver [
	^ receiver
]

{ #category : #accessing }
BTMessageNode >> receiver: anExpression [
	receiver := anExpression
]

{ #category : #accessing }
BTMessageNode >> selector [
	^ selector
]

{ #category : #accessing }
BTMessageNode >> selector: aSelector [
	selector := aSelector
]
