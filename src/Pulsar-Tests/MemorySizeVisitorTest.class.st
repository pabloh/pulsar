Class {
	#name : #MemorySizeVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor',
		'minimalArraySize',
		'orderedCollectionSize'
	],
	#category : #'Pulsar-Tests-Tests'
}

{ #category : #helpers }
MemorySizeVisitorTest >> emptyOrderedCollectionSize [
	
	^(4 + 3) * 8 "OrderedCollection + Array with no items "
]

{ #category : #helpers }
MemorySizeVisitorTest >> minimalOrderedCollectionSize [
	
	^ (4 + 11) * 8 "OrderedCollection + Array with 10 items "
]

{ #category : #initialization }
MemorySizeVisitorTest >> setUp [

	visitor := MemorySizeVisitor new.
]

{ #category : #tests }
MemorySizeVisitorTest >> testArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '{ 45. 77. #a -> 99 }' .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (8 * 8) "Layout"
               + self minimalOrderedCollectionSize  "statements: 1 OrderedCollection"
               + ((8* 8) * 2)  "2 Integer Nodes"
		+  (((8 + 2) + 8 + 8 + 6)* 8) "#a -> 99 : 1 Message Node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testAssignmentNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'as := 25' .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (7 * 8) "Layout"
		+ (9 * 8) "1 variable node"
		+ (8 * 8) " 1 Integer node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ 562 ]' .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (12 * 8)  "Layout"
                + self emptyOrderedCollectionSize   "Arguments: 1 OrderedCollection"
		 + ((16 * 8) + (self minimalOrderedCollectionSize * 2))  "Body: Sequence node with Integer node"
	        
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ :each  | each  ]' .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (12 * 8)  "Layout"
	        + self emptyOrderedCollectionSize "1 OrderedCollection"
		 + (9 * 8)  "1 Variable node"
		 + ((17 * 8) + (self minimalOrderedCollectionSize * 2))  "Sequence node with Variable node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testCascadeNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var inspect; add: 2; yourself'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8) "Layout"
               + ((4 + 4) * 8) "messages 1 OrderedCollection"
               + (25 * 8)  "var inspect"
		+ (30 * 8)  "; add: 2"
		+ (16 * 8) "; yourself"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '#(45 ''hello'')'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self
		assert: measuredMemory
		equals: 8 + 4 + 6 + 8 + 10 * 8 "36 quad words"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNodeForByteArray [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '#[23 24 25]'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self
		assert: measuredMemory
		equals: (8 + 4 + 6 + 8 + 10)* 8 "36 quad words"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForABoolean [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  'false'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAFloat [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '323.724e14'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAHexadecimalInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '16r1FF'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '32'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAScaledDecimal [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '3.2s'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (8 + 4)  * 8 "8 quad words"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAString [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '''hello'''.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  10 * 8 "10 quad words"

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForASymbol [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '#foo'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForNil [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   'nil'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testMessageNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var add: 2'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (8 * 8) "Layout"
               + ((4 + 4) * 8) "Arguments: 1 OrderedCollection"
               + (9 * 8) "Receiver: VariableNode"
		+ (6 * 8) "SelectorNode"
		+ (8 * 8) "Arguments: 1 Integer Node"
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNode [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar ^1' . 	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (14 * 8) "Layout"
		+ (2 * 8) "arguments: 1 Array"
		+ (2 * 8) "pragmas: 1 Array"
		+ (51 * 8) "^8"
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar: var ^var' . 	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (14 * 8) "Layout"
		+ (7 * 8) "arguments: 1 OrderedCollection"
		+ (2 * 8) "pragmas: 1 Array"
               + (9 * 8) "var: 1 VariableNode"
		+ (52 * 8) "^var"
		
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithPragma [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar < qux: 6 > ^8'.
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (14 * 8) "Layout"
		+ (2 * 8) "arguments: 1 Array"
		+ (15 * 8) "pragmas: 1 OrderedCollection"
		+ (51 * 8) "^8"
		+ ((8 + 7 + 8) * 8) "< qux: 6 >"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testReturnNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '^ 45 ' .
	measuredMemory := (visitor visit: ast) measuredSize.	

	self assert: measuredMemory  equals:  (5 + 8) * 8 "13 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForBinary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'a + 5') selectorNode .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForKeywordSelector [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self sendMessage: #hash') selectorNode .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForUnary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self yourself') selectorNode .
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32 . 213. 23'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"
		+ (self minimalOrderedCollectionSize * 2) "2 OrderedCollections"
		+ (8 * 8 * 3) "3 Integers Nodes"
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNodeWithTemporaries [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '|a b| 32 . 213. 23'.
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"		
		+ (self minimalOrderedCollectionSize * 2) "2 OrderedCollections"
		+ (9 * 8 * 2)  "2 Variable Nodes"
		+ (8 * 8 * 3) "3 Integers Nodes"

]

{ #category : #tests }
MemorySizeVisitorTest >> testVariableNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  ' var' .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitor visit: ast) measuredSize.			

	self assert: measuredMemory  equals:  (7 * 8) "Layout"
		+ (2 * 8) "1 Unresolved Variable"
	
]
