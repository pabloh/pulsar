"
A RB2BlastConverter allows you to create Blast AST nodes from RBParser nodes as input.

"
Class {
	#name : #RB2BlastConverter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'literalsCache'
	],
	#category : #'Blast-Conversion'
}

{ #category : #converting }
RB2BlastConverter class >> convert: anRBMethodNode [

	^ self encode: anRBMethodNode.
]

{ #category : #converting }
RB2BlastConverter class >> encode: anRBMethodNode [

	^ self new visitNode: anRBMethodNode.
]

{ #category : #'literals cache' }
RB2BlastConverter >> canBeCached: aLiteralValue [
	"Symbols and SmallIntegers are pointless to reuse since the first ones are unique accross the system and the latter ones are implemented as tagged pointers, on a 64 bits system this should also be valid for float values"
	^ (aLiteralValue isSymbol or: [ aLiteralValue isInteger and: [ aLiteralValue isLarge not ] ]) not
]

{ #category : #converting }
RB2BlastConverter >> encodeCompiledMethod: aCompiledMethod [
	self initializeLiteralsCacheFrom: aCompiledMethod.
	^ self visitMethodNode: aCompiledMethod ast
]

{ #category : #'literals cache' }
RB2BlastConverter >> initializeLiteralsCacheFrom: aCompiledMethod [
	aCompiledMethod literalsDo: [ :each | 
		(self canBeCached: each) ifTrue: [ self literalsCache add: each ] ]
]

{ #category : #'literals cache' }
RB2BlastConverter >> literalFromCache: aLiteralValue [
	^ self literalsCache like: aLiteralValue ifAbsent: aLiteralValue
]

{ #category : #'literals cache' }
RB2BlastConverter >> literalsCache [
	^ literalsCache ifNil: [ literalsCache := Set new ].
]

{ #category : #visiting }
RB2BlastConverter >> visitArgumentNodes: aNodeCollection [

	^ self visitNodeCollection: aNodeCollection
]

{ #category : #visiting }
RB2BlastConverter >> visitArrayNode: anArrayNode [
	
	^ BTArrayNode expressions: (self visitNodeCollection: anArrayNode statements)
]

{ #category : #visiting }
RB2BlastConverter >> visitAssignmentNode: anAssignmentNode [
	|variable expression|
	
	variable := self visitNode: anAssignmentNode variable.
	expression := self visitNode: anAssignmentNode value.
	
	^ BTAssignmentNode variable: variable expression: expression
]

{ #category : #visiting }
RB2BlastConverter >> visitBlockNode: aBlockNode [
	| arguments statements temporaries returns |
	
	arguments := self visitArgumentNodes: aBlockNode arguments.
	temporaries := self visitTemporaryNodes: aBlockNode body temporaries.
	statements := self visitNodeCollection: aBlockNode body statements.
	returns := statements isNotEmpty and: [ aBlockNode body statements last isReturn ].
	
	^ BTBlockNode arguments: arguments temporaries: temporaries statements: statements hasReturn: returns.
]

{ #category : #visiting }
RB2BlastConverter >> visitCascadeNode: aCascadeNode [
	| receiver parts |
	
	receiver := self visitNode: aCascadeNode messages first receiver.
	parts := aCascadeNode messages
		collect: [ :anRBMessage | 
			BTCascadePartNode
				selector: anRBMessage selector
				arguments: (self visitNodeCollection: anRBMessage arguments) ]
		as: Array.
	
	^ BTCascadeNode receiver: receiver parts: parts
]

{ #category : #visiting }
RB2BlastConverter >> visitLiteralNode: aLiteralNode [

	^ BTLiteralNode value: (self literalFromCache: (aLiteralNode value))
]

{ #category : #visiting }
RB2BlastConverter >> visitMessageNode: aMessageNode [
	| receiver selector arguments |

	receiver := self visitNode: aMessageNode receiver.
	selector := aMessageNode selector.
	arguments := self visitNodeCollection: aMessageNode arguments.

	^ BTMessageNode
		receiver: receiver
		selector: selector 
		arguments: arguments.
]

{ #category : #visiting }
RB2BlastConverter >> visitMethodNode: aMethodNode [
	| selector pragmas body |
	
	selector := aMethodNode selector.
	pragmas := self visitNodeCollection: aMethodNode pragmas.
	body := self visitBlockNode: aMethodNode.
	
	^ BTMethodNode
		selector: selector
		pragmas: pragmas
		body: body.
]

{ #category : #visiting }
RB2BlastConverter >> visitNodeCollection: aNodeCollection [

	^ aNodeCollection collect: [ :aNode | self visitNode: aNode ] as: Array
]

{ #category : #visiting }
RB2BlastConverter >> visitPragmaNode: aPragmaNode [
	| selector arguments |

	selector := aPragmaNode selector.
	arguments := self visitNodeCollection: aPragmaNode arguments.

	^ BTPragmaNode 
		selector: selector 
		arguments: arguments.
]

{ #category : #visiting }
RB2BlastConverter >> visitVariableNode: aVariableNode [
	
	^ BTVariableNode name: aVariableNode name.
]
