Class {
	#name : #MemorySizeVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor',
		'minimalArraySize',
		'orderedCollectionSize',
		'visitorWithWhitespace'
	],
	#category : #'Pulsar-Tests-Tests'
}

{ #category : #initialization }
MemorySizeVisitorTest >> setUp [

	visitor := PLMemorySizeVisitor new.	
	visitorWithWhitespace := PLMemorySizeVisitor newWithWhitespace 
]

{ #category : #tests }
MemorySizeVisitorTest >> testArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '{ 45. 77. #a -> 99 }' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords  "Layout"
               + (4 + 11) quadWords "statements: 1 OrderedCollection"
               + (8 * 2) quadWords "2 Integer Nodes"
		+ ((8 + 2) + 8 + 8 + 6) quadWords "#a -> 99 : 1 Message Node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testAssignmentNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'as := 25' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals:  (7 * 8) "Layout"
		+ (9 * 8) "1 Variable node"
		+ (8 * 8) " 1 Integer node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ 562 ]' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (12 * 8) "Layout"
		+ (7 * 8) "Arguments: 1 OrderedCollection"
		+ (((8 + (15 * 2)) * 8) "Body: Sequence Node"
			+ (8 * 8) "1 Integer node"
		)
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ :each  | each  ]' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (12 * 8)  "Layout"
	        + (7 * 8) "arguements: 1 OrderedCollection"
		 + (9 * 8)  "1 Variable node"
		+ (((8 + (15 * 2)) * 8) "Body: Sequence Node"
			+ (9 * 8) "1 Variable node"
		)
]

{ #category : #tests }
MemorySizeVisitorTest >> testCascadeNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var inspect; add: 2; yourself'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (6 * 8) "Layout"
               + ((4 + 4) * 8) "messages: 1 OrderedCollection"
               + (((8 + 2) * 8) "var inspect: 1 Message Node" 
			+ (9 * 8) "Receiver: 1 Variable Node"
			+ (6 * 8) "Selector: 1 Selector Node"
		)
		+ (((8 + 8) * 8) "; add: 2: 1 Message Node" 
			+ (6 * 8) "Selector: 1 Selector Node"
			+ (8 * 8) "Arguments: 1 Integer Node"
		)
               + (((8 + 2) * 8) ";yourself: 1 Message Node" 
			+ (6 * 8) "Selector: 1 Selector Node"
		)
	
]

{ #category : #'tests - formatting' }
MemorySizeVisitorTest >> testComentNode [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  'var "asddsasd" ') comments first.  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureComment: ast) measuredSize.			

	self assert: measuredMemory  equals: 6 quadWords "Layout"
		+ 2 quadWords "content"
]

{ #category : #'tests - formatting' }
MemorySizeVisitorTest >> testComentedVariableNode [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  ' "qwertyui" var "asddsasd" ').  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureComments: ast) measuredSize.			

	self assert: measuredMemory  equals: (10 + 3) quadWords "1 SmallDictionary and 1 Array"  
		+ (2 * (8 quadWords)) "2 coments node"
]

{ #category : #'tests - formatting' }
MemorySizeVisitorTest >> testFormatedNodeWithParens [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  ' (((var))) ') .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureParentheses: ast) measuredSize.			

	self assert: measuredMemory  equals: (4 + 5) quadWords "1 Ordered Collection"
		+ (3 * 4 quadWords) "3 Intervals"
]

{ #category : #'tests - formatting' }
MemorySizeVisitorTest >> testFormatedVariableNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  ' (((var))) "asdasd" '  .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.			

	self assert: measuredMemory  equals: 7 quadWords "Layout"
		+ 2 quadWords "1 Unresolved Variable"
		+ (12 + 8) quadWords "1 Comment node"
		+ (4 + 5) quadWords "properties structure"
		+ (3 * 4) quadWords "3 Intervals for parens"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '#(45 ''hello'')'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"
		+ (10 * 8) "contents: 1 Array" 
		+ (8* 8) "1 Integer Node"
		+ (10* 8) "1 String Node"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNodeForByteArray [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '#[23 24 25]'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"
		+ (4 * 8) "contents: 1 Array" 
		+ (8* 8 * 3) "3 Integer Nodes"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForABoolean [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  'false'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAFloat [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '323.724e14'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAHexadecimalInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '16r1FF'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAScaledDecimal [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '3.2s'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
		+ (4 * 8)  "3.2s ScaledDecimal"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAString [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '''hello'''.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
		+ (2 * 8)  "'hello' String"

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForASymbol [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '#foo'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForNil [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'nil'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testMessageNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var add: 2'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
               + ((4 + 4) * 8) "Arguments: 1 OrderedCollection"
               + (9 * 8) "Receiver: VariableNode"
		+ (6 * 8) "Selector: SelectorNode"
		+ (8 * 8) "Arguments: 1 Integer Node"
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNode [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar ^1' . 	
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory  equals: (14 * 8) "Layout"
		+ (2 * 8) "arguments: 1 Array"
		+ (2 * 8) "pragmas: 1 Array"
		+ (((8 + (15 * 2)) * 8) "Body: Sequence Node" "^8"
			+ ((5 * 8) "1 Return node"
				+ (8 * 8) "1 Integer node"
			)
		)
		
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar: var ^var' . 	
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (14 * 8) "Layout"
		+ (7 * 8) "arguments: 1 OrderedCollection"
		+ (2 * 8) "pragmas: 1 Array"
               + (9 * 8) "var: 1 VariableNode"
		+ (((8 + (15 * 2)) * 8) "Body: Sequence Node" "^var"
			+ ((5 * 8) "1 Return node"
				+ (9 * 8) "1 Variable node"
			)
		)
		
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithPragma [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar < qux: 6 > ^8'.
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (14 * 8) "Layout"
		+ (2 * 8) "arguments: 1 Array"
		+ (15 * 8) "pragmas: 1 OrderedCollection"
		+ ((8 + 7 + 8) * 8) "< qux: 6 >: 1 Pragma Node"
		+ (((8 + (15 * 2)) * 8) "Body: Sequence Node" "^8"
			+ ((5 * 8) "1 Return node"
				+ (8 * 8) "1 Integer node"
			)
		)
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testReturnNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '^ 45 ' .
	measuredMemory := (visitor visitNode: ast) measuredSize.	

	self assert: measuredMemory  equals:  (5 * 8) "Layout"
		+ (8 * 8) "1 Integer Node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForBinary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'a + 5') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForKeywordSelector [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self sendMessage: #hash') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForUnary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self yourself') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals:  (6 * 8)  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32 . 213. 23'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"
		+ ((15 * 8) * 2) "2 OrderedCollections"
		+ (8 * 8 * 3) "3 Integers Nodes"
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNodeWithTemporaries [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '|a b| 32 . 213. 23'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (8 * 8) "Layout"		
		+ (15 * 8 * 2) "2 OrderedCollections"
		+ (9 * 8 * 2)  "|a b|: 2 Variable Nodes"
		+ (8 * 8 * 3) "3 Integers Nodes"

]

{ #category : #tests }
MemorySizeVisitorTest >> testVariableNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  ' var' .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitor visitNode: ast) measuredSize.			

	self assert: measuredMemory  equals: (7 * 8) "Layout"
		+ (2 * 8) "1 Unresolved Variable"
	
]
