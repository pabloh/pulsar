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

	self assert: measuredMemory equals: 7 quadWords "Layout"
		+ 9 quadWords "1 Variable node"
		+ 8 quadWords " 1 Integer node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ 562 ]' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 12 quadWords "Layout"
		+ 7 quadWords "Arguments: 1 OrderedCollection"
		+ ((8 + (15 * 2)) quadWords "Body: Sequence Node"
			+ 8 quadWords "1 Integer node"
		)
]

{ #category : #tests }
MemorySizeVisitorTest >> testBlockNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ :each  :res | each  ]' .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 12 quadWords "Layout"
		+ 7 quadWords "Arguments: 1 OrderedCollection"
		 + (2 * 9) quadWords  "2 Variable node"
		+ ((8 + (15 * 2)) quadWords "Body: Sequence Node"
			+ 9 quadWords "1 Variable node"
		)
]

{ #category : #tests }
MemorySizeVisitorTest >> testCascadeNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var inspect; add: 2; yourself'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (6 quadWords) "Layout"
               + ((4 + 4) quadWords)  "messages: 1 OrderedCollection"
               + (((8 + 2) quadWords) "var inspect: 1 Message Node" 
			+ (9 quadWords) "Receiver: 1 Variable Node"
			+ (6 quadWords) "Selector: 1 Selector Node"
		)
		+ (((8 + 8) quadWords) "; add: 2: 1 Message Node" 
			+ (6 quadWords) "Selector: 1 Selector Node"
			+ (8 quadWords) "Arguments: 1 Integer Node"
		)
               + (((8 + 2) quadWords) ";yourself: 1 Message Node" 
			+ (6 quadWords) "Selector: 1 Selector Node"
		)
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testComentNode [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  'var "asddsasd" ') comments first.  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureComment: ast) measuredSize.			

	self assert: measuredMemory  equals: 6 quadWords "Layout"
		+ 2 quadWords "content"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testComentedVariableNode [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  ' "qwertyui" var "asddsasd" ').  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureComments: ast) measuredSize.			

	self assert: measuredMemory  equals: (10 + 3) quadWords "1 SmallDictionary and 1 Array"  
		+ (2 * (8 quadWords)) "2 coments node"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '{ 45. 77. #a -> 99 }' .
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords  "Layout"
               + (4 + 11) quadWords "statements: 1 OrderedCollection"
               + ((8 + 2) * 2) quadWords "2 Integer Nodes"
		+ ((8 + 2) + (8 + 2) + (8 + 2) + 6 + 2 + 2) quadWords "#a -> 99 : 1 Message Node"
		+ (15 quadWords) "1 OrderedCollection for 2 periods"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedBlockNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '[ :each  :res | each  ]' .
	measuredMemory := (visitorWithWhitespace  visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 12 quadWords "Layout"
		+ 7 quadWords "Arguments: 1 OrderedCollection"
		 + (2 * 9) quadWords  "1 Variable node"
		+ ((8 + (15 * 2)) quadWords "Body: Sequence Node"
			+ 9 quadWords "1 Variable node"
		)
		+ 7 quadWords "1 OrderedCollection for 2 colons"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedCascadeNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var inspect; add: 2; yourself'.
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory equals: (6 quadWords) "Layout"
               + ((4 + 4) quadWords)  "messages: 1 OrderedCollection"
               + (((8 + 2) quadWords) "var inspect: 1 Message Node" 
			+ (9 quadWords) "Receiver: 1 Variable Node"
			+ (6 quadWords) "Selector: 1 Selector Node"
			+ (2 quadWords)  "1 IntegerArray for keywordPositions"
			+ (2 quadWords)  "1 IntegerArray for SelectorNode's keywordPositions"
		)
		+ (((8 + 8) quadWords) "; add: 2: 1 Message Node" 
			+ (6 quadWords) "Selector: 1 Selector Node"
			+ ((8 + 2) quadWords) "Arguments: 1 Integer Node"
			+ (2 quadWords)  "1 IntegerArray for keywordPositions"
			+ (8 quadWords)  "1 IntegerArray for SelectorNode's keywordPositions"
		)
               + (((8 + 2) quadWords) ";yourself: 1 Message Node" 
			+ (6 quadWords) "Selector: 1 Selector Node"
			+ (2 quadWords)  "1 IntegerArray for keywordPositions"			
			+ (2 quadWords)  "1 IntegerArray for SelectorNode's keywordPositions"
		)
	 	+ (8 quadWords) "1 Ordered collection for 2 cascade semicolons"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedLiteralValueNodeForAFloat [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '323.724e14'.	
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
		+ 3 quadWords "sourceText"
	
	
		
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedLiteralValueNodeForAHexadecimalInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '16r1FF'.	
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
		+ 2 quadWords  "sourceText"
	
	
		

	

]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedLiteralValueNodeForAInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32'.	
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: (8 * 8) "Layout"
		+ 2 quadWords "sourceText"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedMessageNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var add: 2'.
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
               + (4 + 4) quadWords "Arguments: 1 OrderedCollection"
              + 9 quadWords "Receiver: VariableNode"
		+ (6 + 8) quadWords "Selector: SelectorNode"
		+ (8 + 2) quadWords "Arguments: 1 Integer Node"
		+ 2 quadWords  "1 IntegerArray for keywordPositions"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedMethodNode [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar ^1' . 	
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.
	
	self assert: measuredMemory equals: (14 quadWords) "Layout"
		+ (2 quadWords) "arguments: 1 Array"
		+ (2 quadWords) "pragmas: 1 Array"
		+ (((8 + (15 * 2)) quadWords) "Body: Sequence Node" "^8"
			+ ((5 quadWords) "1 Return node"
				+ ((8 + 2) quadWords) "1 Integer node"
			)
		)
		+ 2 quadWords  "1 IntegerArray for keywordPositions"
		
					
	
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedMethodNodeWithPragma [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar < qux: 6 > ^8'.
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.
	
	self assert: measuredMemory equals: 14 quadWords"Layout"
		+ (2 quadWords) "arguments: 1 Array"
		+ (15 quadWords) "pragmas: 1 OrderedCollection"
		+ ((8 + 7 + (8 + 2)) quadWords) "< qux: 6 >: 1 Pragma Node"
		+ (((8 + (15 * 2)) quadWords) "Body: Sequence Node" "^8"
			+ ((5 quadWords) "1 Return node"
				+ (8 + 2) quadWords "1 Integer node"
			)
		)
		+ 2 quadWords  "1 IntegerArray for keywordPositions"
		+ 2 quadWords  "1 IntegerArray for keywordPositions on Pragma"
	
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedNodeWithParens [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression:  ' (((var))) ') .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitorWithWhitespace measureParentheses: ast) measuredSize.			

	self assert: measuredMemory  equals: (4 + 5) quadWords "1 Ordered Collection"
		+ (3 * 4 quadWords) "3 Intervals"
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedSelectorNodeForBinary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'a + 5') selectorNode .
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
		+ 2 quadWords  "1 IntegerArray for keywordPositions"
	
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedSelectorNodeForKeywordSelector [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self sendMessage: #hash') selectorNode .
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
		+ 8 quadWords  "1 IntegerArray for keywordPositions"
	
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedSelectorNodeForUnary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self yourself') selectorNode .
	measuredMemory := (visitorWithWhitespace visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
		+ 2 quadWords  "1 IntegerArray for keywordPositions"	
]

{ #category : #'tests - whitespace' }
MemorySizeVisitorTest >> testFormatedSequenceNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32 . 213. 23'.
	measuredMemory := (visitorWithWhitespace  visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"
		+ (2 * 15) quadWords "2 OrderedCollections"
		+ (3 * (8 + 2)) quadWords "3 Integers Nodes"
		+ (4 + 11) quadWords "2 periods"
]

{ #category : #'tests - whitespace' }
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

	self assert: measuredMemory equals: (8 quadWords) "Layout"
		+ (10 quadWords) "contents: 1 Array" 
		+ (8 quadWords) "1 Integer Node"
		+ (10 quadWords) "1 String Node"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNodeForByteArray [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '#[23 24 25]'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"
		+ 4 quadWords "contents: 1 Array" 
		+ (8 * 3) quadWords  "3 Integer Nodes"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForABoolean [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  'false'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAFloat [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '323.724e14'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAHexadecimalInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  '16r1FF'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAScaledDecimal [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '3.2s'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords "Layout"
		+ 4 quadWords  "3.2s ScaledDecimal"
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAString [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '''hello'''.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory  equals: 8 quadWords"Layout"
		+ 2 quadWords  "'hello' String"

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForASymbol [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '#foo'.	
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForNil [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'nil'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testMessageNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: 'var add: 2'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"
               + (4 + 4) quadWords "Arguments: 1 OrderedCollection"
               + 9 quadWords "Receiver: VariableNode"
		+ 6 quadWords "Selector: SelectorNode"
		+ 8 quadWords "Arguments: 1 Integer Node"
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNode [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar ^1' . 	
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory equals: (14 quadWords) "Layout"
		+ (2 quadWords) "arguments: 1 Array"
		+ (2 quadWords) "pragmas: 1 Array"
		+ (((8 + (15 * 2)) quadWords) "Body: Sequence Node" "^8"
			+ ((5 quadWords) "1 Return node"
				+ (8 quadWords) "1 Integer node"
			)
		)
		
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithArguments [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar: var ^var' . 	
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory equals: 14 quadWords "Layout"
		+ (7 quadWords) "arguments: 1 OrderedCollection"
		+ (2 quadWords) "pragmas: 1 Array"
               + (9 quadWords) "var: 1 VariableNode"
		+ (((8 + (15 * 2)) quadWords) "Body: Sequence Node" "^var"
			+ ((5 quadWords) "1 Return node"
				+ (9 quadWords) "1 Variable node"
			)
		)
		
					
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testMethodNodeWithPragma [
	| ast measuredMemory |
	
	ast := RBParser parseMethod:  'foobar < qux: 6 > ^8'.
	measuredMemory := (visitor visitNode: ast) measuredSize.
	
	self assert: measuredMemory equals: 14 quadWords"Layout"
		+ (2 quadWords) "arguments: 1 Array"
		+ (15 quadWords) "pragmas: 1 OrderedCollection"
		+ ((8 + 7 + 8) quadWords) "< qux: 6 >: 1 Pragma Node"
		+ (((8 + (15 * 2)) quadWords) "Body: Sequence Node" "^8"
			+ ((5 quadWords) "1 Return node"
				+ (8 quadWords) "1 Integer node"
			)
		)
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testReturnNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '^ 45 ' .
	measuredMemory := (visitor visitNode: ast) measuredSize.	

	self assert: measuredMemory equals: 5 quadWords "Layout"
		+ 8 quadWords "1 Integer Node"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForBinary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'a + 5') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForKeywordSelector [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self sendMessage: #hash') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSelectorNodeForUnary [
	| ast measuredMemory |
	
	ast := (RBParser parseExpression: 'self yourself') selectorNode .
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 6 quadWords  "Layout"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '32 . 213. 23'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"
		+ (2 * 15) quadWords "2 OrderedCollections"
		+ (3 * 8) quadWords "3 Integers Nodes"
]

{ #category : #tests }
MemorySizeVisitorTest >> testSequenceNodeWithTemporaries [
	| ast measuredMemory |
	
	ast := RBParser parseExpression: '|a b| 32 . 213. 23'.
	measuredMemory := (visitor visitNode: ast) measuredSize.

	self assert: measuredMemory equals: 8 quadWords "Layout"		
		+ (2 * 15) quadWords "2 OrderedCollections"
		+ (2 * 9) quadWords  "|a b|: 2 Variable Nodes"
		+ (3 * 8) quadWords "3 Integers Nodes"

]

{ #category : #tests }
MemorySizeVisitorTest >> testVariableNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  ' var' .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitor visitNode: ast) measuredSize.			

	self assert: measuredMemory  equals: 7 quadWords "Layout"
		+ 2 quadWords "1 Unresolved Variable"
	
]
