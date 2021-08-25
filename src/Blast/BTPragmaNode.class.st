"
A BTPragmaNode is the AST node for pragmas.

Instance Variables
	arguments:		<Object>
	selector:		<Object>

arguments
	- xxxxx

selector
	- xxxxx

"
Class {
	#name : #BTPragmaNode,
	#superclass : #BTEncodedNode,
	#traits : 'TKeywordedNode',
	#classTraits : 'TKeywordedNode classTrait',
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTPragmaNode class >> selector: aSelector [
	
	^ self selector: aSelector arguments: #()
]

{ #category : #'instance creation' }
BTPragmaNode class >> selector: aSelector arguments: aLiteralList [
	
	^self new
		selector: aSelector;
		arguments: aLiteralList;
		yourself 
]

{ #category : #visitor }
BTPragmaNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitPragmaNode: self
]

{ #category : #accessing }
BTPragmaNode >> arguments [
	^ arguments
]

{ #category : #accessing }
BTPragmaNode >> arguments: anArgumentList [
	arguments := anArgumentList
]

{ #category : #printing }
BTPragmaNode >> printOn: aStream [

	aStream << '<'.
	self printKeywordsAndArgumentsOn: aStream.
	aStream << '>'
]

{ #category : #accessing }
BTPragmaNode >> selector [
	^ selector
]

{ #category : #accessing }
BTPragmaNode >> selector: aSelector [
	selector := aSelector
]
