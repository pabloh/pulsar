"
Represents the code of a message.

Instance Variables
	receiver:		<BSIdentifierValue>
	selector:		<Symbol>
Variable Part 		<BSExpressionValue*>

"
Class {
	#name : #BSMessageNode,
	#superclass : #BSFlyweightNode,
	#type : #variable,
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'receiver',
		'selector'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSMessageNode class >> receiver: anExpressionNode selector: aSymbol arguments: anExpressionNodeArray [
	self privateCheckSelector: aSymbol arguments: anExpressionNodeArray. 
	self assert: anExpressionNode isExpressionNode.
	self assert: aSymbol isSymbol.
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: { anExpressionNode. aSymbol }, anExpressionNodeArray
]

{ #category : #visitor }
BSMessageNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitMessageNode: self
]

{ #category : #accessing }
BSMessageNode >> arguments [
	^ self variablePart
]

{ #category : #transformations }
BSMessageNode >> arguments: anExpressionArray [
	^ self class 
		receiver: self receiver 
		selector: self selector 
		arguments: anExpressionArray
]

{ #category : #testing }
BSMessageNode >> isMessageNode [
	^ true
]

{ #category : #printing }
BSMessageNode >> printOn: aStream [
	aStream
		<< self receiver asString;
		space.
	self printKeywordsAndArgumentsOn: aStream
]

{ #category : #accessing }
BSMessageNode >> receiver [
	^ receiver
]

{ #category : #transformations }
BSMessageNode >> receiver: anExpressionValue [
	^ self class 
		receiver: anExpressionValue 
		selector: self selector
		arguments: self arguments 
]

{ #category : #accessing }
BSMessageNode >> selector [
	^ selector
]

{ #category : #transformations }
BSMessageNode >> selector: aSymbol [
	^ self class 
		receiver: self receiver 
		selector: aSymbol
		arguments: self arguments 
]
