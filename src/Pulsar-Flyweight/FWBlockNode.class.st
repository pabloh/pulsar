"
Represents the code of a block.

Instance Variables
	arguments:			<BSIdentifierFlyweight*>
	temporaries:		<BSIdentifierFlyweight*>
	hasReturn:			<Boolean>			
Variable Part			<BSExpressionFlyweight*>

"
Class {
	#name : 'FWBlockNode',
	#superclass : 'FWFlyweightNode',
	#type : 'variable',
	#instVars : [
		'arguments',
		'temporaries',
		'hasReturn'
	],
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWBlockNode class >> arguments: argSymbolArray temporaries: tempSymbolArray expressions: anExpressionNodeArray [ 
	^ self arguments: argSymbolArray temporaries: tempSymbolArray expressions: anExpressionNodeArray hasReturn: false
]

{ #category : 'instance creation' }
FWBlockNode class >> arguments: argVariableNodeArray temporaries: tempVariableNodeArray expressions: anExpressionNodeArray hasReturn: aBoolean [
	self assert: (argVariableNodeArray allSatisfy: #isVariableNode).
	self assert: (tempVariableNodeArray allSatisfy: #isVariableNode).
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	self assert: (aBoolean isKindOf: Boolean).
	^ self privateLookup: {argVariableNodeArray. tempVariableNodeArray. aBoolean}, anExpressionNodeArray
]

{ #category : 'visitor' }
FWBlockNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitBlockNode: self
]

{ #category : 'accessing' }
FWBlockNode >> arguments [
	^ arguments shallowCopy 
]

{ #category : 'transformations' }
FWBlockNode >> arguments: anIdentifierArray [
	^ self class 
		arguments: anIdentifierArray 
		temporaries: self temporaries
		expressions:  self expressions
		hasReturn: self hasReturn 
]

{ #category : 'accessing' }
FWBlockNode >> expressions [
	^ self variablePart
]

{ #category : 'transformations' }
FWBlockNode >> expressions: anExpressionArray [
	^ self class 
		arguments: self arguments 
		temporaries: self temporaries
		expressions: anExpressionArray
		hasReturn: self hasReturn
]

{ #category : 'accessing' }
FWBlockNode >> hasReturn [
	^ hasReturn
]

{ #category : 'transformations' }
FWBlockNode >> hasReturn: aBoolean [
	^ self class 
		arguments: self arguments 
		temporaries: self temporaries
		expressions: self expressions
		hasReturn: aBoolean
]

{ #category : 'testing' }
FWBlockNode >> isBlockNode [
	^ true 
]

{ #category : 'printing' }
FWBlockNode >> printArgumentsOn: aStream [
	self arguments ifNotEmpty: [ :args |
		args do: [ :identifier |
			aStream 
				<< ':';
				print: identifier;
				space ].
		aStream << '| ' ]
]

{ #category : 'printing' }
FWBlockNode >> printExpressionsOn: aStream [
	self expressions 
		do: [ :expression | expression printOn: aStream ]
		separatedBy: [ aStream < '. ' ]
]

{ #category : 'printing' }
FWBlockNode >> printOn: aStream [
	aStream << '[ '.
	self 
		printArgumentsOn: aStream;
		printTemporariesOn: aStream;
		printStatementsOn: aStream.
	aStream << ' ]'.
]

{ #category : 'printing' }
FWBlockNode >> printStatementsOn: aStream [
	self expressions ifNotEmpty: [
		self expressions allButLastDo: [ :statement | 
			aStream 
				print: statement;
				<< '. '  ].
		self hasReturn ifTrue: [ aStream << '^ ' ].
		aStream print: self expressions last ].
]

{ #category : 'printing' }
FWBlockNode >> printTemporariesOn: aStream [
	self temporaries ifNotEmpty: [
		aStream << ' | '.
		self temporaries 
			do: [ :temporary | aStream print: temporary ]
			separatedBy: [ aStream << ' ' ].
		aStream << ' | ']
]

{ #category : 'accessing' }
FWBlockNode >> return [
	^ self hasReturn
		ifTrue: [ self at: self basicSize ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
FWBlockNode >> temporaries [
	^ temporaries shallowCopy
]

{ #category : 'transformations' }
FWBlockNode >> temporaries: anIdentifierArray [
	^ self class 
		arguments: self arguments 
		temporaries: anIdentifierArray
		expressions:  self expressions
		hasReturn: self hasReturn 
]
