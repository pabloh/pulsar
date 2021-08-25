"
A BSMethod represent a specific method. It has a reference to a BSBlockNode that represents its code.
Later, it should have a property dictionary that stores the extrinsic state of the different flyweight nodes.

Instance Variables
	selector: 			<Symbol>
	pragmas:			<BSPragmaNode>
	body:		  		<BSBlockNode>
"
Class {
	#name : #BSMethod,
	#superclass : #BSNode,
	#traits : 'TKeyworded',
	#classTraits : 'TKeyworded classTrait',
	#instVars : [
		'selector',
		'pragmas',
		'body'
	],
	#category : #'Bonsai-Method'
}

{ #category : #'private-checking' }
BSMethod class >> privateCheckSelector: selector arguments: arguments [ 
	(arguments size = selector numArgs) ifFalse: [ 
		self error: 
			('The selector { 1 } expects {2} arguments but {3} arguments are provided.' 
				format: {selector. selector numArgs. arguments size }) ].
]

{ #category : #'instance creation' }
BSMethod class >> selector: aSymbol pragmas: pragmaCollection body: aBlockFlyweight [ 
	self privateCheckSelector: aSymbol arguments: aBlockFlyweight arguments.
	self assert: (pragmaCollection allSatisfy: #isPragmaNode).
	self assert: aBlockFlyweight isBlockNode.
	^ self new
		selector: aSymbol;
		pragmas: pragmaCollection;
		body: aBlockFlyweight;
		yourself
]

{ #category : #visitor }
BSMethod >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitMethodNode: self
]

{ #category : #accessing }
BSMethod >> arguments [
	^ self body arguments
]

{ #category : #accessing }
BSMethod >> body [
	^ body
]

{ #category : #accessing }
BSMethod >> body: aMethodFlyweight [
	body := aMethodFlyweight
]

{ #category : #testing }
BSMethod >> isExpressionNode [ 
	^ false
]

{ #category : #accessing }
BSMethod >> keywords [
	^ self selector keywords
]

{ #category : #enumerating }
BSMethod >> keywordsAndArgumentsDo: aBlock [
	self keywordsAndArgumentsDo: aBlock separatedBy: nil
]

{ #category : #enumerating }
BSMethod >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : #accessing }
BSMethod >> pragmas [
	^ pragmas
]

{ #category : #accessing }
BSMethod >> pragmas: anObject [
	pragmas := anObject
]

{ #category : #printing }
BSMethod >> printKeywordsAndArgumentsOn: aStream [
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
BSMethod >> printOn: aStream [
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

{ #category : #accessing }
BSMethod >> properties [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #accessing }
BSMethod >> properties: aDictionary [
	^ properties := aDictionary
]

{ #category : #accessing }
BSMethod >> selector [
	^ selector
]

{ #category : #accessing }
BSMethod >> selector: anObject [
	selector := anObject
]
