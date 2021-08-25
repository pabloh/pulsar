"
A BSPragmaNode is a node that represents the code of a pragma.
Warning: It's the only subclass of BSFlyweightNode that is not an expression node.
Yes it's crapy.

Instance Variables
	selector:		<Symbol>
Variable Part 		<BSLiteralValue*>

"
Class {
	#name : #BSPragmaNode,
	#superclass : #BSFlyweightNode,
	#type : #variable,
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'selector'
	],
	#category : #'Bonsai-Method'
}

{ #category : #'private-checking' }
BSPragmaNode class >> privateCheckSelector: selector arguments: arguments [ 
	(arguments size = selector numArgs) ifFalse: [ 
		self error: 
			('The selector { 1 } expects {2} arguments but {3} arguments are provided.' 
				format: {selector. selector numArgs. arguments size }) ].
]

{ #category : #'instance creation' }
BSPragmaNode class >> receiver: anExpressionNode selector: aSymbol arguments: anExpressionNodeArray [
	self privateCheckSelector: aSymbol arguments: anExpressionNodeArray. 
	self assert: anExpressionNode isExpressionNode.
	self assert: aSymbol isSymbol.
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: { anExpressionNode. aSymbol }, anExpressionNodeArray
]

{ #category : #'instance creation' }
BSPragmaNode class >> selector: aSymbol arguments: anLiteralNodeArray [
	self privateCheckSelector: aSymbol arguments: anLiteralNodeArray. 
	self assert: aSymbol isSymbol.
	self assert: (anLiteralNodeArray allSatisfy: #isLiteralNode).
	^ self privateLookup: { aSymbol }, anLiteralNodeArray
]

{ #category : #visitor }
BSPragmaNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitPragmaNode: self
]

{ #category : #accessing }
BSPragmaNode >> arguments [
	^ self variablePart
]

{ #category : #transformations }
BSPragmaNode >> arguments: anExpressionArray [
	^ self class 
		selector: self selector 
		arguments: anExpressionArray
]

{ #category : #testing }
BSPragmaNode >> isExpressionNode [ 
	^ false
]

{ #category : #testing }
BSPragmaNode >> isPragmaNode [
	^ true
]

{ #category : #accessing }
BSPragmaNode >> keywords [
	^ self selector keywords
]

{ #category : #enumerating }
BSPragmaNode >> keywordsAndArgumentsDo: aBlock [
	self keywordsAndArgumentsDo: aBlock separatedBy: nil
]

{ #category : #enumerating }
BSPragmaNode >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : #printing }
BSPragmaNode >> printKeywordsAndArgumentsOn: aStream [
	self arguments isEmpty ifTrue: [ ^ aStream << self selector ].
	self 
		keywordsAndArgumentsDo:  [ :keyword :argument |
			aStream 
				<< keyword;
				space;
				print: argument ]
		separatedBy: [ aStream space ]

]

{ #category : #printing }
BSPragmaNode >> printOn: aStream [
	aStream << '<'.
	self printKeywordsAndArgumentsOn: aStream.
	aStream << '>'.
]

{ #category : #accessing }
BSPragmaNode >> selector [
	^ selector
]

{ #category : #transformations }
BSPragmaNode >> selector: aSymbol [
	^ self class 
		selector: aSymbol
		arguments: self arguments 
]
