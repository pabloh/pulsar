"
Represents the code of a block.

Instance Variables
	arguments:			<BSIdentifierFlyweight*>
	temporaries:		<BSIdentifierFlyweight*>
	hasReturn:			<Boolean>			
Variable Part			<BSExpressionFlyweight*>

"
Class {
	#name : #BSBlockNode,
	#superclass : #BSFlyweightNode,
	#type : #variable,
	#instVars : [
		'arguments',
		'temporaries',
		'hasReturn'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSBlockNode class >> arguments: argSymbolArray temporaries: tempSymbolArray expressions: anExpressionNodeArray [ 
	^ self arguments: argSymbolArray temporaries: tempSymbolArray expressions: anExpressionNodeArray hasReturn: false
]

{ #category : #'instance creation' }
BSBlockNode class >> arguments: argVariableNodeArray temporaries: tempVariableNodeArray expressions: anExpressionNodeArray hasReturn: aBoolean [
	self assert: (argVariableNodeArray allSatisfy: #isVariableNode).
	self assert: (tempVariableNodeArray allSatisfy: #isVariableNode).
	self assert: (anExpressionNodeArray allSatisfy: #isExpressionNode).
	self assert: (aBoolean isKindOf: Boolean).
	^ self privateLookup: {argVariableNodeArray. tempVariableNodeArray. aBoolean}, anExpressionNodeArray
]

{ #category : #visitor }
BSBlockNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitBlockNode: self
]

{ #category : #accessing }
BSBlockNode >> arguments [
	^ arguments shallowCopy 
]

{ #category : #transformations }
BSBlockNode >> arguments: anIdentifierArray [
	^ self class 
		arguments: anIdentifierArray 
		temporaries: self temporaries
		expressions:  self expressions
		hasReturn: self hasReturn 
]

{ #category : #accessing }
BSBlockNode >> expressions [
	^ self variablePart
]

{ #category : #transformations }
BSBlockNode >> expressions: anExpressionArray [
	^ self class 
		arguments: self arguments 
		temporaries: self temporaries
		expressions: anExpressionArray
		hasReturn: self hasReturn
]

{ #category : #accessing }
BSBlockNode >> hasReturn [
	^ hasReturn
]

{ #category : #transformations }
BSBlockNode >> hasReturn: aBoolean [
	^ self class 
		arguments: self arguments 
		temporaries: self temporaries
		expressions: self expressions
		hasReturn: aBoolean
]

{ #category : #testing }
BSBlockNode >> isBlockNode [
	^ true 
]

{ #category : #printing }
BSBlockNode >> printArgumentsOn: aStream [
	self arguments ifNotEmptyDo: [ :args |
		args do: [ :identifier |
			aStream 
				<< ':';
				print: identifier;
				space ].
		aStream << '| ' ]
]

{ #category : #printing }
BSBlockNode >> printExpressionsOn: aStream [
	self expressions 
		do: [ :expression | expression printOn: aStream ]
		separatedBy: [ aStream < '. ' ]
]

{ #category : #printing }
BSBlockNode >> printOn: aStream [
	aStream << '[ '.
	self 
		printArgumentsOn: aStream;
		printTemporariesOn: aStream;
		printStatementsOn: aStream.
	aStream << ' ]'.
]

{ #category : #printing }
BSBlockNode >> printStatementsOn: aStream [
	self expressions ifNotEmpty: [
		self expressions allButLastDo: [ :statement | 
			aStream 
				print: statement;
				<< '. '  ].
		self hasReturn ifTrue: [ aStream << '^ ' ].
		aStream print: self expressions last ].
]

{ #category : #printing }
BSBlockNode >> printTemporariesOn: aStream [
	self temporaries ifNotEmpty: [
		aStream << ' | '.
		self temporaries 
			do: [ :temporary | aStream print: temporary ]
			separatedBy: [ aStream << ' ' ].
		aStream << ' | ']
]

{ #category : #accessing }
BSBlockNode >> return [
	^ self hasReturn
		ifTrue: [ self at: self basicSize ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
BSBlockNode >> temporaries [
	^ temporaries shallowCopy
]

{ #category : #transformations }
BSBlockNode >> temporaries: anIdentifierArray [
	^ self class 
		arguments: self arguments 
		temporaries: anIdentifierArray
		expressions:  self expressions
		hasReturn: self hasReturn 
]
