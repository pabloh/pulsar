"
A BSMethod represent a specific method. It has a reference to a BSBlockNode that represents its code.
Later, it should have a property dictionary that stores the extrinsic state of the different flyweight nodes.

Instance Variables
	selector: 			<Symbol>
	pragmas:			<BSPragmaNode>
	body:		  		<BSBlockNode>
"
Class {
	#name : 'FWMethod',
	#superclass : 'FWNode',
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'selector',
		'pragmas',
		'body'
	],
	#category : 'Pulsar-Flyweight-Method',
	#package : 'Pulsar-Flyweight',
	#tag : 'Method'
}

{ #category : 'private-checking' }
FWMethod class >> privateCheckSelector: selector arguments: arguments [ 
	(arguments size = selector numArgs) ifFalse: [ 
		self error: 
			('The selector { 1 } expects {2} arguments but {3} arguments are provided.' 
				format: {selector. selector numArgs. arguments size }) ].
]

{ #category : 'instance creation' }
FWMethod class >> selector: aSymbol pragmas: pragmaCollection body: aBlockFlyweight [ 
	self privateCheckSelector: aSymbol arguments: aBlockFlyweight arguments.
	self assert: (pragmaCollection allSatisfy: #isPragmaNode).
	self assert: aBlockFlyweight isBlockNode.
	^ self new
		selector: aSymbol;
		pragmas: pragmaCollection;
		body: aBlockFlyweight;
		yourself
]

{ #category : 'visitor' }
FWMethod >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitMethodNode: self
]

{ #category : 'accessing' }
FWMethod >> arguments [
	^ self body arguments
]

{ #category : 'accessing' }
FWMethod >> body [
	^ body
]

{ #category : 'accessing' }
FWMethod >> body: aMethodFlyweight [
	body := aMethodFlyweight
]

{ #category : 'testing' }
FWMethod >> isExpressionNode [ 
	^ false
]

{ #category : 'accessing' }
FWMethod >> keywords [
	^ self selector keywords
]

{ #category : 'enumerating' }
FWMethod >> keywordsAndArgumentsDo: aBlock [
	self keywordsAndArgumentsDo: aBlock separatedBy: nil
]

{ #category : 'enumerating' }
FWMethod >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : 'accessing' }
FWMethod >> pragmas [
	^ pragmas
]

{ #category : 'accessing' }
FWMethod >> pragmas: anObject [
	pragmas := anObject
]

{ #category : 'printing' }
FWMethod >> printKeywordsAndArgumentsOn: aStream [
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
FWMethod >> printOn: aStream [
	self printKeywordsAndArgumentsOn: aStream.
	aStream space.
	"self pragmas do: [ :pragma |
		aStream 
			print: pragma;
			cr ]."
	self body 
		printTemporariesOn: aStream;
		printStatementsOn: aStream.
]

{ #category : 'accessing' }
FWMethod >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : 'accessing' }
FWMethod >> properties: aDictionary [
	^ properties := aDictionary
]

{ #category : 'accessing' }
FWMethod >> selector [
	^ selector
]

{ #category : 'accessing' }
FWMethod >> selector: anObject [
	selector := anObject
]
