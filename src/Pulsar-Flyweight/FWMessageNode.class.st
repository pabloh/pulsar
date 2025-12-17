"
Represents the code of a message.

Instance Variables
	receiver:		<BSIdentifierValue>
	selector:		<Symbol>
Variable Part 		<BSExpressionValue*>

"
Class {
	#name : 'FWMessageNode',
	#superclass : 'FWFlyweightNode',
	#type : 'variable',
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'receiver',
		'selector'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWMessageNode class >> receiver: anExpressionNode selector: aSymbol arguments: anExpressionNodeArray [
	self privateCheckSelector: aSymbol arguments: anExpressionNodeArray. 
	self assert: anExpressionNode isExpressionNode.
	self assert: aSymbol isSymbol.
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: { anExpressionNode. aSymbol }, anExpressionNodeArray
]

{ #category : 'visitor' }
FWMessageNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitMessageNode: self
]

{ #category : 'accessing' }
FWMessageNode >> arguments [
	^ self variablePart
]

{ #category : 'transformations' }
FWMessageNode >> arguments: anExpressionArray [
	^ self class 
		receiver: self receiver 
		selector: self selector 
		arguments: anExpressionArray
]

{ #category : 'testing' }
FWMessageNode >> isMessageNode [
	^ true
]

{ #category : 'printing' }
FWMessageNode >> printOn: aStream [
	aStream
		<< self receiver asString;
		space.
	self printKeywordsAndArgumentsOn: aStream
]

{ #category : 'accessing' }
FWMessageNode >> receiver [
	^ receiver
]

{ #category : 'transformations' }
FWMessageNode >> receiver: anExpressionValue [
	^ self class 
		receiver: anExpressionValue 
		selector: self selector
		arguments: self arguments 
]

{ #category : 'accessing' }
FWMessageNode >> selector [
	^ selector
]

{ #category : 'transformations' }
FWMessageNode >> selector: aSymbol [
	^ self class 
		receiver: self receiver 
		selector: aSymbol
		arguments: self arguments 
]
