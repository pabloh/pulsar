Class {
	#name : #MemorySizeVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #'Pulsar-Tests'
}

{ #category : #initialization }
MemorySizeVisitorTest >> setUp [

	visitor := MemorySizeVisitor new.
]

{ #category : #tests }
MemorySizeVisitorTest >> testArrayNode [
	| ast measuredMemory |
	
	self notYetImplemented.

	ast := RBParser parseExpression:   '#( 45 ''hello'')' .	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (8 + 4 + 6 + 8 + 10) * 8 "36 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNode [
	| ast measuredMemory |

	ast := RBParser parseExpression:   '#( 45 ''hello'')' .	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (8 + 4 + 6 + 8 + 10) * 8 "36 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralArrayNodeForByteArray [
	| ast measuredMemory |

	ast := RBParser parseExpression:  '#[23 24 25]' .	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  (8 + 4 + 6 + 8 + 10) * 8 "36 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForABoolean [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   'false'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAFloat [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '323.724e14'.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAHexadecimalInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '16r1FF'.	
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
	
	ast := RBParser parseExpression:   '3.2s'.	
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
MemorySizeVisitorTest >> testReturnNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '^ 45 ' .
	measuredMemory := (visitor visit: ast) measuredSize.	

	self assert: measuredMemory  equals:  (5 + 8) * 8 "13 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testVariableNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:  ' var ' .  "Unresolved identifier is an unresolved variable"
	measuredMemory := (visitor visit: ast) measuredSize.			

	self assert: measuredMemory  equals:  (7 + 2 + 2) * 8 "12 quad words"
	
]
