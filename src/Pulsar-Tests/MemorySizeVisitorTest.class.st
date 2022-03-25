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
MemorySizeVisitorTest >> testLiteralArrayNode [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '#( 45 ''hello'')' .	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  (8 + 4 + 6 + 8 + 10) * 8 "36 quad words"
	
]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAInteger [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '32'.	
	measuredMemory := (visitor visit: ast) measuredSize.
	
	self assert: measuredMemory  equals:  8  * 8 "8 quad words"
	
	
		

	

]

{ #category : #tests }
MemorySizeVisitorTest >> testLiteralValueNodeForAString [
	| ast measuredMemory |
	
	ast := RBParser parseExpression:   '''hello'''.	
	measuredMemory := (visitor visit: ast) measuredSize.

	self assert: measuredMemory  equals:  10 * 8 "10 quad words"

]
