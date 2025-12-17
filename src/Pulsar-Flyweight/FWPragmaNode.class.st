"
A BSPragmaNode is a node that represents the code of a pragma.
Warning: It's the only subclass of BSFlyweightNode that is not an expression node.
Yes it's crapy.

Instance Variables
	selector:		<Symbol>
Variable Part 		<BSLiteralValue*>

"
Class {
	#name : 'FWPragmaNode',
	#superclass : 'FWFlyweightNode',
	#type : 'variable',
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'selector'
	],
	#category : 'Pulsar-Flyweight-Method',
	#package : 'Pulsar-Flyweight',
	#tag : 'Method'
}

{ #category : 'private-checking' }
FWPragmaNode class >> privateCheckSelector: selector arguments: arguments [ 
	(arguments size = selector numArgs) ifFalse: [ 
		self error: 
			('The selector { 1 } expects {2} arguments but {3} arguments are provided.' 
				format: {selector. selector numArgs. arguments size }) ].
]

{ #category : 'instance creation' }
FWPragmaNode class >> receiver: anExpressionNode selector: aSymbol arguments: anExpressionNodeArray [
	self privateCheckSelector: aSymbol arguments: anExpressionNodeArray. 
	self assert: anExpressionNode isExpressionNode.
	self assert: aSymbol isSymbol.
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	^ self privateLookup: { anExpressionNode. aSymbol }, anExpressionNodeArray
]

{ #category : 'instance creation' }
FWPragmaNode class >> selector: aSymbol arguments: anLiteralNodeArray [
	self privateCheckSelector: aSymbol arguments: anLiteralNodeArray. 
	self assert: aSymbol isSymbol.
	self assert: (anLiteralNodeArray allSatisfy: #isLiteralNode).
	^ self privateLookup: { aSymbol }, anLiteralNodeArray
]

{ #category : 'visitor' }
FWPragmaNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitPragmaNode: self
]

{ #category : 'accessing' }
FWPragmaNode >> arguments [
	^ self variablePart
]

{ #category : 'transformations' }
FWPragmaNode >> arguments: anExpressionArray [
	^ self class 
		selector: self selector 
		arguments: anExpressionArray
]

{ #category : 'testing' }
FWPragmaNode >> isExpressionNode [ 
	^ false
]

{ #category : 'testing' }
FWPragmaNode >> isPragmaNode [
	^ true
]

{ #category : 'accessing' }
FWPragmaNode >> keywords [
	^ self selector keywords
]

{ #category : 'enumerating' }
FWPragmaNode >> keywordsAndArgumentsDo: aBlock [
	self keywordsAndArgumentsDo: aBlock separatedBy: nil
]

{ #category : 'enumerating' }
FWPragmaNode >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : 'printing' }
FWPragmaNode >> printKeywordsAndArgumentsOn: aStream [
	self arguments isEmpty ifTrue: [ ^ aStream << self selector ].
	self 
		keywordsAndArgumentsDo:  [ :keyword :argument |
			aStream 
				<< keyword;
				space;
				print: argument ]
		separatedBy: [ aStream space ]

]

{ #category : 'printing' }
FWPragmaNode >> printOn: aStream [
	aStream << '<'.
	self printKeywordsAndArgumentsOn: aStream.
	aStream << '>'.
]

{ #category : 'accessing' }
FWPragmaNode >> selector [
	^ selector
]

{ #category : 'transformations' }
FWPragmaNode >> selector: aSymbol [
	^ self class 
		selector: aSymbol
		arguments: self arguments 
]
